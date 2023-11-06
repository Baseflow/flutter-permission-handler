import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/permission_handler_android.dart';
import 'permission_handler.pigeon.dart';

/// Handles initialization of Flutter APIs for the Android permission handler.
class AndroidPermissionHandlerFlutterApis {
  /// Creates an [AndroidPermissionHandlerFlutterApis].
  AndroidPermissionHandlerFlutterApis({
    ActivityFlutterApiImpl? activityFlutterApi,
    ContextFlutterApiImpl? contextFlutterApi,
    PowerManagerFlutterApiImpl? powerManagerFlutterApi,
  }) {
    this.activityFlutterApi = activityFlutterApi ?? ActivityFlutterApiImpl();
    this.contextFlutterApi = contextFlutterApi ?? ContextFlutterApiImpl();
    this.powerManagerFlutterApi =
        powerManagerFlutterApi ?? PowerManagerFlutterApiImpl();
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

  /// Flutter API for [PowerManager].
  late final PowerManagerFlutterApiImpl powerManagerFlutterApi;

  /// Ensures all the Flutter APIs have been setup to receive calls from native code.
  void ensureSetUp() {
    if (!_haveBeenSetUp) {
      ActivityFlutterApi.setup(activityFlutterApi);
      ContextFlutterApi.setup(contextFlutterApi);
      PowerManagerFlutterApi.setup(powerManagerFlutterApi);

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

  /// Launch a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  Future<void> startActivityFromInstance(
    Activity activity,
    Intent intent,
  ) async {
    return startActivity(
      instanceManager.getIdentifier(activity)!,
      instanceManager.getIdentifier(intent)!,
    );
  }

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  Future<String> getPackageNameFromInstance(
    Activity activity,
  ) async {
    return getPackageName(
      instanceManager.getIdentifier(activity)!,
    );
  }

  /// Start an activity for which the application would like a result when it finished.
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// activity results are returned as a [Future].
  ///
  /// See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
  Future<ActivityResult> startActivityForResultFromInstance(
    Activity activity,
    Intent intent,
  ) async {
    final ActivityResultPigeon activityResult = await startActivityForResult(
      instanceManager.getIdentifier(activity)!,
      instanceManager.getIdentifier(intent)!,
    );

    Intent? data;
    final String? dataInstanceId = activityResult.dataInstanceId;
    if (dataInstanceId != null) {
      data = instanceManager.getInstanceWithWeakReference(dataInstanceId);
    }

    return ActivityResult(
      resultCode: activityResult.resultCode,
      data: data,
    );
  }

  /// Return the handle to a system-level service by name.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getSystemService(java.lang.String).
  Future<JavaObject> getSystemServiceFromInstance(
    Activity activity,
    String name,
  ) async {
    final String systemServiceId = await getSystemService(
      instanceManager.getIdentifier(activity)!,
      name,
    );

    return instanceManager.getInstanceWithWeakReference(systemServiceId)!;
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
  /// See https://developer.android.com/reference/android/content/Context#checkSelfPermission(java.lang.String).
  Future<int> checkSelfPermissionFromInstance(
    Context context,
    String permission,
  ) async {
    return checkSelfPermission(
      instanceManager.getIdentifier(context)!,
      permission,
    );
  }

  /// Launch a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  Future<void> startActivityFromInstance(
    Context context,
    Intent intent,
  ) async {
    return startActivity(
      instanceManager.getIdentifier(context)!,
      instanceManager.getIdentifier(intent)!,
    );
  }

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  Future<String> getPackageNameFromInstance(
    Context context,
  ) async {
    return getPackageName(
      instanceManager.getIdentifier(context)!,
    );
  }

  /// Return the handle to a system-level service by name.
  ///
  /// Returns the instance ID of the service.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getSystemService(java.lang.String).
  Future<JavaObject?> getSystemServiceFromInstance(
    Context context,
    String name,
  ) async {
    final String systemServiceId = await getSystemService(
      instanceManager.getIdentifier(context)!,
      name,
    );

    return instanceManager.getInstanceWithWeakReference(systemServiceId);
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

/// Host API implementation of PowerManager.
class PowerManagerHostApiImpl extends PowerManagerHostApi {
  /// Creates a new instance of [PowerManagerHostApiImpl].
  PowerManagerHostApiImpl({
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

  /// Returns whether the given application package name is on the device's power allowlist.
  ///
  /// Apps can be placed on the allowlist through the settings UI invoked by
  /// [Settings.actionRequestIgnoreBatteryOptimizations].
  ///
  /// Being on the power allowlist means that the system will not apply most
  /// power saving features to the app. Guardrails for extreme cases may still
  /// be applied.
  ///
  /// See https://developer.android.com/reference/android/os/PowerManager#isIgnoringBatteryOptimizations(java.lang.String).
  Future<bool> isIgnoringBatteryOptimizationsFromInstance(
    PowerManager powerManager,
    String packageName,
  ) async {
    return await Build.version.sdkInt >= Build.versionCodes.m &&
        await isIgnoringBatteryOptimizations(
          instanceManager.getIdentifier(powerManager)!,
          packageName,
        );
  }
}

/// Flutter API implementation of PowerManager.
class PowerManagerFlutterApiImpl extends PowerManagerFlutterApi {
  /// Constructs a new instance of [PowerManagerFlutterApiImpl].
  PowerManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final PowerManager powerManager = PowerManager.detached();
    _instanceManager.addHostCreatedInstance(
      powerManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of Build.Version.
class BuildVersionHostApiImpl extends BuildVersionHostApi {
  /// Creates a new instance of [BuildVersionHostApiImpl].
  BuildVersionHostApiImpl({
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
}
