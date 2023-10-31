import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

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

  /// Determine whether you have been granted a particular permission.
  Future<int> checkSelfPermission(
    String permission,
  ) {
    return _hostApi.checkSelfPermissionFromInstance(
      this,
      permission,
    );
  }
}
