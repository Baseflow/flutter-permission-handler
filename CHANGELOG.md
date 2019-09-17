## 4.0.3

* iOS 仅支持相册

## 4.0.0

* Remove Remove redundant implementation(iOS)

## 3.2.2

* Fixed problem with dependency on specific version of gradle wrapper on Android.

## 3.2.1+1

* Reverted the update of the 'meta' plugin since Flutter SDK depends on version 1.1.6

## 3.2.1

* Updated dependecy on 'meta' to latest version.

## 3.2.0

* Add support for Androids' "ignore battery optimizations" permission;
* Improve error logging;
* Documented support for AndroidX.

## 3.1.0

* Support service status inquiry for phone permission on iOS & Android.

## 3.0.2

* Fixed bug when rapidly requesting permissions (#23);
* Rename Enums.h to PermissionHandlerEnums.h to prevent conflicts with geolocator (#104);
* Update the Android permission request code to prevent conflicts with geolocator (#111);
* Update Gradle infrastructure.

## 3.0.1

* Mark the Swift pod as static

## 3.0.0

* Converted the iOS version from Swift to Objective-C, reducing the size of the final binary considerably.

## 2.2.0

* Added new method `checkServiceStatus` to allow users to check if the location services (on Android and iOS) and motion services (iOS only) are enabled;
* When checking permission status (using `checkPermissionStatus`) return `PermissionStatus.disabled` when permissions are granted or denied and the location services (on Android and iOS) or the motion services (iOS only) are disabled.

## 2.1.3

* Fixed bug on iOS where result of the `openAppSettings` call always returned `false`;
* Upgrade Android plugin to support AndroidX and latest Gradle and Kotlin versions;
* Added Swift version number to the Podfile of the plugin;
* Updated flutter static analyzes to conform to latest recommendations.

## 2.1.2

* Make sure the Permission Handler compiles with latest iOS SDK

## 2.1.1

* Update to the latest version of Swift (4.2);
* Make sure that the correct Swift version is set in the `Podfile` of consuming Apps;
* Updated configuration for statis code analyses, so it complies with the Flutter recommendations.

## 2.1.0

* Added Android support to check if location services are enabled. If location services are not running the permission check returns `PermissionStatus.DISABLED`.

## 2.0.1

* Fix bug with dependency on `com.android.support:support-compat` library
* Update used Kotlin and Gradle versions

## 2.0.0

* Make methods non static so users can create an instance or override

## 1.0.1

* Converted the plugin into a library so that developers don't have to import additional files;
* Updated the README.md to fix example code.

## 1.0.0

* Initial release.
