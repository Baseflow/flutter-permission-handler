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
//   PERMISSION_HANDLER_FLAVOR      The active flavor, overriding the one
//                                  recorded by the `select` command.
//   PERMISSION_HANDLER_CONFIG      Path to permission_handler.yaml, for builds
//                                  that cannot locate the app automatically.
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

/// Every Info.plist that appears to belong to `appRoot`: what the build
/// settings name, falling back to a scan of `ios/` when they name nothing that
/// exists.
func discoverInfoPlists(appRoot: URL) -> [URL] {
    let fromSettings = existingFiles(infoPlistsFromBuildSettings(appRoot: appRoot))
    return fromSettings.isEmpty ? infoPlistsFromScan(appRoot: appRoot) : fromSettings
}

// MARK: - Per-flavor configuration

/// The user declares flavors in a `permission_handler.yaml` next to the app's
/// pubspec.yaml:
///
/// ```yaml
/// strict: true
/// flavors:
///   dev:
///     info-plist: ios/Runner/Info-dev.plist
///     configurations:
///       - Debug-dev
///       - Release-dev
///   prod:
///     info-plist: ios/Runner/Info-prod.plist
///     configurations:
///       - Debug-prod
///       - Release-prod
/// ```
///
/// This manifest never parses that file. Foundation has no YAML support and a
/// package manifest cannot import a library for its own evaluation, so
/// `dart run permission_handler_apple:select` — the one place with a real YAML
/// parser — translates it into a generated
/// `ios/Flutter/permission_handler.resolved.json`, which is what is read here
/// with JSONSerialization. The YAML file's existence and modification time are
/// the only things consulted directly, to catch a translation that is missing
/// or stale.
///
/// A flavor names the single Info.plist that defines it. Listing usage
/// description keys directly was considered and rejected: it would duplicate the
/// permission vocabulary across the config, this manifest and the verification
/// build phase, and a drift between those copies fails silently.
///
/// `configurations` is deliberately not read here. A manifest is given no build
/// settings, so it cannot know which configuration is building and could not act
/// on the mapping; only `tool/verify_flavor_selection.sh`, which runs as a build
/// phase where CONFIGURATION exists, consumes that key.
struct FlavorConfig {
    let strict: Bool
    let infoPlists: [String: String]  // flavor -> path, relative to the app root
    let url: URL                      // the user-facing permission_handler.yaml
}

/// The user-facing config file and the directory its relative paths resolve
/// against, when this app has one.
///
/// PERMISSION_HANDLER_CONFIG names the config *and* the root: the file sits
/// next to the app's pubspec.yaml by definition, so its directory is the app.
/// Deriving the root from `appRoot` instead would let the config come from one
/// app while its generated translation and Info.plists come from another.
func locateConfigYaml(appRoot: URL?) -> (yaml: URL, root: URL)? {
    let configURL: URL
    let root: URL
    if let explicit = env["PERMISSION_HANDLER_CONFIG"], !explicit.isEmpty {
        configURL = URL(fileURLWithPath: explicit).standardizedFileURL
        root = configURL.deletingLastPathComponent()
    } else if let appRoot {
        configURL = appRoot.appendingPathComponent("permission_handler.yaml")
        root = appRoot
    } else {
        return nil
    }
    return fileManager.fileExists(atPath: configURL.path) ? (configURL, root) : nil
}

func modificationDate(of url: URL) -> Date? {
    (try? fileManager.attributesOfItem(atPath: url.path))?[.modificationDate] as? Date
}

