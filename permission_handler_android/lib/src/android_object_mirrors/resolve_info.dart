import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

/// Information that is returned from resolving an intent against an IntentFilter.
///
/// This partially corresponds to information collected from the
/// AndroidManifest.xml's <intent> tags.
///
/// See https://developer.android.com/reference/android/content/pm/ResolveInfo.
class ResolveInfo extends JavaObject {
  /// Instantiates a [ResolveInfo] without creating and attaching to an instance
  /// of the associated native class.
  ResolveInfo.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  }) : super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );
}
