package com.baseflow.permissionhandler;

import android.content.pm.PackageManager.ApplicationInfoFlags;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ApplicationInfoFlagsFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `ApplicationInfoFlags`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ApplicationInfoFlagsFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final ApplicationInfoFlagsFlutterApi api;

    /**
     * Constructs a {@link ApplicationInfoFlagsFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ApplicationInfoFlagsFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new ApplicationInfoFlagsFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `ApplicationInfoFlags` instance and notifies Dart to create and store a new
     * `ApplicationInfoFlags` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull ApplicationInfoFlags instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID applicationInfoFlagsInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(applicationInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `ApplicationInfoFlags` instance in the instance manager and notifies Dart to
     * do the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(ApplicationInfoFlags instance) {
        final UUID applicationInfoFlagsInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (applicationInfoFlagsInstanceUuid != null) {
            api.dispose(applicationInfoFlagsInstanceUuid.toString(), reply -> {});
        }
    }
}
