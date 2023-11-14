import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

import 'bluetooth_adapter.dart';

/// High level manager used to obtain an instance of a [BluetoothAdapter] and to conduct overall Bluetooth Management.
///
/// Use [Context.getSystemService] with [Context.bluetoothService] to create a
/// BluetoothManager, then call [getAdapter] to obtain the BluetoothAdapter.
///
/// See https://developer.android.com/reference/android/bluetooth/BluetoothManager.
class BluetoothManager extends JavaObject {
  /// Instantiates a [BluetoothManager] without creating and attaching to an
  /// instance of the associated native class.
  BluetoothManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  static final BluetoothManagerHostApiImpl _hostApi =
      BluetoothManagerHostApiImpl();

  /// Get the BLUETOOTH Adapter for this device.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothManager#getAdapter().
  Future<BluetoothAdapter> getAdapter() async {
    return _hostApi.getAdapterFromInstance(this);
  }
}
