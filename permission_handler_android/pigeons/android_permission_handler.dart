import 'package:pigeon/pigeon.dart';

/// Pigeon configuration file for the communication with the Android platform.
///
/// To regenerate these files, run
/// `dart run pigeon --input pigeons/android_permission_handler.dart`.
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/permission_handler.pigeon.dart',
    dartTestOut: 'test/test_permission_handler.pigeon.dart',
    javaOut:
        'android/src/main/java/com/baseflow/permissionhandler/PermissionHandlerPigeon.java',
    javaOptions: JavaOptions(
      package: 'com.baseflow.permissionhandler',
      className: 'PermissionHandlerPigeon',
    ),
  ),
)

/// Result of a permission request.
///
/// See https://developer.android.com/reference/androidx/core/app/ActivityCompat.OnRequestPermissionsResultCallback.
class PermissionRequestResult {
  const PermissionRequestResult({
    required this.permissions,
    required this.grantResults,
    this.requestCode,
  });

  final List<String?> permissions;
  final List<int?> grantResults;
  final int? requestCode;
}

/// Result of an activity-for-result request.
///
/// See https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent).
class ActivityResultPigeon {
  const ActivityResultPigeon({
    required this.resultCode,
    this.dataInstanceId,
    this.requestCode,
  });

  final int resultCode;
  final String? dataInstanceId;
  final int? requestCode;
}

/// Host API for `Activity`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/app/Activity.
@HostApi(dartHostTestHandler: 'ActivityTestHostApi')
abstract class ActivityHostApi {
  /// Gets whether the application should show UI with rationale before requesting a permission.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#shouldShowRequestPermissionRationale(java.lang.String).
  bool shouldShowRequestPermissionRationale(
    String instanceId,
    String permission,
  );

  /// Requests permissions to be granted to this application.
  ///
  /// See
  /// https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String[],%20int[]).
  @async
  PermissionRequestResult requestPermissions(
    String instanceId,
    List<String> permissions,
    int? requestCode,
  );

  /// Start an activity for which the application would like a result when it finished.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
  @async
  ActivityResultPigeon startActivityForResult(
    String instanceId,
    String intentInstanceId,
    int? requestCode,
  );
}

/// Flutter API for `Activity`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/app/Activity.
@FlutterApi()
abstract class ActivityFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `Context`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/Context.
@HostApi(dartHostTestHandler: 'ContextTestHostApi')
abstract class ContextHostApi {
  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/Context#checkSelfPermission(java.lang.String).
  int checkSelfPermission(
    String instanceId,
    String permission,
  );

  /// Launch a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  void startActivity(
    String instanceId,
    String intentInstanceId,
  );

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  String getPackageName(
    String instanceId,
  );

  /// Return the handle to a system-level service by name.
  ///
  /// The class of the returned object varies by the requested name.
  ///
  /// Returns the instance ID of the service.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getSystemService(java.lang.String).
  String? getSystemService(
    String instanceId,
    String name,
  );

  /// Returns the instance ID of a PackageManager instance to find global package information.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageManager().
  String getPackageManager(
    String instanceId,
  );

  /// Return a ContentResolver instance for your application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getContentResolver().
  String getContentResolver(
    String instanceId,
  );
}

/// Flutter API for `Context`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/Context.
@FlutterApi()
abstract class ContextFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `Uri`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/net/Uri.
@HostApi(dartHostTestHandler: 'UriTestHostApi')
abstract class UriHostApi {
  /// Creates a Uri which parses the given encoded URI string.
  ///
  /// Returns the instance ID of the created Uri.
  ///
  /// See https://developer.android.com/reference/android/net/Uri#parse(java.lang.String).
  String parse(
    String uriString,
  );

  /// Returns the encoded string representation of this URI.
  ///
  /// Example: "http://google.com/".
  ///
  /// Method name is [toStringAsync] as opposed to [toString], as [toString]
  /// cannot be overridden with return type [Future].
  ///
  /// See https://developer.android.com/reference/android/net/Uri#toString().
  String toStringAsync(
    String instanceId,
  );
}

/// Flutter API for `Uri`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/net/Uri.
@FlutterApi()
abstract class UriFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `Intent`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/Intent.
@HostApi(dartHostTestHandler: 'IntentTestHostApi')
abstract class IntentHostApi {
  /// Creates an empty intent.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#Intent().
  void create(
    String instanceId,
  );

