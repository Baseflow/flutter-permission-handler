import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/activity_aware.dart';

import 'android_object_mirrors/activity.dart';
import 'android_object_mirrors/context.dart';
import 'permission_handler.pigeon.dart';

/// Handles initialization of Flutter APIs for the Android permission handler.
class AndroidPermissionHandlerFlutterApis {
  /// Creates an [AndroidPermissionHandlerFlutterApis].
  AndroidPermissionHandlerFlutterApis({
    ActivityFlutterApiImpl? activityFlutterApi,
    ContextFlutterApiImpl? contextFlutterApi,
  }) {
    this.activityFlutterApi = activityFlutterApi ?? ActivityFlutterApiImpl();
    this.contextFlutterApi = contextFlutterApi ?? ContextFlutterApiImpl();
  }

  static bool _haveBeenSetUp = false;

  /// Mutable instance containing all Flutter APIs for the Android permission handler.
  static AndroidPermissionHandlerFlutterApis get instance => _instance;
  static AndroidPermissionHandlerFlutterApis _instance =
      AndroidPermissionHandlerFlutterApis();
  @visibleForTesting
  static set instance(AndroidPermissionHandlerFlutterApis instance) {
    _instance = instance;
  }

  /// Flutter API for [Activity].
  late final ActivityFlutterApiImpl activityFlutterApi;

  /// Flutter API for [Context].
  late final ContextFlutterApiImpl contextFlutterApi;

  /// Ensures all the Flutter APIs have been setup to receive calls from native code.
  void ensureSetUp() {
    if (!_haveBeenSetUp) {
      ActivityFlutterApi.setup(activityFlutterApi);
      ContextFlutterApi.setup(contextFlutterApi);

      _haveBeenSetUp = true;
    }
  }
}

/// Host API implementation of Activity.
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
  Future<PermissionRequestResult> requestPermissionsFromInstance(
    Activity activity,
    List<String> permissions,
  ) async {
    final String activityInstanceId = instanceManager.getIdentifier(activity)!;

    return requestPermissions(
      activityInstanceId,
      permissions,
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

  @override
  void create(String instanceId) {
    Activity activity = Activity.detached();
    _instanceManager.addHostCreatedInstance(activity, instanceId);

    ActivityAwareManager.notifyAttachedToActivity(activity);
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);

    ActivityAwareManager.notifyDetachedFromActivity();
  }
}

/// Host API implementation of Context.
class ContextHostApiImpl extends ContextHostApi {
  /// Creates a new instance of [ContextHostApiImpl].
  ContextHostApiImpl({
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

  /// Determine whether you have been granted a particular permission.
  Future<int> checkSelfPermissionFromInstance(
    Context context,
    String permission,
  ) async {
    return checkSelfPermission(
      instanceManager.getIdentifier(context)!,
      permission,
    );
  }
}

/// Flutter API implementation of Context.
class ContextFlutterApiImpl extends ContextFlutterApi {
  /// Constructs a new instance of [ContextFlutterApiImpl].
  ContextFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final Context context = Context.detached();
    _instanceManager.addHostCreatedInstance(
      context,
      instanceId,
    );

    ActivityAwareManager.notifyAttachedToApplication(context);
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}
