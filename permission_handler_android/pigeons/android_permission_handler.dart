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
/// permission results are returned as a [Future] instead of through a
/// separate callback.
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
  /// See https://developer.android.com/reference/android/app/Activity.html#shouldShowRequestPermissionRationale(java.lang.String).
  bool shouldShowRequestPermissionRationale(
    String activityInstanceId,
    String permission,
  );

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/ContextWrapper#checkSelfPermission(java.lang.String).
  int checkSelfPermission(
    String activityInstanceId,
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
    String activityInstanceId,
    List<String> permissions,
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
  int checkSelfPermission(
    String activityInstanceId,
    String permission,
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
