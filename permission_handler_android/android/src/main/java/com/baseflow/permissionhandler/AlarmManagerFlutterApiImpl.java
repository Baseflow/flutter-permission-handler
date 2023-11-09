package com.baseflow.permissionhandler;

import android.app.AlarmManager;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.AlarmManagerFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `AlarmManager`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class AlarmManagerFlutterApiImpl {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final AlarmManagerFlutterApi api;

    /**
     * Constructs a {@link AlarmManagerFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public AlarmManagerFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        api = new AlarmManagerFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `AlarmManager` instance and notifies Dart to create and store a new `AlarmManager`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull AlarmManager instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID alarmManagerInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(alarmManagerInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `AlarmManager` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(AlarmManager instance) {
        final UUID alarmManagerInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (alarmManagerInstanceUuid != null) {
            api.dispose(alarmManagerInstanceUuid.toString(), reply -> {});
        }
    }
}
