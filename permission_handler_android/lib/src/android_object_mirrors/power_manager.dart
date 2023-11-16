import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

/// This class lets you query and request control of aspects of the device's power state.
///
/// See: https://developer.android.com/reference/android/os/PowerManager.
class PowerManager extends JavaObject {
  /// Instantiates a [PowerManager] without creating and attaching to an
  /// instance of the associated native class.
  PowerManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = PowerManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  final PowerManagerHostApiImpl _hostApi;

  /// Returns whether the given application package name is on the device's power allowlist.
  ///
  /// Only works on Android M and above. Returns false on lower API levels.
  ///
  /// Apps can be placed on the allowlist through the settings UI invoked by
  /// [Settings.actionRequestIgnoreBatteryOptimizations].
  ///
  /// Being on the power allowlist means that the system will not apply most
  /// power saving features to the app. Guardrails for extreme cases may still
  /// be applied.
  ///
  /// See https://developer.android.com/reference/android/os/PowerManager#isIgnoringBatteryOptimizations(java.lang.String).
  Future<bool> isIgnoringBatteryOptimizations(String packageName) {
    return _hostApi.isIgnoringBatteryOptimizationsFromInstance(
      this,
      packageName,
    );
  }
}
