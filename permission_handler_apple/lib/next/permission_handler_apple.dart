import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'src/permission_handler_apple_impl.dart';

/// Platform implementation of [permission_handler] for Apple platforms (iOS).
class PermissionHandlerApple extends PermissionHandlerPlatform {
  /// Registers the Apple platform implementation.
  static void registerWith() {
    PermissionHandlerPlatform.instance = PermissionHandlerApple();
  }

  final PermissionHandlerAppleImpl _impl = PermissionHandlerAppleImpl();

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    return _impl.checkPermissionStatus(permission);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) {
    return _impl.checkServiceStatus(permission);
  }

  @override
  Future<bool> openAppSettings() {
    return _impl.openAppSettings();
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) {
    return _impl.requestPermissions(permissions);
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
    Permission permission,
  ) async {
    return false;
  }
}
