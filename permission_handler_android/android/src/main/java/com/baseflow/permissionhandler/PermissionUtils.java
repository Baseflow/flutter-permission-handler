package com.baseflow.permissionhandler;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Environment;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

public class PermissionUtils {

    static final String SHARED_PREFERENCES_PERMISSION_WAS_DENIED_BEFORE_KEY =
        "sp_permission_handler_permission_was_denied_before";

    @PermissionConstants.PermissionGroup
    static int parseManifestName(String permission) {
        switch (permission) {
            case Manifest.permission.WRITE_CALENDAR:
            case Manifest.permission.READ_CALENDAR:
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
                return PermissionConstants.PERMISSION_GROUP_PHONE;
            case Manifest.permission.BODY_SENSORS:
                return PermissionConstants.PERMISSION_GROUP_SENSORS;
            case Manifest.permission.BODY_SENSORS_BACKGROUND:
                return PermissionConstants.PERMISSION_GROUP_SENSORS_ALWAYS;
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
            case Manifest.permission.BLUETOOTH_SCAN:
                return PermissionConstants.PERMISSION_GROUP_BLUETOOTH_SCAN;
            case Manifest.permission.BLUETOOTH_ADVERTISE:
                return PermissionConstants.PERMISSION_GROUP_BLUETOOTH_ADVERTISE;
            case Manifest.permission.BLUETOOTH_CONNECT:
                return PermissionConstants.PERMISSION_GROUP_BLUETOOTH_CONNECT;
            case Manifest.permission.POST_NOTIFICATIONS:
                return PermissionConstants.PERMISSION_GROUP_NOTIFICATION;
            case Manifest.permission.NEARBY_WIFI_DEVICES:
                return PermissionConstants.PERMISSION_GROUP_NEARBY_WIFI_DEVICES;
            case Manifest.permission.READ_MEDIA_IMAGES:
                return PermissionConstants.PERMISSION_GROUP_PHOTOS;
            case Manifest.permission.READ_MEDIA_VIDEO:
                return PermissionConstants.PERMISSION_GROUP_VIDEOS;
            case Manifest.permission.READ_MEDIA_AUDIO:
                return PermissionConstants.PERMISSION_GROUP_AUDIO;
            case Manifest.permission.SCHEDULE_EXACT_ALARM:
                return PermissionConstants.PERMISSION_GROUP_SCHEDULE_EXACT_ALARM;
            case Manifest.permission.ACCESS_LOCAL_NETWORK:
                return PermissionConstants.PERMISSION_GROUP_ACCESS_LOCAL_NETWORK;
            default:
                return PermissionConstants.PERMISSION_GROUP_UNKNOWN;
        }
    }

