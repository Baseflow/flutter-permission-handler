## 9.1.0

> **IMPORTANT:** when updating to version 9.1.0 make sure to also set the `compileSdkVersion` in the `app/build.gradle` file to `33`.

* Added support for the new Android 13 Notification permission: POST_NOTIFICATIONS.
* Updated Android compile and target SDK to 33 (Android 13 (Tiramisu)).

## 9.0.2+1

* Undoes PR [#765](https://github.com/baseflow/flutter-permission-handler/pull/765) which by mistake requests write_external_storage permission based on the target SDK instead of the actual SDK of the Android device.

## 9.0.2

* Moves Android implementation into its own package.