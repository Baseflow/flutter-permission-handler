## 4.2.3

* Fixes class name references in the API documentation.

## 4.2.2

* Adds limited access permission for Android 14+.

## 4.2.1

* Resolves an error that occurred when calling the `shouldShowRequestPermissionRationale` on iOS.

## 4.2.0

* Adds a new permission `Permission.backgroundRefresh` to check the background refresh permission status on iOS & macOS platforms. This is a no-op on all other platforms.

## 4.1.0

* Adds the `Permission.assistant` which allows users to request permissions to access SiriKit on iOS and macOS platforms. This is a no-op on all other platforms.

## 4.0.2

* Improved the documentation around the `PermissionStatus`, `PermissionStatusGetters` and `FuturePermissionStatusGetters`.

## 4.0.1

* Updates Android documentation on how to use `permission.photo` on Android 12 (API 32) and below and Android 13 (API 33) and above.

## 4.0.0

* **BREAKING CHANGE**: Replaces `Permission.calendarReadOnly` with `Permission.calendarWriteOnly`.

## 3.12.0

* Adds `Permission.calendarReadOnly` and `Permission.calendarFullAccess`.
* Deprecates `Permission.calendar`. Developers should use `Permission.calendarReadOnly` and `Permission.calendarFullAccess` instead.

## 3.11.5

* Updates the mentions of Android versions throughout the plugin, now following a format of 'Android {name} (API {number})'. For example: 'Android 13 (API 33)'.

## 3.11.4

* Clarifies the documentation on requesting background location permission
  through `Permission.locationAlways` on Android 10+ (API 29+).

## 3.11.3

* Updates the documentation for the `Permission.bluetooth` permission regarding the limitations of the permission on iOS.

## 3.11.2

* Changes `Permission.bluetooth` into an instance of `PermissionWithService` instead of `Permission` in order to determine iOS native's `CBManagerStatePoweredOn`.

## 3.11.1

* Updates the documentation for the `Permission.storage` permission regarding its use on Android.

## 3.11.0+1

* **HOTFIX**: Fixes misalignment in the `Permission` enum after adding the new BODY_SENSORS_BACKGROUND permission.

## 3.11.0

* Adds support for the new Android 13 permission: BODY_SENSORS_BACKGROUND.

## 3.10.0

* Adds support for the "Provisional" permission status introduced with iOS 12+.

## 3.9.0

* Adds support for the new Android 13 permissions: SCHEDULE_EXACT_ALARM, READ_MEDIA_IMAGES, READ_MEDIA_VIDEO and READ_MEDIA_AUDIO

## 3.8.0

* Adds support for the new Android 13 permission: NEARBY_WIFI_DEVICES.

## 3.7.1

* Updates the documentation on permissions in `permission_status.dart`

## 3.7.0

* Adds support for the new Android 12 Bluetooth permissions: BLUETOOTH_SCAN, BLUETOOTH_ADVERTISE, and BLUETOOTH_CONNECT.

## 3.6.2

* Updates the MethodChannelMock due to breaking changes in the platform channel test interface.

## 3.6.1

* Updates the `meta` dependency to version `^1.3.0`.
* Updates documentation for the `locationAlways` permission

## 3.6.0

* Adds support for iOS Critical Alerts and Android Access Notification Policy.

## 3.5.1

* Updates API documentation for the `PermissionStatus.permanentlyDenied` status.

## 3.5.0

* Adds support for app tracking transparency permission.

## 3.4.0

* Adds support request install packages permission.

## 3.3.0

* Adds support for system alert window permission.

## 3.2.0

* Adds support for managing external storage permission available on Android 10 and up.

## 3.1.3

* Implements the equality operator for the `Permission` class;
* Reverts the status of the services check for notification permission. Turns out the implementation does not fit with the ideas of the permission_handler plugin.

## 3.1.2

* Allows checking service status for notification permission.

## 3.1.1

* Fixes conversion issue where `PermissionStatus.denied` was not translated to the correct index.
* Adds unit tests to guard API against breaking changes.

## 3.1.0

* Adds support for Bluetooth permissions.

## 3.0.0+1

* **BREAKING**: Removes the PermissionStatus.undetermined. This is now replaced by PermissionStatus.denied.

## 3.0.0

* Migrates to null safety.

## 2.0.2

* Adds support for the limited photo permission available on iOS 14 and up.

## 2.0.1

* Updates to `platform_interface 1.0.2`
* Fixes bug that allows requesting if the device has phone capabilities.

## 2.0.0

* **BREAKING**: Creates a much more intuitive API using Dart's new extension methods ([#230](https://github.com/Baseflow/flutter-permission-handler/issues/230)). Big thank you to [@marcelgarus](https://github.com/marcelgarus) for the idea and for doing all the grunt work.

## 1.0.0

* Initial open-source release.
