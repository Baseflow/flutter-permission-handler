import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/permission_handler_android.dart';

import '../android_permission_handler_api_impls.dart';

/// Interface to global information about an application environment.
///
/// This is an abstract class whose implementation is provided by the Android
/// system. It allows access to application-specific resources and classes, as
/// well as up-calls for application-level operations such as launching
/// activities, broadcasting and receiving intents, etc.
///
/// See https://developer.android.com/reference/android/content/Context.
class Context extends JavaObject {
  /// Instantiates an [Context] without creating and attaching to an instance
  /// of the associated native class.
  Context.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = ContextHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );

  final ContextHostApiImpl _hostApi;

  /// Use with [Context.getSystemService] to retrieve a [PowerManager] for
  /// controlling power management, including "wake locks," which let you keep
  /// the device on while you're running long tasks.
  ///
  /// See https://developer.android.com/reference/android/content/Context.html#POWER_SERVICE.
  static const String powerService = 'power';

  /// Use with [Context.getSystemService] to retrieve an [AlarmManager] for
  /// receiving intents at a time of your choosing.
  ///
  /// See https://developer.android.com/reference/android/content/Context.html#ALARM_SERVICE.
  static const String alarmService = 'alarm';

  /// Use with [Context.getSystemService] to retrieve a [NotificationManager]
  /// for informing the user of background events.
  ///
  /// See https://developer.android.com/reference/android/content/Context.html#NOTIFICATION_SERVICE.
  static const String notificationService = 'notification';

  /// Determines whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/Context#checkSelfPermission(java.lang.String).
  Future<int> checkSelfPermission(
    String permission,
  ) {
    return _hostApi.checkSelfPermissionFromInstance(
      this,
      permission,
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

  /// Returns the handle to a system-level service by name.
  ///
  /// The class of the returned object varies by the requested name.
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
