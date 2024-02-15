package com.baseflow.permissionhandler.next;

import android.content.pm.PackageManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PackageManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `PackageManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class PackageManagerFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final PackageManagerFlutterApi api;

    /**
     * Constructs a {@link PackageManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PackageManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new PackageManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `PackageManager` instance and notifies Dart to create and store a new
     * `PackageManager` instance that is attached to this one. If `instance` has already been added,
     * this method does nothing.
     */
    public void create(@NonNull PackageManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID packageManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(packageManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `PackageManager` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(PackageManager instance) {
        final UUID packageManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (packageManagerInstanceUuid != null) {
            api.dispose(packageManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
