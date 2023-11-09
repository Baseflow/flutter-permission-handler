import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'android_object_mirrors/manifest.dart';

/// An extension on [Permission] that provides a [manifestStrings] getter.
extension PermissionToManifestStrings on Permission {
  /// Returns the matching Manifest.permission strings for this permission.
  ///
  /// TODO(jweener): translate all permissions that will be universally
  /// available.
  List<String> get manifestStrings {
    // ignore: deprecated_member_use
    if (this == Permission.calendarFullAccess || this == Permission.calendar) {
      return [
        Manifest.permission.readCalendar,
        Manifest.permission.writeCalendar,
      ];
    } else if (this == Permission.calendarWriteOnly) {
      return [Manifest.permission.writeCalendar];
    } else if (this == Permission.camera) {
      return [Manifest.permission.camera];
    } else if (this == Permission.ignoreBatteryOptimizations) {
      return [Manifest.permission.requestIgnoreBatteryOptimizations];
    }

    throw UnimplementedError(
      'There is no matching Manifest.permission string for $this',
    );
  }
}
