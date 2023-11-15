package com.baseflow.permissionhandler;

import android.location.LocationManager;

import androidx.annotation.NonNull;
import androidx.core.location.LocationManagerCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.LocationManagerHostApi;

import java.util.UUID;

/**
 * Host API implementation for `LocationManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class LocationManagerHostApiImpl implements LocationManagerHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link LocationManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public LocationManagerHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
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
