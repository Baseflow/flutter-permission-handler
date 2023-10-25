import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import 'android_object_mirrors/activity.dart';
import 'permission_handler.pigeon.dart';

/// Host API implementation of ActivityCompat.
class ActivityHostApiImpl extends ActivityHostApi {
  /// Creates a new instance of [ActivityHostApiImpl].
  ActivityHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? JavaObject.globalInstanceManager,
        super(binaryMessenger: binaryMessenger);

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to
  /// the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager instanceManager;

  /// Gets whether you should show UI with rationale before requesting a permission.
  Future<bool> shouldShowRequestPermissionRationaleFromInstance(
    Activity activity,
    String permission,
  ) async {
    final String activityInstanceId = instanceManager.getIdentifier(activity)!;

    return shouldShowRequestPermissionRationale(
      activityInstanceId,
      permission,
    );
  }

  /// Determine whether you have been granted a particular permission.
  Future<int> checkSelfPermissionFromInstance(
    Activity activity,
    String permission,
  ) async {
    final String activityInstanceId = instanceManager.getIdentifier(activity)!;

    return checkSelfPermission(
      activityInstanceId,
      permission,
    );
  }

  /// Requests permissions to be granted to this application.
  Future<void> requestPermissionsFromInstance(
    Activity activity,
    List<String> permissions,
    int requestCode,
  ) async {
    final String activityInstanceId = instanceManager.getIdentifier(activity)!;

    return requestPermissions(
      activityInstanceId,
      permissions,
      requestCode,
    );
  }
}

/// Flutter API implementation of Activity.
class ActivityFlutterApiImpl extends ActivityFlutterApi {
  /// Constructs a new instance of [ActivityFlutterApiImpl].
  ActivityFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  /// The activity currently attached to the Flutter engine.
  ///
  /// This is null when no activity is attached.
  Activity? activity;

  @override
  void create(String instanceId) {
    activity = Activity.detached();
    _instanceManager.addHostCreatedInstance(activity!, instanceId);
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
    activity = null;
  }

  @override
  void onRequestPermissionsResult(
    int requestCode,
    List<String?> permissions,
    List<int?> grantResults,
  ) {
    final List<String> nonNullPermissions =
        permissions.whereType<String>().toList();
    final List<int> nonNullgrantResults =
        grantResults.whereType<int>().toList();

    AndroidActivity.relayOnRequestPermissionsResult(
      requestCode,
      nonNullPermissions,
      nonNullgrantResults,
    );
  }
}
