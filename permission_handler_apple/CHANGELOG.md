## 9.1.4

* Adds checking whether Bluetooth service is enabled through `Permission.bluetooth.serviceStatus`.

## 9.1.3

* Fixes an issue where the `Permission.location.request()`, `Permission.locationWhenInUse.request()` and `Permission.locationAlways.request()` calls returned `PermissionStatus.denied` regardless of the actual permission status.

## 9.1.2

* Fixes an issue where the `Permission.locationAlways.request()` call hangs when the application was granted "Allow once" permissions for fetching location coordinates.

## 9.1.1

* Adds the new Android 13 permission "BODY_SENSORS_BACKGROUND" to PermissionHandlerEnums.h.

## 9.1.0

* Adds the "Provisional" permission status which is introduced in iOS 12+.

## 9.0.8

* Adds missing return statement causing the permission_handler to freeze when already requesting permissions.

## 9.0.7

* Adds new Android 13 permissions "SCHEDULE_EXACT_ALARM, READ_MEDIA_IMAGES, READ_MEDIA_VIDEO and READ_MEDIA_AUDIO" to PermissionHandlerEnums.h

## 9.0.6

* Prevents appearing popup that asks to turn on Bluetooth on iOS

## 9.0.5

* Adds new Android 13 NEARBY_WIFI_DEVICES permission to PermissionHandlerEnums.h

## 9.0.4

* Adds flag inside `UserDefaults` to save whether locationAlways has already been requested and prevent further requests, which would be left unanswered by the system.

## 9.0.3

* Ensures a request for `locationAlways` permission returns a result unblocking the permission request and preventing the `ERROR_ALREADY_REQUESTING_PERMISSIONS` error for subsequent permission request.

## 9.0.2

* Moves Apple implementation into its own package.
