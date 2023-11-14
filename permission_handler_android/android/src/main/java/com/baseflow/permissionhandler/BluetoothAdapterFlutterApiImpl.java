package com.baseflow.permissionhandler;

import android.bluetooth.BluetoothAdapter;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.BluetoothAdapterFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `BluetoothAdapter`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class BluetoothAdapterFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final BluetoothAdapterFlutterApi api;

    /**
     * Constructs a {@link BluetoothAdapterFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public BluetoothAdapterFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new BluetoothAdapterFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `BluetoothAdapter` instance and notifies Dart to create and store a new
     * `BluetoothAdapter` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull BluetoothAdapter instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID bluetoothAdapterInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(bluetoothAdapterInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `BluetoothAdapter` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(BluetoothAdapter instance) {
        final UUID bluetoothAdapterInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (bluetoothAdapterInstanceUuid != null) {
            api.dispose(bluetoothAdapterInstanceUuid.toString(), reply -> {});
        }
    }
}
