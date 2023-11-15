import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

/// Class to notify the user of events that happen.
///
/// This is how you tell the user that something has happened in the background.
///
/// See: https://developer.android.com/reference/android/app/NotificationManager
class NotificationManager extends JavaObject {
  /// Instantiates a [NotificationManager] without creating and attaching to an
  /// instance of the associated native class.
  NotificationManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = NotificationManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  final NotificationManagerHostApiImpl _hostApi;

  /// Checks the ability to modify notification do not disturb policy for the calling package.
  ///
  /// Returns true if the calling package can modify notification policy.
  ///
  /// Apps can request policy access by sending the user to the activity that
  /// matches the system intent action
  /// [Settings.actionNotificationPolicyAccessSettings].
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#isNotificationPolicyAccessGranted().
  Future<bool> isNotificationPolicyAccessGranted() {
    return _hostApi.isNotificationPolicyAccessGrantedFromInstance(this);
  }

  /// Returns whether notifications from the calling package are enabled.
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#areNotificationsEnabled().
  Future<bool> areNotificationsEnabled() {
    return _hostApi.areNotificationsEnabledFromInstance(this);
  }
}
