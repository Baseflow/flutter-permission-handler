package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import com.baseflow.permissionhandler.PermissionManager.ActivityRegistry;
import com.baseflow.permissionhandler.PermissionManager.PermissionRegistry;

import java.util.List;

final class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private final Context applicationContext;
    private final Activity activity;
    private final AppSettingsManager appSettingsManager;
    private final PermissionManager permissionManager;
    private final ServiceManager serviceManager;
    private final ActivityRegistry activityRegistry;
    private final PermissionRegistry permissionRegistry;
    private final MethodChannel methodChannel;

    MethodCallHandlerImpl(
            Context applicationContext,
            Activity activity,
            BinaryMessenger messenger,
            AppSettingsManager appSettingsManager,
            PermissionManager permissionManager,
            ServiceManager serviceManager,
            ActivityRegistry activityRegistry,
            PermissionRegistry permissionRegistry) {
        this.applicationContext = applicationContext;
        this.activity = activity;
        this.appSettingsManager = appSettingsManager;
        this.permissionManager = permissionManager;
        this.serviceManager = serviceManager;
        this.activityRegistry = activityRegistry;
        this.permissionRegistry = permissionRegistry;

        methodChannel = new MethodChannel(
                messenger,
                "flutter.baseflow.com/permissions/methods");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result)
    {
        switch (call.method) {
            case "checkPermissionStatus": {
                @PermissionConstants.PermissionGroup final int permission = (int) call.arguments;
                @PermissionConstants.PermissionStatus final int permissionStatus =
                        permissionManager.checkPermissionStatus(
                                permission,
                                activity);

                result.success(permissionStatus);
                break;
            }
            case "checkServiceStatus": {
                @PermissionConstants.PermissionGroup final int permission = (int) call.arguments;
                @PermissionConstants.ServiceStatus final int serviceStatus =
                        serviceManager.checkServiceStatus(
                                permission,
                                activity);

                result.success(serviceStatus);
                break;
            }
            case "requestPermissions":
                final List<Integer> permissions = call.arguments();
                permissionManager.requestPermissions(
                        permissions,
                        activity,
                        activityRegistry,
                        permissionRegistry,
                        result::success,
                        (String errorCode, String errorDiscription) -> {
                            result.error(errorCode, errorDiscription, null);
                        });

                break;
            case "shouldShowRequestPermissionRationale": {
                @PermissionConstants.PermissionGroup final int permission = (int) call.arguments;
                final boolean showRationale = permissionManager
                        .shouldShowRequestPermissionRationale(permission, activity);
                result.success(showRationale);
                break;
            }
            case "openAppSettings":
                boolean isOpen = appSettingsManager.openAppSettings(applicationContext);
                result.success(isOpen);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    void stopListening() {
        methodChannel.setMethodCallHandler(null);
    }
}
