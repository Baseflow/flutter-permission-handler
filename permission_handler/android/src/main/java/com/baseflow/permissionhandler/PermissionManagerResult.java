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
    Context context;

    final PermissionManager permissionManager;

    PermissionManagerResult(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    PermissionManagerResult(PermissionManager permissionManager, Context context) {
        this.permissionManager = permissionManager;
        this.context = context;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        PermissionManager.RequestPermissionsSuccessCallback callback = permissionManager.getSuccessCallback();
        if (requestCode == PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS) {
            final int status = resultCode == Activity.RESULT_OK ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;

            HashMap<Integer, Integer> results = new HashMap<>();
            results.put(PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS, status);
            if (callback != null)
                callback.onSuccess(results);
            return true;
        } else if (requestCode == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW
                && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            final int status = Settings.canDrawOverlays(context) ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;

            HashMap<Integer, Integer> results = new HashMap<>();
            results.put(PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW, status);
            if (callback != null)
                callback.onSuccess(results);
            return true;
        }
        return false;
    }
}
