package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.VisibleForTesting;

import java.util.HashMap;

import io.flutter.plugin.common.PluginRegistry;

public class PermissionManagerResult implements PluginRegistry.ActivityResultListener {

    // There's no way to unregister permission listeners in the v1 embedding, so we'll be called
    // duplicate times in cases where the user denies and then grants a permission. Keep track of if
    // we've responded before and bail out of handling the callback manually if this is a repeat
    // call.
    boolean alreadyCalled = false;
    boolean alreadySystemAlertWindowCallbackCalled = false;
    Context context;

    final PermissionManager.RequestPermissionsSuccessCallback callback;

    PermissionManagerResult(PermissionManager.RequestPermissionsSuccessCallback callback) {
        this.callback = callback;
    }

    PermissionManagerResult(PermissionManager.RequestPermissionsSuccessCallback callback, Context context) {
        this.callback = callback;
        this.context = context;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS) {
            if (alreadyCalled)
                return false;
            alreadyCalled = true;
            final int status = resultCode == Activity.RESULT_OK ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;

            HashMap<Integer, Integer> results = new HashMap<>();
            results.put(PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS, status);
            callback.onSuccess(results);
            return true;
        } else if (requestCode == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (alreadySystemAlertWindowCallbackCalled)
                return false;
            alreadySystemAlertWindowCallbackCalled = true;
            final int status = Settings.canDrawOverlays(context) ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;

            HashMap<Integer, Integer> results = new HashMap<>();
            results.put(PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW, status);
            callback.onSuccess(results);
            return true;
        }
        return false;
    }
}
