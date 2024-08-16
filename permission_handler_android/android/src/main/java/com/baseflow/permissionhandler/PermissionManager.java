package com.baseflow.permissionhandler;

import static com.baseflow.permissionhandler.PermissionUtils.strictestStatus;

import android.Manifest;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.Application;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.PluginRegistry;

final class PermissionManager implements PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    @NonNull
    private final Context context;
    @Nullable
    private RequestPermissionsSuccessCallback successCallback;
    @Nullable
    private Activity activity;
    /**
     * The number of pending permission requests.
     * <p>
     * This number is set by {@link this#requestPermissions(List, RequestPermissionsSuccessCallback, ErrorCallback)}
     * and then reduced when receiving results in {@link this#onActivityResult(int, int, Intent)}
     * and {@link this#onRequestPermissionsResult(int, String[], int[])}.
     */
    private int pendingRequestCount;
    /**
     * The results of resolved permission requests.
     * <p>
     * This map holds the results to resolved permission requests received through
     * {@link this#onActivityResult(int, int, Intent)} and
     * {@link this#onRequestPermissionsResult(int, String[], int[])}.
     * It is (re)initialized when new permissions are requested through
     * {@link this#requestPermissions(List, RequestPermissionsSuccessCallback, ErrorCallback)}.
     */
    private Map<Integer, Integer> requestResults;

    public PermissionManager(@NonNull Context context) {
        this.context = context;
    }

    public void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (activity == null) {
            return false;
        }

        // The [onActivityResult] with a [requestResult] that is `null` when the Application was
        // terminated while not in the foreground with a permission request in progress (e.g. when
        // Android decides to kill apps while requesting one of the special permissions). In these
        // cases we should casually return and make sure the `pendingRequestCount` is set to `0`.
        if (requestResults == null) {
            pendingRequestCount = 0;
            return false;
        }

        int status, permission;

        if (requestCode == PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS) {
            permission = PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS;

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                String packageName = context.getPackageName();
                PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                status = (pm != null && pm.isIgnoringBatteryOptimizations(packageName))
                        ? PermissionConstants.PERMISSION_STATUS_GRANTED
                        : PermissionConstants.PERMISSION_STATUS_DENIED;
            } else {
                status = PermissionConstants.PERMISSION_STATUS_RESTRICTED;
            }
        } else if (requestCode == PermissionConstants.PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                status = Environment.isExternalStorageManager()
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
            } else {
                return false;
            }
            permission = PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE;
        } else if (requestCode == PermissionConstants.PERMISSION_CODE_SYSTEM_ALERT_WINDOW) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                status = Settings.canDrawOverlays(activity)
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
                permission = PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW;
            } else {
                return false;
            }
        } else if (requestCode == PermissionConstants.PERMISSION_CODE_REQUEST_INSTALL_PACKAGES) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                status = activity.getPackageManager().canRequestPackageInstalls()
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
                permission = PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES;
            } else {
                return false;
            }
        } else if (requestCode == PermissionConstants.PERMISSION_CODE_ACCESS_NOTIFICATION_POLICY) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                NotificationManager notificationManager = (NotificationManager) activity.getSystemService(Application.NOTIFICATION_SERVICE);
                status = notificationManager.isNotificationPolicyAccessGranted()
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
                permission = PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY;
            } else {
                return false;
            }
        } else if (requestCode == PermissionConstants.PERMISSION_CODE_SCHEDULE_EXACT_ALARM) {
            permission = PermissionConstants.PERMISSION_GROUP_SCHEDULE_EXACT_ALARM;
            AlarmManager alarmManager = (AlarmManager) activity.getSystemService(Context.ALARM_SERVICE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                status = alarmManager.canScheduleExactAlarms()
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
            } else {
                status = PermissionConstants.PERMISSION_STATUS_GRANTED;
            }
        } else {
            return false;
        }

        requestResults.put(permission, status);
        pendingRequestCount--;

        // Post result if all requests have been handled.
        if (successCallback != null && pendingRequestCount == 0) {
            this.successCallback.onSuccess(requestResults);
        }
        return true;
    }

    @Override
    public boolean onRequestPermissionsResult(
        int requestCode,
        @NonNull String[] permissions,
        @NonNull int[] grantResults) {

        if (requestCode != PermissionConstants.PERMISSION_CODE) {
            pendingRequestCount = 0;
            return false;
        }

        if (requestResults == null) {
            return false;
        }

        if (permissions.length == 0 && grantResults.length == 0) {
            Log.w(PermissionConstants.LOG_TAG, "onRequestPermissionsResult is called without results. This is probably caused by interfering request codes. If you see this error, please file an issue in flutter-permission-handler, including a list of plugins used by this application: https://github.com/Baseflow/flutter-permission-handler/issues");
            return false;
        }

        // Calendar permissions are split between WRITE and READ in Android, and split between WRITE
        // and FULL ACCESS in the plugin. We need special logic for this translation.
        final List<String> permissionList = Arrays.asList(permissions);
        final int calendarWriteIndex = permissionList.indexOf(Manifest.permission.WRITE_CALENDAR);
        // WRITE -> WRITE.
        if (calendarWriteIndex >= 0) {
            final int writeGrantResult = grantResults[calendarWriteIndex];
            final @PermissionConstants.PermissionStatus int writeStatus =
                PermissionUtils.toPermissionStatus(this.activity, Manifest.permission.WRITE_CALENDAR, writeGrantResult);
            requestResults.put(PermissionConstants.PERMISSION_GROUP_CALENDAR_WRITE_ONLY, writeStatus);

            // WRITE + READ -> FULL ACCESS.
            final int calendarReadIndex = permissionList.indexOf(Manifest.permission.READ_CALENDAR);
            if (calendarReadIndex >= 0) {
                final int readGrantResult = grantResults[calendarReadIndex];
                final @PermissionConstants.PermissionStatus int readStatus =
                    PermissionUtils.toPermissionStatus(this.activity, Manifest.permission.READ_CALENDAR, readGrantResult);
                final @PermissionConstants.PermissionStatus int fullAccessStatus = strictestStatus(writeStatus, readStatus);
                requestResults.put(PermissionConstants.PERMISSION_GROUP_CALENDAR_FULL_ACCESS, fullAccessStatus);
                // Support deprecated CALENDAR permission.
                requestResults.put(PermissionConstants.PERMISSION_GROUP_CALENDAR, fullAccessStatus);
            }
        }

        for (int i = 0; i < permissions.length; i++) {
            final String permissionName = permissions[i];

            // WRITE_CALENDAR and READ_CALENDAR permission results have already been handled.
            if (permissionName.equals(Manifest.permission.WRITE_CALENDAR) || permissionName.equals(Manifest.permission.READ_CALENDAR)) {
                continue;
            }

            @PermissionConstants.PermissionGroup final int permission =
                PermissionUtils.parseManifestName(permissionName);

            if (permission == PermissionConstants.PERMISSION_GROUP_UNKNOWN)
                continue;

            final int result = grantResults[i];

            if (permission == PermissionConstants.PERMISSION_GROUP_PHONE) {
                @Nullable @PermissionConstants.PermissionStatus Integer previousResult = requestResults.get(PermissionConstants.PERMISSION_GROUP_PHONE);
                @PermissionConstants.PermissionStatus int newResult = PermissionUtils.toPermissionStatus(this.activity, permissionName, result);
                @Nullable @PermissionConstants.PermissionStatus Integer strictestStatus = strictestStatus(previousResult, newResult);
                requestResults.put(PermissionConstants.PERMISSION_GROUP_PHONE, strictestStatus);
            } else if (permission == PermissionConstants.PERMISSION_GROUP_MICROPHONE) {
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
            // [grantResults] can only contain PermissionConstants.PERMISSION_STATUS_GRANTED or PermissionConstants.PERMISSION_STATUS_DENIED status.
            // But these permissions can have status PermissionConstants.PERMISSION_STATUS_LIMITED, so we need to recheck status
            } else if (permission == PermissionConstants.PERMISSION_GROUP_PHOTOS || permission == PermissionConstants.PERMISSION_GROUP_VIDEOS) {
                requestResults.put(
                    permission,
                    determinePermissionStatus(permission));
            } else if (!requestResults.containsKey(permission)) {
                requestResults.put(
                    permission,
                    PermissionUtils.toPermissionStatus(this.activity, permissionName, result));
            }
        }

        pendingRequestCount -= grantResults.length;

        // Post result if all requests have been handled.
        if (successCallback != null && pendingRequestCount == 0) {
            this.successCallback.onSuccess(requestResults);
        }
        return true;
    }

    /**
     * Determines the permission status of the provided permission.
     * <p>
     * To distinguish between a status of 'denied' and a status of 'permanently denied', the plugin
     * needs access to an activity. If `this.activity` is null, for example when running the
     * application in the background, the resolved status will be 'denied' for both 'denied' and
     * 'permanently denied'.
     *
     * @param permission      the permission for which to determine the status.
     * @param successCallback the callback to which the resolved status must be supplied.
     */
    void checkPermissionStatus(
        final @PermissionConstants.PermissionGroup int permission,
        final CheckPermissionsSuccessCallback successCallback) {

        successCallback.onSuccess(determinePermissionStatus(permission));
    }

    /**
     * Requests the user for the provided permissions.
     * <p>
     * This method will throw an error if it is called before all permission requests that were
     * requested in a previous call have been resolved.
     * <p>
     * Android distinguishes between
     * <a href="https://developer.android.com/guide/topics/permissions/overview#runtime">runtime permissions</a>
     * and
     * <a href="https://developer.android.com/guide/topics/permissions/overview#special">special permissions</a>.
     * Runtime permissions give an app additional access to restricted data or let the app perform
     * restricted actions that more substantially affect the system and other apps. These
     * permissions present the user with a dialog where they can choose to grant or deny the
     * permission. Special permissions guard access to system resources that are particularly
     * sensitive or not directly related to user privacy. These permissions are requested by sending
     * an {@link Intent} to the OS. The OS will open a special settings page where the user can
     * grant the permission.
     * Runtime permission request results will be reported through
     * {@link this#onRequestPermissionsResult(int, String[], int[])}, while special permissions
     * request results will be reported through {@link this#onActivityResult(int, int, Intent)}.
     * When these methods receive request results, they check whether all permissions that were
     * requested through this method were handled, and if so, return the result back to Dart.
     *
     * @param permissions     the permissions that are requested.
     * @param successCallback the callback for returning the permission results.
     * @param errorCallback   the callback to call in case of an error.
     */
    void requestPermissions(
        List<Integer> permissions,
        RequestPermissionsSuccessCallback successCallback,
        ErrorCallback errorCallback) {
        if (pendingRequestCount > 0) {
            errorCallback.onError(
                "PermissionHandler.PermissionManager",
                "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time).");
            return;
        }

        if (activity == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity.");

            errorCallback.onError(
                "PermissionHandler.PermissionManager",
                "Unable to detect current Android Activity.");
            return;
        }

        this.successCallback = successCallback;
        this.requestResults = new HashMap<>();
        this.pendingRequestCount = 0; // sanity check

        ArrayList<String> permissionsToRequest = new ArrayList<>();
        for (Integer permission : permissions) {
            @PermissionConstants.PermissionStatus final int permissionStatus = determinePermissionStatus(permission);
            if (permissionStatus == PermissionConstants.PERMISSION_STATUS_GRANTED) {
                if (!requestResults.containsKey(permission)) {
                    requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_GRANTED);
                }
                continue;
            }

            final List<String> names = PermissionUtils.getManifestNames(activity, permission);

            // check to see if we can find manifest names
            // if we can't add as unknown and continue
            if (names == null || names.isEmpty()) {
                if (!requestResults.containsKey(permission)) {
                    // On Android below M, the android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS flag in AndroidManifest.xml
                    // may be ignored and not visible to the App as it's a new permission setting as a whole.
                    if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS && Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                        requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_RESTRICTED);
                    } else {
                        requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_DENIED);
                    }
                    // On Android below R, the android.permission.MANAGE_EXTERNAL_STORAGE flag in AndroidManifest.xml
                    // may be ignored and not visible to the App as it's a new permission setting as a whole.
                    if (permission == PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE && Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                        requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_RESTRICTED);
                    } else {
                        requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_DENIED);
                    }
                }

                continue;
            }

            // Request special permissions.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                launchSpecialPermission(
                    Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                    PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && permission == PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE) {
                launchSpecialPermission(
                    Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                    PermissionConstants.PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW) {
                launchSpecialPermission(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    PermissionConstants.PERMISSION_CODE_SYSTEM_ALERT_WINDOW);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && permission == PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES) {
                launchSpecialPermission(
                    Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                    PermissionConstants.PERMISSION_CODE_REQUEST_INSTALL_PACKAGES);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY) {
                launchSpecialPermission(
                    Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS,
                    PermissionConstants.PERMISSION_CODE_ACCESS_NOTIFICATION_POLICY);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && permission == PermissionConstants.PERMISSION_GROUP_SCHEDULE_EXACT_ALARM) {
                launchSpecialPermission(
                    Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                    PermissionConstants.PERMISSION_CODE_SCHEDULE_EXACT_ALARM);
            } else if (permission == PermissionConstants.PERMISSION_GROUP_CALENDAR_FULL_ACCESS || permission == PermissionConstants.PERMISSION_GROUP_CALENDAR) {
                // Deny CALENDAR_FULL_ACCESS permission if manifest is not listing both write- and read permissions.
                final boolean isValidManifest = isValidManifestForCalendarFullAccess();
                if (isValidManifest) {
                    permissionsToRequest.add(Manifest.permission.WRITE_CALENDAR);
                    permissionsToRequest.add(Manifest.permission.READ_CALENDAR);
                    pendingRequestCount += 2;
                } else {
                    requestResults.put(permission, PermissionConstants.PERMISSION_STATUS_DENIED);
                }
            } else {
                permissionsToRequest.addAll(names);
                pendingRequestCount += names.size();
            }
        }

        // Request runtime permissions.
        if (permissionsToRequest.size() > 0) {
            final String[] requestPermissions = permissionsToRequest.toArray(new String[0]);
            ActivityCompat.requestPermissions(
                activity,
                requestPermissions,
                PermissionConstants.PERMISSION_CODE);
        }

        // Post results immediately if no requests are pending.
        if (this.successCallback != null && pendingRequestCount == 0) {
            this.successCallback.onSuccess(requestResults);
        }
    }

    @PermissionConstants.PermissionStatus
    private int determinePermissionStatus(final @PermissionConstants.PermissionGroup int permission) {

        if (permission == PermissionConstants.PERMISSION_GROUP_NOTIFICATION) {
            return checkNotificationPermissionStatus();
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH) {
            return checkBluetoothPermissionStatus();
        }

        if (permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH_CONNECT
            || permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH_SCAN
            || permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH_ADVERTISE) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                return checkBluetoothPermissionStatus();
            }
        }

        // Inspect the manifest for CALENDAR_FULL_ACCESS, as a misconfigured manifest will give a false positive if READ access has been provided.
        if (permission == PermissionConstants.PERMISSION_GROUP_CALENDAR_FULL_ACCESS || permission == PermissionConstants.PERMISSION_GROUP_CALENDAR) {
            boolean isValidManifest = isValidManifestForCalendarFullAccess();
            if (!isValidManifest)
                return PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        final List<String> names = PermissionUtils.getManifestNames(context, permission);

        if (names == null) {
            Log.d(PermissionConstants.LOG_TAG, "No android specific permissions needed for: " + permission);

            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }

        //if no permissions were found then there is an issue and permission is not set in Android manifest
        if (names.size() == 0) {
            Log.d(PermissionConstants.LOG_TAG, "No permissions found in manifest for: " + names + permission);

            // On Android below M, the android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS flag in AndroidManifest.xml
            // may be ignored and not visible to the App as it's a new permission setting as a whole.
            if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                    return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
                }
            }

            // On Android below R, the android.permission.MANAGE_EXTERNAL_STORAGE flag in AndroidManifest.xml
            // may be ignored and not visible to the App as it's a new permission setting as a whole.
            if (permission == PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE) {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                    return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
                }
            }

            return Build.VERSION.SDK_INT < Build.VERSION_CODES.M
                ? PermissionConstants.PERMISSION_STATUS_GRANTED
                : PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        final boolean requiresExplicitPermission = context.getApplicationInfo().targetSdkVersion >= Build.VERSION_CODES.M;

        if (requiresExplicitPermission) {
            final Set<@PermissionConstants.PermissionStatus Integer> permissionStatuses = new HashSet<>();

            for (String name : names) {
                if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                    String packageName = context.getPackageName();
                    PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                    if (pm != null && pm.isIgnoringBatteryOptimizations(packageName)) {
                        permissionStatuses.add(PermissionConstants.PERMISSION_STATUS_GRANTED);
                    } else {
                        permissionStatuses.add(PermissionConstants.PERMISSION_STATUS_DENIED);
                    }
                } else if (permission == PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE) {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                        permissionStatuses.add(PermissionConstants.PERMISSION_STATUS_RESTRICTED);
                    }

                    int status = Environment.isExternalStorageManager()
                        ? PermissionConstants.PERMISSION_STATUS_GRANTED
                        : PermissionConstants.PERMISSION_STATUS_DENIED;
                    permissionStatuses.add(status);
                } else if (permission == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW) {
                    int status = Settings.canDrawOverlays(context)
                        ? PermissionConstants.PERMISSION_STATUS_GRANTED
                        : PermissionConstants.PERMISSION_STATUS_DENIED;
                    permissionStatuses.add(status);
                } else if (permission == PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        int status = context.getPackageManager().canRequestPackageInstalls()
                            ? PermissionConstants.PERMISSION_STATUS_GRANTED
                            : PermissionConstants.PERMISSION_STATUS_DENIED;
                        permissionStatuses.add(status);
                    }
                } else if (permission == PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY) {
                    NotificationManager notificationManager = (NotificationManager) context.getSystemService(Application.NOTIFICATION_SERVICE);
                    int status = notificationManager.isNotificationPolicyAccessGranted()
                        ? PermissionConstants.PERMISSION_STATUS_GRANTED
                        : PermissionConstants.PERMISSION_STATUS_DENIED;
                    permissionStatuses.add(status);
                } else if (permission == PermissionConstants.PERMISSION_GROUP_SCHEDULE_EXACT_ALARM) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
                        int status = alarmManager.canScheduleExactAlarms()
                            ? PermissionConstants.PERMISSION_STATUS_GRANTED
                            : PermissionConstants.PERMISSION_STATUS_DENIED;
                        permissionStatuses.add(status);
                    } else {
                        permissionStatuses.add(PermissionConstants.PERMISSION_STATUS_GRANTED);
                    }
                } else if (permission ==  PermissionConstants.PERMISSION_GROUP_PHOTOS || permission ==  PermissionConstants.PERMISSION_GROUP_VIDEOS){
                    final int permissionStatus = ContextCompat.checkSelfPermission(context, name);
                    int permissionStatusLimited = permissionStatus;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        permissionStatusLimited = ContextCompat.checkSelfPermission(context, Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED);
                    }
                    if (permissionStatusLimited == PackageManager.PERMISSION_GRANTED && permissionStatus == PackageManager.PERMISSION_DENIED) {
                        permissionStatuses.add(PermissionConstants.PERMISSION_STATUS_LIMITED);
                    } else if (permissionStatus == PackageManager.PERMISSION_GRANTED) {
                        permissionStatuses.add(PermissionConstants.PERMISSION_STATUS_GRANTED);
                    }else {
                        permissionStatuses.add(PermissionUtils.determineDeniedVariant(activity, name));
                    }
                }else {
                    final int permissionStatus = ContextCompat.checkSelfPermission(context, name);
                    if (permissionStatus != PackageManager.PERMISSION_GRANTED) {
                        permissionStatuses.add(PermissionUtils.determineDeniedVariant(activity, name));
                    }
                }
            }
            if (!permissionStatuses.isEmpty()) {
                return strictestStatus(permissionStatuses);
            }
        }

        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    /**
     * Launches a request for a <a href="https://developer.android.com/training/permissions/requesting-special">special permission</a>.
     * <p>
     * There is a special case for {@link Settings#ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS}. See
     * <a href="https://github.com/Baseflow/flutter-permission-handler/pull/587#discussion_r649295489">this comment</a>
     * for more details.
     *
     * @param permissionAction the action for launching the settings page for a particular permission.
     * @param requestCode      a request code to verify incoming results.
     */
    private void launchSpecialPermission(String permissionAction, int requestCode) {
        if (activity == null) {
            return;
        }

        Intent intent = new Intent(permissionAction);
        if (!permissionAction.equals(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)) {
            String packageName = activity.getPackageName();
            intent.setData(Uri.parse("package:" + packageName));
        }
        activity.startActivityForResult(intent, requestCode);
        pendingRequestCount++;
    }

    void shouldShowRequestPermissionRationale(
        int permission,
        ShouldShowRequestPermissionRationaleSuccessCallback successCallback,
        ErrorCallback errorCallback) {
        if (activity == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity.");

            errorCallback.onError(
                "PermissionHandler.PermissionManager",
                "Unable to detect current Android Activity.");
            return;
        }

        List<String> names = PermissionUtils.getManifestNames(activity, permission);

        // if isn't an android specific group then go ahead and return false;
        if (names == null) {
            Log.d(PermissionConstants.LOG_TAG, "No android specific permissions needed for: " + permission);
            successCallback.onSuccess(false);
            return;
        }

        if (names.isEmpty()) {
            Log.d(PermissionConstants.LOG_TAG, "No permissions found in manifest for: " + permission + " no need to show request rationale");
            successCallback.onSuccess(false);
            return;
        }

        successCallback.onSuccess(ActivityCompat.shouldShowRequestPermissionRationale(activity, names.get(0)));
    }

    @PermissionConstants.PermissionStatus
    private int checkNotificationPermissionStatus() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            NotificationManagerCompat manager = NotificationManagerCompat.from(context);
            final boolean isGranted = manager.areNotificationsEnabled();
            if (isGranted) {
                return PermissionConstants.PERMISSION_STATUS_GRANTED;
            }
            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        final int status = context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS);
        if (status == PackageManager.PERMISSION_GRANTED) {
            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }
        return PermissionUtils.determineDeniedVariant(activity, Manifest.permission.POST_NOTIFICATIONS);
    }

    @PermissionConstants.PermissionStatus
    private int checkBluetoothPermissionStatus() {
        List<String> names = PermissionUtils.getManifestNames(context, PermissionConstants.PERMISSION_GROUP_BLUETOOTH);
        boolean missingInManifest = names == null || names.isEmpty();
        if (missingInManifest) {
            Log.d(PermissionConstants.LOG_TAG, "Bluetooth permission missing in manifest");
            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }
        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    /**
     * Checks if the manifest contains both {@link Manifest.permission#WRITE_CALENDAR} and
     * {@link Manifest.permission#READ_CALENDAR} permission declarations.
     */
    private boolean isValidManifestForCalendarFullAccess() {
        List<String> names = PermissionUtils.getManifestNames(context, PermissionConstants.PERMISSION_GROUP_CALENDAR_FULL_ACCESS);
        final boolean writeInManifest = names != null && names.contains(Manifest.permission.WRITE_CALENDAR);
        final boolean readInManifest = names != null && names.contains(Manifest.permission.READ_CALENDAR);
        final boolean validManifest = writeInManifest && readInManifest;
        if (!validManifest) {
            if (!writeInManifest)
                Log.d(PermissionConstants.LOG_TAG, Manifest.permission.WRITE_CALENDAR + " missing in manifest");
            if (!readInManifest)
                Log.d(PermissionConstants.LOG_TAG, Manifest.permission.READ_CALENDAR + " missing in manifest");
            return false;
        }
        return true;
    }

    @FunctionalInterface
    interface RequestPermissionsSuccessCallback {
        void onSuccess(Map<Integer, Integer> results);
    }

    @FunctionalInterface
    interface CheckPermissionsSuccessCallback {
        void onSuccess(@PermissionConstants.PermissionStatus int permissionStatus);
    }

    @FunctionalInterface
    interface ShouldShowRequestPermissionRationaleSuccessCallback {
        void onSuccess(boolean shouldShowRequestPermissionRationale);
    }
}
