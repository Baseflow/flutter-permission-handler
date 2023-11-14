package com.baseflow.permissionhandler;

import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.TelephonyManagerHostApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `TelephonyManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class TelephonyManagerHostApiImpl implements TelephonyManagerHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link TelephonyManagerHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public TelephonyManagerHostApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @NonNull
    @Override
    public Long getPhoneType(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final TelephonyManager telephonyManager = instanceManager.getInstance(instanceUuid);
        return (long) telephonyManager.getPhoneType();
    }

    @NonNull
    @Override
    public Long getSimState(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final TelephonyManager telephonyManager = instanceManager.getInstance(instanceUuid);
        return (long) telephonyManager.getSimState();
    }
}
