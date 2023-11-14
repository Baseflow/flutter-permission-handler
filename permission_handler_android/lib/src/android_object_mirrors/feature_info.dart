import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

/// Definition of a single optional hardware or software feature of an Android device.
///
/// This object is used to represent both features supported by a device and
/// features requested by an app. Apps can request that certain features be
/// available as a prerequisite to being installed through the uses-feature tag
/// in their manifests.
///
/// Starting in [Build.versionCodes.n], features can have a version, which must
/// always be backwards compatible. That is, a device claiming to support
/// version 3 of a specific feature must support apps requesting version 1 of
/// that feature.
///
/// See https://developer.android.com/reference/android/content/pm/FeatureInfo.
class FeatureInfo extends JavaObject {
  /// Instantiates a [FeatureInfo] without creating and attaching to an instance
  /// of the associated native class.
  FeatureInfo.detached({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  }) : super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );
}
