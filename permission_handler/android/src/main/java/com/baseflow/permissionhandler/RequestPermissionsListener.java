package com.baseflow.permissionhandler;
import io.flutter.plugin.common.PluginRegistry;
import android.app.Activity;
import android.os.Build;

import java.util.Map;

public class RequestPermissionsListener
        implements PluginRegistry.RequestPermissionsResultListener {

        // There's no way to unregister permission listeners in the v1 embedding, so we'll be called
        // duplicate times in cases where the user denies and then grants a permission. Keep track of if
        // we've responded before and bail out of handling the callback manually if this is a repeat
        // call.
        boolean alreadyCalled = false;

        final Activity activity;
        final PermissionManager.RequestPermissionsSuccessCallback callback;
        final Map<Integer, Integer> requestResults;

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
                    requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_NOT_DETERMINED);
                }

                continue;
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                // activityRegistry.addListener(
                // new ActivityResultListener(successCallback)
                // );

                String packageName = activity.getPackageName();
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setData(Uri.parse("package:" + packageName));
                activity.startActivityForResult(intent, PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW) {
                // activityRegistry.addListener(new ActivityResultListener(successCallback,
                // activity));

                String packageName = activity.getPackageName();
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
                intent.setData(Uri.parse("package:" + packageName));
                activity.startActivityForResult(intent, PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW);
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

        @Override
        public boolean onRequestPermissionsResult(int id, String[] permissions, int[] grantResults)
        {
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
