import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

/// This class provides applications access to the content model.
///
/// See https://developer.android.com/reference/android/content/ContentResolver.
class ContentResolver extends JavaObject {
  /// Instantiates an [ContentResolver] without creating and attaching to an
  /// instance of the associated native class.
  ContentResolver.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );
}