/// Load the generated translation of `yaml`, refusing anything missing, stale
/// or malformed.
///
/// Every failure returns nil after a diagnostic, and the caller compiles no
/// permissions in. Falling back to merged discovery instead would hand the
/// build the union of every flavor's permissions — the exact leak a config
/// file exists to prevent — so a broken translation must never be "ignored".
func loadFlavorConfig(yaml: URL, configRoot: URL) -> FlavorConfig? {
    let resolved = configRoot.appendingPathComponent("ios/Flutter/permission_handler.resolved.json")
    let rerun = """
        Run `dart run permission_handler_apple:select <flavor>` to regenerate it, then build again.
        """

    guard fileManager.fileExists(atPath: resolved.path) else {
        diagnostic("error", """
            \(yaml.lastPathComponent) is present but its generated translation \
            (\(resolved.path)) is not, so every iOS permission has been compiled out. \(rerun)
            """)
        return nil
    }

    // Both files exist, so unreadable timestamps mean something is wrong with
    // the filesystem rather than with the config. Refuse either way: skipping
    // the check would let a stale translation through silently, which is the
    // one outcome this guard exists to prevent.
    guard let yamlDate = modificationDate(of: yaml),
          let resolvedDate = modificationDate(of: resolved) else {
        diagnostic("error", """
            The modification time of \(yaml.lastPathComponent) or \
            \(resolved.lastPathComponent) could not be read, so it is not possible to tell \
            whether the generated translation is current. Every iOS permission has been \
            compiled out. \(rerun)
            """)
        return nil
    }

    if yamlDate > resolvedDate {
        diagnostic("error", """
            \(yaml.lastPathComponent) was modified after its generated translation \
            (\(resolved.lastPathComponent)), so every iOS permission has been compiled out \
            rather than building with a stale configuration. \(rerun)
            """)
        return nil
    }

    guard let data = try? Data(contentsOf: resolved),
          let root = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
          let flavors = root["flavors"] as? [String: Any], !flavors.isEmpty else {
        diagnostic("error", """
            \(resolved.path) is not a valid generated configuration, so every iOS permission \
            has been compiled out. \(rerun)
            """)
        return nil
    }

    var infoPlists: [String: String] = [:]
    for (flavor, raw) in flavors {
        guard let entry = raw as? [String: Any],
              let plist = entry["infoPlist"] as? String, !plist.isEmpty else { continue }
        infoPlists[flavor] = plist
    }

    guard !infoPlists.isEmpty else {
        diagnostic("error", """
            \(resolved.path) declares no usable flavors, so every iOS permission has been \
            compiled out. \(rerun)
            """)
        return nil
    }

    return FlavorConfig(
        strict: root["strict"] as? Bool ?? true,
        infoPlists: infoPlists,
        url: yaml
    )
}

/// The flavor this build should compile permissions for.
///
/// Xcode exposes no build settings to manifest evaluation, so `CONFIGURATION`
/// cannot be read here and the selection has to be made out of band — by
/// `dart run permission_handler_apple:select <flavor>`, which records it and
/// clears the caches that would otherwise keep serving the previous answer.
func resolveFlavor(appRoot: URL?) -> String? {
    if let fromEnv = env["PERMISSION_HANDLER_FLAVOR"], !fromEnv.isEmpty { return fromEnv }
    guard let appRoot else { return nil }
    let selection = appRoot.appendingPathComponent("ios/Flutter/permission_handler.selected")
    guard let raw = try? String(contentsOf: selection, encoding: .utf8) else { return nil }
    let flavor = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    return flavor.isEmpty ? nil : flavor
}

