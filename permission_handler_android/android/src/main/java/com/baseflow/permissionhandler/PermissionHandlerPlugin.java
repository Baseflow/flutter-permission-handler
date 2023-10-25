package com.baseflow.permissionhandler;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.instancemanager.InstanceManagerPigeon.JavaObjectHostApi;
import com.baseflow.instancemanager.InstanceManagerPigeon.InstanceManagerHostApi;
import com.baseflow.instancemanager.JavaObjectHostApiImpl;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ActivityHostApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * Platform implementation of the permission_handler Flutter plugin.
 *
 * <p>Instantiate this in an add-to-app scenario to gracefully handle activity and context changes.
 * See {@code com.example.example.MainActivity} for an example.
 */
public final class PermissionHandlerPlugin implements FlutterPlugin, ActivityAware {
    private InstanceManager instanceManager;

    private ActivityFlutterApiImpl activityFlutterApi;

    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        final BinaryMessenger binaryMessenger = binding.getBinaryMessenger();

        instanceManager = InstanceManager.create(identifier -> {});
        InstanceManagerHostApi.setup(binaryMessenger, () -> {});

        final JavaObjectHostApi javaObjectHostApi = new JavaObjectHostApiImpl(instanceManager);
        JavaObjectHostApi.setup(binaryMessenger, javaObjectHostApi);

        activityFlutterApi = new ActivityFlutterApiImpl(binaryMessenger, instanceManager);

        final ActivityHostApi activityHostApi = new ActivityHostApiImpl(binaryMessenger, instanceManager);
        ActivityHostApi.setup(binaryMessenger, activityHostApi);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (instanceManager != null) {
            instanceManager.stopFinalizationListener();
            instanceManager = null;
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        binding.addRequestPermissionsResultListener(this.activityFlutterApi);
        this.activityFlutterApi.create(this.activity);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        activityFlutterApi.dispose(this.activity);
        this.activity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }
}
