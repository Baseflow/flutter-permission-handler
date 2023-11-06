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
/// Contrary to the Android SDK, we do not make use of a `requestCode`, as
/// permission results are returned as a [Future] instead of through a separate
/// callback.
///
/// See https://developer.android.com/reference/androidx/core/app/ActivityCompat.OnRequestPermissionsResultCallback.
class PermissionRequestResult {
  const PermissionRequestResult({
    required this.permissions,
    required this.grantResults,
  });

  final List<String?> permissions;
  final List<int?> grantResults;
}

/// Result of an activity-for-result request.
///
/// Contrary to the Android SDK, we do not make use of a `requestCode`, as
/// activity results are returned as a [Future] instead of through a separate
/// callback.
///
/// See https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent).
class ActivityResultPigeon {
  const ActivityResultPigeon({
    required this.resultCode,
    required this.dataInstanceId,
  });

  final int resultCode;
  final String? dataInstanceId;
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

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#checkSelfPermission(java.lang.String).
  int checkSelfPermission(
    String instanceId,
    String permission,
  );

  /// Requests permissions to be granted to this application.
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// permission results are returned as a [Future] instead of through a
  /// separate callback.
  ///
  /// See
  /// https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String[],%20int[]).
  @async
  PermissionRequestResult requestPermissions(
    String instanceId,
    List<String> permissions,
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
  String getSystemService(
    String instanceId,
    String name,
  );

  /// Start an activity for which the application would like a result when it finished.
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// activity results are returned as a [Future].
  ///
  /// See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
  @async
  ActivityResultPigeon startActivityForResult(
    String instanceId,
    String intentInstanceId,
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
  String getSystemService(
    String instanceId,
    String name,
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
  void parse(
    String instanceId,
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
