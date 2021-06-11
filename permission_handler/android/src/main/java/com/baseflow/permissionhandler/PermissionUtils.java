package com.baseflow.permissionhandler;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Environment;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class PermissionUtils {

    @PermissionConstants.PermissionGroup
    static int parseManifestName(String permission) {
        switch (permission) {
            case Manifest.permission.READ_CALENDAR:
            case Manifest.permission.WRITE_CALENDAR:
                return PermissionConstants.PERMISSION_GROUP_CALENDAR;
            case Manifest.permission.CAMERA:
                return PermissionConstants.PERMISSION_GROUP_CAMERA;
            case Manifest.permission.READ_CONTACTS:
            case Manifest.permission.WRITE_CONTACTS:
            case Manifest.permission.GET_ACCOUNTS:
                return PermissionConstants.PERMISSION_GROUP_CONTACTS;
            case Manifest.permission.ACCESS_BACKGROUND_LOCATION:
                return PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS;
            case Manifest.permission.ACCESS_COARSE_LOCATION:
            case Manifest.permission.ACCESS_FINE_LOCATION:
                return PermissionConstants.PERMISSION_GROUP_LOCATION;
            case Manifest.permission.RECORD_AUDIO:
                return PermissionConstants.PERMISSION_GROUP_MICROPHONE;
            case Manifest.permission.READ_PHONE_STATE:
            case Manifest.permission.READ_PHONE_NUMBERS:
            case Manifest.permission.CALL_PHONE:
            case Manifest.permission.READ_CALL_LOG:
            case Manifest.permission.WRITE_CALL_LOG:
            case Manifest.permission.ADD_VOICEMAIL:
            case Manifest.permission.USE_SIP:
            case Manifest.permission.BIND_CALL_REDIRECTION_SERVICE:
                return PermissionConstants.PERMISSION_GROUP_PHONE;
            case Manifest.permission.BODY_SENSORS:
                return PermissionConstants.PERMISSION_GROUP_SENSORS;
            case Manifest.permission.SEND_SMS:
            case Manifest.permission.RECEIVE_SMS:
            case Manifest.permission.READ_SMS:
            case Manifest.permission.RECEIVE_WAP_PUSH:
            case Manifest.permission.RECEIVE_MMS:
                return PermissionConstants.PERMISSION_GROUP_SMS;
            case Manifest.permission.READ_EXTERNAL_STORAGE:
            case Manifest.permission.WRITE_EXTERNAL_STORAGE:
                return PermissionConstants.PERMISSION_GROUP_STORAGE;
            case Manifest.permission.ACCESS_MEDIA_LOCATION:
                return PermissionConstants.PERMISSION_GROUP_ACCESS_MEDIA_LOCATION;
            case Manifest.permission.ACTIVITY_RECOGNITION:
                return PermissionConstants.PERMISSION_GROUP_ACTIVITY_RECOGNITION;
            case Manifest.permission.MANAGE_EXTERNAL_STORAGE:
                return PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE;
            case Manifest.permission.SYSTEM_ALERT_WINDOW:
                return PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW;
            case Manifest.permission.REQUEST_INSTALL_PACKAGES:
                return PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES;
            case Manifest.permission.ACCESS_NOTIFICATION_POLICY:
                return PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY;
            default:
                return PermissionConstants.PERMISSION_GROUP_UNKNOWN;
        }
    }

    static List<String> getManifestNames(Context context, @PermissionConstants.PermissionGroup int permission) {
        final ArrayList<String> permissionNames = new ArrayList<>();

        switch (permission) {
            case PermissionConstants.PERMISSION_GROUP_CALENDAR:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_CALENDAR))
                    permissionNames.add(Manifest.permission.READ_CALENDAR);
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.WRITE_CALENDAR))
                    permissionNames.add(Manifest.permission.WRITE_CALENDAR);
                break;

            case PermissionConstants.PERMISSION_GROUP_CAMERA:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.CAMERA))
                    permissionNames.add(Manifest.permission.CAMERA);
                break;

            case PermissionConstants.PERMISSION_GROUP_CONTACTS:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_CONTACTS))
                    permissionNames.add(Manifest.permission.READ_CONTACTS);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.WRITE_CONTACTS))
                    permissionNames.add(Manifest.permission.WRITE_CONTACTS);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.GET_ACCOUNTS))
                    permissionNames.add(Manifest.permission.GET_ACCOUNTS);
                break;

            case PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS:
                // Note that the LOCATION_ALWAYS will deliberately fallthrough to the LOCATION
                // case on pre Android Q devices. The ACCESS_BACKGROUND_LOCATION permission was only
                // introduced in Android Q, before it should be treated as the ACCESS_COARSE_LOCATION or
                // ACCESS_FINE_LOCATION.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    if (hasPermissionInManifest(context, permissionNames, Manifest.permission.ACCESS_BACKGROUND_LOCATION))
                        permissionNames.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION);
                }
            case PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE:
            case PermissionConstants.PERMISSION_GROUP_LOCATION:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.ACCESS_COARSE_LOCATION))
                    permissionNames.add(Manifest.permission.ACCESS_COARSE_LOCATION);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.ACCESS_FINE_LOCATION))
                    permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION);
                break;


            case PermissionConstants.PERMISSION_GROUP_SPEECH:
            case PermissionConstants.PERMISSION_GROUP_MICROPHONE:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.RECORD_AUDIO))
                    permissionNames.add(Manifest.permission.RECORD_AUDIO);
                break;

            case PermissionConstants.PERMISSION_GROUP_PHONE:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_PHONE_STATE))
                    permissionNames.add(Manifest.permission.READ_PHONE_STATE);

                if (android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.Q && hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_PHONE_NUMBERS)) {
                    permissionNames.add(Manifest.permission.READ_PHONE_NUMBERS);
                }

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.CALL_PHONE))
                    permissionNames.add(Manifest.permission.CALL_PHONE);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_CALL_LOG))
                    permissionNames.add(Manifest.permission.READ_CALL_LOG);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.WRITE_CALL_LOG))
                    permissionNames.add(Manifest.permission.WRITE_CALL_LOG);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.ADD_VOICEMAIL))
                    permissionNames.add(Manifest.permission.ADD_VOICEMAIL);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.USE_SIP))
                    permissionNames.add(Manifest.permission.USE_SIP);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && hasPermissionInManifest(context, permissionNames, Manifest.permission.BIND_CALL_REDIRECTION_SERVICE))
                    permissionNames.add(Manifest.permission.BIND_CALL_REDIRECTION_SERVICE);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && hasPermissionInManifest(context, permissionNames, Manifest.permission.ANSWER_PHONE_CALLS))
                    permissionNames.add(Manifest.permission.ANSWER_PHONE_CALLS);

                break;

            case PermissionConstants.PERMISSION_GROUP_SENSORS:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
                    if (hasPermissionInManifest(context, permissionNames, Manifest.permission.BODY_SENSORS)) {
                        permissionNames.add(Manifest.permission.BODY_SENSORS);
                    }
                }
                break;

            case PermissionConstants.PERMISSION_GROUP_SMS:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.SEND_SMS))
                    permissionNames.add(Manifest.permission.SEND_SMS);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.RECEIVE_SMS))
                    permissionNames.add(Manifest.permission.RECEIVE_SMS);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_SMS))
                    permissionNames.add(Manifest.permission.READ_SMS);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.RECEIVE_WAP_PUSH))
                    permissionNames.add(Manifest.permission.RECEIVE_WAP_PUSH);

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.RECEIVE_MMS))
                    permissionNames.add(Manifest.permission.RECEIVE_MMS);
                break;

            case PermissionConstants.PERMISSION_GROUP_STORAGE:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.READ_EXTERNAL_STORAGE))
                    permissionNames.add(Manifest.permission.READ_EXTERNAL_STORAGE);

                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q || (Build.VERSION.SDK_INT == Build.VERSION_CODES.Q && Environment.isExternalStorageLegacy())) {
                    if (hasPermissionInManifest(context, permissionNames, Manifest.permission.WRITE_EXTERNAL_STORAGE))
                        permissionNames.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
                    break;
                }
                break;

            case PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && hasPermissionInManifest(context, permissionNames, Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS))
                    permissionNames.add(Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                break;

            case PermissionConstants.PERMISSION_GROUP_ACCESS_MEDIA_LOCATION:
                // The ACCESS_MEDIA_LOCATION permission is introduced in Android Q, meaning we should
                // not handle permissions on pre Android Q devices.
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q)
                    return null;

                if(hasPermissionInManifest(context, permissionNames, Manifest.permission.ACCESS_MEDIA_LOCATION))
                    permissionNames.add(Manifest.permission.ACCESS_MEDIA_LOCATION);
                break;

            case PermissionConstants.PERMISSION_GROUP_ACTIVITY_RECOGNITION:
                // The ACTIVITY_RECOGNITION permission is introduced in Android Q, meaning we should
                // not handle permissions on pre Android Q devices.
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q)
                    return null;

                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.ACTIVITY_RECOGNITION))
                    permissionNames.add(Manifest.permission.ACTIVITY_RECOGNITION);
                break;

            case PermissionConstants.PERMISSION_GROUP_BLUETOOTH:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.BLUETOOTH))
                    permissionNames.add(Manifest.permission.BLUETOOTH);
                break;

            case PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE:
                // The MANAGE_EXTERNAL_STORAGE permission is introduced in Android R, meaning we should
                // not handle permissions on pre Android R devices.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && hasPermissionInManifest(context, permissionNames, Manifest.permission.MANAGE_EXTERNAL_STORAGE ))
                    permissionNames.add(Manifest.permission.MANAGE_EXTERNAL_STORAGE);
                break;

            case PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW:
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.SYSTEM_ALERT_WINDOW ))
                    permissionNames.add(Manifest.permission.SYSTEM_ALERT_WINDOW);
                break;

            case PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES:
                // The REQUEST_INSTALL_PACKAGES permission is introduced in Android M, meaning we should
                // not handle permissions on pre Android M devices.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && hasPermissionInManifest(context, permissionNames, Manifest.permission.REQUEST_INSTALL_PACKAGES ))
                    permissionNames.add(Manifest.permission.REQUEST_INSTALL_PACKAGES);
                break;
            case PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY:
                // The REQUEST_NOTIFICATION_POLICY permission is introduced in Android M, meaning we should
                // not handle permissions on pre Android M devices.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && hasPermissionInManifest(context, permissionNames, Manifest.permission.ACCESS_NOTIFICATION_POLICY ))
                    permissionNames.add(Manifest.permission.ACCESS_NOTIFICATION_POLICY);
                break;
            case PermissionConstants.PERMISSION_GROUP_NOTIFICATION:
            case PermissionConstants.PERMISSION_GROUP_MEDIA_LIBRARY:
            case PermissionConstants.PERMISSION_GROUP_PHOTOS:
            case PermissionConstants.PERMISSION_GROUP_REMINDERS:
            case PermissionConstants.PERMISSION_GROUP_UNKNOWN:
                return null;
        }

        return permissionNames;
    }

    private static boolean hasPermissionInManifest(Context context, ArrayList<String> confirmedPermissions, String permission) {
        try {
            if (confirmedPermissions != null) {
                for (String r : confirmedPermissions) {
                    if (r.equals(permission)) {
                        return true;
                    }
                }
            }

            if (context == null) {
                Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity or App Context.");
                return false;
            }

            PackageInfo info = context
                    .getPackageManager()
                    .getPackageInfo(context.getPackageName(), PackageManager.GET_PERMISSIONS);

            if (info == null) {
                Log.d(PermissionConstants.LOG_TAG, "Unable to get Package info, will not be able to determine permissions to request.");
                return false;
            }

            confirmedPermissions = new ArrayList<>(Arrays.asList(info.requestedPermissions));
            for (String r : confirmedPermissions) {
                if (r.equals(permission)) {
                    return true;
                }
            }
        } catch (Exception ex) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to check manifest for permission: ", ex);
        }
        return false;
    }

    @PermissionConstants.PermissionStatus
    static int toPermissionStatus(final Activity activity, final String permissionName, int grantResult) {
        if (grantResult == PackageManager.PERMISSION_DENIED) {
            return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && PermissionUtils.isNeverAskAgainSelected(activity, permissionName)
                    ? PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    static void updatePermissionShouldShowStatus(final Activity activity, @PermissionConstants.PermissionGroup int permission) {
        if (activity == null) {
            return;
        }

        List<String> names = getManifestNames(activity, permission);

        if (names == null || names.isEmpty()) {
            return;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    static boolean isNeverAskAgainSelected(final Activity activity, final String name) {
        if (activity == null) {
            return false;
        }

        final boolean shouldShowRequestPermissionRationale = ActivityCompat.shouldShowRequestPermissionRationale(activity, name);
        return !shouldShowRequestPermissionRationale;
    }
}
