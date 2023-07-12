package com.baseflow.permissionhandler;

import static android.content.Context.BLUETOOTH_SERVICE;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
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
    @FunctionalInterface
    interface SuccessCallback {
        void onSuccess(@PermissionConstants.ServiceStatus int serviceStatus);
    }

    void checkServiceStatus(
            int permission,
            Context context,
            SuccessCallback successCallback,
            ErrorCallback errorCallback) {
        if(context == null) {
            Log.d(PermissionConstants.LOG_TAG, "Context cannot be null.");
            errorCallback.onError("PermissionHandler.ServiceManager", "Android context cannot be null.");
            return;
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION ||
            permission == PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS ||
            permission == PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE) {
            final int serviceStatus = isLocationServiceEnabled(context)
                    ? PermissionConstants.SERVICE_STATUS_ENABLED
                    : PermissionConstants.SERVICE_STATUS_DISABLED;

            successCallback.onSuccess(serviceStatus);
            return;
        }
        if(permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH){
            final int serviceStatus = isBluetoothServiceEnabled(context)
                    ? PermissionConstants.SERVICE_STATUS_ENABLED
                    : PermissionConstants.SERVICE_STATUS_DISABLED;

            successCallback.onSuccess(serviceStatus);
            return;
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_PHONE) {
            PackageManager pm = context.getPackageManager();
            if (!pm.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE);
                return;
            }

            TelephonyManager telephonyManager = (TelephonyManager) context
                    .getSystemService(Context.TELEPHONY_SERVICE);

            if (telephonyManager == null || telephonyManager.getPhoneType() == TelephonyManager.PHONE_TYPE_NONE) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE);
                return;
            }

            List<ResolveInfo> callAppsList = getCallAppsList(pm);

            if (callAppsList.isEmpty()) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE);
                return;
            }

            if (telephonyManager.getSimState() != TelephonyManager.SIM_STATE_READY) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_DISABLED);
                return;
            }

            successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_ENABLED);
            return;
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
            final int serviceStatus = Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                    ? PermissionConstants.SERVICE_STATUS_ENABLED
                    : PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE;
            successCallback.onSuccess(serviceStatus);
            return;
        }

        successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE);
    }

    private boolean isLocationServiceEnabled(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            final LocationManager locationManager = context.getSystemService(LocationManager.class);
            if (locationManager == null) {
                return false;
            }

            return locationManager.isLocationEnabled();
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            return isLocationServiceEnabledKitKat(context);
        } else {
            return isLocationServiceEnablePreKitKat(context);
        }
    }

    // Suppress deprecation warnings since its purpose is to support to be backwards compatible with
    // pre Pie versions of Android.
    @SuppressWarnings("deprecation")
    private static boolean isLocationServiceEnabledKitKat(Context context)
    {
        if (Build.VERSION.SDK_INT < VERSION_CODES.KITKAT) {
            return false;
        }

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

    // Suppress deprecation warnings since its purpose is to support to be backwards compatible with
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
    // Suppress deprecation warnings since its purpose is to support to be backwards compatible with
    // pre S versions of Android
    @SuppressWarnings("deprecation")
    private boolean isBluetoothServiceEnabled(Context context) {
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.JELLY_BEAN_MR2) {
            return BluetoothAdapter.getDefaultAdapter().isEnabled();
        } 
        
        BluetoothManager manager = (BluetoothManager) context.getSystemService(BLUETOOTH_SERVICE);
        final BluetoothAdapter adapter = manager.getAdapter();
        return adapter.isEnabled();
    }

    // Suppress deprecation warnings since its purpose is to support to be backwards compatible with
    // pre TIRAMISU versions of Android
    @SuppressWarnings("deprecation")
    private List<ResolveInfo> getCallAppsList(PackageManager pm) {
        Intent callIntent = new Intent(Intent.ACTION_CALL);
        callIntent.setData(Uri.parse("tel:123123"));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return pm.queryIntentActivities(callIntent, PackageManager.ResolveInfoFlags.of(0));
        } else {
            return pm.queryIntentActivities(callIntent, 0);
        }
    }
}
