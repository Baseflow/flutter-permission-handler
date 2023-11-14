import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_object_mirrors/package_info.dart';

import '../android_permission_handler_api_impls.dart';
import 'intent.dart';
import 'resolve_info.dart';

/// Class for retrieving various kinds of information related to the application
/// packages that are currently installed on the device. You can find this class
/// through Context#getPackageManager.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.
class PackageManager extends JavaObject {
  /// Instantiates a [PackageManager] without creating and attaching to an
  /// instance of the associated native class.
  PackageManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = PackageManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  final PackageManagerHostApiImpl _hostApi;

  /// Permission check result: this is returned by checkPermission(String, String) if the permission has not been granted to the given package.
  ///
  /// Constant Value: -1 (0xffffffff)
  static const int permissionDenied = -1;

  /// Permission check result: this is returned by checkPermission(String, String) if the permission has been granted to the given package.
  ///
  /// Constant Value: 0 (0x00000000)
  static const int permissionGranted = 0;

  /// The device has a telephony radio with data communication support.
  ///
  /// Feature for [getSystemAvailableFeatures] and [hasSystemFeature].
  ///
  /// Constant Value: "android.hardware.telephony".
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#FEATURE_TELEPHONY.
  static const String featureTelephony = 'android.hardware.telephony';

  /// Checks whether the calling package is allowed to request package installs through package installer.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#canRequestPackageInstalls().
  Future<bool> canRequestPackageInstalls() {
    return _hostApi.canRequestPackageInstallsFromInstance(this);
  }

  /// Retrieve overall information about an application package that is installed on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20int).
  Future<PackageInfo?> getPackageInfoWithFlags(
    String packageName,
    int flags,
  ) {
    return _hostApi.getPackageInfoWithFlagsFromInstance(
      this,
      packageName,
      flags,
    );
  }

  /// Retrieve overall information about an application package that is installed on the system.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20android.content.pm.PackageManager.PackageInfoFlags).
  Future<PackageInfo?> getPackageInfo(
    String packageName,
    PackageInfoFlags flags,
  ) {
    return _hostApi.getPackageInfoWithInfoFlagsFromInstance(
      this,
      packageName,
      flags,
    );
  }

  /// Retrieve all activities that can be performed for the given intent.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#queryIntentActivities(android.content.Intent,%20int).
  Future<List<ResolveInfo>> queryIntentActivitiesWithFlags(
    Intent intent,
    int flags,
  ) {
    return _hostApi.queryIntentActivitiesWithFlagsFromInstance(
      this,
      intent,
      flags,
    );
  }

  /// Retrieve all activities that can be performed for the given intent.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#queryIntentActivities(android.content.Intent,%20android.content.pm.ResolveInfoFlags).
  Future<List<ResolveInfo>> queryIntentActivities(
    Intent intent,
    ResolveInfoFlags resolveInfoFlags,
  ) {
    return _hostApi.queryIntentActivitiesWithInfoFlagsFromInstance(
      this,
      intent,
      resolveInfoFlags,
    );
  }
}

/// Specific flags used for retrieving package info.
///
/// Example: `PackageManager.getPackageInfoWithInfoFlags(packageName, PackageInfoFlags.of(0)`.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.PackageInfoFlags.
class PackageInfoFlags extends JavaObject {
  /// Instantiates a [PackageInfoFlags] without creating and attaching to an
  /// instance of the associated native class.
  PackageInfoFlags.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  static final PackageInfoFlagsHostApiImpl _hostApi =
      PackageInfoFlagsHostApiImpl();

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.PackageInfoFlags#of(long).
  static Future<PackageInfoFlags> of(int value) {
    return _hostApi.ofFromClass(value);
  }
}

/// Specific flags used for retrieving resolve info.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.ResolveInfoFlags.
class ResolveInfoFlags extends JavaObject {
  /// Instantiates a [ResolveInfoFlags] without creating and attaching to an
  /// instance of the associated native class.
  ResolveInfoFlags.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  static final ResolveInfoFlagsHostApiImpl _hostApi =
      ResolveInfoFlagsHostApiImpl();

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ResolveInfoFlags#of(long).
  static Future<ResolveInfoFlags> of(int value) {
    return _hostApi.ofFromClass(value);
  }
}

/// Specific flags used for retrieving application info.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.ApplicationInfoFlags.
class ApplicationInfoFlags extends JavaObject {
  /// Instantiates an [ApplicationInfoFlags] without creating and attaching to
  /// an instance of the associated native class.
  ApplicationInfoFlags.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  static final ApplicationInfoFlagsHostApiImpl _hostApi =
      ApplicationInfoFlagsHostApiImpl();

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ApplicationInfoFlags#of(long).
  static Future<ApplicationInfoFlags> of(int value) {
    return _hostApi.ofFromClass(value);
  }
}

/// Specific flags used for retrieving component info.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.ComponentInfoFlags.
class ComponentInfoFlags extends JavaObject {
  /// Instantiates a [ComponentInfoFlags] without creating and attaching to an
  /// instance of the associated native class.
  ComponentInfoFlags.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  static final ComponentInfoFlagsHostApiImpl _hostApi =
      ComponentInfoFlagsHostApiImpl();

  /// See https://developer.android.com/reference/android/content/pm/PackageManager.ComponentInfoFlags#of(long).
  static Future<ComponentInfoFlags> of(int value) {
    return _hostApi.ofFromClass(value);
  }
}
