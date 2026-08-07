// swift-tools-version: 5.9

import PackageDescription
import Foundation

// ---------------------------------------------------------------------------
// Permission configuration
//
// Permissions are resolved in priority order:
//   1. Environment variable (e.g. `launchctl setenv PERMISSION_CAMERA 1`
//      or `launchctl setenv PERMISSION_NOTIFICATIONS 0` to explicitly disable)
//   2. Matching key present in the app's Info.plist
//   3. Default: enabled for permissions with no required plist key
//              (PERMISSION_NOTIFICATIONS, PERMISSION_CRITICAL_ALERTS),
//              disabled for all others.
//
// Additional environment variables:
//   PERMISSION_HANDLER_INFO_PLIST  ':'-separated Info.plist paths. When set,
//                                  replaces automatic discovery entirely. This
//                                  is the only mechanism that works for builds
//                                  started from Xcode.app (see findAppRoot()).
//   PERMISSION_HANDLER_VERBOSE     Set to 1 to log what was discovered and
//                                  which permissions ended up enabled.
//
// After changing Info.plist or env vars, clear DerivedData once so Xcode
// re-evaluates this manifest:
//   rm -rf ~/Library/Developer/Xcode/DerivedData
// ---------------------------------------------------------------------------

let env = ProcessInfo.processInfo.environment
let fileManager = FileManager.default
let verbose = (env["PERMISSION_HANDLER_VERBOSE"] ?? "0") != "0"

/// Write to stderr.
///
/// The `swift package` CLI reports this; Xcode discards manifest output
/// entirely, during package resolution and during a build alike. Anything
/// written here is therefore invisible to exactly the users who most need it,
/// which is why a failed lookup also has to degrade safely: every permission
/// reports `denied` rather than crashing (see the disabled strategy
/// implementations in Sources/.../strategies).
///
/// Never call `fatalError` here: it aborts evaluation of the whole package
/// graph with a message the user cannot act on.
func diagnostic(_ level: String, _ message: String) {
    FileHandle.standardError.write("\(level): [permission_handler_apple] \(message)\n".data(using: .utf8)!)
}

func loadInfoPlist(at url: URL) -> [String: Any]? {
    NSDictionary(contentsOf: url) as? [String: Any]
}

// MARK: - Locating the host app

/// Directories that never contain the host app's Info.plist, and that are
/// expensive to walk.
let skippedDirectoryNames: Set<String> = [
    "Pods", "build", "DerivedData", "ephemeral", ".dart_tool", ".symlinks", ".git",
]

/// Depth-first walk of `root`, collecting files whose name satisfies `isMatch`.
/// Package directories such as `Runner.xcodeproj` are descended into, because
/// `project.pbxproj` lives inside one.
func enumerateFiles(under root: URL, matching isMatch: (String) -> Bool) -> [URL] {
    guard let enumerator = fileManager.enumerator(
        at: root,
        includingPropertiesForKeys: [.isDirectoryKey]
    ) else { return [] }

    var matches: [URL] = []
    for case let url as URL in enumerator {
        let name = url.lastPathComponent
        let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false

        if isDirectory {
            if skippedDirectoryNames.contains(name) || name.hasSuffix(".xcworkspace") {
                enumerator.skipDescendants()
            }
            continue
        }

        if isMatch(name) { matches.append(url) }
    }
    return matches
}

/// True when `dir` is a Flutter *application* root.
///
/// The `ios/*.xcodeproj` requirement is what separates an app from a plugin
/// package: plugins also have a pubspec.yaml next to an `ios/` directory, but
/// never an Xcode project inside it. Without this check the walk-up below
/// stops on this very package when it is consumed as a path dependency.
func isAppRoot(_ dir: URL) -> Bool {
    guard fileManager.fileExists(atPath: dir.appendingPathComponent("pubspec.yaml").path) else {
        return false
    }
    let iosDir = dir.appendingPathComponent("ios")
    guard let entries = try? fileManager.contentsOfDirectory(atPath: iosDir.path) else {
        return false
    }
    return entries.contains { $0.hasSuffix(".xcodeproj") }
}

