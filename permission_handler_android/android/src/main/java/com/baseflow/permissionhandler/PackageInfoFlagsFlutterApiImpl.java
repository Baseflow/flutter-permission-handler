package com.baseflow.permissionhandler;

import android.content.pm.PackageManager.PackageInfoFlags;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PackageInfoFlagsFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `PackageInfoFlags`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class PackageInfoFlagsFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final PackageInfoFlagsFlutterApi api;

    /**
     * Constructs a {@link PackageInfoFlagsFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PackageInfoFlagsFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new PackageInfoFlagsFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `PackageInfoFlags` instance and notifies Dart to create and store a new
     * `PackageInfoFlags` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull PackageInfoFlags instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID packageInfoFlagsInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(packageInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `PackageInfoFlags` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(PackageInfoFlags instance) {
        final UUID packageInfoFlagsInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (packageInfoFlagsInstanceUuid != null) {
            api.dispose(packageInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }
}
