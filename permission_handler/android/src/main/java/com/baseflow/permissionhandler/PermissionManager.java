package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

final class PermissionManager {
    @FunctionalInterface
    interface ActivityRegistry {
        void addListener(PluginRegistry.ActivityResultListener handler);
    }

    @FunctionalInterface
    interface PermissionRegistry {
        void addListener(PluginRegistry.RequestPermissionsResultListener handler);
    }

    @FunctionalInterface
    interface RequestPermissionsSuccessCallback {
        void onSuccess(Map<Integer, Integer> results);
    }

    @FunctionalInterface
    interface CheckPermissionsSuccessCallback {
        void onSuccess(@PermissionConstants.PermissionStatus int permissionStatus);
    }

    @FunctionalInterface
    interface ShouldShowRequestPermissionRationaleSuccessCallback {
        void onSuccess(boolean shouldShowRequestPermissionRationale);
    }

    private boolean ongoing = false;

    void checkPermissionStatus(
            @PermissionConstants.PermissionGroup int permission,
            Context context,
            Activity activity,
            CheckPermissionsSuccessCallback successCallback,
            ErrorCallback errorCallback) {

        successCallback.onSuccess(determinePermissionStatus(
                permission,
                context,
                activity));
    }

    void requestPermissions(
            List<Integer> permissions,
            Activity activity,
            ActivityRegistry activityRegistry,
            PermissionRegistry permissionRegistry,
            RequestPermissionsSuccessCallback successCallback,
            ErrorCallback errorCallback) {
        if (ongoing) {
            errorCallback.onError(
                    "PermissionHandler.PermissionManager",
                    "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time).");
            return;
        }

        if (activity == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity.");

            errorCallback.onError(
                    "PermissionHandler.PermissionManager",
                    "Unable to detect current Android Activity.");
            return;
        }

        Map<Integer, Integer> requestResults = new HashMap<>();
        ArrayList<String> permissionsToRequest = new ArrayList<>();
        for (Integer permission : permissions) {
            @PermissionConstants.PermissionStatus final int permissionStatus = determinePermissionStatus(permission, activity, activity);
            if (permissionStatus == PermissionConstants.PERMISSION_STATUS_GRANTED) {
                if (!requestResults.containsKey(permission)) {
                    requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_GRANTED);
                }
                continue;
            }

            final List<String> names = PermissionUtils.getManifestNames(activity, permission);

            // check to see if we can find manifest names
            // if we can't add as unknown and continue
            if (names == null || names.isEmpty()) {
                if (!requestResults.containsKey(permission)) {
                    // On Android below M, the android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS flag in AndroidManifest.xml
                    // may be ignored and not visible to the App as it's a new permission setting as a whole.
                    if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS && Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                        requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_RESTRICTED);
                    } else {
                        requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_DENIED);
                    }
                }

                continue;
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                activityRegistry.addListener(
                        new ActivityResultListener(successCallback)
                );

                String packageName = activity.getPackageName();
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setData(Uri.parse("package:" + packageName));
                activity.startActivityForResult(intent, PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS);
            } else {
                permissionsToRequest.addAll(names);
            }
        }

        final String[] requestPermissions = permissionsToRequest.toArray(new String[0]);
        if (permissionsToRequest.size() > 0) {
            permissionRegistry.addListener(
                    new RequestPermissionsListener(
                            activity,
                            requestResults,
                            (Map<Integer, Integer> results) -> {
                                ongoing = false;
                                successCallback.onSuccess(results);
                            })
            );

            ongoing = true;

            ActivityCompat.requestPermissions(
                    activity,
                    requestPermissions,
                    PermissionConstants.PERMISSION_CODE);
        } else {
            ongoing = false;
            if (requestResults.size() > 0) {
                successCallback.onSuccess(requestResults);
            }
        }
    }

    @PermissionConstants.PermissionStatus
    private int determinePermissionStatus(
            @PermissionConstants.PermissionGroup int permission,
            Context context,
            @Nullable Activity activity) {

        if (permission == PermissionConstants.PERMISSION_GROUP_NOTIFICATION) {
            return checkNotificationPermissionStatus(context);
        }
        if(permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH){
            return checkBluetoothPermissionStatus(context);
        }

        final List<String> names = PermissionUtils.getManifestNames(context, permission);

        if (names == null) {
            Log.d(PermissionConstants.LOG_TAG, "No android specific permissions needed for: " + permission);

            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }

        //if no permissions were found then there is an issue and permission is not set in Android manifest
        if (names.size() == 0) {
            Log.d(PermissionConstants.LOG_TAG, "No permissions found in manifest for: " + permission);

            // On Android below M, the android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS flag in AndroidManifest.xml
            // may be ignored and not visible to the App as it's a new permission setting as a whole.
            if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                    return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
                }
            }

            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        final boolean targetsMOrHigher = context.getApplicationInfo().targetSdkVersion >= Build.VERSION_CODES.M;

        for (String name : names) {
            // Only handle them if the client app actually targets a API level greater than M.
            if (targetsMOrHigher) {
                if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                    String packageName = context.getPackageName();
                    PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                    // PowerManager.isIgnoringBatteryOptimizations has been included in Android M first.
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        if (pm != null && pm.isIgnoringBatteryOptimizations(packageName)) {
                            return PermissionConstants.PERMISSION_STATUS_GRANTED;
                        } else {
                            return PermissionConstants.PERMISSION_STATUS_DENIED;
                        }
                    } else {
                        return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
                    }
                }
                final int permissionStatus = ContextCompat.checkSelfPermission(context, name);
                if (permissionStatus != PackageManager.PERMISSION_GRANTED) {
                    return PermissionConstants.PERMISSION_STATUS_DENIED;
                }
            }
        }
        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    void shouldShowRequestPermissionRationale(
            int permission,
            Activity activity,
            ShouldShowRequestPermissionRationaleSuccessCallback successCallback,
            ErrorCallback errorCallback) {
        if (activity == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity.");

            errorCallback.onError(
                    "PermissionHandler.PermissionManager",
                    "Unable to detect current Android Activity.");
            return;
        }

        List<String> names = PermissionUtils.getManifestNames(activity, permission);

        // if isn't an android specific group then go ahead and return false;
        if (names == null) {
            Log.d(PermissionConstants.LOG_TAG, "No android specific permissions needed for: " + permission);
            successCallback.onSuccess(false);
            return;
        }

        if (names.isEmpty()) {
            Log.d(PermissionConstants.LOG_TAG, "No permissions found in manifest for: " + permission + " no need to show request rationale");
            successCallback.onSuccess(false);
            return;
        }

        successCallback.onSuccess(ActivityCompat.shouldShowRequestPermissionRationale(activity, names.get(0)));
    }

    private int checkNotificationPermissionStatus(Context context) {
        NotificationManagerCompat manager = NotificationManagerCompat.from(context);
        boolean isGranted = manager.areNotificationsEnabled();
        if (isGranted) {
            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }
        return PermissionConstants.PERMISSION_STATUS_DENIED;
    }

    private int checkBluetoothPermissionStatus(Context context) {
        List<String> names = PermissionUtils.getManifestNames(context, PermissionConstants.PERMISSION_GROUP_BLUETOOTH);
        boolean missingInManifest = names == null || names.isEmpty();
        if(missingInManifest) {
            Log.d(PermissionConstants.LOG_TAG, "Bluetooth permission missing in manifest");
            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }
        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    @VisibleForTesting
    static final class ActivityResultListener
            implements PluginRegistry.ActivityResultListener {

        // There's no way to unregister permission listeners in the v1 embedding, so we'll be called
        // duplicate times in cases where the user denies and then grants a permission. Keep track of if
        // we've responded before and bail out of handling the callback manually if this is a repeat
        // call.
        boolean alreadyCalled = false;

        final RequestPermissionsSuccessCallback callback;

        @VisibleForTesting
        ActivityResultListener(RequestPermissionsSuccessCallback callback) {
            this.callback = callback;
        }

        @Override
        public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
            if (alreadyCalled || requestCode != PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS) {
                return false;
            }

            alreadyCalled = true;
            final int status = resultCode == Activity.RESULT_OK
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;

            HashMap<Integer, Integer> results = new HashMap<>();
            results.put(PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS, status);
            callback.onSuccess(results);
            return true;
        }
    }

    @VisibleForTesting
    static final class RequestPermissionsListener
            implements PluginRegistry.RequestPermissionsResultListener {

        // There's no way to unregister permission listeners in the v1 embedding, so we'll be called
        // duplicate times in cases where the user denies and then grants a permission. Keep track of if
        // we've responded before and bail out of handling the callback manually if this is a repeat
        // call.
        boolean alreadyCalled = false;

        final Activity activity;
        final RequestPermissionsSuccessCallback callback;
        final Map<Integer, Integer> requestResults;

        @VisibleForTesting
        RequestPermissionsListener(
                Activity activity,
                Map<Integer, Integer> requestResults,
                RequestPermissionsSuccessCallback callback) {
            this.activity = activity;
            this.callback = callback;
            this.requestResults = requestResults;
        }

        @Override
        public boolean onRequestPermissionsResult(int id, String[] permissions, int[] grantResults) {
            if (alreadyCalled || id != PermissionConstants.PERMISSION_CODE) {
                return false;
            }

            alreadyCalled = true;

            for (int i = 0; i < permissions.length; i++) {
                final String permissionName = permissions[i];

                @PermissionConstants.PermissionGroup final int permission =
                        PermissionUtils.parseManifestName(permissionName);

                if (permission == PermissionConstants.PERMISSION_GROUP_UNKNOWN)
                    continue;

                final int result = grantResults[i];

                if (permission == PermissionConstants.PERMISSION_GROUP_MICROPHONE) {
                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_MICROPHONE)) {
                        requestResults.put(
                                PermissionConstants.PERMISSION_GROUP_MICROPHONE,
                                PermissionUtils.toPermissionStatus(this.activity, permissionName, result));
                    }
                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_SPEECH)) {
                        requestResults.put(
                                PermissionConstants.PERMISSION_GROUP_SPEECH,
                                PermissionUtils.toPermissionStatus(this.activity, permissionName, result));
                    }
                } else if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS) {
                    @PermissionConstants.PermissionStatus int permissionStatus =
                            PermissionUtils.toPermissionStatus(this.activity, permissionName, result);

                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS)) {
                        requestResults.put(PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS, permissionStatus);
                    }
                } else if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION) {
                    @PermissionConstants.PermissionStatus int permissionStatus =
                            PermissionUtils.toPermissionStatus(this.activity, permissionName, result);

                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                        if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS)) {
                            requestResults.put(
                                    PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS,
                                    permissionStatus);
                        }
                    }

                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE)) {
                        requestResults.put(
                                PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE,
                                permissionStatus);
                    }

                    requestResults.put(permission, permissionStatus);
                } else if (!requestResults.containsKey(permission)) {
                    requestResults.put(
                            permission,
                            PermissionUtils.toPermissionStatus(this.activity, permissionName, result));
                }

                PermissionUtils.updatePermissionShouldShowStatus(this.activity, permission);
            }

            this.callback.onSuccess(requestResults);
            return true;
        }
    }
}
