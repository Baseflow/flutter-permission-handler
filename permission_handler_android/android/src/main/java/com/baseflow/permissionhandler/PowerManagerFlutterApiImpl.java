package com.baseflow.permissionhandler;

import android.os.PowerManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PowerManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `PowerManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class PowerManagerFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final PowerManagerFlutterApi api;

    /**
     * Constructs a {@link PowerManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PowerManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new PowerManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `PowerManager` instance and notifies Dart to create and store a new `PowerManager`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull PowerManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID powerManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(powerManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `PowerManager` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(PowerManager instance) {
        final UUID powerManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (powerManagerInstanceUuid != null) {
            api.dispose(powerManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
