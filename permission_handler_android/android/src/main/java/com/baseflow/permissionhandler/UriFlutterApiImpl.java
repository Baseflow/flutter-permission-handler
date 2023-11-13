package com.baseflow.permissionhandler;

import android.net.Uri;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.UriFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `Uri`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class UriFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final UriFlutterApi api;

    /**
     * Constructs a {@link UriFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public UriFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new UriFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `Uri` instance and notifies Dart to create and store a new `Uri` instance that is
     * attached to this one. If `instance` has already been added, this method does nothing.
     */
    public void create(@NonNull Uri instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID uriInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(uriInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `Uri` instance in the instance manager and notifies Dart to do the same. If
     * `instance` was already disposed, this method does nothing.
     */
    public void dispose(Uri instance) {
        final UUID uriInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (uriInstanceUuid != null) {
            api.dispose(uriInstanceUuid.toString(), reply -> {});
        }
    }
}
