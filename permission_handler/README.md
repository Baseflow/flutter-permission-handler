[![pub package](https://img.shields.io/pub/v/permission_handler.svg)](https://pub.dartlang.org/packages/permission_handler) [![Build status](https://github.com/Baseflow/flutter-permission-handler/actions/workflows/permission_handler.yaml/badge.svg?branch=master)](https://github.com/Baseflow/flutter-permission-handler/actions/workflows/permission_handler.yaml) [![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart) [![codecov](https://codecov.io/gh/Baseflow/flutter-permission-handler/branch/master/graph/badge.svg)](https://codecov.io/gh/Baseflow/flutter-permission-handler)

On most operating systems, permissions aren't just granted to apps at install time.
Rather, developers have to ask the user for permission while the app is running.

This plugin provides a cross-platform (iOS, Android) API to request permissions and check their status.
You can also open the device's app settings so users can grant permission.  
On Android, you can show a rationale for requesting permission.

See the [FAQ](#faq) section for more information on common questions when using the permission_handler plugin.

## Setup

While the permissions are being requested during runtime, you'll still need to tell the OS which permissions your app might potentially use. That requires adding permission configuration to Android* and iOS-specific files.

<details>
<summary>Android (click to expand)</summary>
  
**Upgrade pre-1.12 Android projects**
  
Since version 4.4.0 this plugin is implemented using the Flutter 1.12 Android plugin APIs. Unfortunately, this means App developers also need to migrate their Apps to support the new Android infrastructure. You can do so by following the [Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects) migration guide. Failing to do so might result in unexpected behavior. The most common known error is the permission_handler not returning after calling the `.request()` method on permission.

**AndroidX**

As of version 3.1.0, the <kbd>permission_handler</kbd> plugin switched to the AndroidX version of the Android Support Libraries. This means you need to make sure your Android project is also upgraded to support AndroidX. Detailed instructions can be found [here](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility).

The TL;DR version is:

1. Add the following to your "gradle.properties" file:

```properties
android.useAndroidX=true
android.enableJetifier=true
```

2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 33:

```gradle
android {
  compileSdkVersion 33
  ...
}
```

3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found [here](https://developer.android.com/jetpack/androidx/migrate)).

Add permissions to your `AndroidManifest.xml` file.
There are `debug`, `main`, and `profile` versions which are chosen depending on how you start your app.
In general, it's sufficient to add permission only to the `main` version.
[Here](https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler/example/android/app/src/main/AndroidManifest.xml)'s an example `AndroidManifest.xml` with a complete list of all possible permissions.

</details>

<details>
<summary>iOS (click to expand)</summary>

Add permission to your `Info.plist` file.
[Here](https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler/example/ios/Runner/Info.plist)'s an example `Info.plist` with a complete list of all possible permissions.

> IMPORTANT: ~~You will have to include all permission options when you want to submit your App.~~ This is because the `permission_handler` plugin touches all different SDKs and because the static code analyzer (run by Apple upon App submission) detects this and will assert if it cannot find a matching permission option in the `Info.plist`. More information about this can be found [here](https://github.com/Baseflow/flutter-permission-handler/issues/26).

The <kbd>permission_handler</kbd> plugin use [macros](https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h) to control whether a permission is enabled.

You must list the permission you want to use in your application:

1. Add the following to your `Podfile` file:

  ```ruby
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)

      target.build_configurations.each do |config|
        # You can remove unused permissions here
        # for more information: https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
        # e.g. when you don't need camera permission, just add 'PERMISSION_CAMERA=0'
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
          '$(inherited)',

          ## dart: PermissionGroup.calendar
          'PERMISSION_EVENTS=1',
          
          ## dart: PermissionGroup.calendarFullAccess
          'PERMISSION_EVENTS_FULL_ACCESS=1',

          ## dart: PermissionGroup.reminders
          'PERMISSION_REMINDERS=1',

          ## dart: PermissionGroup.contacts
          'PERMISSION_CONTACTS=1',

          ## dart: PermissionGroup.camera
          'PERMISSION_CAMERA=1',

          ## dart: PermissionGroup.microphone
          'PERMISSION_MICROPHONE=1',

          ## dart: PermissionGroup.speech
          'PERMISSION_SPEECH_RECOGNIZER=1',

          ## dart: PermissionGroup.photos
          'PERMISSION_PHOTOS=1',

          ## The 'PERMISSION_LOCATION' macro enables the `locationWhenInUse` and `locationAlways` permission. If
          ## the application only requires `locationWhenInUse`, only specify the `PERMISSION_LOCATION_WHENINUSE`
          ## macro.
          ##
          ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
          'PERMISSION_LOCATION=1',
          'PERMISSION_LOCATION_WHENINUSE=0',

          ## dart: PermissionGroup.notification
          'PERMISSION_NOTIFICATIONS=1',

          ## dart: PermissionGroup.mediaLibrary
          'PERMISSION_MEDIA_LIBRARY=1',

          ## dart: PermissionGroup.sensors
          'PERMISSION_SENSORS=1',

          ## dart: PermissionGroup.bluetooth
          'PERMISSION_BLUETOOTH=1',

          ## dart: PermissionGroup.appTrackingTransparency
          'PERMISSION_APP_TRACKING_TRANSPARENCY=1',

          ## dart: PermissionGroup.criticalAlerts
          'PERMISSION_CRITICAL_ALERTS=1',

          ## dart: PermissionGroup.criticalAlerts
          'PERMISSION_ASSISTANT=1',
        ]

      end
    end
  end
  ```

2. Remove the `#` character in front of the permission you want to use. For example, if you need access to the calendar make sure the code looks like this:

   ```ruby
           ## dart: PermissionGroup.calendar
           'PERMISSION_EVENTS=1',
   ```

3. Delete the corresponding permission description in `Info.plist`
   e.g. when you don't need camera permission, just delete 'NSCameraUsageDescription'
   The following lists the relationship between `Permission` and `The key of Info.plist`:

| Permission                                                                                  | Info.plist                                                                                                    | Macro                                |
|---------------------------------------------------------------------------------------------| ------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| PermissionGroup.calendar (< iOS 17)                                                         | NSCalendarsUsageDescription                                                                                   | PERMISSION_EVENTS                    |
| PermissionGroup.calendarWriteOnly (iOS 17+)                                                 | NSCalendarsWriteOnlyAccessUsageDescription                                                                    | PERMISSION_EVENTS                    |
| PermissionGroup.calendarFullAccess  (iOS 17+)                                               | NSCalendarsFullAccessUsageDescription                                                                         | PERMISSION_EVENTS_FULL_ACCESS        |
| PermissionGroup.reminders                                                                   | NSRemindersUsageDescription                                                                                   | PERMISSION_REMINDERS                 |
| PermissionGroup.contacts                                                                    | NSContactsUsageDescription                                                                                    | PERMISSION_CONTACTS                  |
| PermissionGroup.camera                                                                      | NSCameraUsageDescription                                                                                      | PERMISSION_CAMERA                    |
| PermissionGroup.microphone                                                                  | NSMicrophoneUsageDescription                                                                                  | PERMISSION_MICROPHONE                |
| PermissionGroup.speech                                                                      | NSSpeechRecognitionUsageDescription                                                                           | PERMISSION_SPEECH_RECOGNIZER         |
| PermissionGroup.photos                                                                      | NSPhotoLibraryUsageDescription                                                                                | PERMISSION_PHOTOS                    |
| PermissionGroup.photosAddOnly                                                               | NSPhotoLibraryAddUsageDescription                                                                             | PERMISSION_PHOTOS_ADD_ONLY           |
| PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse | NSLocationUsageDescription, NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationWhenInUseUsageDescription | PERMISSION_LOCATION                  |
| PermissionGroup.locationWhenInUse                                                           | NSLocationWhenInUseUsageDescription                                                                           | PERMISSION_LOCATION_WHENINUSE        |
| PermissionGroup.notification                                                                | PermissionGroupNotification                                                                                   | PERMISSION_NOTIFICATIONS             |
| PermissionGroup.mediaLibrary                                                                | NSAppleMusicUsageDescription, kTCCServiceMedia                                                                |
PERMISSION_MEDIA_LIBRARY             |

4. Clean & Rebuild

</details>

## How to use

There are a number of [`Permission`](https://pub.dev/documentation/permission_handler_platform_interface/latest/permission_handler_platform_interface/Permission-class.html#constants)s.
You can get a `Permission`'s `status`, which is either `granted`, `denied`, `restricted`, `permanentlyDenied`, `limited`, or `provisional`.

```dart
var status = await Permission.camera.status;
if (status.isDenied) {
  // We haven't asked for permission yet or the permission has been denied before, but not permanently.
}

// You can also directly ask permission about its status.
if (await Permission.location.isRestricted) {
  // The OS restricts access, for example, because of parental controls.
}
```

Can use also this style for better readability of your code when using the `Permission` class.

```dart
await Permission.camera
  .onDeniedCallback(() {
    // Your code
  })
  .onGrantedCallback(() {
    // Your code
  })
  .onPermanentlyDeniedCallback(() {
    // Your code
  })
  .onRestrictedCallback(() {
    // Your code
  })
  .onLimitedCallback(() {
    // Your code
  })
  .onProvisionalCallback(() {
    // Your code
  })
  .request();
```

Call `request()` on a `Permission` to request it.
If it has already been granted before, nothing happens.  
`request()` returns the new status of the `Permission`.

```dart
if (await Permission.contacts.request().isGranted) {
  // Either the permission was already granted before or the user just granted it.
}

// You can request multiple permissions at once.
Map<Permission, PermissionStatus> statuses = await [
  Permission.location,
  Permission.storage,
].request();
print(statuses[Permission.location]);
```

Some permissions, for example, location or acceleration sensor permissions, have an associated service, which can be `enabled` or `disabled`.

```dart
if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
  // Use location.
}
```

You can also open the app settings:

```dart
if (await Permission.speech.isPermanentlyDenied) {
  // The user opted to never again see the permission request dialog for this
  // app. The only way to change the permission's status now is to let the
  // user manually enables it in the system settings.
  openAppSettings();
}
```

On Android, you can show a rationale for using permission:

```dart
bool isShown = await Permission.contacts.shouldShowRequestRationale;
```

Some permissions will not show a dialog asking the user to allow or deny the requested permission.  
This is because the OS setting(s) of the app are being retrieved for the corresponding permission.  
The status of the setting will determine whether the permission is `granted` or `denied`.

The following permissions will show no dialog:

- Notification
- Bluetooth

The following permissions will show no dialog, but will open the corresponding setting intent for the user to change the permission status:

- manageExternalStorage
- systemAlertWindow
- requestInstallPackages
- accessNotificationPolicy

The `locationAlways` permission can not be requested directly, the user has to request the `locationWhenInUse` permission first.
Accepting this permission by clicking on the 'Allow While Using App' gives the user the possibility to request the `locationAlways` permission.
This will then bring up another permission popup asking you to `Keep Only While Using` or to `Change To Always Allow`.

## FAQ

### Requesting "storage" permissions always returns "denied" on Android 13+. What can I do?

On Android, the `Permission.storage` permission is linked to the Android `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE` permissions. Starting from Android 10 (API 29) the `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE` permissions have been marked deprecated and have been fully removed/disabled since Android 13 (API 33).

If your application needs access to media files Google recommends using the `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, or `READ_MEDIA_AUDIO` permissions instead. These can be requested using the `Permission.photos`, `Permission.videos`, and `Permission.audio` respectively. To request these permissions make sure the `compileSdkVersion` in the `android/app/build.gradle` file is set to `33`.

If your application needs access to Android's file system, it is possible to request the `MANAGE_EXTERNAL_STORAGE` permission (using `Permission.manageExternalStorage`). As of Android 11 (API 30), the `MANAGE_EXTERNAL_STORAGE` permission is considered a high-risk or sensitive permission. Therefore it is required to [declare the use of these permissions](https://support.google.com/googleplay/android-developer/answer/9214102) if you intend to release the application via the Google Play Store.

### Requesting `Permission.locationAlways` always returns "denied" on Android 10+ (API 29+). What can I do?

Starting with Android 10, apps are required to first obtain permission to read the device's location in the foreground, before requesting to read the location in the background as well. When requesting the 'location always' permission directly, or when requesting both permissions at the same time, the system will ignore the request. So, instead of calling only `Permission.location.request()`, make sure to first call either `Permission.location.request()` or `Permission.locationWhenInUse.request()`, and obtain permission to read the GPS. Once you obtain this permission, you can call `Permission.locationAlways.request()`. This will present the user with the option to update the settings so the location can always be read in the background. For more information, visit the [Android documentation on requesting location permissions](https://developer.android.com/training/location/permissions#request-only-foreground).

### onRequestPermissionsResult is called without results. What can I do?

It is probably caused by a difference between completeSdkVersion and targetSdkVersion. It can be depending on the flutter version that you use. `targetSdkVersion = flutter.targetSdkVersion` in the app/build.gradle indicates that the targetSdkVersion is flutter version dependant. For more information: [issue 1222](https://github.com/Baseflow/flutter-permission-handler/issues/1222)

### Checking or requesting a permission terminates the application on iOS. What can I do?

First of all make sure all that the `ios/Runner/Info.plist` file contains entries for all the permissions the application requires. If an entry is missing iOS will terminate the application as soon as the particular permission is being checked or requested.

If the application requires access to SiriKit (by requesting the `Permission.assistant` permission), also make sure to add the `com.apple.developer.siri` entitlement to the application configuration. To do so create a file (if it doesn't exists already) called `Runner.entitlements` in the `ios/Runner` folder that is part of the project. Open the file and add the following contents:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.siri</key>
	<true/>
</dict>
</plist>
```

The important part here is the `key` with value `com.apple.developer.siri` and the element `<true/>`. It is possible that this file also contains other entitlements depending on the needs of the application.

## Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-permission-handler/issues) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [hello@baseflow.com](mailto:hello@baseflow.com).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-permission-handler/pulls).

## Author

This Permission handler plugin for Flutter is developed by [Baseflow](https://baseflow.com). You can contact us at <hello@baseflow.com>
