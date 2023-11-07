import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/permission_handler_android.dart';

import '../android_permission_handler_api_impls.dart';

/// Interface to global information about an application environment.
///
/// This is an abstract class whose implementation is provided by the Android
/// system. It allows access to application-specific resources and classes, as
/// well as up-calls for application-level operations such as launching
/// activities, broadcasting and receiving intents, etc.
///
/// See https://developer.android.com/reference/android/content/Context.
class Context extends JavaObject {
  /// Instantiates an [Context] without creating and attaching to an instance
  /// of the associated native class.
  Context.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = ContextHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );

  final ContextHostApiImpl _hostApi;

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/Context#checkSelfPermission(java.lang.String).
  Future<int> checkSelfPermission(
    String permission,
  ) {
    return _hostApi.checkSelfPermissionFromInstance(
      this,
      permission,
    );
  }

  /// Launch a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  Future<void> startActivity(
    Intent intent,
  ) {
    return _hostApi.startActivityFromInstance(
      this,
      intent,
    );
  }

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  Future<String> getPackageName() {
    return _hostApi.getPackageNameFromInstance(
      this,
    );
  }
}
