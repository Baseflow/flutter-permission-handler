package com.baseflow.permissionhandler.next;

import android.app.NotificationManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.NotificationManagerHostApi;

import java.util.UUID;

/**
 * Host API implementation for `NotificationManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class NotificationManagerHostApiImpl implements NotificationManagerHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link NotificationManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public NotificationManagerHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @NonNull
    @Override
    public Boolean isNotificationPolicyAccessGranted(
        @NonNull String instanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final NotificationManager notificationManager = instanceManager.getInstance(instanceUuid);

        return notificationManager.isNotificationPolicyAccessGranted();
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @NonNull
    @Override
    public Boolean areNotificationsEnabled(
        @NonNull String instanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final NotificationManager notificationManager = instanceManager.getInstance(instanceUuid);

        return notificationManager.areNotificationsEnabled();
    }
}
