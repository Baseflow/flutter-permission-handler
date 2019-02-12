# Flutter Permission handler Plugin

[![pub package](https://img.shields.io/pub/v/permission_handler.svg)](https://pub.dartlang.org/packages/permission_handler)

A permissions plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API to request and check permissions.

Branch  | Build Status 
------- | ------------
develop | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-permission-handler.svg?branch=develop)](https://travis-ci.com/BaseflowIT/flutter-permission-handler)
master  | [![Build Status](https://travis-ci.com/BaseflowIT/flutter-permission-handler.svg?branch=master)](https://travis-ci.com/BaseflowIT/flutter-permission-handler)

## Features

* Check if a permission is granted.
* Request permission for a specific feature.
* Open app settings so the user can enable a permission.
* Show a rationale for requesting permission (Android).

## Usage

To use this plugin, add `permission_handler` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  permission_handler: '^2.2.0'
```

> **NOTE:** There's a known issue with integrating plugins that use Swift into a Flutter project created with the Objective-C template. See issue [Flutter#16049](https://github.com/flutter/flutter/issues/16049) for help on integration.

## API

### Requesting permission

```dart
import 'package:permission_handler/permission_handler.dart';

Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
```

### Checking permission

```dart
import 'package:permission_handler/permission_handler.dart';

PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
```

### Checking service status

```dart
import 'package:permission_handler/permission_handler.dart';

ServiceStatus serviceStatus = await PermissionHandler().checkServiceStatus(PermissionGroup.location);
```

Checking the service status only makes sense for the `PermissionGroup.location` on Android and the `PermissionGroup.location`, `PermissionGroup.locationWhenInUser`, `PermissionGroup.locationAlways` or `PermissionGroup.sensors` on iOS. All other permission groups are not backed by a separate service and will always return `ServiceStatus.notApplicable`.

### Open app settings

```dart
import 'package:permission_handler/permission_handler.dart';

bool isOpened = await PermissionHandler().openAppSettings();
```

### Show a rationale for requesting permission (Android only)

```dart
import 'package:permission_handler/permission_handler.dart';

bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
```

This will always return `false` on iOS.

### List of available permissions

Defines the permission groups for which permissions can be checked or requested.

```dart
enum PermissionGroup {
  /// The unknown permission only used for return type, never requested
  unknown,

  /// Android: Calendar
  /// iOS: Calendar (Events)
  calendar,

  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  camera,

  /// Android: Contacts
  /// iOS: AddressBook
  contacts,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  location,

  /// Android: Microphone
  /// iOS: Microphone
  microphone,

  /// Android: Phone
  /// iOS: Nothing
  phone,

  /// Android: Nothing
  /// iOS: Photos
  photos,

  /// Android: Nothing
  /// iOS: Reminders
  reminders,

  /// Android: Body Sensors
  /// iOS: CoreMotion
  sensors,

  /// Android: Sms
  /// iOS: Nothing
  sms,

  /// Android: External Storage
  /// iOS: Nothing
  storage,

  /// Android: Microphone
  /// iOS: Speech
  speech,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  locationAlways,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  locationWhenInUse,

  /// Android: None
  /// iOS: MPMediaLibrary
  mediaLibrary
}
```

### Status of the permission

Defines the state of a permission group

```dart
enum PermissionStatus {
  /// Permission to access the requested feature is denied by the user.
  denied,

  /// Permissions to access the feature is granted by the user but the feature is disabled.
  disabled,

  /// Permission to access the requested feature is granted by the user.
  granted,

  /// The user granted restricted access to the requested feature (only on iOS).
  restricted,

  /// Permission is in an unknown state
  unknown
}
```

### Overview of possible service statuses

Defines the state of the backing service for the supplied permission group

```dart
/// Defines the state of a service related to the permission group
enum ServiceStatus {
  /// The unknown service status indicates the state of the service could not be determined.
  unknown,

  /// There is no service for the supplied permission group.
  notApplicable,

  /// The service for the supplied permission group is disabled.
  disabled,

  /// The service for the supplied permission group is enabled.
  enabled
}
```

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/BaseflowIT/flutter-permission-handler/issues) page.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](CONTRIBUTING.md) and send us your [pull request](https://github.com/BaseflowIT/flutter-permission-handler/pulls).

## Author

This Permission handler plugin for Flutter is developed by [Baseflow](https://baseflow.com). You can contact us at <hello@baseflow.com>
