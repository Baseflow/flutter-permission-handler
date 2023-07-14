import 'dart:html' as html;
import 'dart:async';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/permission_handler_web.dart';

class FakeWebPermissionHandler extends WebPermissionHandler {
  FakeWebPermissionHandler(this.devices);

  html.MediaDevices? devices;

  Future<bool> _requestMicrophonePermission(html.MediaDevices devices) async {
    html.MediaStream? mediaStream;

    try {
      mediaStream = await devices.getUserMedia({'audio': true});

      // In browsers, calling [getUserMedia] will start the recording
      // automatically right after. This is undesired behavior as
      // [requestPermission] is expected to request permission only.
      //
      // The manual stop action is then needed here for to stop the automatic
      // recording.

      if (mediaStream.active!) {
        final audioTracks = mediaStream.getAudioTracks();
        if (audioTracks.isNotEmpty) {
          audioTracks[0].stop();
        }
      }
    } on html.DomException {
      return false;
    }

    return true;
  }

  Future<bool> _requestCameraPermission(html.MediaDevices devices) async {
    html.MediaStream? mediaStream;

    try {
      mediaStream = await devices.getUserMedia({'video': true});

      // In browsers, calling [getUserMedia] will start the recording
      // automatically right after. This is undesired behavior as
      // [requestPermission] is expected to request permission only.
      //
      // The manual stop action is then needed here for to stop the automatic
      // recording.

      if (mediaStream.active!) {
        final videoTracks = mediaStream.getVideoTracks();
        if (videoTracks.isNotEmpty) {
          videoTracks[0].stop();
        }
      }
    } on html.DomException {
      return false;
    }

    return true;
  }

  Future<bool> _requestNotificationPermission() async {
    bool granted = false;
    html.Notification.requestPermission().then((permission) => {
          if (permission == "granted") {granted = true}
        });

    return granted;
  }

  Future<PermissionStatus> _requestSingularPermission(
      Permission permission) async {
    bool permissionGranted = false;

    switch (permission) {
      case Permission.microphone:
        permissionGranted = await _requestMicrophonePermission(devices!);
        break;
      case Permission.camera:
        permissionGranted = await _requestCameraPermission(devices!);
        break;
      case Permission.notification:
        permissionGranted = await _requestNotificationPermission();
        break;
      default:
        throw UnimplementedError(
          '_requestSingularPermission() has not been implemented for '
          '${permission.toString()} on web.',
        );
    }

    if (!permissionGranted) {
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
}
