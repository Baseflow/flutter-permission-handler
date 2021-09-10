package com.baseflow.permissionhandler;

import android.app.Activity;
import android.app.Application;
import android.app.Notification;
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

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

final class PermissionManager implements PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    @Nullable
    private RequestPermissionsSuccessCallback successCallback;

    @Nullable
    private Activity activity;

    private Map<Integer, Integer> requestResults;

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode != PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS &&
                requestCode != PermissionConstants.PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE &&
                requestCode != PermissionConstants.PERMISSION_CODE_SYSTEM_ALERT_WINDOW &&
                requestCode != PermissionConstants.PERMISSION_CODE_REQUEST_INSTALL_PACKAGES &&
                requestCode != PermissionConstants.PERMISSION_CODE_ACCESS_NOTIFICATION_POLICY) {
            return false;
        }

        int status = resultCode == Activity.RESULT_OK
                ? PermissionConstants.PERMISSION_STATUS_GRANTED
                : PermissionConstants.PERMISSION_STATUS_DENIED;

        int permission;

        if (requestCode == PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS) {
            permission = PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS;
        } else if (requestCode == PermissionConstants.PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE) {
            status = Environment.isExternalStorageManager()
                    ? PermissionConstants.PERMISSION_STATUS_GRANTED
                    : PermissionConstants.PERMISSION_STATUS_DENIED;
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
        } else {
            return false;
        }

        HashMap<Integer, Integer> results = new HashMap<>();
        results.put(permission, status);
        successCallback.onSuccess(results);
        return true;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode != PermissionConstants.PERMISSION_CODE) {
            ongoing = false;
            return false;
        }

        if (requestResults == null) {
           return false;
        }

        for (int i = 0; i < permissions.length; i++) {
            final String permissionName = permissions[i];

            @PermissionConstants.PermissionGroup final int permission =
                    PermissionUtils.parseManifestName(permissionName);

            if (permission == PermissionConstants.PERMISSION_GROUP_UNKNOWN)
                continue;

            final int result = grantResults[i];

            if (permission == PermissionConstants.PERMISSION_GROUP_MICROPHONE) {
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
            } else if (!requestResults.containsKey(permission)) {
                requestResults.put(
                        permission,
                        PermissionUtils.toPermissionStatus(this.activity, permissionName, result));
            }

            PermissionUtils.updatePermissionShouldShowStatus(this.activity, permission);
        }

        this.successCallback.onSuccess(requestResults);
        ongoing = false;
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

    private boolean ongoing = false;

    void checkPermissionStatus(
            @PermissionConstants.PermissionGroup int permission,
            Context context,
            CheckPermissionsSuccessCallback successCallback) {

        successCallback.onSuccess(determinePermissionStatus(
                permission,
                context));
    }

    void requestPermissions(
            List<Integer> permissions,
            Activity activity,
            RequestPermissionsSuccessCallback successCallback,
            ErrorCallback errorCallback) {
        if (ongoing) {
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
        this.activity = activity;
        this.requestResults = new HashMap<>();

        ArrayList<String> permissionsToRequest = new ArrayList<>();
        for (Integer permission : permissions) {
            @PermissionConstants.PermissionStatus final int permissionStatus = determinePermissionStatus(permission, activity);
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

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                executeIntent(
                        Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                        PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && permission == PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE) {
                executeIntent(
                        Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                        PermissionConstants.PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW) {
                executeIntent(
                        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        PermissionConstants.PERMISSION_CODE_SYSTEM_ALERT_WINDOW);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && permission == PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES) {
                executeIntent(
                        Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                        PermissionConstants.PERMISSION_CODE_REQUEST_INSTALL_PACKAGES);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && permission == PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY) {
                executeSimpleIntent(
                        Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS,
                        PermissionConstants.PERMISSION_CODE_ACCESS_NOTIFICATION_POLICY);
            } else {
                permissionsToRequest.addAll(names);
            }
        }

        final String[] requestPermissions = permissionsToRequest.toArray(new String[0]);
        if (permissionsToRequest.size() > 0) {
            ongoing = true;

            ActivityCompat.requestPermissions(
                    activity,
                    requestPermissions,
                    PermissionConstants.PERMISSION_CODE);
        } else {
            ongoing = false;
            if (requestResults.size() > 0) {
                successCallback.onSuccess(requestResults);
            }
        }
    }

    @PermissionConstants.PermissionStatus
    private int determinePermissionStatus(
            @PermissionConstants.PermissionGroup int permission,
            Context context) {

        if (permission == PermissionConstants.PERMISSION_GROUP_NOTIFICATION) {
            return checkNotificationPermissionStatus(context);
        }
        if (permission == PermissionConstants.PERMISSION_GROUP_BLUETOOTH) {
            return checkBluetoothPermissionStatus(context);
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

            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }

        final boolean targetsMOrHigher = context.getApplicationInfo().targetSdkVersion >= Build.VERSION_CODES.M;

        for (String name : names) {
            // Only handle them if the client app actually targets a API level greater than M.
            if (targetsMOrHigher) {
                if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                    String packageName = context.getPackageName();
                    PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                    // PowerManager.isIgnoringBatteryOptimizations has been included in Android M first.
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        if (pm != null && pm.isIgnoringBatteryOptimizations(packageName)) {
                            return PermissionConstants.PERMISSION_STATUS_GRANTED;
                        } else {
                            return PermissionConstants.PERMISSION_STATUS_DENIED;
                        }
                    } else {
                        return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
                    }
                }

                if (permission == PermissionConstants.PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE) {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                        return PermissionConstants.PERMISSION_STATUS_RESTRICTED;
                    }

                    return Environment.isExternalStorageManager()
                            ? PermissionConstants.PERMISSION_STATUS_GRANTED
                            : PermissionConstants.PERMISSION_STATUS_DENIED;
                }

                if (permission == PermissionConstants.PERMISSION_GROUP_SYSTEM_ALERT_WINDOW) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        return Settings.canDrawOverlays(context)
                                ? PermissionConstants.PERMISSION_STATUS_GRANTED
                                : PermissionConstants.PERMISSION_STATUS_DENIED;
                    }
                }

                if (permission == PermissionConstants.PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        return context.getPackageManager().canRequestPackageInstalls()
                                ? PermissionConstants.PERMISSION_STATUS_GRANTED
                                : PermissionConstants.PERMISSION_STATUS_DENIED;
                    }
                }

                if (permission == PermissionConstants.PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Application.NOTIFICATION_SERVICE);
                        return notificationManager.isNotificationPolicyAccessGranted()
                                ? PermissionConstants.PERMISSION_STATUS_GRANTED
                                : PermissionConstants.PERMISSION_STATUS_DENIED;
                    }
                }

                final int permissionStatus = ContextCompat.checkSelfPermission(context, name);
                if (permissionStatus != PackageManager.PERMISSION_GRANTED) {
                    return PermissionConstants.PERMISSION_STATUS_DENIED;
                }
            }
        }
        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }

    private void executeIntent(String action, int requestCode) {
        String packageName = activity.getPackageName();
        Intent intent = new Intent();
        intent.setAction(action);
        intent.setData(Uri.parse("package:" + packageName));
        activity.startActivityForResult(intent, requestCode);
    }

    private void executeSimpleIntent(String action, int requestCode) {
        activity.startActivityForResult(new Intent(action), requestCode);
    }

    void shouldShowRequestPermissionRationale(
            int permission,
            Activity activity,
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

    private int checkNotificationPermissionStatus(Context context) {
        NotificationManagerCompat manager = NotificationManagerCompat.from(context);
        boolean isGranted = manager.areNotificationsEnabled();
        if (isGranted) {
            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }
        return PermissionConstants.PERMISSION_STATUS_DENIED;
    }

    private int checkBluetoothPermissionStatus(Context context) {
        List<String> names = PermissionUtils.getManifestNames(context, PermissionConstants.PERMISSION_GROUP_BLUETOOTH);
        boolean missingInManifest = names == null || names.isEmpty();
        if (missingInManifest) {
            Log.d(PermissionConstants.LOG_TAG, "Bluetooth permission missing in manifest");
            return PermissionConstants.PERMISSION_STATUS_DENIED;
        }
        return PermissionConstants.PERMISSION_STATUS_GRANTED;
    }
}
