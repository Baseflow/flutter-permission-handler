package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/**
 * Platform implementation of the permission_handler Flutter plugin.
 *
 * <p>Instantiate this in an add-to-app scenario to gracefully handle activity and context changes.
 * See {@code com.example.permissionhandlerexample.MainActivity} for an example.
 */
public final class PermissionHandlerPlugin implements FlutterPlugin, ActivityAware {

    private PermissionManager permissionManager;

    private MethodChannel methodChannel;

    @Nullable private ActivityPluginBinding pluginBinding;

    @Nullable
    private MethodCallHandlerImpl methodCallHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.permissionManager = new PermissionManager(binding.getApplicationContext());

        startListening(
            binding.getApplicationContext(),
            binding.getBinaryMessenger()
        );
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        stopListening();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        startListeningToActivity(
            binding.getActivity()
        );

        pluginBinding = binding;
        registerListeners();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        stopListeningToActivity();
        deregisterListeners();
        pluginBinding = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }


    private void startListening(Context applicationContext, BinaryMessenger messenger) {
        methodChannel = new MethodChannel(
            messenger,
            "flutter.baseflow.com/permissions/methods");

        methodCallHandler = new MethodCallHandlerImpl(
            applicationContext,
            new AppSettingsManager(),
            this.permissionManager,
            new ServiceManager()
        );

        methodChannel.setMethodCallHandler(methodCallHandler);
    }

    private void stopListening() {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
        methodCallHandler = null;
    }

    private void startListeningToActivity(
        Activity activity
    ) {
        if (permissionManager != null) {
            permissionManager.setActivity(activity);
        }
    }

    private void stopListeningToActivity() {
        if (permissionManager != null) {
            permissionManager.setActivity(null);
        }
    }

    private void registerListeners() {
        if (pluginBinding != null) {
            this.pluginBinding.addActivityResultListener(this.permissionManager);
            this.pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
        }
    }

    private void deregisterListeners() {
        if (this.pluginBinding != null) {
            this.pluginBinding.removeActivityResultListener(this.permissionManager);
            this.pluginBinding.removeRequestPermissionsResultListener(this.permissionManager);
        }
    }
}
