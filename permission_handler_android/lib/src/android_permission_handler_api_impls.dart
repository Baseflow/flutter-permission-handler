import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import 'android_object_mirrors/activity.dart';
import 'permission_handler.pigeon.dart';

/// Host API implementation of ActivityCompat.
class ActivityCompatHostApiImpl extends ActivityCompatHostApi {
  /// Creates a new instance of [ActivityCompatHostApiImpl].
  ActivityCompatHostApiImpl({
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
  Activity? _activity;

  /// Registered callbacks for activity attach events.
  final List<void Function(Activity activity)> _onAttachedToActivityCallbacks =
      [];

  /// Registered callbacks for activity detach events.
  final List<void Function()> _onDetachedFromActivityCallbacks = [];

  /// Adds a callback to be called when an activity is attached.
  ///
  /// If an activity is attached when this method is called, the callback is
  /// called immediately.
  void addOnAttachedToActivityCallback(
    void Function(Activity attachedActivity) onActivityAttached,
  ) {
    if (_activity != null) onActivityAttached(_activity!);
    _onAttachedToActivityCallbacks.add(onActivityAttached);
  }

  /// Removes a callback to be called when an activity is attached.
  void removeOnAttachedToActivityCallback(
    void Function(Activity attachedActivity) onActivityAttached,
  ) {
    _onAttachedToActivityCallbacks.remove(onActivityAttached);
  }

  /// Adds a callback to be called when an activity is detached.
  void addOnDetachedFromActivityCallback(
    void Function() onActivityDetached,
  ) {
    _onDetachedFromActivityCallbacks.add(onActivityDetached);
  }

  /// Removes a callback to be called when an activity is detached.
  void removeOnDetachedFromActivityCallback(
    void Function() onActivityDetached,
  ) {
    _onDetachedFromActivityCallbacks.remove(onActivityDetached);
  }

  /// Pretend an activity attaches.
  ///
  /// For testing purposes only.
  @visibleForTesting
  void attachToActivity(Activity activity) {
    _activity = activity;
    for (final callback in _onAttachedToActivityCallbacks) {
      callback(activity);
    }
  }

  /// Pretend the attached activity detaches.
  ///
  /// For testing purposes only.
  @visibleForTesting
  void detachFromActivity() {
    _activity = null;
    for (final callback in _onDetachedFromActivityCallbacks) {
      callback();
    }
  }

  @override
  void create(String instanceId) {
    _activity = Activity.detached();
    _instanceManager.addHostCreatedInstance(_activity!, instanceId);

    for (final callback in _onAttachedToActivityCallbacks) {
      callback(_activity!);
    }
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
    _activity = null;

    for (final callback in _onDetachedFromActivityCallbacks) {
      callback();
    }
  }
}
