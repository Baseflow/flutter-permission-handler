package com.baseflow.permissionhandler;


import android.bluetooth.BluetoothAdapter;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.BluetoothAdapterHostApi;

import java.util.UUID;

/**
 * Host API implementation for `BluetoothAdapter`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class BluetoothAdapterHostApiImpl implements BluetoothAdapterHostApi {
    private final InstanceManager instanceManager;

    private final BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi;

    /**
     * Constructs an {@link BluetoothAdapterHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public BluetoothAdapterHostApiImpl(
        @NonNull BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi,
        @NonNull InstanceManager instanceManager
    ) {
        this.bluetoothAdapterFlutterApi = bluetoothAdapterFlutterApi;
        this.instanceManager = instanceManager;
    }

    @NonNull
    @Override
    public String getDefaultAdapter() {
        final BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        bluetoothAdapterFlutterApi.create(bluetoothAdapter);
        return instanceManager.getIdentifierForStrongReference(bluetoothAdapter).toString();
    }

    @NonNull
    @Override
    public Boolean isEnabled(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final BluetoothAdapter bluetoothAdapter = instanceManager.getInstance(instanceUuid);
        return bluetoothAdapter.isEnabled();
    }
}
