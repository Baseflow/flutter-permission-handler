// swift-tools-version: 5.9

import PackageDescription
import Foundation

// Permission configuration — same resolution order as legacy ios/ Package.swift.
// See permission_handler/README.md for PERMISSION_* macro documentation.

let env = ProcessInfo.processInfo.environment

func loadInfoPlist(at url: URL) -> [String: Any]? {
    NSDictionary(contentsOf: url) as? [String: Any]
}

func findInfoPlist() -> [String: Any] {
    let fileManager = FileManager.default
    let packageDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
    let currentDir = URL(fileURLWithPath: fileManager.currentDirectoryPath)
    var visited = Set<String>()

    for root in [packageDir, currentDir] {
        var dir = root
        for _ in 0..<10 {
            let key = dir.resolvingSymlinksInPath().path
            guard visited.insert(key).inserted else { break }
            let pubspecURL = dir.appendingPathComponent("pubspec.yaml")
            let plistURL = dir.appendingPathComponent("ios/Runner/Info.plist")
            if fileManager.fileExists(atPath: pubspecURL.path),
               let plist = loadInfoPlist(at: plistURL) {
                return plist
            }
            let parent = dir.deletingLastPathComponent()
            if parent.path == dir.path { break }
            dir = parent
        }
    }
    return [:]
}

let infoPlist = findInfoPlist()

func isEnabled(_ envKey: String, plistKeys: String..., defaultValue: Bool = false) -> Bool {
    if let val = env[envKey] { return val != "0" }
    for key in plistKeys where infoPlist[key] != nil { return true }
    return defaultValue
}

func optionalDefine(_ name: String, enabled: Bool) -> SwiftSetting? {
    enabled ? .define(name) : nil
}

let permissionSwiftSettings: [SwiftSetting] = [
    optionalDefine("PERMISSION_EVENTS",
                   enabled: isEnabled("PERMISSION_EVENTS",
                                    plistKeys: "NSCalendarsUsageDescription")),
    optionalDefine("PERMISSION_EVENTS_FULL_ACCESS",
                   enabled: isEnabled("PERMISSION_EVENTS_FULL_ACCESS",
                                    plistKeys: "NSCalendarsFullAccessUsageDescription",
                                               "NSCalendarsWriteOnlyAccessUsageDescription")),
    optionalDefine("PERMISSION_REMINDERS",
                   enabled: isEnabled("PERMISSION_REMINDERS",
                                    plistKeys: "NSRemindersUsageDescription")),
    optionalDefine("PERMISSION_CONTACTS",
                   enabled: isEnabled("PERMISSION_CONTACTS",
                                    plistKeys: "NSContactsUsageDescription")),
    optionalDefine("PERMISSION_CAMERA",
                   enabled: isEnabled("PERMISSION_CAMERA",
                                    plistKeys: "NSCameraUsageDescription")),
    optionalDefine("PERMISSION_MICROPHONE",
                   enabled: isEnabled("PERMISSION_MICROPHONE",
                                    plistKeys: "NSMicrophoneUsageDescription")),
    optionalDefine("PERMISSION_SPEECH_RECOGNIZER",
                   enabled: isEnabled("PERMISSION_SPEECH_RECOGNIZER",
                                    plistKeys: "NSSpeechRecognitionUsageDescription")),
    optionalDefine("PERMISSION_PHOTOS",
                   enabled: isEnabled("PERMISSION_PHOTOS",
                                    plistKeys: "NSPhotoLibraryUsageDescription",
                                               "NSPhotoLibraryAddUsageDescription")),
    optionalDefine("PERMISSION_PHOTOS_ADD_ONLY",
                   enabled: isEnabled("PERMISSION_PHOTOS_ADD_ONLY",
                                    plistKeys: "NSPhotoLibraryAddUsageDescription")),
    optionalDefine("PERMISSION_LOCATION",
                   enabled: isEnabled("PERMISSION_LOCATION",
                                    plistKeys: "NSLocationWhenInUseUsageDescription",
                                               "NSLocationAlwaysAndWhenInUseUsageDescription")),
    optionalDefine("PERMISSION_LOCATION_WHENINUSE",
                   enabled: isEnabled("PERMISSION_LOCATION_WHENINUSE",
                                    plistKeys: "NSLocationWhenInUseUsageDescription")),
    optionalDefine("PERMISSION_LOCATION_ALWAYS",
                   enabled: isEnabled("PERMISSION_LOCATION_ALWAYS",
                                    plistKeys: "NSLocationAlwaysAndWhenInUseUsageDescription")),
    optionalDefine("PERMISSION_NOTIFICATIONS",
                   enabled: isEnabled("PERMISSION_NOTIFICATIONS", defaultValue: true)),
    optionalDefine("PERMISSION_MEDIA_LIBRARY",
                   enabled: isEnabled("PERMISSION_MEDIA_LIBRARY",
                                    plistKeys: "NSAppleMusicUsageDescription")),
    optionalDefine("PERMISSION_SENSORS",
                   enabled: isEnabled("PERMISSION_SENSORS",
                                    plistKeys: "NSMotionUsageDescription")),
    optionalDefine("PERMISSION_BLUETOOTH",
                   enabled: isEnabled("PERMISSION_BLUETOOTH",
                                    plistKeys: "NSBluetoothAlwaysUsageDescription",
                                               "NSBluetoothPeripheralUsageDescription")),
    optionalDefine("PERMISSION_APP_TRACKING_TRANSPARENCY",
                   enabled: isEnabled("PERMISSION_APP_TRACKING_TRANSPARENCY",
                                    plistKeys: "NSUserTrackingUsageDescription")),
    optionalDefine("PERMISSION_CRITICAL_ALERTS",
                   enabled: isEnabled("PERMISSION_CRITICAL_ALERTS")),
    optionalDefine("PERMISSION_ASSISTANT",
                   enabled: isEnabled("PERMISSION_ASSISTANT",
                                    plistKeys: "NSSiriUsageDescription")),
].compactMap { $0 }

let package = Package(
    name: "permission_handler_apple",
    platforms: [
        .iOS("14.0"),
    ],
    products: [
        .library(name: "permission-handler-apple", targets: ["permission_handler_apple"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "permission_handler_apple",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ],
            path: "Sources/permission_handler_apple",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            swiftSettings: permissionSwiftSettings
        ),
    ]
)