func walkUpToAppRoot(from start: URL, maxDepth: Int = 12) -> URL? {
    var dir = start.standardizedFileURL
    for _ in 0..<maxDepth {
        if isAppRoot(dir) { return dir }
        let parent = dir.deletingLastPathComponent()
        if parent.path == dir.path { return nil }
        dir = parent
    }
    return nil
}

/// Locate the Flutter app that is consuming this package.
///
/// Manifest evaluation is a hostile environment for this: it runs sandboxed, in
/// its own process, and Xcode passes none of its build settings through — there
/// is no SRCROOT, PROJECT_DIR, CONFIGURATION or INFOPLIST_FILE to read. `#file`
/// is canonicalised by SwiftPM, so for a normal pub.dev install it resolves
/// inside ~/.pub-cache and can never reach the app; it is only useful when the
/// plugin is a path dependency inside the app's own repository.
///
/// That leaves the working directory, which points at the app whenever the
/// build was started from the app directory — `flutter build ios`,
/// `flutter run` and a direct `xcodebuild` invocation all qualify. Builds
/// started from Xcode.app run with `/` as the working directory and cannot be
/// detected at all; those need PERMISSION_HANDLER_INFO_PLIST.
func findAppRoot() -> URL? {
    var starts = [URL(fileURLWithPath: fileManager.currentDirectoryPath)]
    if let pwd = env["PWD"], !pwd.isEmpty {
        starts.append(URL(fileURLWithPath: pwd))
    }
    starts.append(URL(fileURLWithPath: #file).deletingLastPathComponent())

    var visited = Set<String>()
    for start in starts {
        guard visited.insert(start.resolvingSymlinksInPath().path).inserted else { continue }
        if let appRoot = walkUpToAppRoot(from: start) { return appRoot }
    }
    return nil
}

// MARK: - Locating Info.plist files

/// The lookbehind keeps `GENERATE_INFOPLIST_FILE = YES;` from matching. Xcode
/// writes that setting into every target it creates from a template — app
/// extensions especially — and a match there yields a candidate named `YES`,
/// which is enough to suppress the fallback scan below.
let infoPlistSettingRegex = try? NSRegularExpression(
    pattern: #"(?<![A-Z_])INFOPLIST_FILE\s*=\s*"?([^";\n]+)"?"#
)

/// Plists that live under `ios/` but are never the app's Info.plist.
let ignoredPlistNames: Set<String> = [
    "AppFrameworkInfo.plist", "GoogleService-Info.plist",
]

func expandBuildSettings(_ value: String, projectDir: URL) -> String {
    var expanded = value
    for name in ["SRCROOT", "SOURCE_ROOT", "PROJECT_DIR"] {
        expanded = expanded
            .replacingOccurrences(of: "$(\(name))", with: projectDir.path)
            .replacingOccurrences(of: "${\(name)}", with: projectDir.path)
    }
    return expanded
}

/// Turn one `INFOPLIST_FILE` value into concrete plist URLs.
///
/// A value like `Runner/Info-$(CONFIGURATION).plist` cannot be resolved here —
/// the manifest has no idea which configuration is building, and is evaluated
/// once for all of them. Rather than drop it, expand it to every plist in that
/// directory sharing the literal prefix, and let the caller merge them.
func resolveInfoPlistSetting(_ value: String, projectDir: URL) -> [URL] {
    let expanded = expandBuildSettings(value, projectDir: projectDir)
    let url = expanded.hasPrefix("/")
        ? URL(fileURLWithPath: expanded)
        : projectDir.appendingPathComponent(expanded)

    guard expanded.contains("$(") || expanded.contains("${") else { return [url] }

    // Only a variable in the file name can be globbed; one in a parent
    // directory would need the directory listing of an unknown path.
    let directory = url.deletingLastPathComponent()
    if directory.path.contains("$(") || directory.path.contains("${") { return [] }

    let name = url.lastPathComponent
    guard let variableStart = name.range(of: "$(") ?? name.range(of: "${") else { return [] }
    let prefix = String(name[name.startIndex..<variableStart.lowerBound])
    guard let entries = try? fileManager.contentsOfDirectory(atPath: directory.path) else { return [] }

    return entries
        .filter { $0.hasPrefix(prefix) && $0.hasSuffix(".plist") && !ignoredPlistNames.contains($0) }
        .sorted()
        .map { directory.appendingPathComponent($0) }
}

/// Read `INFOPLIST_FILE` out of the Xcode project and any xcconfig files.
///
/// This is what makes flavors work: an app with `Info-Debug.plist` /
/// `Info-Release.plist`, a per-flavor directory, or an extra Runner target
/// declares the real path here, and every build configuration contributes its
/// own value. `#include` directives inside xcconfigs are not followed — every
/// xcconfig under `ios/` is read anyway, so an included file is picked up on
/// its own.
///
/// TODO(Pachebel): every `INFOPLIST_FILE` in the project is taken, including
/// the ones belonging to test bundles and app extensions. Their keys are merged
/// in like any other, which is harmless for the macros — those plists declare no
/// usage descriptions, so they add nothing — but it makes an app with a stock
/// `RunnerTests` target trip the divergence warning in `findInfoPlist()` on
/// every resolve, naming keys that do not actually differ between the app's own
/// configurations.
///
/// Two obvious fixes are both wrong. Filtering on a `Test` substring in the file
/// name misses Xcode's own layout, where the path is `RunnerTests/Info.plist`
/// and the *name* is plain `Info.plist`; widening it to the directory would
/// exclude a real app whose target is named e.g. `TestFlightRunner`. Ignoring
/// plists that declare no usage descriptions silences the warning in the case
/// that matters most — a flavor that deliberately requests nothing.
///
/// The real fix is to stop treating the pbxproj as flat text: resolve each
/// `INFOPLIST_FILE` to the `XCBuildConfiguration` that declares it, walk to the
/// `PBXNativeTarget` owning that configuration list, and keep only targets whose
/// `productType` is `com.apple.product-type.application`. That drops test
/// bundles and extensions by what they are rather than by what they are called,
/// and needs a real pbxproj parser here.
func infoPlistsFromBuildSettings(appRoot: URL) -> [URL] {
    guard let regex = infoPlistSettingRegex else { return [] }
    let iosDir = appRoot.appendingPathComponent("ios")

    let settingsFiles = enumerateFiles(under: iosDir) { name in
        name == "project.pbxproj" || name.hasSuffix(".xcconfig")
    }

    var results: [URL] = []
    for file in settingsFiles {
        guard let contents = try? String(contentsOf: file, encoding: .utf8) else { continue }

        // SRCROOT is the directory holding the .xcodeproj — `ios/` in a stock
        // Flutter app. For a bare xcconfig, `ios/` is the best assumption.
        let projectDir = file.pathComponents.contains { $0.hasSuffix(".xcodeproj") }
            ? file.deletingLastPathComponent().deletingLastPathComponent()
            : iosDir

        let range = NSRange(contents.startIndex..., in: contents)
        for match in regex.matches(in: contents, range: range) {
            guard match.numberOfRanges > 1,
                  let valueRange = Range(match.range(at: 1), in: contents) else { continue }
            let value = contents[valueRange]
                .trimmingCharacters(in: CharacterSet(charactersIn: " \t\"'"))
            guard !value.isEmpty else { continue }
            results.append(contentsOf: resolveInfoPlistSetting(value, projectDir: projectDir))
        }
    }
    return results
}

/// Discard candidates that are not files on disk.
///
/// `INFOPLIST_FILE` is read from build settings that may name a plist this
/// manifest cannot resolve — a path built from a build variable it does not
/// expand, or a target whose plist Xcode generates at build time. Such a
/// candidate must not count towards "settings produced something", or it
/// suppresses the fallback scan and every permission is compiled out.
func existingFiles(_ urls: [URL]) -> [URL] {
    urls.filter { fileManager.fileExists(atPath: $0.path) }
}

/// Last resort: any plausibly-named plist under `ios/`. Covers projects whose
/// `INFOPLIST_FILE` lives somewhere this manifest does not parse.
func infoPlistsFromScan(appRoot: URL) -> [URL] {
    enumerateFiles(under: appRoot.appendingPathComponent("ios")) { name in
        name.hasSuffix(".plist")
            && name.contains("Info")
            && !name.contains("Test")
            && !ignoredPlistNames.contains(name)
    }
}

func infoPlistsFromEnvironment() -> [URL]? {
    guard let raw = env["PERMISSION_HANDLER_INFO_PLIST"], !raw.isEmpty else { return nil }
    return raw
        .split(separator: ":")
        .map { URL(fileURLWithPath: String($0).trimmingCharacters(in: .whitespaces)) }
}

/// Collect the usage description keys of every Info.plist belonging to the
/// host app.
///
/// The keys are *merged* across build configurations and flavors. The manifest
/// is evaluated once per package resolution and cannot know which configuration
/// is building, so per-flavor macros are not expressible here. Merging errs
/// towards enabling a permission: an app whose `Info-dev.plist` declares camera
/// access compiles the camera code into its release binary too. Use the
/// per-permission `PERMISSION_*` environment variables where that matters.
func findInfoPlist() -> [String: Any] {
    var candidates: [URL]

    if let explicit = infoPlistsFromEnvironment() {
        candidates = explicit
    } else if let appRoot = findAppRoot() {
        if verbose { diagnostic("note", "app root: \(appRoot.path)") }
        let fromSettings = existingFiles(infoPlistsFromBuildSettings(appRoot: appRoot))
        candidates = fromSettings.isEmpty ? infoPlistsFromScan(appRoot: appRoot) : fromSettings
    } else {
        diagnostic("warning", """
            Could not locate the host app, so every iOS permission has been compiled out and \
            permission checks will report `denied`. Automatic detection needs the build to be \
            started from the Flutter project directory, which is not the case for builds run \
            directly from Xcode.app. Point this manifest at the app's Info.plist with \
            `launchctl setenv PERMISSION_HANDLER_INFO_PLIST /path/to/ios/Runner/Info.plist`, or \
            enable permissions individually with `launchctl setenv PERMISSION_CAMERA 1`, then \
            run `rm -rf ~/Library/Developer/Xcode/DerivedData` so this manifest is re-evaluated.
            """)
        return [:]
    }

    var seen = Set<String>()
    candidates = candidates.filter { seen.insert($0.standardizedFileURL.path).inserted }

    var merged: [String: Any] = [:]
    var loaded: [URL] = []
    var keysPerPlist: [Set<String>] = []

    for url in candidates {
        guard let plist = loadInfoPlist(at: url) else { continue }
        loaded.append(url)
        keysPerPlist.append(Set(plist.keys.filter { $0.hasSuffix("UsageDescription") }))
        for (key, value) in plist where merged[key] == nil { merged[key] = value }
    }

    if loaded.isEmpty {
        diagnostic("warning", """
            No readable Info.plist was found for the host app, so every iOS permission has been \
            compiled out and permission checks will report `denied`. Set \
            PERMISSION_HANDLER_INFO_PLIST to the path of your Info.plist, then run \
            `rm -rf ~/Library/Developer/Xcode/DerivedData`.
            """)
        return [:]
    }

    if verbose {
        diagnostic("note", "Info.plist files used:\n  " + loaded.map(\.path).joined(separator: "\n  "))
    }

    // Merging across configurations enables the union of their permissions. Say
    // so when they actually disagree, because the extra permissions end up in
    // the release binary and can trigger App Store rejection (ITMS-90683).
    if let first = keysPerPlist.first, keysPerPlist.contains(where: { $0 != first }) {
        let divergent = keysPerPlist.reduce(into: Set<String>()) { $0.formUnion($1) }
            .subtracting(keysPerPlist.reduce(into: keysPerPlist[0]) { $0.formIntersection($1) })
        diagnostic("warning", """
            The discovered Info.plist files declare different usage descriptions \
            (\(divergent.sorted().joined(separator: ", "))). Every permission found in any of \
            them is enabled for all build configurations, because a Swift package manifest \
            cannot vary its settings per configuration. Set PERMISSION_HANDLER_INFO_PLIST or the \
            per-permission PERMISSION_* variables to control this explicitly.
            """)
    }

    return merged
}

let infoPlist = findInfoPlist()

/// Every macro this manifest resolved, for PERMISSION_HANDLER_VERBOSE.
var resolvedMacros: [String: String] = [:]

/// Return "1" if the env var is set (non-zero), "0" if explicitly set to "0",
/// else "1" if any Info.plist key is present, else `defaultValue`.
///
/// An empty value counts as unset: `launchctl setenv PERMISSION_CAMERA ""` is
/// how a variable gets cleared, and reading that as "enabled" would be the
/// opposite of what was asked.
func enabled(_ envKey: String, plistKeys: String..., defaultValue: String = "0") -> String {
    let value: String
    if let val = env[envKey]?.trimmingCharacters(in: .whitespaces), !val.isEmpty {
        value = val == "0" ? "0" : "1"
    } else if plistKeys.contains(where: { infoPlist[$0] != nil }) {
        value = "1"
    } else {
        value = defaultValue
    }
    resolvedMacros[envKey] = value
    return value
}

let permissionDefines: [CSetting] = [
    // dart: PermissionGroup.calendar (< iOS 17)
    .define("PERMISSION_EVENTS",
            to: enabled("PERMISSION_EVENTS",
                        plistKeys: "NSCalendarsUsageDescription")),
    // dart: PermissionGroup.calendarFullAccess (iOS 17+) / PermissionGroup.calendarWriteOnly (iOS 17+)
    .define("PERMISSION_EVENTS_FULL_ACCESS",
            to: enabled("PERMISSION_EVENTS_FULL_ACCESS",
                        plistKeys: "NSCalendarsFullAccessUsageDescription",
                                   "NSCalendarsWriteOnlyAccessUsageDescription")),
    // dart: PermissionGroup.reminders
    .define("PERMISSION_REMINDERS",
            to: enabled("PERMISSION_REMINDERS",
                        plistKeys: "NSRemindersUsageDescription")),
    // dart: PermissionGroup.contacts
    .define("PERMISSION_CONTACTS",
            to: enabled("PERMISSION_CONTACTS",
                        plistKeys: "NSContactsUsageDescription")),
    // dart: PermissionGroup.camera
    .define("PERMISSION_CAMERA",
            to: enabled("PERMISSION_CAMERA",
                        plistKeys: "NSCameraUsageDescription")),
    // dart: PermissionGroup.microphone
    .define("PERMISSION_MICROPHONE",
            to: enabled("PERMISSION_MICROPHONE",
                        plistKeys: "NSMicrophoneUsageDescription")),
    // dart: PermissionGroup.speech
    .define("PERMISSION_SPEECH_RECOGNIZER",
            to: enabled("PERMISSION_SPEECH_RECOGNIZER",
                        plistKeys: "NSSpeechRecognitionUsageDescription")),
    // dart: PermissionGroup.photos / PermissionGroup.photosAddOnly
    // NSPhotoLibraryAddUsageDescription alone also enables PhotoPermissionStrategy because the
    // native code compiles photosAddOnly support under PERMISSION_PHOTOS.
    .define("PERMISSION_PHOTOS",
            to: enabled("PERMISSION_PHOTOS",
                        plistKeys: "NSPhotoLibraryUsageDescription",
                                   "NSPhotoLibraryAddUsageDescription")),
    // dart: PermissionGroup.photosAddOnly
    .define("PERMISSION_PHOTOS_ADD_ONLY",
            to: enabled("PERMISSION_PHOTOS_ADD_ONLY",
                        plistKeys: "NSPhotoLibraryAddUsageDescription")),
    // dart: PermissionGroup.location / locationAlways / locationWhenInUse
    .define("PERMISSION_LOCATION",
            to: enabled("PERMISSION_LOCATION",
                        plistKeys: "NSLocationWhenInUseUsageDescription",
                                   "NSLocationAlwaysAndWhenInUseUsageDescription")),
    // dart: PermissionGroup.locationWhenInUse (only when locationAlways is NOT needed)
    .define("PERMISSION_LOCATION_WHENINUSE",
            to: enabled("PERMISSION_LOCATION_WHENINUSE",
                        plistKeys: "NSLocationWhenInUseUsageDescription")),
    // dart: PermissionGroup.locationAlways
    .define("PERMISSION_LOCATION_ALWAYS",
            to: enabled("PERMISSION_LOCATION_ALWAYS",
                        plistKeys: "NSLocationAlwaysAndWhenInUseUsageDescription")),
    // dart: PermissionGroup.notification (no required Info.plist key — enabled by default)
    .define("PERMISSION_NOTIFICATIONS",
            to: enabled("PERMISSION_NOTIFICATIONS", defaultValue: "1")),
    // dart: PermissionGroup.mediaLibrary
    .define("PERMISSION_MEDIA_LIBRARY",
            to: enabled("PERMISSION_MEDIA_LIBRARY",
                        plistKeys: "NSAppleMusicUsageDescription")),
    // dart: PermissionGroup.sensors
    .define("PERMISSION_SENSORS",
            to: enabled("PERMISSION_SENSORS",
                        plistKeys: "NSMotionUsageDescription")),
    // dart: PermissionGroup.bluetooth
    .define("PERMISSION_BLUETOOTH",
            to: enabled("PERMISSION_BLUETOOTH",
                        plistKeys: "NSBluetoothAlwaysUsageDescription",
                                   "NSBluetoothPeripheralUsageDescription")),
    // dart: PermissionGroup.appTrackingTransparency
    .define("PERMISSION_APP_TRACKING_TRANSPARENCY",
            to: enabled("PERMISSION_APP_TRACKING_TRANSPARENCY",
                        plistKeys: "NSUserTrackingUsageDescription")),
    // dart: PermissionGroup.criticalAlerts (no required Info.plist key — requires Apple entitlement,
    // opt-in via env var: launchctl setenv PERMISSION_CRITICAL_ALERTS 1)
    .define("PERMISSION_CRITICAL_ALERTS",
            to: enabled("PERMISSION_CRITICAL_ALERTS")),
    // dart: PermissionGroup.assistant
    .define("PERMISSION_ASSISTANT",
            to: enabled("PERMISSION_ASSISTANT",
                        plistKeys: "NSSiriUsageDescription")),
]

if verbose {
    diagnostic("note", "resolved permission macros:\n  "
        + resolvedMacros.sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "\n  "))
}

let package = Package(
    name: "permission_handler_apple",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "permission-handler-apple", targets: ["permission_handler_apple"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "permission_handler_apple",
            dependencies: [],
            path: "Sources/permission_handler_apple",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("strategies"),
                .headerSearchPath("util"),
                .headerSearchPath("include/permission_handler_apple"),
            ] + permissionDefines
        ),
    ]
)
