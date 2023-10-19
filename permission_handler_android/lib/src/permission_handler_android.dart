import 'package:flutter/foundation.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'android_object_mirrors/activity.dart';
import 'android_object_mirrors/activity_compat.dart';
import 'android.dart';

/// An implementation of [PermissionHandlerPlatform] for Android.
class PermissionHandlerAndroid extends PermissionHandlerPlatform {
  /// The activity that Flutter is attached to.
  ///
  /// Used for method invocation that require an activity or context.
  Activity? _activity;

  /// Allow overriding the attached activity for testing purposes.
  @visibleForTesting
  set activity(Activity? activity) {
    _activity = activity;
  }

  /// Private constructor for creating a new instance of [PermissionHandlerAndroid].
  PermissionHandlerAndroid._();

  /// Creates and initializes an instance of [PermissionHandlerAndroid].
  factory PermissionHandlerAndroid() {
    final instance = PermissionHandlerAndroid._();
    Android.register(
      onAttachedToActivityCallback: (Activity activity) =>
          instance._activity = activity,
      onDetachedFromActivityCallback: () => instance._activity = null,
    );
    return instance;
  }

  /// Registers this class as the default instance of [PermissionHandlerPlatform].
  static void registerWith() {
    PermissionHandlerPlatform.setInstanceBuilder(
      () => PermissionHandlerAndroid(),
    );
  }

  /// TODO(jweener): implement this method.
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    return Future(() => PermissionStatus.denied);
  }

  /// TODO(jweener): implement this method.
  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    return Future(() => <Permission, PermissionStatus>{});
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(Permission permission) {
    if (_activity == null) {
      throw Exception('There is no attached activity');
    }

    return ActivityCompat.shouldShowRequestPermissionRationale(
      _activity!,
      // TODO(jweener): replace with Android manifest name for permission once
      // they have been ported over.
      'android.permission.READ_CONTACTS',
    );
  }
}
