package com.baseflow.permissionhandler;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

final class AppSettingsManager {
    @FunctionalInterface
    interface OpenAppSettingsSuccessCallback {
        void onSuccess(boolean appSettingsOpenedSuccessfully);
    }

    void openAppSettings(
            Context context,
            OpenAppSettingsSuccessCallback successCallback,
            ErrorCallback errorCallback) {
        if(context == null) {
            Log.d(PermissionConstants.LOG_TAG, "Context cannot be null.");
            errorCallback.onError("PermissionHandler.AppSettingsManager", "Android context cannot be null.");
            return;
        }

        try {
            Intent settingsIntent = new Intent();
            settingsIntent.setAction(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            settingsIntent.addCategory(Intent.CATEGORY_DEFAULT);
            settingsIntent.setData(android.net.Uri.parse("package:" + context.getPackageName()));
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

            context.startActivity(settingsIntent);

            successCallback.onSuccess(true);
        } catch (Exception ex) {
            successCallback.onSuccess(false);
        }
    }
}
