## 5.0.1

- Added Support for Draw Over Other Apps permission on Android (SYSTEM_ALERT_WINDOW)

## 5.0.0+hotfix.8

- Solved an issue on iOS where requesting notifcation permissions returned prematurely (see pull-request [#297](https://github.com/Baseflow/flutter-permission-handler/pull/297))

## 5.0.0+hotfix.7

- ** Mistake release please don't use this version **

## 5.0.0+hotfix.6

- Solved an issue on iOS where requesting notification permissions always resulted in a "granted" result (see pull-request [#289](https://github.com/Baseflow/flutter-permission-handler/pull/289))

## 5.0.0+hotfix.5

- Remove use of the deprecated pre iOS 8 API causing users compile issues (see issue [#277](https://github.com/Baseflow/flutter-permission-handler/issues/277)).

## 5.0.0+hotfix.4

- Solve issue on Android causing an IllegalStateException ([#267](https://github.com/Baseflow/flutter-permission-handler/issues/267)).

## 5.0.0+hotfix.3

- Includes the changes of 4.4.0+hotfix.4 (which was released to be backwardscompatible).

## 5.0.0+hotfix.2

- Removed some residual usages of the `PermissionStatusUnknown` constants in #ifdef statements that were not found by the compiler.

## 5.0.0+hotfix.1

- Make sure all enums from `permission_handler_platform_interface: 2.0.0` are exposed through the `permission_handler`.

## 5.0.0

- **BREAKING**: Implemented more intuitive API exposed by `permission_handler_platform_interface: 2.0.0` ([#230](https://github.com/Baseflow/flutter-permission-handler/issues/230)).

## 4.4.0+hotfix.4

- Android: solved issue where `permission_handler` is used in a service (see [#251](https://github.com/Baseflow/flutter-permission-handler/issues/251))

## 4.4.0+hotfix.3

IGNORE THIS VERSION, it was released by accident and contains the same code as 4.4.0+hotfix.2

## 4.4.0+hotfix.2

- Issue #235: Solved a bug which made it impossible to request service status on Android 7;
- Issue #237: Solved a bug which crashes the application when cancelling the "Ignore battery optimizations" request for permissions.

## 4.4.0+hotfix.1

- Issue #233: Solved a bug that prevented Android applications running in the background to check the permission status.

## 4.4.0

- Updated plugin structure to confirm to the Flutter federated plugin architecture. This will make it easier to add new platform implementations (see: https://medium.com/flutter/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6);
- Android: Migrate to FlutterPlugin Android API (better support for Add-to-App);
- Android: Suppress JAVA warnings which are generated to old platform code (only executes on older platforms);
- Android: Fixed issue which sometimes resulting in illegal cast exception.

## 4.3.0

- Allow requesting location permissions when location services are disabled (on iOS this will redirect the user to the Location settings page);
- Android: Add support for requesting Activity Recognition permissions;
- Confirm to Effective Dart guidelines;
- Documented all public API members;
- Fixed several typos in the README.md.

## 4.2.0+hotfix.3

- Android: Fixes a bug which in some cases caused the permission `neverAskAgain` to be returned incorrectly.

## 4.2.0+hotfix.2

- Android: Fixes a bug where permissions are reported as `neverAskAgain` incorrectly after calling `requestPermissions` method.

## 4.2.0+hotfix.1

- Android: Fixes a bug where permissions are reported as `neverAskAgain` incorrectly.

## 4.2.0

- Android: Methods `checkPermissionStatus` and `requestPermissions` now support addition `neverAskAgain` status.

## 4.1.0

- iOS: Added option to exclude permissions logic using macros. This allows developers to submit their app to the AppStore without having to include all permissions in their Info.plist;
- Android: Support ANSWER_PHONE_CALLS permission for API 26 and higher;
- Android: Support ACCESS_MEDIA_LOCATION permission for API 26 and higher;
- Android: Synchronized Gradle version with Flutter stable (1.12.13+hotfix.5).

## 4.0.0

- iOS: Added support for requesting permissions on the DOCUMENTS and DOWNLOADS folder (thanks to @phranck);
- Androis: Fix the PROCESS_OUTGOING_CALLS permissions which have been deprecated in API 29.

## 3.3.0

- Android: Add support for requesting the background location permission within the `locationAlways` group.
- Android: Update AGP, Gradle and AndroidX dependencies

## 3.2.2

- Fixed problem with dependency on specific version of gradle wrapper on Android.

## 3.2.1+1

- Reverted the update of the 'meta' plugin since Flutter SDK depends on version 1.1.6

## 3.2.1

- Updated dependecy on 'meta' to latest version.

## 3.2.0

- Add support for Androids' "ignore battery optimizations" permission;
- Improve error logging;
- Documented support for AndroidX.

## 3.1.0

- Support service status inquiry for phone permission on iOS & Android.

## 3.0.2

- Fixed bug when rapidly requesting permissions (#23);
- Rename Enums.h to PermissionHandlerEnums.h to prevent conflicts with geolocator (#104);
- Update the Android permission request code to prevent conflicts with geolocator (#111);
- Update Gradle infrastructure.

## 3.0.1

- Mark the Swift pod as static

## 3.0.0

- Converted the iOS version from Swift to Objective-C, reducing the size of the final binary considerably.

## 2.2.0

- Added new method `checkServiceStatus` to allow users to check if the location services (on Android and iOS) and motion services (iOS only) are enabled;
- When checking permission status (using `checkPermissionStatus`) return `PermissionStatus.disabled` when permissions are granted or denied and the location services (on Android and iOS) or the motion services (iOS only) are disabled.

## 2.1.3

- Fixed bug on iOS where result of the `openAppSettings` call always returned `false`;
- Upgrade Android plugin to support AndroidX and latest Gradle and Kotlin versions;
- Added Swift version number to the Podfile of the plugin;
- Updated flutter static analyzes to conform to latest recommendations.

## 2.1.2

- Make sure the Permission Handler compiles with latest iOS SDK

## 2.1.1

- Update to the latest version of Swift (4.2);
- Make sure that the correct Swift version is set in the `Podfile` of consuming Apps;
- Updated configuration for statis code analyses, so it complies with the Flutter recommendations.

## 2.1.0

- Added Android support to check if location services are enabled. If location services are not running the permission check returns `PermissionStatus.DISABLED`.

## 2.0.1

- Fix bug with dependency on `com.android.support:support-compat` library
- Update used Kotlin and Gradle versions

## 2.0.0

- Make methods non static so users can create an instance or override

## 1.0.1

- Converted the plugin into a library so that developers don't have to import additional files;
- Updated the README.md to fix example code.

## 1.0.0

- Initial release.
