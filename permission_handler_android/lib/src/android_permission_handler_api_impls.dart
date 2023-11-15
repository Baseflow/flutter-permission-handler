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
    AlarmManagerFlutterApiImpl? alarmManagerFlutterApi,
    PackageManagerFlutterApiImpl? packageManagerFlutterApi,
    NotificationManagerFlutterApiImpl? notificationManagerFlutterApi,
  }) {
    this.activityFlutterApi = activityFlutterApi ?? ActivityFlutterApiImpl();
    this.contextFlutterApi = contextFlutterApi ?? ContextFlutterApiImpl();
    this.powerManagerFlutterApi =
        powerManagerFlutterApi ?? PowerManagerFlutterApiImpl();
    this.alarmManagerFlutterApi =
        alarmManagerFlutterApi ?? AlarmManagerFlutterApiImpl();
    this.packageManagerFlutterApi =
        packageManagerFlutterApi ?? PackageManagerFlutterApiImpl();
    this.notificationManagerFlutterApi =
        notificationManagerFlutterApi ?? NotificationManagerFlutterApiImpl();
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

  /// Flutter API for [AlarmManager].
  late final AlarmManagerFlutterApiImpl alarmManagerFlutterApi;

  /// Flutter API for [PackageManager].
  late final PackageManagerFlutterApiImpl packageManagerFlutterApi;

  /// Flutter API for [NotificationManager].
  late final NotificationManagerFlutterApiImpl notificationManagerFlutterApi;

  /// Ensures all the Flutter APIs have been setup to receive calls from native code.
  void ensureSetUp() {
    if (!_haveBeenSetUp) {
      ActivityFlutterApi.setup(activityFlutterApi);
      ContextFlutterApi.setup(contextFlutterApi);
      PowerManagerFlutterApi.setup(powerManagerFlutterApi);
      AlarmManagerFlutterApi.setup(alarmManagerFlutterApi);
      PackageManagerFlutterApi.setup(packageManagerFlutterApi);
      NotificationManagerFlutterApi.setup(notificationManagerFlutterApi);

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

  /// Requests permissions to be granted to this application.
  ///
  /// See
  /// https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String[],%20int[]).
  Future<PermissionRequestResult> requestPermissionsFromInstance(
    Activity activity,
    List<String> permissions,
    int? requestCode,
  ) async {
    assert(
      requestCode == null || requestCode.bitLength + 1 <= 32,
      'The request code must fit in a 32-bit integer.',
    );

    final String activityInstanceId = instanceManager.getIdentifier(activity)!;

    return requestPermissions(
      activityInstanceId,
      permissions,
      requestCode,
    );
  }

  /// Start an activity for which the application would like a result when it finished.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
  Future<ActivityResult> startActivityForResultFromInstance(
    Activity activity,
    Intent intent,
    int? requestCode,
  ) async {
    assert(
      requestCode == null || requestCode.bitLength + 1 <= 32,
      'The request code must fit in a 32-bit integer.',
    );

    final ActivityResultPigeon activityResult = await startActivityForResult(
      instanceManager.getIdentifier(activity)!,
      instanceManager.getIdentifier(intent)!,
      requestCode,
    );

    Intent? data;
    final String? dataInstanceId = activityResult.dataInstanceId;
    if (dataInstanceId != null) {
      data = instanceManager.getInstanceWithWeakReference(dataInstanceId);
    }

    return ActivityResult(
      resultCode: activityResult.resultCode,
      data: data,
      requestCode: requestCode,
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
  /// See https://developer.android.com/reference/android/content/Context#getSystemService(java.lang.String).
  Future<Object?> getSystemServiceFromInstance(
    Context context,
    String name,
  ) async {
    final String systemServiceId = await getSystemService(
      instanceManager.getIdentifier(context)!,
      name,
    );

    return instanceManager.getInstanceWithWeakReference(systemServiceId);
  }

  /// Return PackageManager instance to find global package information.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageManager().
  Future<PackageManager> getPackageManagerFromInstance(
    Context context,
  ) async {
    final String packageManagerId = await getPackageManager(
      instanceManager.getIdentifier(context)!,
    );

    return instanceManager.getInstanceWithWeakReference(packageManagerId)
        as PackageManager;
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

/// Host API implementation of AlarmManager.
class AlarmManagerHostApiImpl extends AlarmManagerHostApi {
  /// Creates a new instance of [AlarmManagerHostApiImpl].
  AlarmManagerHostApiImpl({
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

  /// Called to check if the application can schedule exact alarms.
  ///
  /// See https://developer.android.com/reference/android/app/AlarmManager#canScheduleExactAlarms().
  Future<bool> canScheduleExactAlarmsFromInstance(
    AlarmManager alarmManager,
  ) async {
    return await canScheduleExactAlarms(
      instanceManager.getIdentifier(alarmManager)!,
    );
  }
}

/// Flutter API implementation of AlarmManager.
class AlarmManagerFlutterApiImpl extends AlarmManagerFlutterApi {
  /// Constructs a new instance of [AlarmManagerFlutterApiImpl].
  AlarmManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final AlarmManager alarmManager = AlarmManager.detached();
    _instanceManager.addHostCreatedInstance(
      alarmManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of PackageManager.
class PackageManagerHostApiImpl extends PackageManagerHostApi {
  /// Creates a new instance of [PackageManagerHostApiImpl].
  PackageManagerHostApiImpl({
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

  /// Checks whether the calling package is allowed to request package installs through package installer.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#canRequestPackageInstalls().
  Future<bool> canRequestPackageInstallsFromInstance(
    PackageManager packageManager,
  ) {
    return canRequestPackageInstalls(
      instanceManager.getIdentifier(packageManager)!,
    );
  }
}

/// Flutter API implementation of PackageManager.
class PackageManagerFlutterApiImpl extends PackageManagerFlutterApi {
  /// Constructs a new instance of [PackageManagerFlutterApiImpl].
  PackageManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final PackageManager packageManager = PackageManager.detached();
    _instanceManager.addHostCreatedInstance(
      packageManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of Settings.
class SettingsHostApiImpl extends SettingsHostApi {
  /// Creates a new instance of [SettingsHostApiImpl].
  SettingsHostApiImpl({
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

  /// Checks if the specified context can draw on top of other apps.
  ///
  /// As of API level 23, an app cannot draw on top of other apps unless it
  /// declares the [Manifest.permission.systemAlertWindow] permission in its
  /// manifest, **and** the user specifically grants the app this capability. To
  /// prompt the user to grant this approval, the app must send an intent with
  /// the action [Settings.actionManageOverlayPermission], which causes the
  /// system to display a permission management screen.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#canDrawOverlays(android.content.Context).
  Future<bool> canDrawOverlaysFromInstance(
    Context context,
  ) {
    return canDrawOverlays(
      instanceManager.getIdentifier(context)!,
    );
  }
}

/// Host API implementation of NotificationManager.
class NotificationManagerHostApiImpl extends NotificationManagerHostApi {
  /// Creates a new instance of [NotificationManagerHostApiImpl].
  NotificationManagerHostApiImpl({
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

  /// Checks the ability to modify notification do not disturb policy for the calling package.
  ///
  /// Returns true if the calling package can modify notification policy.
  ///
  /// Apps can request policy access by sending the user to the activity that
  /// matches the system intent action
  /// [Settings.actionNotificationPolicyAccessSettings].
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#isNotificationPolicyAccessGranted().
  Future<bool> isNotificationPolicyAccessGrantedFromInstance(
    NotificationManager notificationManager,
  ) {
    return isNotificationPolicyAccessGranted(
      instanceManager.getIdentifier(notificationManager)!,
    );
  }

  /// Returns whether notifications from the calling package are enabled.
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#areNotificationsEnabled().
  Future<bool> areNotificationsEnabledFromInstance(
    NotificationManager notificationManager,
  ) {
    return areNotificationsEnabled(
      instanceManager.getIdentifier(notificationManager)!,
    );
  }
}

/// Flutter API implementation of NotificationManager.
class NotificationManagerFlutterApiImpl extends NotificationManagerFlutterApi {
  /// Constructs a new instance of [NotificationManagerFlutterApiImpl].
  NotificationManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final NotificationManager notificationManager =
        NotificationManager.detached();
    _instanceManager.addHostCreatedInstance(
      notificationManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of Environment.
class EnvironmentHostApiImpl extends EnvironmentHostApi {
  /// Creates a new instance of [EnvironmentHostApiImpl].
  EnvironmentHostApiImpl({
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
