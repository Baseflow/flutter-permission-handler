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

* Adds support for the new Android 12 Bluetooth permissions: BLUETOOTH_SCAN, BLUETOOTH_ADVERTISE and BLUETOOTH_CONNECT.

## 3.6.2

* Updates the MethodChannelMock due to breaking changes in the platform channel test interface.

## 3.6.1

* Updates the `meta` dependency to version `^1.3.0`.
* Updates documentation for the `locationAlways` permission

## 3.6.0

* Adds support for iOS Critical alerts and Android Access Notification Policy.

## 3.5.1

* Updates API documentation for the `PermissionStatus.permanentlyDenied` status.

## 3.5.0

* Adds support for app tracking transparency permission.

## 3.4.0

* Adds support request install packages permission.

## 3.3.0

* Adds support for system alert window permission.

## 3.2.0

* Adds support for manage external storage permission available on Android 10 and up.

## 3.1.3 

* Implements the equality operator for `Permission` class;
* Reverts the services status check for notification permission. Turns out implementation does not fit with idea's of permission_handler plugin.

## 3.1.2

* Allows checking serviceStatus for notification permission.

## 3.1.1

* Fixes conversion issue where `PermissionStatus.denied` was not translated to the correct index.
* Adds unit-tests to guard API against breaking changes.

## 3.1.0

* Adds support for bluetooth permissions. 

## 3.0.0+1

* **BREAKING**: Removes the PermissionStatus.undetermined. This is now replaced by PermissionStatus.denied.

## 3.0.0

* Migrates to null safety.

## 2.0.2

* Adds support for the limited photos permission available on iOS 14 and up.

## 2.0.1

* Updates to `platform_interface 1.0.2`
* Fixes bug which allows requesting is the device has phone capabilities.

## 2.0.0

- **BREAKING**: Creates a much more intuitive API using Dart's new extension methods ([#230](https://github.com/Baseflow/flutter-permission-handler/issues/230)). Big thank you to [@marcelgarus](https://github.com/marcelgarus) for the idea and doing all the grunt work.

## 1.0.0

- Initial open-source release.
