package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Host API implementation for `ActivityCompat`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ActivityHostApiImpl implements
    ActivityHostApi,
    PluginRegistry.RequestPermissionsResultListener,
    PluginRegistry.ActivityResultListener {

    /**
     * The request code used when requesting permissions.
     *
     * <p>This code has been randomly generated once, in the hope of avoiding collisions with other
     * request codes that are used on the native side, such as by other plugins.
     */
    static final int REQUEST_CODE_PERMISSIONS = 702764314;

    /**
     * The request code used when requesting special permissions.
     *
     * <p>This code has been randomly generated once, in the hope of avoiding collisions with other
     * request codes that are used on the native side, such as by other plugins.
     */
    static final int REQUEST_CODE_ACTIVITY_FOR_RESULT = 834370754;

    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * A callback to complete a pending permission request.
     * <p>
     * This callback is set in {@link this#requestPermissions(String, List, Result)}, and completed
     * in {@link this#onRequestPermissionsResult(int, String[], int[])}.
     */
    private Result<PermissionRequestResult> pendingPermissionsRequest;

    /**
     * A callback to complete a pending activity-for-result request.
     * <p>
     * This callback is set in {@link this#startActivityForResult(String, String, Result)}, and
     * completed in {@link this#onActivityResult(int, int, Intent)}.
     */
    private Result<ActivityResultPigeon> pendingActivityResultRequest;

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

        return ActivityCompat.shouldShowRequestPermissionRationale(activity, permission);
    }

    @Override
    @NonNull public Long checkSelfPermission(
        @NonNull String activityInstanceId,
        @NonNull String permission
    ) {
        final UUID activityInstanceUuid = UUID.fromString(activityInstanceId);
        final Activity activity = instanceManager.getInstance(activityInstanceUuid);

        return (long) ActivityCompat.checkSelfPermission(activity, permission);
    }

    @Override
    public void requestPermissions(
        @NonNull String activityInstanceId,
        @NonNull List<String> permissions,
        @NonNull Result<PermissionRequestResult> result
    ) {
        final UUID activityInstanceUuid = UUID.fromString(activityInstanceId);
        final Activity activity = instanceManager.getInstance(activityInstanceUuid);

        pendingPermissionsRequest = result;

        String[] permissionsArray = permissions.toArray(new String[0]);
        ActivityCompat.requestPermissions(activity, permissionsArray, REQUEST_CODE_PERMISSIONS);
    }

    @Override
    public boolean onRequestPermissionsResult(
        int requestCode,
        @NonNull String[] permissions,
        @NonNull int[] grantResults
    ) {
        if (requestCode != REQUEST_CODE_PERMISSIONS) {
            return false;
        }

        final List<String> permissionsList = Arrays.asList(permissions);
        final List<Long> grantResultsList = new ArrayList<>();
        for (int grantResult : grantResults) {
            grantResultsList.add((long) grantResult);
        }
        final PermissionRequestResult result = new PermissionRequestResult
            .Builder()
            .setPermissions(permissionsList)
            .setGrantResults(grantResultsList)
            .build();

        pendingPermissionsRequest.success(result);
        pendingPermissionsRequest = null;

        return true;
    }

    @Override
    public void startActivity(
        @NonNull String instanceId,
        @NonNull String intentInstanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID intentInstanceUuid = UUID.fromString(intentInstanceId);

        final Activity activity = instanceManager.getInstance(instanceUuid);
        final Intent intent = instanceManager.getInstance(intentInstanceUuid);

        ActivityCompat.startActivity(activity, intent, null);
    }

    @Override
    @NonNull public String getPackageName(
        @NonNull String instanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Activity activity = instanceManager.getInstance(instanceUuid);

        return activity.getPackageName();
    }

    @Override
    public void startActivityForResult(
        @NonNull String instanceId,
        @NonNull String intentInstanceId,
        @NonNull Result<ActivityResultPigeon> result
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID intentInstanceUuid = UUID.fromString(intentInstanceId);

        final Activity activity = instanceManager.getInstance(instanceUuid);
        final Intent intent = instanceManager.getInstance(intentInstanceUuid);

        pendingActivityResultRequest = result;

        activity.startActivityForResult(intent, REQUEST_CODE_ACTIVITY_FOR_RESULT);
    }

    @Override
    public boolean onActivityResult(
        int requestCode,
        int resultCode,
        @Nullable Intent data
    ) {
        if (requestCode != REQUEST_CODE_ACTIVITY_FOR_RESULT) {
            return false;
        }

        final ActivityResultPigeon.Builder activityResultBuilder = new ActivityResultPigeon.Builder()
            .setResultCode((long) resultCode);

        if (data != null) {
            final UUID intentInstanceId = instanceManager.addHostCreatedInstance(data);
            activityResultBuilder.setDataInstanceId(intentInstanceId.toString());
        }

        pendingActivityResultRequest.success(activityResultBuilder.build());
        pendingActivityResultRequest = null;

        return true;
    }
}
