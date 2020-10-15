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

        RequestPermissionsListener(
                Activity activity,
                Map<Integer, Integer> requestResults,
                PermissionManager.RequestPermissionsSuccessCallback callback) {
            this.activity = activity;
            this.callback = callback;
            this.requestResults = requestResults;
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
