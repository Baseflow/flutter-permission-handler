import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/permission_handler.pigeon.dart';

import '../android_permission_handler_api_impls.dart';

/// An activity is a single, focused thing that the user can do.
///
/// See https://developer.android.com/reference/android/app/Activity.
class Activity extends JavaObject {
  /// Instantiates an [Activity] without creating and attaching to an instance
  /// of the associated native class.
  Activity.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = ActivityHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );

  final ActivityHostApiImpl _hostApi;

  /// Gets whether the application should show UI with rationale before requesting a permission.
  ///
  /// See https://developer.android.com/reference/android/app/Activity.html#shouldShowRequestPermissionRationale(java.lang.String).
  Future<bool> shouldShowRequestPermissionRationale(
    String permission,
  ) {
    return _hostApi.shouldShowRequestPermissionRationaleFromInstance(
      this,
      permission,
    );
  }

  /// Determine whether you have been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/ContextWrapper#checkSelfPermission(java.lang.String).
  Future<int> checkSelfPermission(
    String permission,
  ) {
    return _hostApi.checkSelfPermissionFromInstance(
      this,
      permission,
    );
  }

  /// Requests permissions to be granted to this application.
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// permission results are returned as a [Future] instead of through a
  /// separate callback.
  ///
  /// See
  /// https://developer.android.com/reference/android/app/Activity.html#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/androidx/core/app/ActivityCompat.OnRequestPermissionsResultCallback.
  Future<PermissionRequestResult> requestPermissions(
    List<String> permissions,
  ) {
    return _hostApi.requestPermissionsFromInstance(
      this,
      permissions,
    );
  }
}
