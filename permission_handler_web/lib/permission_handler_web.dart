// ignore_for_file: overridden_fields
import 'dart:html' as html;
import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/web_handler.dart';

class WebPermissionHandler extends PermissionHandlerPlatform {
  WebHandler? webHandler;

  html.MediaDevices? devices = html.window.navigator.mediaDevices!;
  html.Permissions? permissions = html.window.navigator.permissions;

  WebPermissionHandler() {
    webHandler = WebHandler(devices, permissions);
  }

  static void registerWith(Registrar registrar) {
    PermissionHandlerPlatform.instance = WebPermissionHandler();
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    return webHandler!.requestPermissions(permissions);
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return webHandler!.checkPermissionStatus(permission);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    return webHandler!.checkServiceStatus(permission);
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
      Permission permission) async {
    return webHandler!.shouldShowRequestPermissionRationale(permission);
  }

  @override
  Future<bool> openAppSettings() {
    return webHandler!.openAppSettings();
  }
}
