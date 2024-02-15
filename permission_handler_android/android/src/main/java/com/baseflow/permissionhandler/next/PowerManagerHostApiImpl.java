package com.baseflow.permissionhandler.next;

import android.os.Build;
import android.os.PowerManager;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PowerManagerHostApi;

import java.util.UUID;

/**
 * Host API implementation for `PowerManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class PowerManagerHostApiImpl implements PowerManagerHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link PowerManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PowerManagerHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @NonNull
    @Override
    public Boolean isIgnoringBatteryOptimizations(@NonNull String instanceId, @NonNull String packageName) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final PowerManager powerManager = instanceManager.getInstance(instanceUuid);

        return powerManager.isIgnoringBatteryOptimizations(packageName);
    }
}
