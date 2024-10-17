## 12.0.13

* Updates the Android min SDK to 19 (from 16).
* Migrates example app away from deprecated imperative apply in gradle (see: https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply).

## 12.0.12

* Fixes permission status returned from `Permission.photos.request()` or `Permission.videos.request()` when limited access selected

## 12.0.11

* Adds `TargetApi` annotation to `getManifestNames` method in `PermissionUtils.java`.

## 12.0.10

* Fixes a bug that causes a `NullPointerException` when the application is restarted after being killed by Android during the request of special permissions (like, `Permission.ignoreBatteryOptimizations`, `Permission.systemAlertWindow`, `Permission.accessNotificationPolicy`, `Permission.scheduleExactAlarm` and `Permission.manageExternalStorage`).

## 12.0.9

* Makes the status returned when requesting the READ_MEDIA_VISUAL_USER_SELECTED permission more accurate.

## 12.0.8

* Adds support for limited photo and video permission on Android. 

## 12.0.7

* Removes additional Android v1 embedding class reference.

## 12.0.6

* Removes deprecated support for Android V1 embedding as support will be removed from Flutter (see [flutter/flutter#144726](https://github.com/flutter/flutter/pull/144726)).

## 12.0.5

* Upgrades Gradle and Android Gradle plugin.

## 12.0.4

* Returns `granted` on permission `Permission.scheduleExactAlarm` for devices running lower than Android S (API 31), before this change the default return was `denied`.
* Updates `minSdkVersion` version to `flutter.minSdkVersion`.

## 12.0.3

* Updates the dependency on `permission_handler_platform_interface` to version 4.1.0 (SiriKit support is only available for iOS or macOS).

## 12.0.2

* Fixes bug where Android activity is leaked when embedded in native Android application.

## 12.0.1

* Fixes a bug where the `ignoreBatteryOptimizations` permission didn't report the correct status when the permission is requested and granted.

## 12.0.0

* **BREAKING CHANGES:**
  * Adds `Permission.calendarWriteOnly`.
  * Removes `Permission.calendarReadOnly`.

## 11.1.0

* Implements the `Permission.calendarReadOnly` and `PermissionCalendarFullAccess` permissions.

## 11.0.5

* Removes the obsolete `updatePermissionShouldShowStatus` method from the Java code base.
* Fixes some analysis warnings in the Java code base.

## 11.0.4

* Fixes a bug where the status of special permissions would incorrectly be reported as `denied`.

## 11.0.3

* Fixes a bug where `Permission.notification.status` would never return `permanentlyDenied` on Android.

## 11.0.2

* Fixes a bug where `Permission.Phone` would always return 'denied' when requesting the permission status.
* Fixes a bug where Flutter permissions that require multiple Android permissions would base their status on the status of the first Android permission, as opposed to the result of all relevant Android permissions.

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
  instead of 'denied' when the user dismisses the permission dialog.

## 10.3.3

* Migrates the Gradle compile arguments to the example app, so they are not enforced upon consumers of the plugin.

## 10.3.2

* Updates example app to show `Permission.photos` and hide `Permission.bluetooth`.

## 10.3.1

* Fixes `java.lang.IllegalStateException: Reply already submitted` when checking the status of Bluetooth service.

## 10.3.0

* Adds support for the new Android 13 permission: BODY_SENSORS_BACKGROUND.

## 10.2.3

* Fix missing POST_NOTIFICATIONS permission in the Android example project.

## 10.2.2

* Fixes the SCHEDULE_EXACT_ALARM status check on Android 12 and 13.

## 10.2.1

* Adds compatibility with Android Gradle Plugin 8.0.

## 10.2.0

* Adds support for the new Android 13 permissions: SCHEDULE_EXACT_ALARM, READ_MEDIA_IMAGES, READ_MEDIA_VIDEO and READ_MEDIA_AUDIO

## 10.1.0

* Adds support for the new Android 13 permission: NEARBY_WIFI_DEVICES.

## 10.0.0

* **BREAKING CHANGE**: Updates Android `compileSdkVersion` to `33` to handle the new `POST_NOTIFICATIONS` permission.
  > When updating to version 10.0.0 make sure to update the `android/app/build.gradle` file and set the `compileSdkVersion` to `33`.

## 9.0.2+1

* Undoes PR [#765](https://github.com/baseflow/flutter-permission-handler/pull/765) which by mistake requests write_external_storage permission based on the target SDK instead of the actual SDK of the Android device.

## 9.0.2

* Moves Android implementation into its own package.
