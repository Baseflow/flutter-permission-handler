package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

import java.util.List;

final class ServiceManager {
    @PermissionConstants.ServiceStatus
    int checkServiceStatus(
            int permission,
            Activity activity) {
        if (activity == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity or App Context.");
            return PermissionConstants.SERVICE_STATUS_UNKNOWN;
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION ||
            permission == PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS ||
            permission == PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE) {
                return isLocationServiceEnabled(activity)
                        ? PermissionConstants.SERVICE_STATUS_ENABLED
                        : PermissionConstants.SERVICE_STATUS_DISABLED;
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_PHONE) {
            PackageManager pm = activity.getPackageManager();
            if (!pm.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)) {
                return PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE;
            }

            TelephonyManager telephonyManager = (TelephonyManager) activity
                    .getSystemService(Context.TELEPHONY_SERVICE);

            if (telephonyManager == null || telephonyManager.getPhoneType() == TelephonyManager.PHONE_TYPE_NONE) {
                return PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE;
            }

            Intent callIntent = new Intent(Intent.ACTION_CALL);
            callIntent.setData(Uri.parse("tel:123123"));
            List<ResolveInfo> callAppsList = pm.queryIntentActivities(callIntent, 0);

            if (callAppsList.isEmpty()) {
                return PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE;
            }

            if (telephonyManager.getSimState() != TelephonyManager.SIM_STATE_READY) {
                return PermissionConstants.SERVICE_STATUS_DISABLED;
            }

            return PermissionConstants.SERVICE_STATUS_ENABLED;
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
            return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                    ? PermissionConstants.SERVICE_STATUS_ENABLED
                    : PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE;
        }

        return PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE;
    }

    private boolean isLocationServiceEnabled(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            final LocationManager locationManager = context.getSystemService(LocationManager.class);
            if (locationManager == null) {
                return false;
            }

            return locationManager.isLocationEnabled();
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            return isLocationServiceEnablePrePie(context);
        } else {
            return isLocationServiceEnablePreKitKat(context);
        }
    }

    // Suppress deprecation warnings since it's purpose is to support to be backwards compatible with
    // pre Pie versions of Android.
    @SuppressWarnings("deprecation")
    private static boolean isLocationServiceEnablePrePie(Context context)
    {
        if (VERSION.SDK_INT < VERSION_CODES.P)
            return false;

        final int locationMode;

        try {
            locationMode = Settings.Secure.getInt(
                    context.getContentResolver(),
                    Settings.Secure.LOCATION_MODE);
        } catch (Settings.SettingNotFoundException e) {
            e.printStackTrace();
            return false;
        }

        return locationMode != Settings.Secure.LOCATION_MODE_OFF;
    }

    // Suppress deprecation warnings since it's purpose is to support to be backwards compatible with
    // pre KitKat versions of Android.
    @SuppressWarnings("deprecation")
    private static boolean isLocationServiceEnablePreKitKat(Context context)
    {
        if (VERSION.SDK_INT >= VERSION_CODES.KITKAT)
            return false;

        final String locationProviders = Settings.Secure.getString(
                context.getContentResolver(),
                Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
        return !TextUtils.isEmpty(locationProviders);
    }
}
