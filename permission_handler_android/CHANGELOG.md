## 11.0.1

* Fixes `java.lang.IllegalStateException: Reply already submitted` when requesting post notification permission.

## 11.0.0

* **BREAKING CHANGE:** Fixes a bug where the permission status would return 'denied' regardless of whether the status was 'denied' or 'permanently denied'.

## 10.3.6

* Fixes a bug where requesting multiple permissions would crash the app if at least one of the permissions was a [special permission](https://developer.android.com/guide/topics/permissions/overview#special).

## 10.3.5

* Fixes a bug where `Permission.ScheduleExactAlarm` was not opening the settings
screen.

## 10.3.4

* Fixes a bug where the permission status would return 'permanently denied'
instead of 'denied' when the user would dismiss the permission dialog.

## 10.3.3

* Migrates the Gradle compile arguments to the example app, so they are not enforced upon consumers of the plugin.

## 10.3.2

* Updates example app to show `Permission.photos` and hide `Permission.bluetooth`.

## 10.3.1

* Fixes `java.lang.IllegalStateException: Reply already submitted` when checking status of Bluetooth service.

## 10.3.0

* Adds support for the new Android 13 permission: BODY_SENSORS_BACKGROUND.

## 10.2.3

* Fixes missing POST_NOTIFICATIONS permission in Android example project.

## 10.2.2

* Fixes the SCHEDULE_EXACT_ALARM status check on Android 12 and 13.

## 10.2.1

* Adds compatibility with Android Gradle Plugin 8.0.

## 10.2.0

* Adds support for the new Android 13 permissions: SCHEDULE_EXACT_ALARM, READ_MEDIA_IMAGES, READ_MEDIA_VIDEO and READ_MEDIA_AUDIO

## 10.1.0

* Adds support for the new Android 13 permission: NEARBY_WIFI_DEVICES.

## 10.0.0

 * __BREAKING CHANGE__: Updates Android `compileSdkVersion` to `33` to handle the new `POST_NOTIFICATIONS` permission.
 > When updating to version 10.0.0 make sure to update the `android/app/build.gradle` file and set the `compileSdkVersion` to `33`.

## 9.0.2+1

* Undoes PR [#765](https://github.com/baseflow/flutter-permission-handler/pull/765) which by mistake requests write_external_storage permission based on the target SDK instead of the actual SDK of the Android device.

## 9.0.2

* Moves Android implementation into its own package.