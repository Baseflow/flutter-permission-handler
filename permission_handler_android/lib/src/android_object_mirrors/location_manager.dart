import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

/// Provides access to the system location services.
///
/// These services allow applications to obtain periodic updates of the device's
/// geographical location, or to be notified when the device enters the
/// proximity of a given geographical location.
///
/// See https://developer.android.com/reference/android/location/LocationManager.
class LocationManager extends JavaObject {
  /// Instantiates a [LocationManager] without creating and attaching to an
  /// instance of the associated native class.
  LocationManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = LocationManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  final LocationManagerHostApiImpl _hostApi;

  /// Returns the current enabled/disabled state of location.
  ///
  /// See https://developer.android.com/reference/android/location/LocationManager#isLocationEnabled().
  Future<bool> isLocationEnabled() async {
    return await _hostApi.isLocationEnabledFromInstance(this);
  }
}
