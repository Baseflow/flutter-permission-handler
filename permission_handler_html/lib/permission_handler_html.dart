import 'dart:async';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'web_delegate.dart';

/// Platform implementation of the permission_handler Flutter plugin.
class WebPermissionHandler extends PermissionHandlerPlatform {
  static final web.MediaDevices? _devices = (() {
    if (!web.window.navigator.has('mediaDevices')) {
      return null;
    }
    return web.window.navigator.mediaDevices;
  })();
  static final web.Geolocation _geolocation = web.window.navigator.geolocation;
  static final web.Permissions? _htmlPermissions = (() {
    // Using unsafe interop to check availability of `permissions`.
    // It's not defined as nullable, so merely loading it into a web.Permission? variable
    // causes the null-check to fail
    if (!web.window.navigator.has("permissions")) {
      return null;
    }
    return web.window.navigator.permissions;
  })();

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
