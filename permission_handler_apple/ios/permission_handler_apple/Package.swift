// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "permission_handler_apple",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "permission-handler-apple", targets: ["permission_handler_apple"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "permission_handler_apple",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: "",
            cSettings: [
                .define("PERMISSION_EVENTS", to: "1"),
                .define("PERMISSION_REMINDERS", to: "1"),
                .define("PERMISSION_CONTACTS", to: "1"),
                .define("PERMISSION_CAMERA", to: "1"),
                .define("PERMISSION_MICROPHONE", to: "1"),
                .define("PERMISSION_SPEECH_RECOGNIZER", to: "1"),
                .define("PERMISSION_PHOTOS", to: "1"),
                .define("PERMISSION_LOCATION", to: "1"),
                .define("PERMISSION_NOTIFICATIONS", to: "1"),
                .define("PERMISSION_MEDIA_LIBRARY", to: "1"),
                .define("PERMISSION_SENSORS", to: "1"),
                .define("PERMISSION_BLUETOOTH", to: "1"),
                .define("PERMISSION_APP_TRACKING_TRANSPARENCY", to: "1"),
                .define("PERMISSION_CRITICAL_ALERTS", to: "1"),
            ]
        )
    ]
)
