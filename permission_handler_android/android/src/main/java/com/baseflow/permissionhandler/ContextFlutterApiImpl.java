package com.baseflow.permissionhandler;

import android.content.Context;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ContextFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `Context`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ContextFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final ContextFlutterApi api;

    /**
     * Constructs a {@link ContextFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ContextFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new ContextFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `Context` instance and notifies Dart to create and store a new `Context` instance
     * that is attached to this one. If `instance` has already been added, this method does nothing.
     */
    public void create(@NonNull Context instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID contextInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(contextInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `Context` instance in the instance manager and notifies Dart to do the same.
     * If `instance` was already disposed, this method does nothing.
     */
    public void dispose(Context instance) {
        final UUID contextInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (contextInstanceUuid != null) {
            api.dispose(contextInstanceUuid.toString(), reply -> {});
        }
    }
}
