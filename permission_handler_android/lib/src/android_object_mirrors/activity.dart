import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/permission_handler.pigeon.dart';

import '../../permission_handler_android.dart';
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

  /// Use with [Context.getSystemService] to retrieve a [PowerManager] for
  /// controlling power management, including "wake locks," which let you keep
  /// the device on while you're running long tasks.
  static const String powerService = 'power';

  /// Use with [Context.getSystemService] to retrieve an [AlarmManager] for
  /// receiving intents at a time of your choosing.
  static const String alarmService = 'alarm';

  /// Standard activity result: operation succeeded.
  ///
  /// Constant Value: -1 (0xffffffff).
  ///
  /// See https://developer.android.com/reference/android/app/Activity#RESULT_OK.
  static const int resultOkay = -1;

  /// Standard activity result: operation canceled.
  ///
  /// Constant Value: 0 (0x00000000).
  ///
  /// See https://developer.android.com/reference/android/app/Activity#RESULT_CANCELED.
  static const int resultCanceled = 0;

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

  /// Determines whether the application has been granted a particular permission.
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
  /// See
  /// https://developer.android.com/reference/android/app/Activity.html#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/androidx/core/app/ActivityCompat.OnRequestPermissionsResultCallback.
  Future<PermissionRequestResult> requestPermissions(
    List<String> permissions, {
    int? requestCode,
  }) {
    return _hostApi.requestPermissionsFromInstance(
      this,
      permissions,
      requestCode,
    );
  }

  /// Launches a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  Future<void> startActivity(
    Intent intent,
  ) {
    return _hostApi.startActivityFromInstance(
      this,
      intent,
    );
  }

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  Future<String> getPackageName() {
    return _hostApi.getPackageNameFromInstance(
      this,
    );
  }

  /// Start an activity for which the application would like a result when it finished.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
  Future<ActivityResult> startActivityForResult(
    Intent intent, {
    int? requestCode,
  }) {
    return _hostApi.startActivityForResultFromInstance(
      this,
      intent,
      requestCode,
    );
  }

  /// Returns the handle to a system-level service by name.
  ///
  /// The class of the returned object varies by the requested name.
  ///
  /// Returns the instance ID of the service.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getSystemService(java.lang.String).
  Future<Object?> getSystemService(
    String name,
  ) {
    return _hostApi.getSystemServiceFromInstance(
      this,
      name,
    );
  }

  /// Returns a PackageManager instance to find global package information.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageManager().
  Future<PackageManager> getPackageManager() {
    return _hostApi.getPackageManagerFromInstance(
      this,
    );
  }
}

/// Result of an activity-for-result request.
///
/// See also [ActivityResultPigeon].
///
/// See https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent).
class ActivityResult {
  /// Instantiates an [ActivityResult].
  const ActivityResult({
    required this.resultCode,
    this.data,
    this.requestCode,
  });

  /// The integer result code returned by the child activity.
  final int resultCode;

  /// An [Intent] which can return result data to the caller.
  final Intent? data;

  /// The integer request code originally supplied to [Activity.startActivityForResult].
  final int? requestCode;
}
