package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.*;

import java.util.List;
import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `ActivityCompat`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ActivityHostApiImpl implements ActivityHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link ActivityHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ActivityHostApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @Override
    @NonNull public Boolean shouldShowRequestPermissionRationale(
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

    @Override
    @NonNull public Long checkSelfPermission(
        @NonNull String activityInstanceId,
        @NonNull String permission
    ) {
        final UUID activityInstanceUuid = UUID.fromString(activityInstanceId);
        final Activity activity = instanceManager.getInstance(activityInstanceUuid);
        if (activity == null) {
            throw new ActivityNotFoundException();
        }
        return (long) ActivityCompat.checkSelfPermission(activity, permission);
    }

    @Override
    public void requestPermissions(
        @NonNull String activityInstanceId,
        @NonNull List<String> permissions,
        @NonNull Long requestCode
    ) {
        final UUID activityInstanceUuid = UUID.fromString(activityInstanceId);
        final Activity activity = instanceManager.getInstance(activityInstanceUuid);
        if (activity == null) {
            throw new ActivityNotFoundException();
        }

        String[] permissionsArray = permissions.toArray(new String[0]);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            activity.requestPermissions(permissionsArray, requestCode.intValue());
        } else {
            ActivityCompat.requestPermissions(activity, permissionsArray, requestCode.intValue());
        }
    }
}
