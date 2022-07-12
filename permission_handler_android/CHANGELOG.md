## 10.0.0

 * __BREAKING CHANGE__: Updated Android `compileSdkVersion` to `33` to handle the new `POST_NOTIFICATIONS` permission.
 > When updating to version 10.0.0 make sure to update the `android/app/build.gradle` file and set the `compileSdkVersion` to `33`.

## 9.0.2+1

* Undoes PR [#765](https://github.com/baseflow/flutter-permission-handler/pull/765) which by mistake requests write_external_storage permission based on the target SDK instead of the actual SDK of the Android device.

## 9.0.2

* Moves Android implementation into its own package.