package com.baseflow.permissionhandler;

import android.location.LocationManager;

import androidx.annotation.NonNull;
import androidx.core.location.LocationManagerCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.LocationManagerHostApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `LocationManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class LocationManagerHostApiImpl implements LocationManagerHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link LocationManagerHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public LocationManagerHostApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @NonNull
    @Override
    public Boolean isLocationEnabled(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final LocationManager locationManager = instanceManager.getInstance(instanceUuid);
        return LocationManagerCompat.isLocationEnabled(locationManager);
    }
}
