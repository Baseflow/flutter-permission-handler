import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler_android/src/activity_manager.dart';
import 'package:permission_handler_android/src/utils.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../permission_handler_android.dart';
import 'permission_handler.pigeon.dart';

/// An implementation of [PermissionHandlerPlatform] for Android.
class PermissionHandlerAndroid extends PermissionHandlerPlatform {
  final ActivityManager _activityManager = ActivityManager();

  /// Registers this class as the default instance of [PermissionHandlerPlatform].
  static void registerWith() {
    PermissionHandlerPlatform.setInstanceBuilder(
      () => PermissionHandlerAndroid(),
    );
  }

  /// Determine whether you have been granted a particular permission.
  ///
  /// When running in the foreground, the result can be
  /// [PermissionStatus.granted], [PermissionStatus.denied] or
  /// [PermissionStatus.permanentlyDenied]. When running in the background,
  /// however, only [PermissionStatus.granted] or [PermissionStatus.denied] will
  /// be returned.
  ///
  /// TODO(jweener): handle special permissions.
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    final Iterable<PermissionStatus> statuses = await Future.wait(
      permission.manifestStrings.map(
        (String manifestString) async {
          final int grantResult =
              await _activityManager.applicationContext.checkSelfPermission(
            manifestString,
          );

          final PermissionStatus status = await grantResultToPermissionStatus(
            _activityManager.activity,
            manifestString,
            grantResult,
          );

          return status;
        },
      ),
    );

    return statuses.strictest;
  }

  /// TODO(jweener): Handle activity null.
  @override
  Future<bool> shouldShowPermissionRequestRationale(
    Permission permission,
  ) async {
    final Activity? activity = _activityManager.activity;
    if (activity == null) {
      debugPrint('Activity is null');
      return false;
    }

    final Iterable<bool> shouldShowRationales = await Future.wait(
      permission.manifestStrings.map(
        (String manifestString) {
          return activity.shouldShowRequestPermissionRationale(
            manifestString,
          );
        },
      ),
    );

    return shouldShowRationales.any((bool shouldShow) => shouldShow);
  }

  /// TODO(jweener): handle activity null.
  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    final Activity? activity = _activityManager.activity;
    if (activity == null) {
      debugPrint('Activity is null');
      return PermissionStatus.denied;
    }

    final PermissionRequestResult result = await activity.requestPermissions(
      permission.manifestStrings,
    );

    final List<String> permissions =
        result.permissions.whereType<String>().toList();
    final List<int> grantResults =
        result.grantResults.whereType<int>().toList();

    final List<PermissionStatus> statuses = <PermissionStatus>[];
    for (int i = 0; i < permissions.length; i++) {
      final PermissionStatus status = await grantResultToPermissionStatus(
        activity,
        permissions[i],
        grantResults[i],
      );

      statuses.add(status);
    }

    return statuses.strictest;
  }
}
