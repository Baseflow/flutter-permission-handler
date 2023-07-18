import 'dart:html' as html;
import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/web_delegate.dart';

class WebPermissionHandler extends PermissionHandlerPlatform {
  WebDelegate? webDelegate;

  static final html.MediaDevices devices = html.window.navigator.mediaDevices!;
  static final html.Permissions? htmlPermissions =
      html.window.navigator.permissions;

  static void registerWith(Registrar registrar) {
    PermissionHandlerPlatform.instance = WebPermissionHandler();
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    webDelegate ??= WebDelegate(devices, htmlPermissions);
    return webDelegate!.requestPermissions(permissions);
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    webDelegate ??= WebDelegate(devices, htmlPermissions);
    return webDelegate!.checkPermissionStatus(permission);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    webDelegate ??= WebDelegate(devices, htmlPermissions);
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
