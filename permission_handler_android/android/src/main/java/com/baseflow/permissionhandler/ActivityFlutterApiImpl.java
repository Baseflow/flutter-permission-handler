package com.baseflow.permissionhandler;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ActivityFlutterApi;

import io.flutter.plugin.common.BinaryMessenger;

import java.util.UUID;

/**
 * Flutter API implementation for `Activity`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ActivityFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final ActivityFlutterApi api;

    /**
     * Constructs a {@link ActivityFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ActivityFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new ActivityFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `Activity` instance and notifies Dart to create and store a new `Activity`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull Activity instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID activityInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(activityInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `Activity` instance in the instance manager and notifies Dart to do the same.
     * If `instance` was already disposed, this method does nothing.
     */
    public void dispose(Activity instance) {
        final UUID activityInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (activityInstanceUuid != null) {
            api.dispose(activityInstanceUuid.toString(), reply -> {});
        }
    }
}
