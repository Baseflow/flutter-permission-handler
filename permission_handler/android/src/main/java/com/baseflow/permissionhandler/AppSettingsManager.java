package com.baseflow.permissionhandler;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

final class AppSettingsManager {
    boolean openAppSettings(Context applicationContext) {
        if (applicationContext == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity or App Context.");
            return false;
        }

        try {
            Intent settingsIntent = new Intent();
            settingsIntent.setAction(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            settingsIntent.addCategory(Intent.CATEGORY_DEFAULT);
            settingsIntent.setData(android.net.Uri.parse("package:" + applicationContext.getPackageName()));
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

            applicationContext.startActivity(settingsIntent);

            return true;
        } catch (Exception ex) {
            return false;
        }
    }
}
