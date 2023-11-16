import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

/// Represents the local device Bluetooth adapter.
///
/// The BluetoothAdapter lets you perform fundamental Bluetooth tasks, such as
/// initiate device discovery, query a list of bonded (paired) devices,
/// instantiate a BluetoothDevice using a known MAC address, and create a
/// BluetoothServerSocket to listen for connection requests from other devices,
/// and start a scan for Bluetooth LE devices.
///
/// To get a BluetoothAdapter representing the local Bluetooth adapter, call the
/// [BluetoothManager.getAdapter] function on BluetoothManager. On
/// JELLY_BEAN_MR1 and below you will need to use the static
/// [BluetoothManager.getDefaultAdapter] method instead.
///
/// Fundamentally, this is your starting point for all Bluetooth actions. Once
/// you have the local adapter, you can get a set of BluetoothDevice objects
/// representing all paired devices with getBondedDevices(); start device
/// discovery with startDiscovery(); or create a BluetoothServerSocket to listen
/// for incoming RFComm connection requests with
/// listenUsingRfcommWithServiceRecord(java.lang.String, java.util.UUID); listen
/// for incoming L2CAP Connection-oriented Channels (CoC) connection requests
/// with listenUsingL2capChannel(); or start a scan for Bluetooth LE devices
/// with startLeScan(android.bluetooth.BluetoothAdapter.LeScanCallback).
///
/// This class is thread safe.
///
/// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter.
class BluetoothAdapter extends JavaObject {
  /// Instantiates a [BluetoothAdapter] without creating and attaching to an
  /// instance of the associated native class.
  BluetoothAdapter.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) : super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  static final BluetoothAdapterHostApiImpl _hostApi =
      BluetoothAdapterHostApiImpl();

  /// Get a handle to the default local Bluetooth adapter.
  ///
  /// Currently Android only supports one Bluetooth adapter, but the API could
  /// be extended to support more. This will always return the default adapter.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#getDefaultAdapter().
  static Future<BluetoothAdapter> getDefaultAdapter() {
    return _hostApi.getDefaultAdapterFromClass();
  }

  /// Return true if Bluetooth is currently enabled and ready for use.
  ///
  /// Equivalent to: getBluetoothState() == STATE_ON.
  ///
  /// For apps targeting [Build.versionCodes.r] or lower, this requires the
  /// [Manifest.permission.bluetooth] permission which can be gained with a
  /// simple <uses-permission> manifest tag.
  ///
  /// See https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#isEnabled().
  Future<bool> isEnabled() {
    return _hostApi.isEnabledFromInstance(this);
  }
}
