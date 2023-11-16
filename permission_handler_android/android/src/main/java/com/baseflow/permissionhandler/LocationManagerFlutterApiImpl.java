package com.baseflow.permissionhandler;

import android.location.LocationManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.LocationManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `LocationManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class LocationManagerFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final LocationManagerFlutterApi api;

    /**
     * Constructs a {@link LocationManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public LocationManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new LocationManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `LocationManager` instance and notifies Dart to create and store a new
     * `LocationManager` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull LocationManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID locationManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(locationManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `LocationManager` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(LocationManager instance) {
        final UUID locationManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (locationManagerInstanceUuid != null) {
            api.dispose(locationManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
