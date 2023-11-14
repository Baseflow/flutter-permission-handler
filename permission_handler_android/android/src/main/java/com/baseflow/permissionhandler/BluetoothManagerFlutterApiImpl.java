package com.baseflow.permissionhandler;

import android.bluetooth.BluetoothManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.BluetoothManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `BluetoothManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class BluetoothManagerFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final BluetoothManagerFlutterApi api;

    /**
     * Constructs a {@link BluetoothManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public BluetoothManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new BluetoothManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `BluetoothManager` instance and notifies Dart to create and store a new
     * `BluetoothManager` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull BluetoothManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID bluetoothManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(bluetoothManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `BluetoothManager` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(BluetoothManager instance) {
        final UUID bluetoothManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (bluetoothManagerInstanceUuid != null) {
            api.dispose(bluetoothManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
