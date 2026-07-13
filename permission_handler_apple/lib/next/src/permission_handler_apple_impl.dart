import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'permission_manager.dart';

/// Internal facade that delegates to [PermissionManager].
///
/// Used by [PermissionHandlerApple] to keep the platform class thin.
class PermissionHandlerAppleImpl {
  /// Creates an implementation backed by [permissionManager].
  PermissionHandlerAppleImpl({PermissionManager? permissionManager})
      : _permissionManager = permissionManager ?? PermissionManager();

  final PermissionManager _permissionManager;

  /// Returns the current status of [permission].
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    return _permissionManager.checkPermissionStatus(permission);
  }

  /// Returns whether the service related to [permission] is enabled.
  Future<ServiceStatus> checkServiceStatus(Permission permission) {
    return _permissionManager.checkServiceStatus(permission);
  }

  /// Opens the app settings page on the device.
  Future<bool> openAppSettings() {
    return _permissionManager.openAppSettings();
  }

  /// Requests the given [permissions] and returns their resulting statuses.
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) {
    return _permissionManager.requestPermissions(permissions);
  }
}
