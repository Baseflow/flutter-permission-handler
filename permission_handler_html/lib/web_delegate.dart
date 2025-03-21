import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

/// The delegate class for WebPermissionHandler.
/// Used for dependency injection of html.MediaDevices and html.Permissions objects
class WebDelegate {
  /// Constructs a WebDelegate.
  WebDelegate(
    web.MediaDevices? devices,
    web.Geolocation? geolocation,
    web.Permissions? permissions,
  )   : _devices = devices,
        _geolocation = geolocation,
        _htmlPermissions = permissions;

  /// The html media devices object used to request camera and microphone permissions.
  final web.MediaDevices? _devices;

  /// The html geolocation object used to request location permission.
  final web.Geolocation? _geolocation;

  /// The html permissions object used to check permission status.
  final web.Permissions? _htmlPermissions;

  /// The permission name to request access to the camera.
  static const _microphonePermissionName = 'microphone';

  /// The permission name to request access to the camera.
  static const _cameraPermissionName = 'camera';

  /// The permission name to request notifications from the user.
  static const _notificationsPermissionName = 'notifications';

  /// The permission name to request access to the user's location.
  /// https://developer.mozilla.org/en-US/docs/Web/API/Permissions/query#name
  static const _locationPermissionName = 'geolocation';

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
      String webPermissionName, web.Permissions? permissions) async {
    final webPermissionStatus = await permissions
        ?.query(_PermissionDescriptor(name: webPermissionName))
        .toDart;
    return _toPermissionStatus(webPermissionStatus?.state);
  }

  Future<bool> _requestMicrophonePermission() async {
    if (_devices == null) {
      return false;
    }

    try {
      web.MediaStream? mediaStream = await _devices
          .getUserMedia(web.MediaStreamConstraints(audio: true.toJS))
          .toDart;

      // In browsers, calling [getUserMedia] will start the recording
      // automatically right after. This is undesired behavior as
      // [requestPermission] is expected to request permission only.
      //
      // The manual stop action is then needed here for to stop the automatic
      // recording.

      if (mediaStream.active) {
        final audioTracks = mediaStream.getAudioTracks().toDart;
        if (audioTracks.isNotEmpty) {
          audioTracks[0].stop();
        }
      }
    } on web.DOMException {
      return false;
    }

    return true;
  }

  Future<bool> _requestCameraPermission() async {
    if (_devices == null) {
      return false;
    }

    try {
      web.MediaStream? mediaStream = await _devices
          .getUserMedia(web.MediaStreamConstraints(video: true.toJS))
          .toDart;

      // In browsers, calling [getUserMedia] will start the recording
      // automatically right after. This is undesired behavior as
      // [requestPermission] is expected to request permission only.
      //
      // The manual stop action is then needed here for to stop the automatic
      // recording.

      if (mediaStream.active) {
        final videoTracks = mediaStream.getVideoTracks().toDart;
        if (videoTracks.isNotEmpty) {
          videoTracks[0].stop();
        }
      }
    } on web.DOMException {
      return false;
    }

    return true;
  }

  Future<bool> _requestNotificationPermission() async {
    return web.Notification.requestPermission()
        .toDart
        .then((permission) => (permission == "granted".toJS));
  }

  Future<bool> _requestLocationPermission() async {
    Completer<bool> completer = Completer<bool>();
    try {
      _geolocation?.getCurrentPosition(
        (JSAny _) {
          completer.complete(true);
        }.toJS,
        (JSAny _) {
          completer.complete(false);
        }.toJS,
      );
    } catch (_) {
      completer.complete(false);
    }
    return completer.future;
  }

  Future<PermissionStatus> _requestSingularPermission(
      Permission permission) async {
    bool permissionGranted = switch (permission) {
      Permission.microphone => await _requestMicrophonePermission(),
      Permission.camera => await _requestCameraPermission(),
      Permission.notification => await _requestNotificationPermission(),
      Permission.location => await _requestLocationPermission(),
      _ => throw UnsupportedError(
          'The ${permission.toString()} permission is currently not supported on web.')
    };

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
        rethrow;
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
    return _permissionStatusState(webPermissionName, _htmlPermissions);
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

// copied from https://github.com/dart-lang/web/commit/7604578eb538c471d438608673c037121d95dba5#diff-6f4c7956b6e25b547b16fc561e54d5e7d520d2c79a59ace4438c60913cc2b1a2L35-L40
extension type _PermissionDescriptor._(JSObject _) implements JSObject {
  external factory _PermissionDescriptor({required String name});

  external set name(String value);
  external String get name;
}
