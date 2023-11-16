package com.baseflow.permissionhandler;

import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.TelephonyManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `TelephonyManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class TelephonyManagerFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final TelephonyManagerFlutterApi api;

    /**
     * Constructs a {@link TelephonyManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public TelephonyManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new TelephonyManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `TelephonyManager` instance and notifies Dart to create and store a new
     * `TelephonyManager` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull TelephonyManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID telephonyManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(telephonyManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `TelephonyManager` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(TelephonyManager instance) {
        final UUID telephonyManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (telephonyManagerInstanceUuid != null) {
            api.dispose(telephonyManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
