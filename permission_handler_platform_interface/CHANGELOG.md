## 3.5.0

*A dded support for app tracking transparency permission.

## 3.4.0

* Added support request install packages permission.

## 3.3.0

* Added support for system alert window permission.

## 3.2.0

* Added support for manage external storage permission available on Android 10 and up.

## 3.1.3 

* Implemented equality operator for `Permission` class;
* Reverted services status check for notification permission. Turns out implementation does not fit with idea's of permission_handler plugin.

## 3.1.2

* Allow checking serviceStatus for notification permission.

## 3.1.1

* Fixed conversion issue where `PermissionStatus.denied` was not translated to the correct index.
* Added unit-tests to guard API against breaking changes.

## 3.1.0

* Added support for bluetooth permissions. 

## 3.0.0+1

* **BREAKING**: Removed PermissionStatus.undetermined. This is now replaced by PermissionStatus.denied.

## 3.0.0

* Migrated to null safety.

## 2.0.2

* Added support for the limited photos permission available on iOS 14 and up.

## 2.0.1

* Update `platform_interface 1.0.2`
* Fix bug which allows requesting is the device has phone capabilities.

## 2.0.0

- **BREAKING**: Created a much more intuitive API using Dart's new extension methods ([#230](https://github.com/Baseflow/flutter-permission-handler/issues/230)). Big thank you to [@marcelgarus](https://github.com/marcelgarus) for the idea and doing all the grunt work.

## 1.0.0

- Initial open-source release.
