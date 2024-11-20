## 0.1.3+5

- Updates the way how `window.navigator.mediaDevices` is accessed to keep supporting WASM.

## 0.1.3+4

- Fixes a bug causing the application to crash when running on HTTP protocol (not HTTPS or localhost) and the `window.navigator.mediaDevices` property is `null`.

## 0.1.3+3

- Safari < 16 compatibility: Don't crash on missing `window.navigator.permissions` property

## 0.1.3+2

- `web: 1.0.0` compatibility: `PermissionDescriptor` was removed in web package.

## 0.1.3+1

- Fixes the PermissionDescriptor Error when getting the permission status.

## 0.1.3

* Adds support for `web: ^1.0.0`

## 0.1.2

- Migrate to package:web and adding wasm support.

## 0.1.1

- Updates the dependency on `permission_handler_platform_interface` to version 4.1.0 (SiriKit support is only available for iOS and macOS).

## 0.1.0+2

- Fixes plugin initialization for non-https web app.
- Fixes location permission name.
- Improves error handling in the example app.

## 0.1.0+1

- Updates `permission_handler_platform_interface` dependency to version `^4.0.2`.

## 0.1.0

- Adds an initial implementation of Web support for the permission_handler plugin with camera, notifications, and microphone permissions available.
