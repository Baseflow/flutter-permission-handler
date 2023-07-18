import 'dart:html' as html;
import 'dart:async';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/web_handler.dart';

class FakeWebPermissionHandler {
  WebHandler? webHandler;

  html.MediaDevices? devices;
  html.Permissions? permissions;

  FakeWebPermissionHandler(this.devices, this.permissions) {
    webHandler = WebHandler(devices, permissions);
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    return webHandler!.requestPermissions(permissions);
  }

  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return webHandler!.checkPermissionStatus(permission);
  }

  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    return webHandler!.checkServiceStatus(permission);
  }

  Future<bool> shouldShowRequestPermissionRationale(
      Permission permission) async {
    return webHandler!.shouldShowRequestPermissionRationale(permission);
  }

  Future<bool> openAppSettings() {
    return webHandler!.openAppSettings();
  }
}
