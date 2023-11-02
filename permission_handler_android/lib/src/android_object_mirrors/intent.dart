import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import '../android_permission_handler_api_impls.dart';

/// An intent is an abstract description of an operation to be performed.
///
/// See https://developer.android.com/reference/android/content/Intent.
class Intent extends JavaObject {
  /// Instantiates an [Intent], creating and attaching it to an instance of the
  /// associated native class.
  Intent({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = IntentHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        ) {
    _hostApi.createFromInstance(this);
  }

  final IntentHostApiImpl _hostApi;
}
