## 9.4.6

* Adds the ability to handle `CNAuthorizationStatusLimited` introduced in ios18

## 9.4.5

* Fixes issue #1002, Xcode warning of the unresponsive of main thread when checking isLocationEnabled.
  
## 9.4.4

* Fixes potentially-nil return type of EventPermissionStrategy#getEntityType.
* * Fixes typo in comment for full calendar access.

## 9.4.3

* Adds the `PERMISSION_LOCATION_WHENINUSE` macro, which can be used instead of
the `PERMISSION_LOCATION` macro, and exclusively enables the `requestWhenInUseAuthorization`
and remove the `requestAlwaysAuthorization` when requesting location permission.
* Improves error handling when `Info.plist` doesn't contain the correct declarations.
* Adds support for the `NSLocationAlwaysAndWhenInUseUsageDescription` property list
key.

## 9.4.2

* Updates the privacy manifest to include the use of the `NSUserDefaults` API. 
The permission_handler stores a boolean value to track if permission to always 
access the device location has been requested.

## 9.4.1

* Adds empty privacy manifest.

## 9.4.0

* Adds a new permission `Permission.backgroundRefresh` to check the background refresh permission status.

## 9.3.1

* Updates plist key from `NSPhotoLibraryUsageDescription` to `NSPhotoLibraryAddUsageDescription`.

## 9.3.0

* Adds support to request authorization to access SiriKit via the `Permission.assistant` permission.

## 9.2.0

* Adds the support for `Permission.calendarWriteOnly` and `Permission.calendarFullAccess` permissions which are introduced in iOS 17+.

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

* Adds flag inside `UserDefaults` to save whether `locationAlways` has already been requested and prevent further requests, which would be left unanswered by the system.

## 9.0.3

* Ensures a request for `locationAlways` permission returns a result unblocking the permission request and preventing the `ERROR_ALREADY_REQUESTING_PERMISSIONS` error for subsequent permission requests.

## 9.0.2

* Moves Apple implementation into its own package.
