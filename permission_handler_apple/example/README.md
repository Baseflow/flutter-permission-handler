# permission_handler_example

Demonstrates how to use the permission_handler plugin.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.io/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Testing constraints

Some permissions cannot be tested in all environments:

| Permission | Constraint |
|---|---|
| `assistant` (Siri) | Requires the `com.apple.developer.siri` entitlement in a provisioned app — **not testable on simulator or without a paid developer account**. Adding `NSSiriUsageDescription` to `Info.plist` without this entitlement will crash the app on launch. |
| `bluetooth` | Requires a **physical device** — Bluetooth is not available on the iOS simulator. |
| `locationAlways` | Requires a physical device and the `NSLocationAlwaysAndWhenInUseUsageDescription` key. |
| `appTrackingTransparency` | Dialog is only shown on iOS 14+ physical devices; always returns `authorized` on the simulator. |
