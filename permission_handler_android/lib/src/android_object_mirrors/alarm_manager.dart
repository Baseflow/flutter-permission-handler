import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

/// This class provides access to the system alarm services.
///
/// These allow you to schedule your application to be run at some point in the
/// future.
///
/// When an alarm goes off, the Intent that had been registered for it is
/// broadcast by the system, automatically starting the target application if it
/// is not already running.
///
/// Registered alarms are retained while the device is asleep (and can
/// optionally wake the device up if they go off during that time), but will be
/// cleared if it is turned off and rebooted.
///
/// See https://developer.android.com/reference/android/app/AlarmManager.
class AlarmManager extends JavaObject {
  /// Instantiates an [AlarmManager] without creating and attaching to an
  /// instance of the associated native class.
  AlarmManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = AlarmManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  final AlarmManagerHostApiImpl _hostApi;

  /// Called to check if the application can schedule exact alarms.
  ///
  /// Always returns true on devices running Android versions older than
  /// [Build.versionCodes.s].
  ///
  /// See https://developer.android.com/reference/android/app/AlarmManager#canScheduleExactAlarms().
  Future<bool> canScheduleExactAlarms() {
    return _hostApi.canScheduleExactAlarmsFromInstance(this);
  }
}
