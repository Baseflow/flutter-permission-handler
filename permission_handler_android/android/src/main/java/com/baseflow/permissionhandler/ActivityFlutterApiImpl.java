package com.baseflow.permissionhandler;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ActivityFlutterApi;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Flutter API implementation for `Activity`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ActivityFlutterApiImpl implements PluginRegistry.RequestPermissionsResultListener {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

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
        this.binaryMessenger = binaryMessenger;
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

    /**
     * TODO(jweener): what if another plugin makes a permission request? We may need to keep track
     * in java of open request ids, and return false if they do not match with the incoming result.
     */
    @Override
    public boolean onRequestPermissionsResult(
        int requestCode,
        @NonNull String[] permissions,
        @NonNull int[] grantResults
    ) {
        final Long requestCodeLong = (long) requestCode;
        final List<String> permissionsList = Arrays.asList(permissions);
        final List<Long> grantResultsList = new ArrayList<>();
        for (int grantResult : grantResults) {
            grantResultsList.add((long) grantResult);
        }

        api.onRequestPermissionsResult(
            requestCodeLong,
            permissionsList,
            grantResultsList,
            reply -> {}
        );

        return true;
    }
}
