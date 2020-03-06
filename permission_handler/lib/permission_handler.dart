import 'dart:async';
import 'dart:io';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

export 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    show PermissionGroup, PermissionStatus, ServiceStatus;

/// The Android and iOS implementation of [PermissionHandlerPlatform].
///
/// This class implements the `package:permission_handler` functionality for
/// the Android and iOS platforms.
class PermissionHandler extends PermissionHandlerPlatform {
  @override
  Future<ServiceStatus> checkServiceStatus(PermissionGroup permission) {
    return PermissionHandlerPlatform.instance.checkServiceStatus(permission);
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(PermissionGroup permission) {
    return PermissionHandlerPlatform.instance.checkPermissionStatus(permission);
  }

  @override
  Future<bool> openAppSettings() {
    return PermissionHandlerPlatform.instance.openAppSettings();
  }

  @override
  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
      List<PermissionGroup> permissions) {
    return PermissionHandlerPlatform.instance.requestPermissions(permissions);
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
      PermissionGroup permission) {
    if (!Platform.isAndroid) {
      return Future.value(false);
    }

    return PermissionHandlerPlatform.instance
        .shouldShowRequestPermissionRationale(permission);
  }
}
