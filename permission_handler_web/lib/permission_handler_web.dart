import 'dart:html' as html;
import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/web_delegate.dart';

class WebPermissionHandler extends PermissionHandlerPlatform {
  WebDelegate? webDelegate;

  html.MediaDevices? devices = html.window.navigator.mediaDevices!;
  html.Permissions? permissions = html.window.navigator.permissions;

  WebPermissionHandler() {
    webDelegate = WebDelegate(devices, permissions);
  }

  static void registerWith(Registrar registrar) {
    PermissionHandlerPlatform.instance = WebPermissionHandler();
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    return webDelegate!.requestPermissions(permissions);
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return webDelegate!.checkPermissionStatus(permission);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    return webDelegate!.checkServiceStatus(permission);
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
      Permission permission) async {
    throw UnimplementedError(
        'shouldShowRequestPermissionRationale() has not been implemented for web.');
  }

  @override
  Future<bool> openAppSettings() {
    throw UnimplementedError(
        'openAppSettings() has not been implemented for web.');
  }
}
