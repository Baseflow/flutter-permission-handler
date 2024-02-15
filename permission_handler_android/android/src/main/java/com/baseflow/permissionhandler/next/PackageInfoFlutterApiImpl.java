package com.baseflow.permissionhandler.next;

import android.content.pm.PackageInfo;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PackageInfoFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `PackageInfo`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class PackageInfoFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final PackageInfoFlutterApi api;

    /**
     * Constructs a {@link PackageInfoFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PackageInfoFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new PackageInfoFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `PackageInfo` instance and notifies Dart to create and store a new `PackageInfo`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull PackageInfo instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID packageInfoInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(packageInfoInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `PackageInfo` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(PackageInfo instance) {
        final UUID packageInfoInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (packageInfoInstanceUuid != null) {
            api.dispose(packageInfoInstanceUuid.toString(), reply -> {});
        }
    }
}
