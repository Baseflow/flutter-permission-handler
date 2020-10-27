package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.permissionhandler.PermissionManager.ActivityRegistry;
import com.baseflow.permissionhandler.PermissionManager.PermissionRegistry;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

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

    private MethodChannel methodChannel;
//    private final RequestPermissionsListener permissionManager;
    private final PermissionManagerResult activityResultManager;

    @Nullable
    private Registrar pluginRegistrar;

    @Nullable
    private MethodCallHandlerImpl methodCallHandler;

    @Nullable
    private ActivityPluginBinding pluginBinding;

    public PermissionHandlerPlugin() {
//        this.permissionManager = new RequestPermissionsListener();
        this.activityResultManager = new PermissionManagerResult(new PermissionManager.RequestPermissionsSuccessCallback() {
            @Override
            public void onSuccess(Map<Integer, Integer> results) {
                //handle response here for successfully granted permission
            }
        });
    }

    /**
     * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
     * package.
     *
     * <p>Calling this automatically initializes the plugin. However plugins initialized this way
     * won't react to changes in activity or context, unlike {@link PermissionHandlerPlugin}.
     */
    public static void registerWith(Registrar registrar) {
        final PermissionHandlerPlugin plugin = new PermissionHandlerPlugin();
        plugin.pluginRegistrar = registrar;
        plugin.registerListeners();

        plugin.startListening(registrar.context(), registrar.messenger());

        if (registrar.activeContext() instanceof Activity) {
            plugin.startListeningToActivity(
                registrar.activity(),
                registrar::addActivityResultListener,
                registrar::addRequestPermissionsResultListener
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
            binding.getActivity(), 
            binding::addActivityResultListener,
            binding::addRequestPermissionsResultListener);
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
            new PermissionManager(),
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
        Activity activity,
        ActivityRegistry activityRegistry,
        PermissionRegistry permissionRegistry
    ) {
        if (methodCallHandler != null) {
            methodCallHandler.setActivity(activity);
            methodCallHandler.setActivityRegistry(activityRegistry);
            methodCallHandler.setPermissionRegistry(permissionRegistry);
        }
    }

    private void stopListeningToActivity() {
        if (methodCallHandler != null) {
            methodCallHandler.setActivity(null);
            methodCallHandler.setActivityRegistry(null);
            methodCallHandler.setPermissionRegistry(null);
        }
    }

    private void registerListeners() {
        if (this.pluginRegistrar != null) {
            this.pluginRegistrar.addActivityResultListener(this.activityResultManager);
        } else if (pluginBinding != null) {
            this.pluginBinding.addActivityResultListener(this.activityResultManager);
        }
    }

    private void deregisterListeners() {
        if (this.pluginBinding != null) {
            this.pluginBinding.removeActivityResultListener(this.activityResultManager);
        }
    }
}
