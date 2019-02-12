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