  /// Set the general action to be performed.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setAction(java.lang.String).
  void setAction(
    String instanceId,
    String action,
  );

  /// Set the data this intent is operating on.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setData(android.net.Uri).
  void setData(
    String instanceId,
    String uriInstanceId,
  );

  /// Add a new category to the intent.
  ///
  /// Categories provide additional detail about the action the intent performs.
  /// When resolving an intent, only activities that provide all of the
  /// requested categories will be used.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addCategory(java.lang.String).
  void addCategory(
    String instanceId,
    String category,
  );

  /// Add additional flags to the intent (or with existing flags value).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addFlags(int).
  void addFlags(
    String instanceId,
    int flags,
  );
}

/// Host API for `PowerManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/os/PowerManager.
@HostApi(dartHostTestHandler: 'PowerManagerTestHostApi')
abstract class PowerManagerHostApi {
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
  bool isIgnoringBatteryOptimizations(
    String instanceId,
    String packageName,
  );
}

/// Flutter API for `PowerManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/os/PowerManager.
@FlutterApi()
abstract class PowerManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `BuildVersion`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/os/Build.VERSION.
@HostApi(dartHostTestHandler: 'BuildVersionTestHostApi')
abstract class BuildVersionHostApi {
  /// The SDK version of the software currently running on this hardware device.
  ///
  /// This value never changes while a device is booted, but it may increase
  /// when the hardware manufacturer provides an OTA update.
  ///
  /// Possible values are defined in [Build.versionCodes].
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION#SDK_INT.
  int sdkInt();
}

/// Host API for `AlarmManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/app/AlarmManager.
@HostApi(dartHostTestHandler: 'AlarmManagerTestHostApi')
abstract class AlarmManagerHostApi {
  /// Called to check if the application can schedule exact alarms.
  ///
  /// See https://developer.android.com/reference/android/app/AlarmManager#canScheduleExactAlarms().
  bool canScheduleExactAlarms(String instanceId);
}

/// Flutter API for `AlarmManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/app/AlarmManager.
@FlutterApi()
abstract class AlarmManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `PackageManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.
@HostApi(dartHostTestHandler: 'PackageManagerTestHostApi')
abstract class PackageManagerHostApi {
  /// Checks whether the calling package is allowed to request package installs through package installer.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#canRequestPackageInstalls().
  bool canRequestPackageInstalls(String instanceId);

  /// Retrieve overall information about an application package that is installed on the system.
  ///
  /// Use [getPackageInfoWithInfoFlags] when long flags are needed.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20int).
  String? getPackageInfoWithFlags(
    String instanceId,
    String packageName,
    int flags,
  );

  /// Retrieve overall information about an application package that is installed on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20android.content.pm.PackageManager.PackageInfoFlags).
  String? getPackageInfoWithInfoFlags(
    String instanceId,
    String packageName,
    String flagsInstanceId,
  );

  /// Check whether the given feature name is one of the available features as returned by getSystemAvailableFeatures().
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#hasSystemFeature(java.lang.String).
  bool hasSystemFeature(
    String instanceId,
    String featureName,
  );

  /// Retrieve all activities that can be performed for the given intent.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#queryIntentActivities(android.content.Intent,%20int).
  List<String> queryIntentActivitiesWithFlags(
    String instanceId,
    String intentInstanceId,
    int flags,
  );

  /// Retrieve all activities that can be performed for the given intent.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#queryIntentActivities(android.content.Intent,%20android.content.pm.ResolveInfoFlags).
  List<String> queryIntentActivitiesWithInfoFlags(
    String instanceId,
    String intentInstanceId,
    String flagsInstanceId,
  );

  /// Get a list of features that are available on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getSystemAvailableFeatures().
  List<String> getSystemAvailableFeatures(
    String instanceId,
  );
}

/// Flutter API for `PackageManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.
@FlutterApi()
abstract class PackageManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `Settings`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/provider/Settings.
@HostApi(dartHostTestHandler: 'SettingsTestHostApi')
abstract class SettingsHostApi {
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
  bool canDrawOverlays(
    String contextInstanceId,
  );
}