    @TargetApi(22)
    static List<String> getManifestNames(
        Context context,
        @PermissionConstants.PermissionGroup int permission
    ) {
        final ArrayList<String> permissionNames = new ArrayList<>();

        switch (permission) {
            case PermissionConstants.PERMISSION_GROUP_CALENDAR_WRITE_ONLY:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CALENDAR
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CALENDAR);
                break;
            case PermissionConstants.PERMISSION_GROUP_CALENDAR_FULL_ACCESS:
            case PermissionConstants.PERMISSION_GROUP_CALENDAR:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CALENDAR
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CALENDAR);
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_CALENDAR
                    )
                ) permissionNames.add(Manifest.permission.READ_CALENDAR);
                break;
            case PermissionConstants.PERMISSION_GROUP_CAMERA:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.CAMERA
                    )
                ) permissionNames.add(Manifest.permission.CAMERA);
                break;
            case PermissionConstants.PERMISSION_GROUP_CONTACTS:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_CONTACTS
                    )
                ) permissionNames.add(Manifest.permission.READ_CONTACTS);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CONTACTS
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CONTACTS);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.GET_ACCOUNTS
                    )
                ) permissionNames.add(Manifest.permission.GET_ACCOUNTS);
                break;
            case PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS:
            case PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE:
            case PermissionConstants.PERMISSION_GROUP_LOCATION:
                // Note that the LOCATION_ALWAYS will deliberately fallthrough to the LOCATION
                // case on pre Android Q devices. The ACCESS_BACKGROUND_LOCATION permission was only
                // introduced in Android Q, before it should be treated as the ACCESS_COARSE_LOCATION or
                // ACCESS_FINE_LOCATION.
                if (
                    permission ==
                        PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS &&
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
                ) {
                    if (
                        hasPermissionInManifest(
                            context,
                            permissionNames,
                            Manifest.permission.ACCESS_BACKGROUND_LOCATION
                        )
                    ) permissionNames.add(
                        Manifest.permission.ACCESS_BACKGROUND_LOCATION
                    );
                    break;
                }

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    )
                ) permissionNames.add(
                    Manifest.permission.ACCESS_COARSE_LOCATION
                );

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    )
                ) permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION);
                break;
            case PermissionConstants.PERMISSION_GROUP_SPEECH:
            case PermissionConstants.PERMISSION_GROUP_MICROPHONE:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECORD_AUDIO
                    )
                ) permissionNames.add(Manifest.permission.RECORD_AUDIO);
                break;
            case PermissionConstants.PERMISSION_GROUP_PHONE:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_PHONE_STATE
                    )
                ) permissionNames.add(Manifest.permission.READ_PHONE_STATE);

                if (
                    android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.Q &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_PHONE_NUMBERS
                    )
                ) permissionNames.add(Manifest.permission.READ_PHONE_NUMBERS);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.CALL_PHONE
                    )
                ) permissionNames.add(Manifest.permission.CALL_PHONE);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_CALL_LOG
                    )
                ) permissionNames.add(Manifest.permission.READ_CALL_LOG);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CALL_LOG
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CALL_LOG);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ADD_VOICEMAIL
                    )
                ) permissionNames.add(Manifest.permission.ADD_VOICEMAIL);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.USE_SIP
                    )
                ) permissionNames.add(Manifest.permission.USE_SIP);

                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ANSWER_PHONE_CALLS
                    )
                ) permissionNames.add(Manifest.permission.ANSWER_PHONE_CALLS);

                break;
            case PermissionConstants.PERMISSION_GROUP_SENSORS:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
                    if (
                        hasPermissionInManifest(
                            context,
                            permissionNames,
                            Manifest.permission.BODY_SENSORS
                        )
                    ) {
                        permissionNames.add(Manifest.permission.BODY_SENSORS);
                    }
                }
                break;
            case PermissionConstants.PERMISSION_GROUP_SENSORS_ALWAYS:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    if (
                        hasPermissionInManifest(
                            context,
                            permissionNames,
                            Manifest.permission.BODY_SENSORS_BACKGROUND
                        )
                    ) {
                        permissionNames.add(
                            Manifest.permission.BODY_SENSORS_BACKGROUND
                        );
                    }
                }
                break;
            case PermissionConstants.PERMISSION_GROUP_SMS:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.SEND_SMS
                    )
                ) permissionNames.add(Manifest.permission.SEND_SMS);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECEIVE_SMS
                    )
                ) permissionNames.add(Manifest.permission.RECEIVE_SMS);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_SMS
                    )
                ) permissionNames.add(Manifest.permission.READ_SMS);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECEIVE_WAP_PUSH
                    )
                ) permissionNames.add(Manifest.permission.RECEIVE_WAP_PUSH);

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECEIVE_MMS
                    )
                ) permissionNames.add(Manifest.permission.RECEIVE_MMS);
                break;
            case PermissionConstants.PERMISSION_GROUP_STORAGE:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_EXTERNAL_STORAGE
                    )
                ) permissionNames.add(
                    Manifest.permission.READ_EXTERNAL_STORAGE
                );

                if (
                    Build.VERSION.SDK_INT < Build.VERSION_CODES.Q ||
                    (Build.VERSION.SDK_INT == Build.VERSION_CODES.Q &&
                        Environment.isExternalStorageLegacy())
                ) {
                    if (
                        hasPermissionInManifest(
                            context,
                            permissionNames,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE
                        )
                    ) permissionNames.add(
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                    );
                    break;
                }
                break;
            case PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS:
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                    )
                ) permissionNames.add(
                    Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                );
                break;
            case PermissionConstants.PERMISSION_GROUP_ACCESS_MEDIA_LOCATION:
                // The ACCESS_MEDIA_LOCATION permission is introduced in Android Q, meaning we should
                // not handle permissions on pre Android Q devices.
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null;

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_MEDIA_LOCATION
                    )
                ) permissionNames.add(
                    Manifest.permission.ACCESS_MEDIA_LOCATION
                );
                break;
            case PermissionConstants.PERMISSION_GROUP_ACTIVITY_RECOGNITION:
                // The ACTIVITY_RECOGNITION permission is introduced in Android Q, meaning we should
                // not handle permissions on pre Android Q devices.
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null;

                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACTIVITY_RECOGNITION
                    )
                ) permissionNames.add(Manifest.permission.ACTIVITY_RECOGNITION);
                break;
            case PermissionConstants.PERMISSION_GROUP_BLUETOOTH:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.BLUETOOTH
                    )
                ) permissionNames.add(Manifest.permission.BLUETOOTH);
                break;
            case PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE:
                // The MANAGE_EXTERNAL_STORAGE permission is introduced in Android R, meaning we should
                // not handle permissions on pre Android R devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.MANAGE_EXTERNAL_STORAGE
                    )
                ) permissionNames.add(
                    Manifest.permission.MANAGE_EXTERNAL_STORAGE
                );
                break;
            case PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW:
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.SYSTEM_ALERT_WINDOW
                    )
                ) permissionNames.add(Manifest.permission.SYSTEM_ALERT_WINDOW);
                break;
            case PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES:
                // The REQUEST_INSTALL_PACKAGES permission is introduced in Android M, meaning we should
                // not handle permissions on pre Android M devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.REQUEST_INSTALL_PACKAGES
                    )
                ) permissionNames.add(
                    Manifest.permission.REQUEST_INSTALL_PACKAGES
                );
                break;
            case PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY:
                // The REQUEST_NOTIFICATION_POLICY permission is introduced in Android M, meaning we should
                // not handle permissions on pre Android M devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_NOTIFICATION_POLICY
                    )
                ) permissionNames.add(
                    Manifest.permission.ACCESS_NOTIFICATION_POLICY
                );
                break;
            case PermissionConstants.PERMISSION_GROUP_BLUETOOTH_SCAN: {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // The BLUETOOTH_SCAN permission is introduced in Android S, meaning we should
                    // not handle permissions on pre Android S devices.
                    String result = determineBluetoothPermission(
                        context,
                        Manifest.permission.BLUETOOTH_SCAN
                    );

                    if (result != null) {
                        permissionNames.add(result);
                    }
                }

                break;
            }
            case PermissionConstants.PERMISSION_GROUP_BLUETOOTH_ADVERTISE: {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // The BLUETOOTH_ADVERTISE permission is introduced in Android S, meaning we should
                    // not handle permissions on pre Android S devices.
                    String result = determineBluetoothPermission(
                        context,
                        Manifest.permission.BLUETOOTH_ADVERTISE
                    );

                    if (result != null) {
                        permissionNames.add(result);
                    }
                }

                break;
            }
            case PermissionConstants.PERMISSION_GROUP_BLUETOOTH_CONNECT: {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // The BLUETOOTH_CONNECT permission is introduced in Android S, meaning we should
                    // not handle permissions on pre Android S devices.
                    String result = determineBluetoothPermission(
                        context,
                        Manifest.permission.BLUETOOTH_CONNECT
                    );

                    if (result != null) {
                        permissionNames.add(result);
                    }
                }

                break;
            }
            case PermissionConstants.PERMISSION_GROUP_NOTIFICATION:
                // The POST_NOTIFICATIONS permission is introduced in Android TIRAMISU, meaning we should
                // not handle permissions on pre Android TIRAMISU devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.POST_NOTIFICATIONS
                    )
                ) permissionNames.add(Manifest.permission.POST_NOTIFICATIONS);
                break;
            case PermissionConstants.PERMISSION_GROUP_NEARBY_WIFI_DEVICES:
                // The NEARBY_WIFI_DEVICES permission is introduced in Android TIRAMISU, meaning we should
                // not handle permissions on pre Android TIRAMISU devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.NEARBY_WIFI_DEVICES
                    )
                ) permissionNames.add(Manifest.permission.NEARBY_WIFI_DEVICES);
                break;
            case PermissionConstants.PERMISSION_GROUP_PHOTOS:
                // The READ_MEDIA_IMAGES permission is introduced in Android TIRAMISU, meaning we should
                // not handle permissions on pre Android TIRAMISU devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_MEDIA_IMAGES
                    )
                ) permissionNames.add(Manifest.permission.READ_MEDIA_IMAGES);
                break;
            case PermissionConstants.PERMISSION_GROUP_VIDEOS:
                // The READ_MEDIA_VIDEOS permission is introduced in Android TIRAMISU, meaning we should
                // not handle permissions on pre Android TIRAMISU devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_MEDIA_VIDEO
                    )
                ) permissionNames.add(Manifest.permission.READ_MEDIA_VIDEO);
                break;
            case PermissionConstants.PERMISSION_GROUP_AUDIO:
                // The READ_MEDIA_AUDIO permission is introduced in Android TIRAMISU, meaning we should
                // not handle permissions on pre Android TIRAMISU devices.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_MEDIA_AUDIO
                    )
                ) permissionNames.add(Manifest.permission.READ_MEDIA_AUDIO);
                break;
            case PermissionConstants.PERMISSION_GROUP_SCHEDULE_EXACT_ALARM:
                // The SCHEDULE_EXACT_ALARM permission is introduced in Android S, before Android 31 it should alway return Granted
                if (
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.SCHEDULE_EXACT_ALARM
                    )
                ) permissionNames.add(Manifest.permission.SCHEDULE_EXACT_ALARM);
                break;
            case PermissionConstants.PERMISSION_GROUP_ACCESS_LOCAL_NETWORK:
                // The ACCESS_LOCAL_NETWORK permission is introduced in API level 37 (Cinnamon Bun)
                // API 36 was allowed but only with e.g. NEARBY_WIFI_DEVICES, so we should not handle permissions on pre Android 37 devices.
                // Prior to 36, this was always allowed.
                if (
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.CINNAMON_BUN &&
                    hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_LOCAL_NETWORK
                    )
                ) permissionNames.add(Manifest.permission.ACCESS_LOCAL_NETWORK);
                break;
            case PermissionConstants.PERMISSION_GROUP_MEDIA_LIBRARY:
            case PermissionConstants.PERMISSION_GROUP_REMINDERS:
            case PermissionConstants.PERMISSION_GROUP_UNKNOWN:
                return null;
        }

        return permissionNames;
    }

    private static boolean hasPermissionInManifest(
        Context context,
        ArrayList<String> confirmedPermissions,
        String permission
    ) {
        try {
            if (confirmedPermissions != null) {
                for (String r : confirmedPermissions) {
                    if (r.equals(permission)) {
                        return true;
                    }
                }
            }

            if (context == null) {
                Log.d(
                    PermissionConstants.LOG_TAG,
                    "Unable to detect current Activity or App Context."
                );
                return false;
            }

            PackageInfo info = getPackageInfo(context);

            if (info == null) {
                Log.d(
                    PermissionConstants.LOG_TAG,
                    "Unable to get Package info, will not be able to determine permissions to request."
                );
                return false;
            }

            confirmedPermissions = new ArrayList<>(
                Arrays.asList(info.requestedPermissions)
            );
            for (String r : confirmedPermissions) {
                if (r.equals(permission)) {
                    return true;
                }
            }
        } catch (Exception ex) {
            Log.d(
                PermissionConstants.LOG_TAG,
                "Unable to check manifest for permission: ",
                ex
            );
        }
        return false;
    }

    /**
     * Converts the result of a runtime permission request into a
     * {@link PermissionConstants.PermissionStatus}.
     * <p>
     * When {@link PackageManager#PERMISSION_DENIED} is received, the OS does not tell us whether the
     * user denied the request, dismissed the dialog, or whether the dialog was never shown because
     * the permission is permanently denied. Therefore, we need a more sophisticated (read: hacky)
     * approach to determine whether the permission status is
     * {@link PermissionConstants#PERMISSION_STATUS_DENIED} or
     * {@link PermissionConstants#PERMISSION_STATUS_NEVER_ASK_AGAIN}.
     * <p>
     * The OS behavior has been researched experimentally and is displayed in the following diagrams:
     * <p>
     * State machine diagram:
     * <p>
     * Dismissed
     *    ┌┐
     * ┌──┘▼─────┐  Granted ┌───────┐
     * │Not asked├──────────►Granted│
     * └─┬───────┘          └─▲─────┘
     *   │           Granted  │
     *   │Denied  ┌───────────┘
     *   │        │
     * ┌─▼────────┴┐        ┌────────────────────────────────┐
     * │Denied once├────────►Denied twice(permanently denied)│
     * └──▲┌───────┘ Denied └──┬─────────────────────────────┘
     *    └┘                   │ 'Ask every time' in the app settings (Android 11+)
     * Dismissed               ▼
     *                      ┌──────────────┐
     *                      │Ask every time│ (looks exactly like 'Not asked' to the app)
     *                      └──────────────┘
     * <p>
     * Scenario table listing output of
     * {@link ActivityCompat#shouldShowRequestPermissionRationale(Activity, String)}:
     * ┌────────────┬─────────────────────────────┬────────────────────────────┬───────────────────────────────────┬─────────────────────────┐
     * │ Scenario # │ Previous state              │ Action                     │ New state                         │ 'Show rationale' output │
     * ├────────────┼─────────────────────────────┼────────────────────────────┼───────────────────────────────────┼─────────────────────────┤
     * │ 1.         │ Not asked                   │ Dismiss                    │ Not asked                         │ false                   │
     * │ 2.         │ Not asked                   │ Deny                       │ Denied once                       │ true                    │
     * │ 3.         │ Denied once                 │ Dismiss                    │ Denied once                       │ true                    │
     * │ 4.         │ Denied once                 │ Deny                       │ Denied twice (permanently denied) │ false                   │
     * │ 5.         │ Denied twice                │ Request (no dialog shown)  │ Denied twice                      │ false                   │
     * │ 6.         │ Granted / Ask every time    │ 'Don't allow' in settings  │ Denied once                       │ true                    │
     * │ 7.         │ Any                         │ 'Ask every time' in        │ Ask every time                    │ false                   │
     * │            │                             │ settings (Android 11+)     │                                   │                         │
     * │ 8.         │ Ask every time              │ Dismiss                    │ Ask every time                    │ false                   │
     * │ 9.         │ Ask every time              │ Deny                       │ Denied once                       │ true                    │
     * └────────────┴─────────────────────────────┴────────────────────────────┴───────────────────────────────────┴─────────────────────────┘
     * <p>
     * Selecting 'Ask every time' makes the OS revoke the permission as a one-time permission, which
     * clears the {@code FLAG_PERMISSION_USER_SET} flag. As 'show rationale' is exactly that flag
     * (as long as the permission is not user fixed), scenarios 1, 4, 5, 7 and 8 all produce
     * {@code false} and no public API exposes the difference between them.
     * <p>
     * A denied request result is therefore resolved from three signals:
     * <ul>
     * <li>'Show rationale' after the request is {@code true} (scenarios 2, 3 and 9): the user can
     * be asked again, resolve to 'denied'.</li>
     * <li>'Show rationale' was {@code true} before the request and is {@code false} after it
     * (scenario 4): the user denied for the second time, resolve to 'permanently denied'.</li>
     * <li>'Show rationale' was {@code false} before and after the request and the permission was
     * denied before (stored in {@link SharedPreferences}, see
     * {@link #wasPermissionDeniedBefore(Context, String)}): the OS resolved the request without
     * showing a dialog (scenario 5), resolve to 'permanently denied'. A dismissed dialog after the
     * user selected 'Ask every time' (scenario 8) is indistinguishable and resolves the same way;
     * the next request will show the dialog again.</li>
     * <li>Otherwise the user dismissed the very first request (scenario 1), resolve to 'denied'.</li>
     * </ul>
     * <p>
     * Note that a permission status check without a request can never resolve to 'permanently
     * denied' on Android for the same reason, see
     * {@link PermissionManager#checkPermissionStatus(int, PermissionManager.CheckPermissionsSuccessCallback)}.
     *
     * @param activity                         the activity for context
     * @param permissionName                   the name of the permission
     * @param grantResult                      the result of the permission request. Either
     *                                         {@link PackageManager#PERMISSION_DENIED} or
     *                                         {@link PackageManager#PERMISSION_GRANTED}.
     * @param shouldShowRationaleBeforeRequest the output of
     *                                         {@link ActivityCompat#shouldShowRequestPermissionRationale(Activity, String)}
     *                                         captured right before the request was made, or
     *                                         {@code null} when unknown.
     * @return {@link PermissionConstants#PERMISSION_STATUS_GRANTED},
     * {@link PermissionConstants#PERMISSION_STATUS_DENIED}, or
     * {@link PermissionConstants#PERMISSION_STATUS_NEVER_ASK_AGAIN}.
     */
    @PermissionConstants.PermissionStatus
    static int toPermissionStatus(
        final @Nullable Activity activity,
        final String permissionName,
        final int grantResult,
        final @Nullable Boolean shouldShowRationaleBeforeRequest
    ) {
        if (grantResult != PackageManager.PERMISSION_DENIED) {
            if (activity != null) {
                clearPermissionDenied(activity, permissionName);
            }
            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }

        if (activity == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        final boolean shouldShowRationaleAfterRequest =
            ActivityCompat.shouldShowRequestPermissionRationale(activity, permissionName);

        if (shouldShowRationaleAfterRequest) {
            // Scenarios 2, 3 and 9: the OS will show the dialog again on the next request.
            setPermissionDenied(activity, permissionName);
            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        if (Boolean.TRUE.equals(shouldShowRationaleBeforeRequest)) {
            // Scenario 4: the user denied for the second time (or ticked 'Don't ask again' on
            // Android 10 and below).
            setPermissionDenied(activity, permissionName);
            return PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN;
        }

        if (wasPermissionDeniedBefore(activity, permissionName)) {
            // Scenario 5 (and 8): the OS did not show a dialog because the permission is
            // permanently denied.
            return PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN;
        }

        // Scenario 1: the user dismissed the very first request without making a choice.
        return PermissionConstants.PERMISSION_STATUS_DENIED;
    }

    @NonNull
    @PermissionConstants.PermissionStatus
    static Integer strictestStatus(
        final @NonNull Collection<
            @PermissionConstants.PermissionStatus Integer
        > statuses
    ) {
        if (
            statuses.contains(
                PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN
            )
        ) return PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN;
        if (
            statuses.contains(PermissionConstants.PERMISSION_STATUS_RESTRICTED)
        ) return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
        if (
            statuses.contains(PermissionConstants.PERMISSION_STATUS_DENIED)
        ) return PermissionConstants.PERMISSION_STATUS_DENIED;
        if (
            statuses.contains(PermissionConstants.PERMISSION_STATUS_LIMITED)
        ) return PermissionConstants.PERMISSION_STATUS_LIMITED;
        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    @NonNull
    @PermissionConstants.PermissionStatus
    static Integer strictestStatus(
        final @Nullable @PermissionConstants.PermissionStatus Integer statusA,
        final @Nullable @PermissionConstants.PermissionStatus Integer statusB
    ) {
        final Collection<
            @PermissionConstants.PermissionStatus Integer
        > statuses = new HashSet<>();
        statuses.add(statusA);
        statuses.add(statusB);
        return strictestStatus(statuses);
    }


    private static String determineBluetoothPermission(
        Context context,
        String permission
    ) {
        if (
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            hasPermissionInManifest(context, null, permission)
        ) {
            return permission;
        } else if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            if (
                hasPermissionInManifest(
                    context,
                    null,
                    Manifest.permission.ACCESS_FINE_LOCATION
                )
            ) {
                return Manifest.permission.ACCESS_FINE_LOCATION;
            } else if (
                hasPermissionInManifest(
                    context,
                    null,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                )
            ) {
                return Manifest.permission.ACCESS_COARSE_LOCATION;
            }

            return null;
        } else if (
            hasPermissionInManifest(
                context,
                null,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
        ) {
            return Manifest.permission.ACCESS_FINE_LOCATION;
        }

        return null;
    }

    // Suppress deprecation warnings since its purpose is to support to be backwards compatible with
    // pre TIRAMISU versions of Android
    @SuppressWarnings("deprecation")
    private static PackageInfo getPackageInfo(Context context)
        throws PackageManager.NameNotFoundException {
        final PackageManager pm = context.getPackageManager();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return pm.getPackageInfo(
                context.getPackageName(),
                PackageManager.PackageInfoFlags.of(
                    PackageManager.GET_PERMISSIONS
                )
            );
        } else {
            return pm.getPackageInfo(
                context.getPackageName(),
                PackageManager.GET_PERMISSIONS
            );
        }
    }

    /**
     * Checks if permission was denied in the past by reading
     * {@link PermissionUtils#SHARED_PREFERENCES_PERMISSION_WAS_DENIED_BEFORE_KEY} from
     * {@link SharedPreferences}.
     * <p>
     * Because the state is red from shared preferences, it is persistent across application
     * sessions.
     *
     * @param context        context needed for accessing shared preferences
     * @param permissionName the name of the permission
     * @return whether the permission was denied in the past
     */
    private static boolean wasPermissionDeniedBefore(
        final Context context,
        final String permissionName
    ) {
        final SharedPreferences sharedPreferences =
            context.getSharedPreferences(permissionName, Context.MODE_PRIVATE);
        return sharedPreferences.getBoolean(
            SHARED_PREFERENCES_PERMISSION_WAS_DENIED_BEFORE_KEY,
            false
        );
    }

    /**
     * Stores a boolean in {@link SharedPreferences} indicating the provided permission has been
     * denied.
     * <p>
     * Because the state is stored in shared preferences, it is persistent across application
     * sessions.
     *
     * @param context        context needed for accessing shared preferences.
     * @param permissionName the name of the permission
     */
    private static void setPermissionDenied(
        final Context context,
        final String permissionName
    ) {
        final SharedPreferences sharedPreferences =
            context.getSharedPreferences(permissionName, Context.MODE_PRIVATE);
        sharedPreferences
            .edit()
            .putBoolean(
                SHARED_PREFERENCES_PERMISSION_WAS_DENIED_BEFORE_KEY,
                true
            )
            .apply();
    }

    /**
     * Removes the {@link SharedPreferences} flag that marks the provided permission as denied
     * before, if present.
     * <p>
     * Called whenever the permission is observed to be granted, so that a later denial is tracked
     * from a clean slate. Without this, a permission that was denied once, granted in the app
     * settings and then reset to 'Ask every time' would resolve to 'permanently denied' when the
     * user dismisses the next request dialog.
     *
     * @param context        context needed for accessing shared preferences.
     * @param permissionName the name of the permission
     */
    static void clearPermissionDenied(
        final Context context,
        final String permissionName
    ) {
        final SharedPreferences sharedPreferences =
            context.getSharedPreferences(permissionName, Context.MODE_PRIVATE);
        if (
            !sharedPreferences.contains(
                SHARED_PREFERENCES_PERMISSION_WAS_DENIED_BEFORE_KEY
            )
        ) {
            return;
        }
        sharedPreferences
            .edit()
            .remove(SHARED_PREFERENCES_PERMISSION_WAS_DENIED_BEFORE_KEY)
            .apply();
    }
}
