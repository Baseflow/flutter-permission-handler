package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.ActivityNotFoundException;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.*;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `ActivityCompat`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ActivityCompatHostApiImpl implements ActivityCompatHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link ActivityCompatHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ActivityCompatHostApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @NonNull
    @Override
    public Boolean shouldShowRequestPermissionRationale(
        @NonNull String activityInstanceId,
        @NonNull String permission
    ) {
        final UUID activityInstanceUuid = UUID.fromString(activityInstanceId);
        final Activity activity = instanceManager.getInstance(activityInstanceUuid);
        if (activity == null) {
            throw new ActivityNotFoundException();
        }
        return ActivityCompat.shouldShowRequestPermissionRationale(activity, permission);
    }
}
