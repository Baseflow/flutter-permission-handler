import 'dart:html' as html;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'web_delegate.dart';

/// Platform implementation of the permission_handler Flutter plugin.
class WebPermissionHandler extends PermissionHandlerPlatform {
  static final html.MediaDevices? _devices = html.window.navigator.mediaDevices;
  static final html.Geolocation _geolocation =
      html.window.navigator.geolocation;
  static final html.Permissions? _htmlPermissions =
      html.window.navigator.permissions;

  final WebDelegate _webDelegate;

  /// Registers the web plugin implementation.
  static void registerWith(Registrar registrar) {
    PermissionHandlerPlatform.instance = WebPermissionHandler(
      webDelegate: WebDelegate(
        _devices,
        _geolocation,
        _htmlPermissions,
      ),
    );
  }

  /// Constructs a WebPermissionHandler.
  WebPermissionHandler({
    required WebDelegate webDelegate,
  }) : _webDelegate = webDelegate;

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    return _webDelegate.requestPermissions(permissions);
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return _webDelegate.checkPermissionStatus(permission);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    return _webDelegate.checkServiceStatus(permission);
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
