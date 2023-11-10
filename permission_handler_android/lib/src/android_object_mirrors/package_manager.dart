import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import '../android_permission_handler_api_impls.dart';
import 'build.dart';

/// Class for retrieving various kinds of information related to the application
/// packages that are currently installed on the device. You can find this class
/// through Context#getPackageManager.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.
class PackageManager extends JavaObject {
  /// Instantiates an [PackageManager] without creating and attaching to an
  /// instance of the associated native class.
  PackageManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = PackageManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached();

  final PackageManagerHostApiImpl _hostApi;

  /// Permission check result: this is returned by checkPermission(String, String) if the permission has not been granted to the given package.
  ///
  /// Constant Value: -1 (0xffffffff)
  static const int permissionDenied = -1;

  /// Permission check result: this is returned by checkPermission(String, String) if the permission has been granted to the given package.
  ///
  /// Constant Value: 0 (0x00000000)
  static const int permissionGranted = 0;

  /// Checks whether the calling package is allowed to request package installs through package installer.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#canRequestPackageInstalls().
  Future<bool> canRequestPackageInstalls() async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.m) {
      return true;
    }

    return _hostApi.canRequestPackageInstallsFromInstance(this);
  }
}