/// Collect the usage description keys that apply to this build.
///
/// With a `permission_handler.yaml` the active flavor selects exactly one
/// Info.plist and nothing is merged, so a permission declared only by `dev`
/// never reaches a `prod` binary. Without one the keys of every discovered
/// Info.plist are merged, which errs towards enabling a permission.
func findInfoPlist() -> [String: Any] {
    var candidates: [URL]
    let appRoot = findAppRoot()

    if let explicit = infoPlistsFromEnvironment() {
        candidates = explicit
    } else if let located = locateConfigYaml(appRoot: appRoot) {
        let configYaml = located.yaml
        let configRoot = located.root

        guard let config = loadFlavorConfig(yaml: configYaml, configRoot: configRoot) else {
            // Diagnostics already emitted; a present-but-unusable config
            // compiles nothing in rather than falling back to the merge.
            return [:]
        }

        guard let flavor = resolveFlavor(appRoot: configRoot) else {
            guard !config.strict else {
                diagnostic("error", """
                    \(config.url.lastPathComponent) declares the flavors [\(known(config))] with \
                    "strict": true, but the active flavor could not be determined, so every iOS \
                    permission has been compiled out. Run \
                    `dart run permission_handler_apple:select <flavor>` before building, or set \
                    PERMISSION_HANDLER_FLAVOR.
                    """)
                return [:]
            }
            diagnostic("warning", """
                \(config.url.lastPathComponent) declares the flavors [\(known(config))] but the \
                active flavor could not be determined. Falling back to merging every Info.plist \
                found, which enables the union of all flavors' permissions. Set "strict": true to \
                turn this into an error instead.
                """)
            return mergeInfoPlists(discoverInfoPlists(appRoot: configRoot), warnOnDivergence: true)
        }

        guard let relative = config.infoPlists[flavor] else {
            diagnostic("error", """
                Flavor "\(flavor)" is not declared in \(config.url.lastPathComponent) \
                (known flavors: \(known(config))). Every iOS permission has been compiled out.
                """)
            return [:]
        }

        let plist = configRoot.appendingPathComponent(relative)
        guard fileManager.fileExists(atPath: plist.path) else {
            // Falling back to discovery here would hand this flavor the union of
            // every other flavor's permissions, which is the leak the config
            // exists to prevent. Compile nothing in and say why.
            diagnostic("error", """
                Flavor "\(flavor)" points at \(relative), which does not exist \
                (\(plist.path)). Every iOS permission has been compiled out. Fix the "info-plist" \
                path in \(config.url.lastPathComponent) and re-run \
                `dart run permission_handler_apple:select \(flavor)`.
                """)
            return [:]
        }

        if verbose { diagnostic("note", "active flavor: \(flavor) (\(relative))") }
        // One flavor, one plist: never merge, so nothing can leak between flavors.
        return mergeInfoPlists([plist], warnOnDivergence: false)
    } else if let appRoot {
        if verbose { diagnostic("note", "app root: \(appRoot.path)") }
        candidates = discoverInfoPlists(appRoot: appRoot)
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

    return mergeInfoPlists(candidates, warnOnDivergence: true)
}

func known(_ config: FlavorConfig) -> String {
    config.infoPlists.keys.sorted().joined(separator: ", ")
}

/// Read every candidate plist and union their keys.
///
/// Only key *presence* matters to `enabled()`, so the first value for a key
/// wins. `warnOnDivergence` is off when a flavor picked a single plist, where
/// there is nothing to diverge.
func mergeInfoPlists(_ candidates: [URL], warnOnDivergence: Bool) -> [String: Any] {
    var seen = Set<String>()
    let unique = candidates.filter { seen.insert($0.standardizedFileURL.path).inserted }

    var merged: [String: Any] = [:]
    var loaded: [URL] = []
    var keysPerPlist: [Set<String>] = []

    for url in unique {
        guard let plist = loadInfoPlist(at: url) else { continue }
        loaded.append(url)
        keysPerPlist.append(Set(plist.keys.filter { $0.hasSuffix("UsageDescription") }))
        for (key, value) in plist where merged[key] == nil { merged[key] = value }
    }

    if loaded.isEmpty {
        diagnostic("warning", """
            No readable Info.plist was found for the host app, so every iOS permission has been \
            compiled out and permission checks will report `denied`. Looked at: \
            \(unique.map(\.path).joined(separator: ", ")). Set PERMISSION_HANDLER_INFO_PLIST to \
            the path of your Info.plist, then run `rm -rf ~/Library/Developer/Xcode/DerivedData`.
            """)
        return [:]
    }

    if verbose {
        diagnostic("note", "Info.plist files used:\n  " + loaded.map(\.path).joined(separator: "\n  "))
    }

    // Merging across configurations enables the union of their permissions. Say
    // so when they actually disagree, because the extra permissions end up in
    // the release binary and can trigger App Store rejection (ITMS-90683).
    if warnOnDivergence, let first = keysPerPlist.first,
       keysPerPlist.contains(where: { $0 != first }) {
        let divergent = keysPerPlist.reduce(into: Set<String>()) { $0.formUnion($1) }
            .subtracting(keysPerPlist.reduce(into: keysPerPlist[0]) { $0.formIntersection($1) })
        diagnostic("warning", """
            The discovered Info.plist files declare different usage descriptions \
            (\(divergent.sorted().joined(separator: ", "))). Every permission found in any of \
            them is enabled for all build configurations, because a Swift package manifest \
            cannot vary its settings per configuration. Declare a permission_handler.json with \
            one flavor per configuration to compile each of them separately.
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
