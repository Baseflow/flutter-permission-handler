import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/activity_aware.dart';

import 'android_object_mirrors/activity.dart';
import 'android_object_mirrors/context.dart';
import 'android_object_mirrors/intent.dart';
import 'android_object_mirrors/uri.dart';
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

  /// Gets whether the application should show UI with rationale before requesting a permission.
  ///
  /// See https://developer.android.com/reference/android/app/Activity.html#shouldShowRequestPermissionRationale(java.lang.String).
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

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/ContextWrapper#checkSelfPermission(java.lang.String).
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
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// permission results are returned as a [Future] instead of through a
  /// separate callback.
  ///
  /// See
  /// https://developer.android.com/reference/android/app/Activity.html#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/androidx/core/app/ActivityCompat.OnRequestPermissionsResultCallback.
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
    final Activity activity = Activity.detached();
    _instanceManager.addHostCreatedInstance(activity, instanceId);

    ActivityAwareExtension.notifyAttachedToActivity(activity);
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);

    ActivityAwareExtension.notifyDetachedFromActivity();
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

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/ContextWrapper#checkSelfPermission(java.lang.String).
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

    ActivityAwareExtension.notifyAttachedToApplication(context);
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of Uri.
class UriHostApiImpl extends UriHostApi {
  /// Creates a new instance of [UriHostApiImpl].
  UriHostApiImpl({
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

  /// Creates a Uri which parses the given encoded URI string.
  ///
  /// See https://developer.android.com/reference/android/net/Uri#parse(java.lang.String).
  void parseFromInstance(
    Uri uriInstance,
    String uriString,
  ) async {
    final String instanceId =
        instanceManager.addDartCreatedInstance(uriInstance);
    await parse(instanceId, uriString);
  }

  /// Returns the encoded string representation of this URI.
  ///
  /// Example: "http://google.com/".
  ///
  /// See https://developer.android.com/reference/android/net/Uri#toString().
  Future<String> toStringAsyncFromInstance(
    Uri uriInstance,
  ) {
    return toStringAsync(instanceManager.getIdentifier(uriInstance)!);
  }
}

/// Host API implementation of Intent.
class IntentHostApiImpl extends IntentHostApi {
  /// Creates a new instance of [IntentHostApiImpl].
  IntentHostApiImpl({
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

  /// Creates an empty intent.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#Intent().
  Future<void> createFromInstance(
    Intent intent,
  ) {
    final String instanceId = instanceManager.addDartCreatedInstance(intent);
    return create(instanceId);
  }

  /// Sets the general action to be performed.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setAction(java.lang.String).
  Future<void> setActionFromInstance(
    Intent intent,
    String action,
  ) {
    return setAction(
      instanceManager.getIdentifier(intent)!,
      action,
    );
  }

  /// Sets the data this intent is operating on.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setData(android.net.Uri).
  Future<void> setDataFromInstance(
    Intent intent,
    Uri uri,
  ) {
    return setData(
      instanceManager.getIdentifier(intent)!,
      instanceManager.getIdentifier(uri)!,
    );
  }

  /// Add a new category to the intent.
  ///
  /// Categories provide additional detail about the action the intent performs.
  /// When resolving an intent, only activities that provide all of the
  /// requested categories will be used.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addCategory(java.lang.String).
  Future<void> addCategoryFromInstance(
    Intent intent,
    String category,
  ) {
    return addCategory(
      instanceManager.getIdentifier(intent)!,
      category,
    );
  }

  /// Add additional flags to the intent (or with existing flags value).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addFlags(int).
  Future<void> addFlagsFromInstance(
    Intent intent,
    int flags,
  ) {
    return addFlags(
      instanceManager.getIdentifier(intent)!,
      flags,
    );
  }
}