/// Host API for `NotificationManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/app/NotificationManager.
@HostApi(dartHostTestHandler: 'NotificationManagerTestHostApi')
abstract class NotificationManagerHostApi {
  /// Checks the ability to modify notification do not disturb policy for the calling package.
  ///
  /// Returns true if the calling package can modify notification policy.
  ///
  /// Apps can request policy access by sending the user to the activity that
  /// matches the system intent action
  /// [Settings.actionNotificationPolicyAccessSettings].
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#isNotificationPolicyAccessGranted().
  bool isNotificationPolicyAccessGranted(
    String instanceId,
  );

  /// Returns whether notifications from the calling package are enabled.
  ///
  /// See https://developer.android.com/reference/android/app/NotificationManager#areNotificationsEnabled().
  bool areNotificationsEnabled(
    String instanceId,
  );
}

/// Flutter API for `NotificationManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/app/NotificationManager.
@FlutterApi()
abstract class NotificationManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `Environment`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/os/Environment.
@HostApi(dartHostTestHandler: 'EnvironmentTestHostApi')
abstract class EnvironmentHostApi {
  /// Returns whether the calling app has All Files Access on the primary shared/external storage media.
  ///
  /// Declaring the permission [Manifest.permission.manageExternalStorage] is
  /// not enough to gain the access. To request access, use
  /// [Settings.actionManageAppAllFilesAccessPermission].
  ///
  /// See https://developer.android.com/reference/android/os/Environment#isExternalStorageManager().
  bool isExternalStorageManager();
}

/// Host API for `PackageInfo`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageInfo.
@HostApi(dartHostTestHandler: 'PackageInfoTestHostApi')
abstract class PackageInfoHostApi {
  /// Array of all <uses-permission> tags included under <manifest>, or null if there were none.
  ///
  /// This is only filled in if the flag PackageManager#GET_PERMISSIONS was set.
  /// This list includes all permissions requested, even those that were not
  /// granted or known by the system at install time.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageInfo#requestedPermissions.
  List<String> getRequestedPermissions(String instanceId);
}

/// Flutter API for `PackageInfo`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageInfo.
@FlutterApi()
abstract class PackageInfoFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `PackageInfoFlags`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#PackageInfoFlags.
@HostApi(dartHostTestHandler: 'PackageInfoFlagsTestHostApi')
abstract class PackageInfoFlagsHostApi {
  /// See https://developer.android.com/reference/android/content/pm/PackageManager.PackageInfoFlags#of(long).
  String of(int value);
}

/// Flutter API for `PackageInfoFlags`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#PackageInfoFlags.
@FlutterApi()
abstract class PackageInfoFlagsFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `ResolveInfoFlags`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#ResolveInfoFlags.
@HostApi(dartHostTestHandler: 'ResolveInfoFlagsTestHostApi')
abstract class ResolveInfoFlagsHostApi {
  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ResolveInfoFlags#of(long).
  String of(int value);
}

/// Flutter API for `ResolveInfoFlags`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#ResolveInfoFlags.
@FlutterApi()
abstract class ResolveInfoFlagsFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `ApplicationInfoFlags`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#ApplicationInfoFlags.
@HostApi(dartHostTestHandler: 'ApplicationInfoFlagsTestHostApi')
abstract class ApplicationInfoFlagsHostApi {
  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ApplicationInfoFlags#of(long).
  String of(int value);
}

/// Flutter API for `ApplicationInfoFlags`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#ApplicationInfoFlags.
@FlutterApi()
abstract class ApplicationInfoFlagsFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `ComponentInfoFlags`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#ComponentInfoFlags.
@HostApi(dartHostTestHandler: 'ComponentInfoFlagsTestHostApi')
abstract class ComponentInfoFlagsHostApi {
  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ComponentInfoFlags#of(long).
  String of(int value);
}

