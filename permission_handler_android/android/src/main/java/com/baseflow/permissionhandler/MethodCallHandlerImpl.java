package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

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

    public void setActivity(@Nullable Activity activity) {
      this.activity = activity;
    }

  @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result)
    {
        switch (call.method) {
            case "checkServiceStatus": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
                serviceManager.checkServiceStatus(
                        permission,
                        applicationContext,
                        result::success,
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));

                break;
            }
            case "checkPermissionStatus": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
                permissionManager.checkPermissionStatus(
                        permission,
                        applicationContext,
                        result::success);
                break;
            }
            case "requestPermissions":
                final List<Integer> permissions = call.arguments();
                permissionManager.requestPermissions(
                        permissions,
                        activity,
                        result::success,
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));

                break;
            case "shouldShowRequestPermissionRationale": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
                permissionManager.shouldShowRequestPermissionRationale(
                        permission,
                        activity,
                        result::success,
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));

                break;
            }
            case "openAppSettings":
                appSettingsManager.openAppSettings(
                        applicationContext,
                        result::success,
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));

                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
