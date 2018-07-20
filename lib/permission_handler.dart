import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_enums.dart';
import 'package:permission_handler/utils/codec.dart';

/// Provides a cross-platform (iOS, Android) API to request and check permissions.
class PermissionHandler {
  static const MethodChannel _channel =
      const MethodChannel('flutter.baseflow.com/permissions/methods');

  /// Returns a [Future] containing the current permission status for the supplied [PermissionGroup].
  static Future<PermissionStatus> checkPermissionStatus(PermissionGroup permission) async {
    final status = await _channel.invokeMethod('checkPermissionStatus', Codec.encodePermissionGroup(permission));
    return Codec.decodePermissionStatus(status);
  }
}
