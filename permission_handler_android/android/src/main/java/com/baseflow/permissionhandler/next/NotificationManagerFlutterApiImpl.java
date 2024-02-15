package com.baseflow.permissionhandler.next;

import android.app.NotificationManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.NotificationManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `NotificationManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class NotificationManagerFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final NotificationManagerFlutterApi api;

    /**
     * Constructs a {@link NotificationManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public NotificationManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new NotificationManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `NotificationManager` instance and notifies Dart to create and store a new `NotificationManager`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull NotificationManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID notificationManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(notificationManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `NotificationManager` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(NotificationManager instance) {
        final UUID notificationManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (notificationManagerInstanceUuid != null) {
            api.dispose(notificationManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
