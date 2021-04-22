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
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 * See {@code com.example.permissionhandlerexample.MainActivity} for an example.
 *
 * <p>Call {@link #registerWith(io.flutter.plugin.common.PluginRegistry.Registrar)} to register an
 * implementation of this that uses the stable {@code io.flutter.plugin.common} package.
 */
public final class PermissionHandlerPlugin implements FlutterPlugin, ActivityAware {

    private final PermissionManager permissionManager;
    private MethodChannel methodChannel;

    @SuppressWarnings("deprecation")
    @Nullable private io.flutter.plugin.common.PluginRegistry.Registrar pluginRegistrar;

    @Nullable private ActivityPluginBinding pluginBinding;

    @Nullable
    private MethodCallHandlerImpl methodCallHandler;

    public PermissionHandlerPlugin() {
        this.permissionManager = new PermissionManager();
    }

    /**
     * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
     * package.
     *
     * <p>Calling this automatically initializes the plugin. However plugins initialized this way
     * won't react to changes in activity or context, unlike {@link PermissionHandlerPlugin}.
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
        final PermissionHandlerPlugin plugin = new PermissionHandlerPlugin();

        plugin.pluginRegistrar = registrar;
        plugin.registerListeners();

        plugin.startListening(registrar.context(), registrar.messenger());

        if (registrar.activeContext() instanceof Activity) {
            plugin.startListeningToActivity(
                registrar.activity()
            );
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
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

        this.pluginBinding = binding;
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
        if (methodCallHandler != null) {
            methodCallHandler.setActivity(activity);
        }
    }

    private void stopListeningToActivity() {
        if (methodCallHandler != null) {
            methodCallHandler.setActivity(null);
        }
    }

    private void registerListeners() {
        if (this.pluginRegistrar != null) {
            this.pluginRegistrar.addActivityResultListener(this.permissionManager);
            this.pluginRegistrar.addRequestPermissionsResultListener(this.permissionManager);
        } else if (pluginBinding != null) {
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
