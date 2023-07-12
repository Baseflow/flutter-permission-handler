import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class WebPermissionHandler extends PermissionHandlerPlatform {
  /// The permission name to request access to the camera.
  static const _microphonePermissionName = 'microphone';

  /// The permission name to request access to the camera.
  static const _cameraPermissionName = 'camera';

  /// The status indicates that permission has been granted by the user.
  static const _grantedPermissionStatus = 'granted';

  /// The status indicates that permission has been denied by the user.
  static const _deniedPermissionStatus = 'denied';

  /// The status indicates that permission can be requested.
  static const _promptPermissionStatus = 'prompt';

  static void registerWith(Registrar registrar) {
    PermissionHandlerPlatform.instance = WebPermissionHandler();
  }

  PermissionStatus _toPermissionStatus(String? webPermissionStatus) {
    switch (webPermissionStatus) {
      case _grantedPermissionStatus:
        return PermissionStatus.granted;
      case _deniedPermissionStatus:
        return PermissionStatus.permanentlyDenied;
      case _promptPermissionStatus:
      default:
        return PermissionStatus.denied;
    }
  }

  Future<PermissionStatus> _requestSingularPermission(
      Permission permission) async {
    html.MediaStream? mediaStream;
    try {
      switch (permission) {
        case Permission.microphone:
          mediaStream = await html.window.navigator.mediaDevices
              ?.getUserMedia({'audio': true});
          break;
        case Permission.camera:
          mediaStream = await html.window.navigator.mediaDevices
              ?.getUserMedia({'video': true});
          break;
        default:
          throw UnimplementedError(
            '_requestSingularPermission() has not been implemented for '
            '${permission.toString()} on web.',
          );
      }
      // In browsers, calling [getUserMedia] will start the recording
      // automatically right after. This is undesired bahavior as
      // [requestPermission] is expected to request permission only.
      //
      // The manual stop action is then needed here for to stop the automatic
      // recording.
      if (mediaStream != null && mediaStream.active!) {
        final audioTracks = mediaStream.getAudioTracks();
        if (audioTracks.isNotEmpty) {
          audioTracks[0].stop();
        }
      }
    } on html.DomException catch (e) {
      print(e);
      return PermissionStatus.permanentlyDenied;
    }
    return PermissionStatus.granted;
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    final Map<Permission, PermissionStatus> permissionStatusMap = {};

    for (final permission in permissions) {
      try {
        permissionStatusMap[permission] =
            await _requestSingularPermission(permission);
      } on UnimplementedError {
        continue;
      }
    }
    return permissionStatusMap;
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    String webPermissionName;
    switch (permission) {
      case Permission.microphone:
        webPermissionName = _microphonePermissionName;
        break;
      case Permission.camera:
        webPermissionName = _cameraPermissionName;
        break;
      default:
        throw UnimplementedError(
          '_requestSingularPermission() has not been implemented for ${permission.toString()} '
          'on web.',
        );
    }
    final webPermissionStatus = await html.window.navigator.permissions
        ?.query({'name': webPermissionName});
    return _toPermissionStatus(webPermissionStatus?.state);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    try {
      final permissionStatus = await checkPermissionStatus(permission);
      switch (permissionStatus) {
        case PermissionStatus.granted:
          return ServiceStatus.enabled;
        default:
          return ServiceStatus.disabled;
      }
    } on UnimplementedError {
      rethrow;
    }
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
