package com.baseflow.permissionhandler;

import android.content.pm.PackageManager.ComponentInfoFlags;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ComponentInfoFlagsFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `ComponentInfoFlags`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ComponentInfoFlagsFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final ComponentInfoFlagsFlutterApi api;

    /**
     * Constructs a {@link ComponentInfoFlagsFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ComponentInfoFlagsFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new ComponentInfoFlagsFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `ComponentInfoFlags` instance and notifies Dart to create and store a new
     * `ComponentInfoFlags` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull ComponentInfoFlags instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID componentInfoFlagsInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(componentInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `ComponentInfoFlags` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(ComponentInfoFlags instance) {
        final UUID componentInfoFlagsInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (componentInfoFlagsInstanceUuid != null) {
            api.dispose(componentInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }
}
