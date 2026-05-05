// swift-tools-version: 5.9

import PackageDescription
import Foundation

let environmentVariables = ProcessInfo.processInfo.environment

let permissionDefines: [CSetting] = [
    // dart: PermissionGroup.calendar (< iOS 17)
    .define("PERMISSION_EVENTS", to: environmentVariables["PERMISSION_EVENTS"] ?? "0"),
    // dart: PermissionGroup.calendarFullAccess (iOS 17+)
    .define("PERMISSION_EVENTS_FULL_ACCESS", to: environmentVariables["PERMISSION_EVENTS_FULL_ACCESS"] ?? "0"),
    // dart: PermissionGroup.reminders
    .define("PERMISSION_REMINDERS", to: environmentVariables["PERMISSION_REMINDERS"] ?? "0"),
    // dart: PermissionGroup.contacts
    .define("PERMISSION_CONTACTS", to: environmentVariables["PERMISSION_CONTACTS"] ?? "0"),
    // dart: PermissionGroup.camera
    .define("PERMISSION_CAMERA", to: environmentVariables["PERMISSION_CAMERA"] ?? "0"),
    // dart: PermissionGroup.microphone
    .define("PERMISSION_MICROPHONE", to: environmentVariables["PERMISSION_MICROPHONE"] ?? "0"),
    // dart: PermissionGroup.speech
    .define("PERMISSION_SPEECH_RECOGNIZER", to: environmentVariables["PERMISSION_SPEECH_RECOGNIZER"] ?? "0"),
    // dart: PermissionGroup.photos
    .define("PERMISSION_PHOTOS", to: environmentVariables["PERMISSION_PHOTOS"] ?? "0"),
    // dart: PermissionGroup.photosAddOnly
    .define("PERMISSION_PHOTOS_ADD_ONLY", to: environmentVariables["PERMISSION_PHOTOS_ADD_ONLY"] ?? "0"),
    // dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
    .define("PERMISSION_LOCATION", to: environmentVariables["PERMISSION_LOCATION"] ?? "0"),
    // dart: PermissionGroup.locationWhenInUse (only when locationAlways is NOT needed)
    .define("PERMISSION_LOCATION_WHENINUSE", to: environmentVariables["PERMISSION_LOCATION_WHENINUSE"] ?? "0"),
    // dart: PermissionGroup.locationAlways
    .define("PERMISSION_LOCATION_ALWAYS", to: environmentVariables["PERMISSION_LOCATION_ALWAYS"] ?? "0"),
    // dart: PermissionGroup.notification
    .define("PERMISSION_NOTIFICATIONS", to: environmentVariables["PERMISSION_NOTIFICATIONS"] ?? "0"),
    // dart: PermissionGroup.mediaLibrary
    .define("PERMISSION_MEDIA_LIBRARY", to: environmentVariables["PERMISSION_MEDIA_LIBRARY"] ?? "0"),
    // dart: PermissionGroup.sensors
    .define("PERMISSION_SENSORS", to: environmentVariables["PERMISSION_SENSORS"] ?? "0"),
    // dart: PermissionGroup.bluetooth
    .define("PERMISSION_BLUETOOTH", to: environmentVariables["PERMISSION_BLUETOOTH"] ?? "0"),
    // dart: PermissionGroup.appTrackingTransparency
    .define("PERMISSION_APP_TRACKING_TRANSPARENCY", to: environmentVariables["PERMISSION_APP_TRACKING_TRANSPARENCY"] ?? "0"),
    // dart: PermissionGroup.criticalAlerts
    .define("PERMISSION_CRITICAL_ALERTS", to: environmentVariables["PERMISSION_CRITICAL_ALERTS"] ?? "0"),
    // dart: PermissionGroup.assistant
    .define("PERMISSION_ASSISTANT", to: environmentVariables["PERMISSION_ASSISTANT"] ?? "0"),
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
