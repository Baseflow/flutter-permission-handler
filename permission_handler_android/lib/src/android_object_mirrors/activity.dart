import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/permission_handler.pigeon.dart';

import '../../permission_handler_android.dart';
import '../android_permission_handler_api_impls.dart';

/// An activity is a single, focused thing that the user can do.
///
/// See https://developer.android.com/reference/android/app/Activity.
class Activity extends Context {
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
  ///
  /// Copy of [Context.powerService], as static fields are not inherited in
  /// Dart.
  ///
  /// See https://developer.android.com/reference/android/content/Context.html#POWER_SERVICE.
  static const String powerService = 'power';

  /// Use with [Context.getSystemService] to retrieve an [AlarmManager] for
  /// receiving intents at a time of your choosing.
  ///
  /// Copy of [Context.alarmService], as static fields are not inherited in
  /// Dart.
  ///
  /// See https://developer.android.com/reference/android/content/Context.html#ALARM_SERVICE.
  static const String alarmService = 'alarm';

  /// Use with [Context.getSystemService] to retrieve a [NotificationManager]
  /// for informing the user of background events.
  ///
  /// Copy of [Context.notificationService], as static fields are not inherited
  /// in Dart.
  ///
  /// See https://developer.android.com/reference/android/content/Context.html#NOTIFICATION_SERVICE.
  static const String notificationService = 'notification';

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
