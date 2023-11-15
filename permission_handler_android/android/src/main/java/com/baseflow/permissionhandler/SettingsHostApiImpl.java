package com.baseflow.permissionhandler;

import android.content.Context;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.SettingsHostApi;

import java.util.UUID;

/**
 * Host API implementation for `Settings`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class SettingsHostApiImpl implements SettingsHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link SettingsHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public SettingsHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @NonNull
    @Override
    public Boolean canDrawOverlays(
        @NonNull String contextInstanceId
    ) {
        final UUID contextInstanceUuid = UUID.fromString(contextInstanceId);
        final Context context = instanceManager.getInstance(contextInstanceUuid);

        return Settings.canDrawOverlays(context);
    }
}
