package com.baseflow.permissionhandler.next;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.BluetoothManagerHostApi;

import java.util.UUID;

/**
 * Host API implementation for `BluetoothManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class BluetoothManagerHostApiImpl implements BluetoothManagerHostApi {
    private final InstanceManager instanceManager;

    private final BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi;

    /**
     * Constructs an {@link BluetoothManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public BluetoothManagerHostApiImpl(
        @NonNull BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi,
        @NonNull InstanceManager instanceManager
    ) {
        this.bluetoothAdapterFlutterApi = bluetoothAdapterFlutterApi;
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
