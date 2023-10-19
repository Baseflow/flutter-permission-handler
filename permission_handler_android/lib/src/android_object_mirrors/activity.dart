import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

/// An activity is a single, focused thing that the user can do.
///
/// See https://developer.android.com/reference/android/app/Activity.
class Activity extends JavaObject {
  /// Instantiates an [Activity] without creating and attaching to an instance
  /// of the associated native class.
  Activity.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  }) : super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );
}
