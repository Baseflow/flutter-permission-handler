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
    UriFlutterApiImpl? uriFlutterApi,
    PowerManagerFlutterApiImpl? powerManagerFlutterApi,
    AlarmManagerFlutterApiImpl? alarmManagerFlutterApi,
    PackageManagerFlutterApiImpl? packageManagerFlutterApi,
    PackageInfoFlutterApiImpl? packageInfoFlutterApi,
    PackageInfoFlagsFlutterApiImpl? packageInfoFlagsFlutterApi,
    ResolveInfoFlagsFlutterApiImpl? resolveInfoFlagsFlutterApi,
    ResolveInfoFlutterApiImpl? resolveInfoFlutterApi,
    ComponentInfoFlagsFlutterApiImpl? componentInfoFlagsFlutterApi,
    ApplicationInfoFlagsFlutterApiImpl? applicationInfoFlagsFlutterApi,
    NotificationManagerFlutterApiImpl? notificationManagerFlutterApi,
    FeatureInfoFlutterApiImpl? featureInfoFlutterApi,
    TelephonyManagerFlutterApiImpl? telephonyManagerFlutterApi,
    LocationManagerFlutterApiImpl? locationManagerFlutterApi,
    BluetoothAdapterFlutterApiImpl? bluetoothAdapterFlutterApi,
    BluetoothManagerFlutterApiImpl? bluetoothManagerFlutterApi,
  }) {
    this.activityFlutterApi = activityFlutterApi ?? ActivityFlutterApiImpl();
    this.contextFlutterApi = contextFlutterApi ?? ContextFlutterApiImpl();
    this.uriFlutterApi = uriFlutterApi ?? UriFlutterApiImpl();
    this.powerManagerFlutterApi =
        powerManagerFlutterApi ?? PowerManagerFlutterApiImpl();
    this.alarmManagerFlutterApi =
        alarmManagerFlutterApi ?? AlarmManagerFlutterApiImpl();
    this.packageManagerFlutterApi =
        packageManagerFlutterApi ?? PackageManagerFlutterApiImpl();
    this.packageInfoFlutterApi =
        packageInfoFlutterApi ?? PackageInfoFlutterApiImpl();
    this.packageInfoFlagsFlutterApi =
        packageInfoFlagsFlutterApi ?? PackageInfoFlagsFlutterApiImpl();
    this.resolveInfoFlagsFlutterApi =
        resolveInfoFlagsFlutterApi ?? ResolveInfoFlagsFlutterApiImpl();
    this.resolveInfoFlutterApi =
        resolveInfoFlutterApi ?? ResolveInfoFlutterApiImpl();
    this.componentInfoFlagsFlutterApi =
        componentInfoFlagsFlutterApi ?? ComponentInfoFlagsFlutterApiImpl();
    this.applicationInfoFlagsFlutterApi =
        applicationInfoFlagsFlutterApi ?? ApplicationInfoFlagsFlutterApiImpl();
    this.notificationManagerFlutterApi =
        notificationManagerFlutterApi ?? NotificationManagerFlutterApiImpl();
    this.featureInfoFlutterApi =
        featureInfoFlutterApi ?? FeatureInfoFlutterApiImpl();
    this.telephonyManagerFlutterApi =
        telephonyManagerFlutterApi ?? TelephonyManagerFlutterApiImpl();
    this.locationManagerFlutterApi =
        locationManagerFlutterApi ?? LocationManagerFlutterApiImpl();
    this.bluetoothAdapterFlutterApi =
        bluetoothAdapterFlutterApi ?? BluetoothAdapterFlutterApiImpl();
    this.bluetoothManagerFlutterApi =
        bluetoothManagerFlutterApi ?? BluetoothManagerFlutterApiImpl();
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

  /// Flutter API for [Uri].
  late final UriFlutterApiImpl uriFlutterApi;

  /// Flutter API for [PowerManager].
  late final PowerManagerFlutterApiImpl powerManagerFlutterApi;

  /// Flutter API for [AlarmManager].
  late final AlarmManagerFlutterApiImpl alarmManagerFlutterApi;

  /// Flutter API for [PackageManager].
  late final PackageManagerFlutterApiImpl packageManagerFlutterApi;

  /// Flutter API for [PackageInfo].
  late final PackageInfoFlutterApiImpl packageInfoFlutterApi;

  /// Flutter API for [PackageInfoFlags].
  late final PackageInfoFlagsFlutterApiImpl packageInfoFlagsFlutterApi;

  /// Flutter API for [ResolveInfoFlags].
  late final ResolveInfoFlagsFlutterApiImpl resolveInfoFlagsFlutterApi;

  /// Flutter API for [ResolveInfo].
  late final ResolveInfoFlutterApiImpl resolveInfoFlutterApi;

  /// Flutter API for [ComponentInfoFlags].
  late final ComponentInfoFlagsFlutterApiImpl componentInfoFlagsFlutterApi;

  /// Flutter API for [ApplicationInfoFlags].
  late final ApplicationInfoFlagsFlutterApiImpl applicationInfoFlagsFlutterApi;

  /// Flutter API for [NotificationManager].
  late final NotificationManagerFlutterApiImpl notificationManagerFlutterApi;

  /// Flutter API for [FeatureInfo].
  late final FeatureInfoFlutterApiImpl featureInfoFlutterApi;

  /// Flutter API for [TelephonyManager].
  late final TelephonyManagerFlutterApiImpl telephonyManagerFlutterApi;

  /// Flutter API for [LocationManager].
  late final LocationManagerFlutterApiImpl locationManagerFlutterApi;

  /// Flutter API for [BluetoothAdapter].
  late final BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi;

  /// Flutter API for [BluetoothManager].
  late final BluetoothManagerFlutterApiImpl bluetoothManagerFlutterApi;

  /// Ensures all the Flutter APIs have been setup to receive calls from native code.
  void ensureSetUp() {
    if (!_haveBeenSetUp) {
      ActivityFlutterApi.setup(activityFlutterApi);
      ContextFlutterApi.setup(contextFlutterApi);
      UriFlutterApi.setup(uriFlutterApi);
      PowerManagerFlutterApi.setup(powerManagerFlutterApi);
      AlarmManagerFlutterApi.setup(alarmManagerFlutterApi);
      PackageManagerFlutterApi.setup(packageManagerFlutterApi);
      PackageInfoFlutterApi.setup(packageInfoFlutterApi);
      PackageInfoFlagsFlutterApi.setup(packageInfoFlagsFlutterApi);
      ResolveInfoFlagsFlutterApi.setup(resolveInfoFlagsFlutterApi);
      ResolveInfoFlutterApi.setup(resolveInfoFlutterApi);
      ComponentInfoFlagsFlutterApi.setup(componentInfoFlagsFlutterApi);
      ApplicationInfoFlagsFlutterApi.setup(applicationInfoFlagsFlutterApi);
      NotificationManagerFlutterApi.setup(notificationManagerFlutterApi);
      FeatureInfoFlutterApi.setup(featureInfoFlutterApi);
      TelephonyManagerFlutterApi.setup(telephonyManagerFlutterApi);
      LocationManagerFlutterApi.setup(locationManagerFlutterApi);
      BluetoothAdapterFlutterApi.setup(bluetoothAdapterFlutterApi);
      BluetoothManagerFlutterApi.setup(bluetoothManagerFlutterApi);

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
  Future<Uri> parseFromClass(
    String uriString,
  ) async {
    final String instanceId = await parse(uriString);

    return instanceManager.getInstanceWithWeakReference(instanceId) as Uri;
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

/// Flutter API implementation of Uri.
class UriFlutterApiImpl extends UriFlutterApi {
  /// Constructs a new instance of [UriFlutterApiImpl].
  UriFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final Uri uri = Uri.detached();
    _instanceManager.addHostCreatedInstance(
      uri,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
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
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.m) {
      return false;
    }

    return await isIgnoringBatteryOptimizations(
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
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.s) {
      return true;
    }

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
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.m) {
      return true;
    }

    return canRequestPackageInstalls(
      instanceManager.getIdentifier(packageManager)!,
    );
  }

  /// Retrieve overall information about an application package that is installed on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20android.content.pm.PackageManager.PackageInfoFlags).
  Future<PackageInfo?> getPackageInfoWithFlagsFromInstance(
    PackageManager packageManager,
    String packageName,
    int flags,
  ) async {
    final String? instanceId = await getPackageInfoWithFlags(
      instanceManager.getIdentifier(packageManager)!,
      packageName,
      flags,
    );

    if (instanceId == null) {
      return null;
    }
    return instanceManager.getInstanceWithWeakReference(instanceId)
        as PackageInfo;
  }

  /// Retrieve overall information about an application package that is installed on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20android.content.pm.PackageManager.PackageInfoFlags).
  Future<PackageInfo?> getPackageInfoWithInfoFlagsFromInstance(
    PackageManager packageManager,
    String packageName,
    PackageInfoFlags flags,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.tiramisu) {
      return null;
    }

    final String? instanceId = await getPackageInfoWithInfoFlags(
      instanceManager.getIdentifier(packageManager)!,
      packageName,
      instanceManager.getIdentifier(flags)!,
    );

    if (instanceId == null) {
      return null;
    }
    return instanceManager.getInstanceWithWeakReference(instanceId)
        as PackageInfo;
  }

  /// Check whether the given feature name is one of the available features as returned by getSystemAvailableFeatures().
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#hasSystemFeature(java.lang.String).
  Future<bool> hasSystemFeatureFromInstance(
    PackageManager packageManager,
    String featureName,
  ) {
    return hasSystemFeature(
      instanceManager.getIdentifier(packageManager)!,
      featureName,
    );
  }

  /// Retrieve all activities that can be performed for the given intent.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#queryIntentActivities(android.content.Intent,%20int).
  Future<List<ResolveInfo>> queryIntentActivitiesWithFlagsFromInstance(
    PackageManager packageManager,
    Intent intent,
    int flags,
  ) async {
    return (await queryIntentActivitiesWithFlags(
      instanceManager.getIdentifier(packageManager)!,
      instanceManager.getIdentifier(intent)!,
      flags,
    ))
        .whereType<String>()
        .map((String instanceId) => instanceManager
            .getInstanceWithWeakReference(instanceId) as ResolveInfo)
        .toList();
  }

  /// Retrieve all activities that can be performed for the given intent.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#queryIntentActivities(android.content.Intent,%20android.content.pm.PackageManager.ResolveInfoFlags).
  Future<List<ResolveInfo>> queryIntentActivitiesWithInfoFlagsFromInstance(
    PackageManager packageManager,
    Intent intent,
    ResolveInfoFlags resolveInfoFlags,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.tiramisu) {
      return [];
    }

    return (await queryIntentActivitiesWithInfoFlags(
      instanceManager.getIdentifier(packageManager)!,
      instanceManager.getIdentifier(intent)!,
      instanceManager.getIdentifier(resolveInfoFlags)!,
    ))
        .whereType<String>()
        .map((String instanceId) => instanceManager
            .getInstanceWithWeakReference(instanceId) as ResolveInfo)
        .toList();
  }

  /// Get a list of features that are available on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getSystemAvailableFeatures().
  Future<List<FeatureInfo>> getSystemAvailableFeaturesFromInstance(
    PackageManager packageManager,
  ) async {
    return (await getSystemAvailableFeatures(
      instanceManager.getIdentifier(packageManager)!,
    ))
        .whereType<String>()
        .map((String instanceId) => instanceManager
            .getInstanceWithWeakReference(instanceId) as FeatureInfo)
        .toList();
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
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.m) {
      return true;
    }

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
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.m) {
      return true;
    }

    return isNotificationPolicyAccessGranted(
      instanceManager.getIdentifier(notificationManager)!,
    );
  }

  /// Returns whether notifications from the calling package are enabled.
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#areNotificationsEnabled().
  Future<bool> areNotificationsEnabledFromInstance(
    NotificationManager notificationManager,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.n) {
      return true;
    }

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

