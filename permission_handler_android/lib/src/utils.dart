import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'android_object_mirrors/activity.dart';
import 'android_object_mirrors/package_manager.dart';

/// A class that provides methods for setting and getting whether a manifest
/// permission was denied before.
class ManifestPersistentStorage {
  const ManifestPersistentStorage._();

  /// Writes to shared preferences that the permission was denied before.
  static Future<void> setDeniedBefore(String manifestString) async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(manifestString, true);
  }

  /// Reads from shared preferences if the permission was denied before.
  static Future<bool> wasDeniedBefore(String manifestString) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(manifestString) ?? false;
  }
}

/// Returns a [PermissionStatus] for a given manifest permission.
///
/// Note: This method has side-effects as it will store whether the permission
/// was denied before in persistent memory.
///
/// When [PackageManager.permissionDenied] is received, we do not know if the
/// permission was denied permanently. The OS does not tell us whether the
/// user dismissed the dialog or pressed 'deny'. Therefore, we need a more
/// sophisticated (read: hacky) approach to determine whether the permission
/// status is [PermissionStatus.denied] or
/// [PermissionStatus.permanentlyDenied].
///
/// The OS behavior has been researched experimentally and is displayed in the
/// following diagrams:
///
/// **State machine diagram:**
///
/// Dismissed
///    ┌┐
/// ┌──┘▼─────┐  Granted ┌───────┐
/// │Not asked├──────────►Granted│
/// └─┬───────┘          └─▲─────┘
///   │           Granted  │
///   │Denied  ┌───────────┘
///   │        │
/// ┌─▼────────┴┐        ┌────────────────────────────────┐
/// │Denied once├────────►Denied twice(permanently denied)│
/// └──▲┌───────┘ Denied └────────────────────────────────┘
///    └┘
/// Dismissed
///
/// **Scenario table listing output of
/// [ActivityCompat.shouldShowRequestPermissionRationale]:**
///
/// ┌────────────┬────────────────┬─────────┬───────────────────────────────────┬─────────────────────────┐
/// │ Scenario # │ Previous state │ Action  │ New state                         │ 'Show rationale' output │
/// ├────────────┼────────────────┼─────────┼───────────────────────────────────┼─────────────────────────┤
/// │ 1.         │ Not asked      │ Dismiss │ Not asked                         │ false                   │
/// │ 2.         │ Not asked      │ Deny    │ Denied once                       │ true                    │
/// │ 3.         │ Denied once    │ Dismiss │ Denied once                       │ true                    │
/// │ 4.         │ Denied once    │ Deny    │ Denied twice (permanently denied) │ false                   │
/// └────────────┴────────────────┴─────────┴───────────────────────────────────┴─────────────────────────┘
///
/// To distinguish between scenarios, we can use
/// [ActivityCompat.shouldShowRequestPermissionRationale]. If it returns true,
/// we can safely return [PermissionStatus.denied]. To distinguish between
/// scenarios 1 and 4, however, we need an extra mechanism. We opt to store a
/// boolean stating whether permission has been requested before. Using a
/// combination of checking for showing the permission rationale and the
/// boolean, we can distinguish all scenarios and return the appropriate
/// permission status.
///
/// Changing permissions via the app info screen (so outside of the application)
/// changes the permission state to 'Granted' if the permission is allowed, or
/// 'Denied once' if denied. This behavior should not require any additional
/// logic.
Future<PermissionStatus> grantResultToPermissionStatus(
  AndroidActivity activity,
  String manifestString,
  int grantResult,
) async {
  if (grantResult == PackageManager.permissionGranted) {
    return PermissionStatus.granted;
  }

  final bool wasDeniedBefore =
      await ManifestPersistentStorage.wasDeniedBefore(manifestString);
  final bool shouldShowRationale =
      await activity.shouldShowRequestPermissionRationale(
    manifestString,
  );

  final bool isDeniedNow =
      wasDeniedBefore ? !shouldShowRationale : shouldShowRationale;

  if (!wasDeniedBefore && isDeniedNow) {
    ManifestPersistentStorage.setDeniedBefore(manifestString);
  }

  if (wasDeniedBefore && isDeniedNow) {
    return PermissionStatus.permanentlyDenied;
  }
  return PermissionStatus.denied;
}
