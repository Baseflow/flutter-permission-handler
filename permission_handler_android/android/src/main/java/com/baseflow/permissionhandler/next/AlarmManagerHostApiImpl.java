package com.baseflow.permissionhandler.next;

import android.os.Build;
import android.app.AlarmManager;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.AlarmManagerHostApi;

import java.util.UUID;

/**
 * Host API implementation for `AlarmManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class AlarmManagerHostApiImpl implements AlarmManagerHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link AlarmManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public AlarmManagerHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.S)
    @NonNull
    @Override
    public Boolean canScheduleExactAlarms(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final AlarmManager alarmManager = instanceManager.getInstance(instanceUuid);

        return alarmManager.canScheduleExactAlarms();
    }
}
