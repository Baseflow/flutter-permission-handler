import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import '../../permission_handler_android.dart';
import '../android_permission_handler_api_impls.dart';
import '../permission_handler.pigeon.dart';

/// An activity is a single, focused thing that the user can do.
///
/// See https://developer.android.com/reference/android/app/Activity.
class Activity extends JavaObject {
  /// Instantiates an [AndroidActivity] without creating and attaching to an instance
  /// of the associated native class.
  Activity.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  }) : super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );
}

/// A mixin that exposes Android activity functionality to the class it is mixed into.
///
/// [AndroidActivity.register] should be called once before using any of the
/// methods in this class.
///
/// The using class can call activity methods such as [requestPermissions] and
/// listen to callbacks by implementing methods such as
/// [onRequestPermissionsResult].
///
/// Example:
/// ```dart
/// void main() {
///   // Register the [AndroidActivity] mixin.
///   AndroidActivity.register();
///
///   runApp(MyApp());
/// }
///
/// // Mix in [AndroidActivity].
/// class MyApp extends StatelessWidget with AndroidActivity {
///   @override
///   Widget build(BuildContext context) {
///     return ...
///   }
///
///   void _requestPermission() {
///     requestPermissions([Manifest.permission.camera]);
///   }
///
///   @override
///   void onRequestPermissionsResult(
///     int requestCode,
///     List<String> permissions,
///     List<int> grantResults,
///   ) {
///     // Handle permission request results.
///   }
/// }
/// ```
mixin AndroidActivity {
  static final ActivityHostApiImpl _hostApi = ActivityHostApiImpl();
  static final ActivityFlutterApiImpl _flutterApi = ActivityFlutterApiImpl();

  /// An [AndroidActivity] instance that is waiting for permission request results.
  ///
  /// We are assuming there is only ever 1 instance of [AndroidActivity] that
  /// is waiting for permission request results.
  static AndroidActivity? _requestingAndroidActivity;

  /// Initializes communication with native platform.
  static void register() {
    ActivityFlutterApi.setup(_flutterApi);
  }

  /// Gets whether you should show UI with rationale before requesting a permission.
  Future<bool> shouldShowRequestPermissionRationale(
    String permission,
  ) {
    final Activity? activity = _flutterApi.activity;
    if (activity == null) {
      throw const MissingActivityException();
    }

    return _hostApi.shouldShowRequestPermissionRationaleFromInstance(
      activity,
      permission,
    );
  }

  /// Gets whether the app has been granted the given permission.
  Future<int> checkSelfPermission(
    String permission,
  ) {
    final Activity? activity = _flutterApi.activity;
    if (activity == null) {
      throw const MissingActivityException();
    }

    return _hostApi.checkSelfPermissionFromInstance(
      activity,
      permission,
    );
  }

  /// Requests permissions to be granted to this application.
  Future<void> requestPermissions(
    List<String> permissions,
    int requestCode,
  ) {
    final Activity? activity = _flutterApi.activity;
    if (activity == null) {
      throw const MissingActivityException();
    }

    _requestingAndroidActivity = this;

    return _hostApi.requestPermissionsFromInstance(
      activity,
      permissions,
      requestCode,
    );
  }

  /// Relays the permission request result to the correct [AndroidActivity] instance.
  static void relayOnRequestPermissionsResult(
    int requestCode,
    List<String> permissions,
    List<int> grantResults,
  ) {
    final AndroidActivity? androidActivity = _requestingAndroidActivity;
    if (androidActivity == null) {
      debugPrint(
        'A permission result was received while no instance of `AndroidActivity` is waiting for it',
      );
    }

    _requestingAndroidActivity = null;

    androidActivity?.onRequestPermissionsResult(
      requestCode,
      permissions,
      grantResults,
    );
  }

  /// Overwrite this method to receive permission request results.
  ///
  /// Request permissions using [AndroidActivity.requestPermissions].
  void onRequestPermissionsResult(
    int requestCode,
    List<String> permissions,
    List<int> grantResults,
  ) {
    debugPrint(
      '`onRequestPermissionsResult` was called but not overwritten. You should override `onRequestPermissionsResult` to receive the results from calling `requestPermissions`',
    );
  }
}
