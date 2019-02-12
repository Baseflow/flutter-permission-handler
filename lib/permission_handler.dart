library permission_handler;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'package:permission_handler/permission_enums.dart';
part 'package:permission_handler/utils/codec.dart';

/// Provides a cross-platform (iOS, Android) API to request and check permissions.
class PermissionHandler {
  factory PermissionHandler() {
    if (_instance == null) {
      const MethodChannel methodChannel =
          MethodChannel('flutter.baseflow.com/permissions/methods');

      _instance = PermissionHandler.private(methodChannel);
    }
    return _instance;
  }

  @visibleForTesting
  PermissionHandler.private(this._methodChannel);

  static PermissionHandler _instance;

  final MethodChannel _methodChannel;

  /// Check current permission status.
  ///
  /// Returns a [Future] containing the current permission status for the supplied [PermissionGroup].
  Future<PermissionStatus> checkPermissionStatus(
      PermissionGroup permission) async {
    final String status = await _methodChannel.invokeMethod(
        'checkPermissionStatus', Codec.encodePermissionGroup(permission));

    return Codec.decodePermissionStatus(status);
  }

  /// Check current service status.
  ///
  /// Returns a [Future] containing the current service status for the supplied [PermissionGroup].
  Future<ServiceStatus> checkServiceStatus(
      PermissionGroup permission) async {
    final String status = await _methodChannel.invokeMethod(
      'checkServiceStatus', Codec.encodePermissionGroup(permission));

    return Codec.decodeServiceStatus(status);
  }

  /// Open the App settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise [false] is returned.
  Future<bool> openAppSettings() async {
    final bool hasOpened = await _methodChannel.invokeMethod(
        'openAppSettings');

    return hasOpened;
  }

  /// Request the user for access to the supplied list of permissiongroups.
  ///
  /// Returns a [Map] containing the status per requested permissiongroup.
  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
      List<PermissionGroup> permissions) async {
    final String jsonData = Codec.encodePermissionGroups(permissions);
    final String status =
        await _methodChannel.invokeMethod(
            'requestPermissions', jsonData);

    return Codec.decodePermissionRequestResult(status);
  }

  /// Request to see if you should show a rationale for requesting permission.
  ///
  /// This method is only implemented on Android, calling this on iOS always
  /// returns [false].
  Future<bool> shouldShowRequestPermissionRationale(
      PermissionGroup permission) async {
    if (!Platform.isAndroid) {
      return false;
    }

    final bool shouldShowRationale = await _methodChannel.invokeMethod(
        'shouldShowRequestPermissionRationale',
        Codec.encodePermissionGroup(permission));

    return shouldShowRationale;
  }
}
