package com.baseflow.permissionhandler;

import android.os.Build;
import android.os.Environment;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.EnvironmentHostApi;

/**
 * Host API implementation for `Environment`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class EnvironmentHostApiImpl implements EnvironmentHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link EnvironmentHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public EnvironmentHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.R)
    @NonNull
    @Override
    public Boolean isExternalStorageManager() {
        return Environment.isExternalStorageManager();
    }
}
