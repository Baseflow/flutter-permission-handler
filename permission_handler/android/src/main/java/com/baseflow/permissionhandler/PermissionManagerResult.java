package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.VisibleForTesting;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

public class PermissionManagerResult implements PluginRegistry.ActivityResultListener {

    // There's no way to unregister permission listeners in the v1 embedding, so we'll be called
    // duplicate times in cases where the user denies and then grants a permission. Keep track of if
    // we've responded before and bail out of handling the callback manually if this is a repeat
    // call.
    Context context;

    final PermissionManager permissionManager;
    private boolean alreadyCalled = false;
    private Map<Integer, Integer> results;

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
            if(!alreadyCalled || results==null)
            results = permissionManager.getResult();
            alreadyCalled = true;
            for (Map.Entry<Integer,Integer> entry : results.entrySet())
                if(entry.getKey()==PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS)
                    entry.setValue(status);
                int count = permissionManager.getSendingIntentCount();
            if(callback!=null&&count<=1) {
                permissionManager.setSendingIntentCount(--count);
                callback.onSuccess(results);
            }
            else
            permissionManager.setSendingIntentCount(--count);
            return true;
        } else if (requestCode == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            final int status = Settings.canDrawOverlays(context) ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
            if(!alreadyCalled || results==null)
                results = permissionManager.getResult();
            alreadyCalled = true;
            for (Map.Entry<Integer,Integer> entry : results.entrySet())
                if(entry.getKey()==PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW)
                    entry.setValue(status);
            int count = permissionManager.getSendingIntentCount();
            if(callback!=null&&count<=1) {
                permissionManager.setSendingIntentCount(--count);
                callback.onSuccess(results);
            }
            else
            permissionManager.setSendingIntentCount(--count);
            return true;
        }
        return false;
    }
}
