package com.baseflow.permissionhandler;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.BluetoothManagerHostApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `BluetoothManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class BluetoothManagerHostApiImpl implements BluetoothManagerHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi;

    /**
     * Constructs an {@link BluetoothManagerHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public BluetoothManagerHostApiImpl(
        @NonNull BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi,
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.bluetoothAdapterFlutterApi = bluetoothAdapterFlutterApi;
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    @NonNull
    @Override
    public String getAdapter(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final BluetoothManager bluetoothManager = instanceManager.getInstance(instanceUuid);
        final BluetoothAdapter bluetoothAdapter = bluetoothManager.getAdapter();

        bluetoothAdapterFlutterApi.create(bluetoothAdapter);

        return instanceManager.getIdentifierForStrongReference(bluetoothAdapter).toString();
    }
}
