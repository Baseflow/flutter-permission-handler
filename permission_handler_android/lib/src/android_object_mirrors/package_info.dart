import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import '../android_permission_handler_api_impls.dart';

/// Overall information about the contents of a package.
///
/// This corresponds to all of the information collected from
/// AndroidManifest.xml.
///
/// See https://developer.android.com/reference/android/content/pm/PackageInfo.
class PackageInfo extends JavaObject {
  /// Instantiates a [PackageInfo] without creating and attaching to an instance
  /// of the associated native class.
  PackageInfo.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = PackageInfoHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );

  final PackageInfoHostApiImpl _hostApi;

  /// PackageInfo flag: return information about permissions in the package in PackageInfo#permissions.
  ///
  /// Constant Value: 4096 (0x00001000).
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageManager#GET_PERMISSIONS.
  static const int getPermissions = 0x00001000;

  /// Array of all <uses-permission> tags included under <manifest>, or null if there were none.
  ///
  /// This is only filled in if the flag PackageManager#GET_PERMISSIONS was set.
  /// This list includes all permissions requested, even those that were not
  /// granted or known by the system at install time.
  ///
  /// See https://developer.android.com/reference/android/content/pm/PackageInfo#requestedPermissions.
  Future<List<String>> get requestedPermissions =>
      _hostApi.getRequestedPermissionsFromInstance(this);
}
