// swift-tools-version: 5.9

import PackageDescription
import Foundation

// ---------------------------------------------------------------------------
// Permission configuration
//
// Permissions are resolved in priority order:
//   1. Environment variable (e.g. `launchctl setenv PERMISSION_CAMERA 1`)
//   2. Matching key present in the app's Info.plist
//   3. Default: disabled (0)
//
// After changing Info.plist or env vars, clear DerivedData once so Xcode
// re-evaluates this manifest:
//   rm -rf ~/Library/Developer/Xcode/DerivedData
// ---------------------------------------------------------------------------

let env = ProcessInfo.processInfo.environment

/// Walk up from Package.swift looking for Runner/Info.plist.
/// Works when the package is resolved via Flutter's .symlinks/ directory.
func findInfoPlist() -> [String: Any] {
    var dir = URL(fileURLWithPath: #file).deletingLastPathComponent()
    for _ in 0..<8 {
        let candidate = dir.appendingPathComponent("Runner/Info.plist")
        if let plist = NSDictionary(contentsOf: candidate) as? [String: Any] {
            return plist
        }
        dir = dir.deletingLastPathComponent()
    }
    return [:]
}

let infoPlist = findInfoPlist()

/// Return "1" if the env var is set, else if any of the Info.plist keys are
/// present, else "0".
func enabled(_ envKey: String, plistKeys: String...) -> String {
    if let val = env[envKey], val != "0" { return "1" }
    for key in plistKeys where infoPlist[key] != nil { return "1" }
    return "0"
}

let permissionDefines: [CSetting] = [
    // dart: PermissionGroup.calendar (< iOS 17)
    .define("PERMISSION_EVENTS",
            to: enabled("PERMISSION_EVENTS",
                        plistKeys: "NSCalendarsUsageDescription")),
    // dart: PermissionGroup.calendarFullAccess (iOS 17+)
    .define("PERMISSION_EVENTS_FULL_ACCESS",
            to: enabled("PERMISSION_EVENTS_FULL_ACCESS",
                        plistKeys: "NSCalendarsFullAccessUsageDescription")),
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
    // dart: PermissionGroup.photos
    .define("PERMISSION_PHOTOS",
            to: enabled("PERMISSION_PHOTOS",
                        plistKeys: "NSPhotoLibraryUsageDescription")),
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
    // dart: PermissionGroup.notification (no required Info.plist key)
    .define("PERMISSION_NOTIFICATIONS",
            to: enabled("PERMISSION_NOTIFICATIONS")),
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
    // dart: PermissionGroup.criticalAlerts (no required Info.plist key)
    .define("PERMISSION_CRITICAL_ALERTS",
            to: enabled("PERMISSION_CRITICAL_ALERTS")),
    // dart: PermissionGroup.assistant
    .define("PERMISSION_ASSISTANT",
            to: enabled("PERMISSION_ASSISTANT",
                        plistKeys: "NSSiriUsageDescription")),
]

let package = Package(
    name: "permission_handler_apple",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "permission-handler-apple", targets: ["permission_handler_apple"]),
    ],
    targets: [
        .target(
            name: "permission_handler_apple",
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
