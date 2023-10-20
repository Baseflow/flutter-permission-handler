import 'package:flutter/foundation.dart';
import 'package:permission_handler_android/src/extensions.dart';
import 'package:permission_handler_android/src/utils.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'android_object_mirrors/activity.dart';
import 'android_object_mirrors/activity_compat.dart';
import 'android.dart';
import 'missing_android_activity_exception.dart';

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

  /// TODO(jweener): handle special permissions.
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    if (_activity == null) {
      throw const MissingAndroidActivityException();
    }

    final Iterable<PermissionStatus> statuses = await Future.wait(
      permission.manifestStrings.map(
        (String manifestString) async {
          final int grantResult = await ActivityCompat.checkSelfPermission(
            _activity!,
            manifestString,
          );

          final PermissionStatus status = await grantResultToPermissionStatus(
            _activity!,
            manifestString,
            grantResult,
          );

          return status;
        },
      ),
    );

    return statuses.strictest;
  }

  /// TODO(jweener): implement this method.
  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    return Future(() => <Permission, PermissionStatus>{});
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
    Permission permission,
  ) async {
    if (_activity == null) {
      throw const MissingAndroidActivityException();
    }

    final Iterable<bool> shouldShowRationales = await Future.wait(
      permission.manifestStrings.map(
        (String manifestString) {
          return ActivityCompat.shouldShowRequestPermissionRationale(
            _activity!,
            manifestString,
          );
        },
      ),
    );

    return shouldShowRationales.any((bool shouldShow) => shouldShow);
  }
}
