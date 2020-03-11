package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

import com.baseflow.permissionhandler.PermissionManager.ActivityRegistry;
import com.baseflow.permissionhandler.PermissionManager.PermissionRegistry;

/**
 * Platform implementation of the permission_handler Flutter plugin.
 *
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 * See {@code com.example.permissionhandlerexample.MainActivity} for an example.
 *
 * <p>Call {@link #registerWith(Registrar)} to register an implementation of this that uses the
 * stable {@code io.flutter.plugin.common} package.
 */
public final class PermissionHandlerPlugin implements FlutterPlugin, ActivityAware {
    private @Nullable FlutterPluginBinding flutterPluginBinding;
    private @Nullable MethodCallHandlerImpl methodCallHandler;

    /**
     * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
     * package.
     *
     * <p>Calling this automatically initializes the plugin. However plugins initialized this way
     * won't react to changes in activity or context, unlike {@link PermissionHandlerPlugin}.
     */
    public static void registerWith(Registrar registrar) {
        final PermissionHandlerPlugin permissionHandlerPlugin = new PermissionHandlerPlugin();
        permissionHandlerPlugin.startListening(
                registrar.context(),
                registrar.activity(),
                registrar.messenger(),
                registrar::addActivityResultListener,
                registrar::addRequestPermissionsResultListener
        );
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if(flutterPluginBinding == null) {
            return;
        }

        startListening(
                flutterPluginBinding.getApplicationContext(),
                binding.getActivity(),
                flutterPluginBinding.getBinaryMessenger(),
                binding::addActivityResultListener,
                binding::addRequestPermissionsResultListener);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        if (methodCallHandler == null) {
            return;
        }

        methodCallHandler.stopListening();
        methodCallHandler = null;
    }

    private void startListening(
            Context applicationContext,
            Activity activity,
            BinaryMessenger messenger,
            ActivityRegistry activityRegistry,
            PermissionRegistry permissionRegistry) {
      methodCallHandler = new MethodCallHandlerImpl(
              applicationContext,
              activity,
              messenger,
              new AppSettingsManager(),
              new PermissionManager(),
              new ServiceManager(),
              activityRegistry,
              permissionRegistry);
    }
}
