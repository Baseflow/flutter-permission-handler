package com.baseflow.permissionhandler;

import android.content.pm.PackageManager.ResolveInfoFlags;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ResolveInfoFlagsFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `ResolveInfoFlags`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ResolveInfoFlagsFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final ResolveInfoFlagsFlutterApi api;

    /**
     * Constructs a {@link ResolveInfoFlagsFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ResolveInfoFlagsFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new ResolveInfoFlagsFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `ResolveInfoFlags` instance and notifies Dart to create and store a new
     * `ResolveInfoFlags` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull ResolveInfoFlags instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID resolveInfoFlagsInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(resolveInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `ResolveInfoFlags` instance in the instance manager and notifies Dart to
     * do the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(ResolveInfoFlags instance) {
        final UUID resolveInfoFlagsInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (resolveInfoFlagsInstanceUuid != null) {
            api.dispose(resolveInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }
}
