package com.baseflow.permissionhandler.next;

import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.TelephonyManagerHostApi;

import java.util.UUID;

/**
 * Host API implementation for `TelephonyManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class TelephonyManagerHostApiImpl implements TelephonyManagerHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link TelephonyManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public TelephonyManagerHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
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