/// Flutter API for `ComponentInfoFlags`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager#ComponentInfoFlags.
@FlutterApi()
abstract class ComponentInfoFlagsFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Flutter API for `ResolveInfo`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/ResolveInfo.
@FlutterApi()
abstract class ResolveInfoFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Flutter API for `FeatureInfo`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/pm/FeatureInfo.
@FlutterApi()
abstract class FeatureInfoFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `TelephonyManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/telephony/TelephonyManager.
@HostApi(dartHostTestHandler: 'TelephonyManagerTestHostApi')
abstract class TelephonyManagerHostApi {
  /// Returns a constant indicating the device phone type. This indicates the type of radio used to transmit voice calls.
  ///
  /// Requires the [PackageManager.featureTelephony] feature which can be
  /// detected using [PackageManager.hasSystemFeature].
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#getPhoneType().
  int getPhoneType(
    String instanceId,
  );

  /// Returns a constant indicating the state of the default SIM card.
  ///
  /// Requires the [PackageManager.featureTelephonySubscription] feature which
  /// can be detected using [PackageManager.hasSystemFeature].
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#getSimState(int).
  int getSimState(
    String instanceId,
  );
}

/// Flutter API for `TelephonyManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/telephony/TelephonyManager.
@FlutterApi()
abstract class TelephonyManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `LocationManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/location/LocationManager.
@HostApi(dartHostTestHandler: 'LocationManagerTestHostApi')
abstract class LocationManagerHostApi {
  /// Returns the current enabled/disabled status of location updates.
  ///
  /// See https://developer.android.com/reference/android/location/LocationManager#isLocationEnabled().
  bool isLocationEnabled(String instanceId);
}

/// Flutter API for `LocationManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/location/LocationManager.
@FlutterApi()
abstract class LocationManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `BluetoothAdapter`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter.
@HostApi(dartHostTestHandler: 'BluetoothAdapterTestHostApi')
abstract class BluetoothAdapterHostApi {
  /// Get a handle to the default local Bluetooth adapter.
  ///
  /// Currently Android only supports one Bluetooth adapter, but the API could
  /// be extended to support more. This will always return the default adapter.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#getDefaultAdapter().
  String getDefaultAdapter();

  /// Return true if Bluetooth is currently enabled and ready for use.
  ///
  /// Equivalent to: getBluetoothState() == STATE_ON.
  ///
  /// For apps targeting [Build.versionCodes.r] or lower, this requires the
  /// [Manifest.permission.bluetooth] permission which can be gained with a
  /// simple <uses-permission> manifest tag.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#isEnabled().
  bool isEnabled(
    String instanceId,
  );
}

/// Flutter API for `BluetoothAdapter`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter.
@FlutterApi()
abstract class BluetoothAdapterFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Host API for `BluetoothManager`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/bluetooth/BluetoothManager.
@HostApi(dartHostTestHandler: 'BluetoothManagerTestHostApi')
abstract class BluetoothManagerHostApi {
  /// Get the BLUETOOTH Adapter for this device.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothManager#getAdapter().
  String getAdapter(
    String instanceId,
  );
}

/// Flutter API for `BluetoothManager`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/bluetooth/BluetoothManager.
@FlutterApi()
abstract class BluetoothManagerFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

/// Flutter API for `ContentResolver`.
///
/// This class may handle instantiating and adding Dart instances that are
/// attached to a native instance or receiving callback methods from an
/// overridden native class.
///
/// See https://developer.android.com/reference/android/content/ContentResolver.
@FlutterApi()
abstract class ContentResolverFlutterApi {
  /// Create a new Dart instance and add it to the `InstanceManager`.
  void create(String instanceId);

  /// Dispose of the Dart instance and remove it from the `InstanceManager`.
  void dispose(String instanceId);
}

@HostApi(dartHostTestHandler: 'ContentResolverTestHostApi')
abstract class SettingsSecureHostApi {
  /// Convenience function for retrieving a single secure settings value as an integer.
  ///
  /// Note that internally setting values are always stored as strings; this
  /// function converts the string to an integer for you.
  ///
  /// This version does not take a default value. If the setting has not been
  /// set, or the string value is not a number, it returns null.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings.Secure#getInt(android.content.ContentResolver,%20java.lang.String).
  int? getInt(
    String contentResolverInstanceId,
    String name,
  );

  /// Convenience function for retrieving a single secure settings value as an integer.
  ///
  /// Note that internally setting values are always stored as strings; this
  /// function converts the string to an integer for you.
  ///
  /// The default value will be returned if the setting is not defined or not an
  /// integer.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings.Secure#getInt(android.content.ContentResolver,%20java.lang.String,%20int).
  int getIntWithDefault(
    String contentResolverInstanceId,
    String name,
    int defaultValue,
  );

  /// Look up a name in the database.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings.Secure#getString(android.content.ContentResolver,%20java.lang.String).
  String? getString(
    String contentResolverInstanceId,
    String name,
  );
}
