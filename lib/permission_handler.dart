import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_enums.dart';
import 'package:permission_handler/utils/codec.dart';

/// Provides a cross-platform (iOS, Android) API to request and check permissions.
class PermissionHandler {
  static const MethodChannel _channel =
      const MethodChannel('flutter.baseflow.com/permissions/methods');

  /// Returns a [Future] containing the current permission status for the supplied [PermissionGroup].
  static Future<PermissionStatus> checkPermissionStatus(
      PermissionGroup permission) async {
    final status = await _channel.invokeMethod(
        'checkPermissionStatus', Codec.encodePermissionGroup(permission));

    return Codec.decodePermissionStatus(status);
  }

  /// Open the App settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise [false] is returned.
  static Future<bool> openAppSettings() async =>
      await _channel.invokeMethod("openAppSettings");

  /// Request the user for access to the supplied list of permissiongroups.
  ///
  /// Returns a [Map] containing the status per requested permissiongroup.
  static Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
      List<PermissionGroup> permissions) async {
    final jsonData = Codec.encodePermissionGroups(permissions);
    final status = await _channel.invokeMethod('requestPermissions', jsonData);

    return Codec.decodePermissionRequestResult(status);
  }

  /// Request to see if you should show a rationale for requesting permission.
  ///
  /// This method is only implemented on Android, calling this on iOS always
  /// returns [false].
  static Future<bool> shouldShowRequestPermissionRationale(
          PermissionGroup permission) async =>
      await _channel.invokeMethod('shouldShowRequestPermissionRationale',
          Codec.encodePermissionGroup(permission));
}
