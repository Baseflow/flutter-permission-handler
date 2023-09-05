import 'dart:html' as html;
import 'dart:async';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

/// The delegate class for WebPermissionHandler.
/// Used for dependency injection of html.MediaDevices and html.Permissions objects
class WebDelegate {
  /// Constructs a WebDelegate.
  WebDelegate(this.devices, this.geolocation, this.htmlPermissions);

  /// The html media devices object used to request camera and microphone permissions.
  html.MediaDevices? devices;

  /// The html geolocation object used to request location permission.
  html.Geolocation? geolocation;

  /// The html permissions object used to check permission status.
  html.Permissions? htmlPermissions;

  /// Getter for WebDelegate.
  WebDelegate get webDelegate => WebDelegate(devices, geolocation, htmlPermissions);

  /// The permission name to request access to the camera.
  static const _microphonePermissionName = 'microphone';

  /// The permission name to request access to the camera.
  static const _cameraPermissionName = 'camera';

  /// The permission name to request notifications from the user.
  static const _notificationsPermissionName = 'notifications';

  /// The permission name to request access to the user's location.
  static const _locationPermissionName = 'location';

  /// The status indicates that permission has been granted by the user.
  static const _grantedPermissionStatus = 'granted';

  /// The status indicates that permission has been denied by the user.
  static const _deniedPermissionStatus = 'denied';

  /// The status indicates that permission can be requested.
  static const _promptPermissionStatus = 'prompt';

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

  Future<PermissionStatus> _permissionStatusState(
      String webPermissionName, html.Permissions? permissions) async {
    final webPermissionStatus =
        await permissions?.query({'name': webPermissionName});
    return _toPermissionStatus(webPermissionStatus?.state);
  }

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

  Future<bool> _requestLocationPermission(html.Geolocation geolocation) async {
    try {
      await geolocation.getCurrentPosition();
      return true;
    } on html.PositionError {
      return false;
    }
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
      case Permission.location:
        permissionGranted = await _requestLocationPermission(geolocation!);
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

  /// Requests the user for access to the supplied list of [Permission]s, if
  /// they have not already been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
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

  /// Checks the current status of the given [Permission].
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    String webPermissionName;
    switch (permission) {
      case Permission.microphone:
        webPermissionName = _microphonePermissionName;
        break;
      case Permission.camera:
        webPermissionName = _cameraPermissionName;
        break;
      case Permission.notification:
        webPermissionName = _notificationsPermissionName;
        break;
      case Permission.location:
        webPermissionName = _locationPermissionName;
        break;
      default:
        throw UnimplementedError(
          'checkPermissionStatus() has not been implemented for ${permission.toString()} '
          'on web.',
        );
    }
    return _permissionStatusState(webPermissionName, htmlPermissions);
  }

  /// Checks the current status of the service associated with the given
  /// [Permission].
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
}