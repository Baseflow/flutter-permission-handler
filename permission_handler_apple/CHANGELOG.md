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
