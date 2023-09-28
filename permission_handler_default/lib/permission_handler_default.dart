import 'package:flutter/foundation.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

/// Platform implementation of the permission_handler Flutter plugin.
class DefaultPermissionHandler extends PermissionHandlerPlatform {
  /// Registers the default plugin implementation.
  static void registerWith() {
    PermissionHandlerPlatform.instance = DefaultPermissionHandler();
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    final Map<Permission, PermissionStatus> permissionStatusMap = {};

    for (final permission in permissions) {
      permissionStatusMap[permission] = PermissionStatus.granted;
    }

    return SynchronousFuture(permissionStatusMap);
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return SynchronousFuture(PermissionStatus.granted);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    return SynchronousFuture(ServiceStatus.enabled);
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
      Permission permission) async {
    return SynchronousFuture(false);
  }

  @override
  Future<bool> openAppSettings() {
    return SynchronousFuture(false);
  }
}
