package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import com.baseflow.permissionhandler.PermissionManager.ActivityRegistry;
import com.baseflow.permissionhandler.PermissionManager.PermissionRegistry;

import java.util.List;

final class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private final Context applicationContext;
    private final AppSettingsManager appSettingsManager;
    private final PermissionManager permissionManager;
    private final ServiceManager serviceManager;

    MethodCallHandlerImpl(
            Context applicationContext,
            AppSettingsManager appSettingsManager,
            PermissionManager permissionManager,
            ServiceManager serviceManager) {
        this.applicationContext = applicationContext;
        this.appSettingsManager = appSettingsManager;
        this.permissionManager = permissionManager;
        this.serviceManager = serviceManager;
    }

    @Nullable
    private Activity activity;

    @Nullable
    private ActivityRegistry activityRegistry;

    @Nullable
    private PermissionRegistry permissionRegistry;

    public void setActivity(@Nullable Activity activity) {
      this.activity = activity;
    }

    public void setActivityRegistry(
        @Nullable ActivityRegistry activityRegistry) {
      this.activityRegistry = activityRegistry;
    }

    public void setPermissionRegistry(
        @Nullable PermissionRegistry permissionRegistry) {
      this.permissionRegistry = permissionRegistry;
    }

  @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result)
    {
        switch (call.method) {
            case "checkPermissionStatus": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
                @PermissionConstants.PermissionStatus final int permissionStatus =
                        permissionManager.checkPermissionStatus(
                                permission,
                                applicationContext,
                                activity);

                result.success(permissionStatus);
                break;
            }
            case "checkServiceStatus": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
                @PermissionConstants.ServiceStatus final int serviceStatus =
                        serviceManager.checkServiceStatus(
                                permission,
                                applicationContext);

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
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));

                break;
            case "shouldShowRequestPermissionRationale": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
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
}