/// Host API implementation of PackageInfoFlags.
class PackageInfoFlagsHostApiImpl extends PackageInfoFlagsHostApi {
  /// Creates a new instance of [PackageInfoFlagsHostApiImpl].
  PackageInfoFlagsHostApiImpl({
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

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.PackageInfoFlags#of(long).
  Future<PackageInfoFlags> ofFromClass(
    int value,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.tiramisu) {
      throw UnsupportedError(
        'ApplicationInfoFlags.of() is only supported on Android 13 and above.',
      );
    }

    final String instanceId = await of(value);
    final PackageInfoFlags flags = instanceManager
        .getInstanceWithWeakReference(instanceId) as PackageInfoFlags;
    return flags;
  }
}

/// Flutter API implementation of PackageInfoFlags.
class PackageInfoFlagsFlutterApiImpl extends PackageInfoFlagsFlutterApi {
  /// Constructs a new instance of [PackageInfoFlagsFlutterApiImpl].
  PackageInfoFlagsFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final PackageInfoFlags packageInfoFlags = PackageInfoFlags.detached();
    _instanceManager.addHostCreatedInstance(
      packageInfoFlags,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of PackageInfoFlags.
class ResolveInfoFlagsHostApiImpl extends ResolveInfoFlagsHostApi {
  /// Creates a new instance of [ResolveInfoFlagsHostApiImpl].
  ResolveInfoFlagsHostApiImpl({
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

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ResolveInfoFlags#of(long).
  Future<ResolveInfoFlags> ofFromClass(
    int value,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.tiramisu) {
      throw UnsupportedError(
        'ApplicationInfoFlags.of() is only supported on Android 13 and above.',
      );
    }

    final String instanceId = await of(value);
    final ResolveInfoFlags flags = instanceManager
        .getInstanceWithWeakReference(instanceId) as ResolveInfoFlags;
    return flags;
  }
}

/// Flutter API implementation of ResolveInfoFlags.
class ResolveInfoFlagsFlutterApiImpl extends ResolveInfoFlagsFlutterApi {
  /// Constructs a new instance of [ResolveInfoFlagsFlutterApiImpl].
  ResolveInfoFlagsFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final ResolveInfoFlags resolveInfoFlags = ResolveInfoFlags.detached();
    _instanceManager.addHostCreatedInstance(
      resolveInfoFlags,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of ApplicationInfoFlags.
class ApplicationInfoFlagsHostApiImpl extends ApplicationInfoFlagsHostApi {
  /// Creates a new instance of [ApplicationInfoFlagsHostApiImpl].
  ApplicationInfoFlagsHostApiImpl({
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

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ApplicationInfoFlags#of(long).
  Future<ApplicationInfoFlags> ofFromClass(
    int value,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.tiramisu) {
      throw UnsupportedError(
        'ApplicationInfoFlags.of() is only supported on Android 13 and above.',
      );
    }

    final String instanceId = await of(value);
    final ApplicationInfoFlags flags = instanceManager
        .getInstanceWithWeakReference(instanceId) as ApplicationInfoFlags;
    return flags;
  }
}

/// Flutter API implementation of ApplicationInfoFlags.
class ApplicationInfoFlagsFlutterApiImpl
    extends ApplicationInfoFlagsFlutterApi {
  /// Constructs a new instance of [ApplicationInfoFlagsFlutterApiImpl].
  ApplicationInfoFlagsFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final ApplicationInfoFlags applicationInfoFlags =
        ApplicationInfoFlags.detached();
    _instanceManager.addHostCreatedInstance(
      applicationInfoFlags,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of ComponentInfoFlags.
class ComponentInfoFlagsHostApiImpl extends ComponentInfoFlagsHostApi {
  /// Creates a new instance of [ComponentInfoFlagsHostApiImpl].
  ComponentInfoFlagsHostApiImpl({
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

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ComponentInfoFlags#of(long).
  Future<ComponentInfoFlags> ofFromClass(
    int value,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.tiramisu) {
      throw UnsupportedError(
        'ApplicationInfoFlags.of() is only supported on Android 13 and above.',
      );
    }

    final String instanceId = await of(value);
    final ComponentInfoFlags flags = instanceManager
        .getInstanceWithWeakReference(instanceId) as ComponentInfoFlags;
    return flags;
  }
}

/// Flutter API implementation of ComponentInfoFlags.
class ComponentInfoFlagsFlutterApiImpl extends ComponentInfoFlagsFlutterApi {
  /// Constructs a new instance of [ComponentInfoFlagsFlutterApiImpl].
  ComponentInfoFlagsFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final ComponentInfoFlags componentInfoFlags = ComponentInfoFlags.detached();
    _instanceManager.addHostCreatedInstance(
      componentInfoFlags,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of PackageInfo.
class PackageInfoHostApiImpl extends PackageInfoHostApi {
  /// Creates a new instance of [PackageInfoHostApiImpl].
  PackageInfoHostApiImpl({
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

  /// Array of all <uses-permission> tags included under <manifest>, or null if there were none.
  ///
  /// This is only filled in if the flag PackageManager#GET_PERMISSIONS was set.
  /// This list includes all permissions requested, even those that were not
  /// granted or known by the system at install time.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageInfo#requestedPermissions.
  Future<List<String>> getRequestedPermissionsFromInstance(
    PackageInfo packageInfo,
  ) async {
    return (await getRequestedPermissions(
      instanceManager.getIdentifier(packageInfo)!,
    ))
        .whereType<String>()
        .toList();
  }
}

/// Flutter API implementation of PackageInfo.
class PackageInfoFlutterApiImpl extends PackageInfoFlutterApi {
  /// Constructs a new instance of [PackageInfoFlutterApiImpl].
  PackageInfoFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final PackageInfo packageInfo = PackageInfo.detached();
    _instanceManager.addHostCreatedInstance(
      packageInfo,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Flutter API implementation of ResolveInfo.
class ResolveInfoFlutterApiImpl extends ResolveInfoFlutterApi {
  /// Constructs a new instance of [ResolveInfoFlutterApiImpl].
  ResolveInfoFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final ResolveInfo resolveInfo = ResolveInfo.detached();
    _instanceManager.addHostCreatedInstance(
      resolveInfo,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Flutter API implementation of FeatureInfo.
class FeatureInfoFlutterApiImpl extends FeatureInfoFlutterApi {
  /// Constructs a new instance of [FeatureInfoFlutterApiImpl].
  FeatureInfoFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final FeatureInfo featureInfo = FeatureInfo.detached();
    _instanceManager.addHostCreatedInstance(
      featureInfo,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of TelephonyManager.
class TelephonyManagerHostApiImpl extends TelephonyManagerHostApi {
  /// Creates a new instance of [TelephonyManagerHostApiImpl].
  TelephonyManagerHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? JavaObject.globalInstanceManager,
        super(
          binaryMessenger: binaryMessenger,
        );

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager instanceManager;

  /// Returns a constant indicating the device phone type. This indicates the type of radio used to transmit voice calls.
  ///
  /// Requires the [PackageManager.featureTelephony] feature which can be
  /// detected using [PackageManager.hasSystemFeature].
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#getPhoneType().
  Future<int> getPhoneTypeFromInstance(
    TelephonyManager telephonyManager,
  ) {
    return getPhoneType(
      instanceManager.getIdentifier(telephonyManager)!,
    );
  }

  /// Returns a constant indicating the state of the default SIM card.
  ///
  /// Requires the [PackageManager.featureTelephonySubscription] feature which
  /// can be detected using [PackageManager.hasSystemFeature].
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#getSimState(int).
  Future<int> getSimeStateFromInstance(
    TelephonyManager telephonyManager,
  ) {
    return getSimState(
      instanceManager.getIdentifier(telephonyManager)!,
    );
  }
}

/// Flutter API implementation of TelephonyManager.
class TelephonyManagerFlutterApiImpl extends TelephonyManagerFlutterApi {
  /// Constructs a new instance of [TelephonyManagerFlutterApiImpl].
  TelephonyManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final TelephonyManager telephonyManager = TelephonyManager.detached();
    _instanceManager.addHostCreatedInstance(
      telephonyManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of LocationManager.
class LocationManagerHostApiImpl extends LocationManagerHostApi {
  /// Creates a new instance of [LocationManagerHostApiImpl].
  LocationManagerHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? JavaObject.globalInstanceManager,
        super(
          binaryMessenger: binaryMessenger,
        );

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager instanceManager;

  /// Returns the current enabled/disabled status of location updates.
  ///
  /// See https://developer.android.com/reference/android/location/LocationManager#isLocationEnabled().
  Future<bool> isLocationEnabledFromInstance(
    LocationManager locationManager,
  ) {
    return isLocationEnabled(instanceManager.getIdentifier(locationManager)!);
  }
}

/// Flutter API implementation of LocationManager.
class LocationManagerFlutterApiImpl extends LocationManagerFlutterApi {
  /// Constructs a new instance of [LocationManagerFlutterApiImpl].
  LocationManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final LocationManager locationManager = LocationManager.detached();
    _instanceManager.addHostCreatedInstance(
      locationManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of BluetoothAdapter.
class BluetoothAdapterHostApiImpl extends BluetoothAdapterHostApi {
  /// Creates a new instance of [BluetoothAdapterHostApiImpl].
  BluetoothAdapterHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? JavaObject.globalInstanceManager,
        super(
          binaryMessenger: binaryMessenger,
        );

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager instanceManager;

  /// Get a handle to the default local Bluetooth adapter.
  ///
  /// Currently Android only supports one Bluetooth adapter, but the API could
  /// be extended to support more. This will always return the default adapter.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#getDefaultAdapter().
  Future<BluetoothAdapter> getDefaultAdapterFromClass() async {
    final String instanceId = await getDefaultAdapter();

    return instanceManager.getInstanceWithWeakReference(instanceId)
        as BluetoothAdapter;
  }

  /// Return true if Bluetooth is currently enabled and ready for use.
  ///
  /// Equivalent to: getBluetoothState() == STATE_ON.
  ///
  /// For apps targeting [Build.versionCodes.r] or lower, this requires the
  /// [Manifest.permission.bluetooth] permission which can be gained with a
  /// simple <uses-permission> manifest tag.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#isEnabled().
  Future<bool> isEnabledFromInstance(
    BluetoothAdapter bluetoothAdapter,
  ) {
    return isEnabled(instanceManager.getIdentifier(bluetoothAdapter)!);
  }
}

/// Flutter API implementation of BluetoothAdapter.
class BluetoothAdapterFlutterApiImpl extends BluetoothAdapterFlutterApi {
  /// Constructs a new instance of [BluetoothAdapterFlutterApiImpl].
  BluetoothAdapterFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final BluetoothAdapter bluetoothAdapter = BluetoothAdapter.detached();
    _instanceManager.addHostCreatedInstance(
      bluetoothAdapter,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}

/// Host API implementation of BluetoothManager.
class BluetoothManagerHostApiImpl extends BluetoothManagerHostApi {
  /// Creates a new instance of [BluetoothManagerHostApiImpl].
  BluetoothManagerHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? JavaObject.globalInstanceManager,
        super(
          binaryMessenger: binaryMessenger,
        );

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager instanceManager;

  /// Get the BLUETOOTH Adapter for this device.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothManager#getAdapter().
  Future<BluetoothAdapter> getAdapterFromInstance(
    BluetoothManager bluetoothManager,
  ) async {
    final String adapterInstanceId =
        await getAdapter(instanceManager.getIdentifier(bluetoothManager)!);

    return instanceManager.getInstanceWithWeakReference(adapterInstanceId)
        as BluetoothAdapter;
  }
}

/// Flutter API implementation of BluetoothManager.
class BluetoothManagerFlutterApiImpl extends BluetoothManagerFlutterApi {
  /// Constructs a new instance of [BluetoothManagerFlutterApiImpl].
  BluetoothManagerFlutterApiImpl({
    InstanceManager? instanceManager,
  }) : _instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager _instanceManager;

  @override
  void create(String instanceId) {
    final BluetoothManager bluetoothManager = BluetoothManager.detached();
    _instanceManager.addHostCreatedInstance(
      bluetoothManager,
      instanceId,
    );
  }

  @override
  void dispose(String instanceId) {
    _instanceManager.remove(instanceId);
  }
}
