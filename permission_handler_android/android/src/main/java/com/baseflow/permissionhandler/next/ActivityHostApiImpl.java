package com.baseflow.permissionhandler.next;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
     * The default request code used when requesting permissions.
     *
     * <p>This code has been randomly generated once, in the hope of avoiding collisions with other
     * request codes that are used on the native side, such as by other plugins.
     */
    static final int DEFAULT_REQUEST_CODE_PERMISSIONS = 702764314;

    /**
     * The default request code used when requesting special permissions.
     *
     * <p>This code has been randomly generated once, in the hope of avoiding collisions with other
     * request codes that are used on the native side, such as by other plugins.
     */
    static final int DEFAULT_REQUEST_CODE_ACTIVITY_FOR_RESULT = 834370754;

    private final InstanceManager instanceManager;

    /**
     * Callbacks to complete a pending permission request.
     * <p>
     * These callbacks are set in {@link this#requestPermissions(String, List, Long, Result)}, and
     * are completed in {@link this#onRequestPermissionsResult(int, String[], int[])}.
     */
    private final Map<Integer, Result<PermissionRequestResult>> pendingPermissionsRequestMap = new HashMap<>();

    /**
     * Callbacks to complete a pending activity-for-result request.
     * <p>
     * These callbacks are set in {@link this#startActivityForResult(String, String, Long, Result)},
     * and are completed in {@link this#onActivityResult(int, int, Intent)}.
     */
    private final Map<Integer, Result<ActivityResultPigeon>> pendingActivityResultRequestMap = new HashMap<>();

    /**
     * Constructs an {@link ActivityHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ActivityHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
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
    public void requestPermissions(
        @NonNull String activityInstanceId,
        @NonNull List<String> permissions,
        @Nullable Long requestCode,
        @NonNull Result<PermissionRequestResult> result
    ) {
        final UUID activityInstanceUuid = UUID.fromString(activityInstanceId);
        final Activity activity = instanceManager.getInstance(activityInstanceUuid);

        int requestCodeInt = requestCode == null ? DEFAULT_REQUEST_CODE_PERMISSIONS : requestCode.intValue();
        pendingPermissionsRequestMap.put(requestCodeInt, result);

        String[] permissionsArray = permissions.toArray(new String[0]);
        ActivityCompat.requestPermissions(activity, permissionsArray, requestCodeInt);
    }

    @Override
    public boolean onRequestPermissionsResult(
        int requestCode,
        @NonNull String[] permissions,
        @NonNull int[] grantResults
    ) {
        @Nullable final Result<PermissionRequestResult> pendingPermissionsRequest = pendingPermissionsRequestMap.get(requestCode);
        if (pendingPermissionsRequest == null) {
            return false;
        }

        final List<String> permissionsList = Arrays.asList(permissions);
        final List<Long> grantResultsList = new ArrayList<>();
        for (int grantResult : grantResults) {
            grantResultsList.add((long) grantResult);
        }
        final PermissionRequestResult result = new PermissionRequestResult
            .Builder()
            .setRequestCode((long) requestCode)
            .setPermissions(permissionsList)
            .setGrantResults(grantResultsList)
            .build();

        pendingPermissionsRequest.success(result);
        pendingPermissionsRequestMap.remove(requestCode);

        return true;
    }

    @Override
    public void startActivityForResult(
        @NonNull String instanceId,
        @NonNull String intentInstanceId,
        @Nullable Long requestCode,
        @NonNull Result<ActivityResultPigeon> result
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID intentInstanceUuid = UUID.fromString(intentInstanceId);

        final Activity activity = instanceManager.getInstance(instanceUuid);
        final Intent intent = instanceManager.getInstance(intentInstanceUuid);

        int requestCodeInt = requestCode == null ? DEFAULT_REQUEST_CODE_ACTIVITY_FOR_RESULT : requestCode.intValue();
        pendingActivityResultRequestMap.put(requestCodeInt, result);

        activity.startActivityForResult(intent, requestCodeInt);
    }

    @Override
    public boolean onActivityResult(
        int requestCode,
        int resultCode,
        @Nullable Intent data
    ) {
        @Nullable final Result<ActivityResultPigeon> pendingActivityResultRequest = pendingActivityResultRequestMap.get(requestCode);
        if (pendingActivityResultRequest == null) {
            return false;
        }

        final ActivityResultPigeon.Builder activityResultBuilder = new ActivityResultPigeon.Builder()
            .setRequestCode((long) requestCode)
            .setResultCode((long) resultCode);

        if (data != null) {
            final UUID intentInstanceId = instanceManager.addHostCreatedInstance(data);
            activityResultBuilder.setDataInstanceId(intentInstanceId.toString());
        }

        pendingActivityResultRequest.success(activityResultBuilder.build());
        pendingActivityResultRequestMap.remove(requestCode);

        return true;
    }
}
