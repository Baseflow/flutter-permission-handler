package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.instancemanager.InstanceManagerPigeon.JavaObjectHostApi;
import com.baseflow.instancemanager.InstanceManagerPigeon.InstanceManagerHostApi;
import com.baseflow.instancemanager.JavaObjectHostApiImpl;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ActivityHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.AlarmManagerHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.BuildVersionHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ContextHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.IntentHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PackageManagerHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PowerManagerHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.SettingsHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.UriHostApi;

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
    private ActivityHostApiImpl activityHostApi;

    private ContextFlutterApiImpl contextFlutterApi;

    /**
     * The {@link Activity} the {@link io.flutter.embedding.engine.FlutterEngine} is attached to.
     *
     * <p>This activity can be null. For example, when the application is in the background.
     */
    @Nullable private Activity attachedActivity;

    private void setUp(
        BinaryMessenger binaryMessenger
    ) {
        instanceManager = InstanceManager.create(identifier -> {});
        InstanceManagerHostApi.setup(binaryMessenger, () -> {});

        final JavaObjectHostApi javaObjectHostApi = new JavaObjectHostApiImpl(instanceManager);
        JavaObjectHostApi.setup(binaryMessenger, javaObjectHostApi);

        final UriHostApi uriHostApi = new UriHostApiImpl(binaryMessenger, instanceManager);
        UriHostApi.setup(binaryMessenger, uriHostApi);

        final IntentHostApi intentHostApi = new IntentHostApiImpl(binaryMessenger, instanceManager);
        IntentHostApi.setup(binaryMessenger, intentHostApi);

        final PowerManagerFlutterApiImpl powerManagerFlutterApi = new PowerManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final PowerManagerHostApi powerManagerHostApi = new PowerManagerHostApiImpl(binaryMessenger, instanceManager);
        PowerManagerHostApi.setup(binaryMessenger, powerManagerHostApi);

        final AlarmManagerFlutterApiImpl alarmManagerFlutterApi = new AlarmManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final AlarmManagerHostApi alarmManagerHostApi = new AlarmManagerHostApiImpl(binaryMessenger, instanceManager);
        AlarmManagerHostApi.setup(binaryMessenger, alarmManagerHostApi);

        final PackageManagerFlutterApiImpl packageManagerFlutterApi = new PackageManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageManagerHostApi packageManagerHostApi = new PackageManagerHostApiImpl(binaryMessenger, instanceManager);
        PackageManagerHostApi.setup(binaryMessenger, packageManagerHostApi);

        final SettingsHostApi settingsHostApi = new SettingsHostApiImpl(binaryMessenger, instanceManager);
        SettingsHostApi.setup(binaryMessenger, settingsHostApi);

        activityFlutterApi = new ActivityFlutterApiImpl(binaryMessenger, instanceManager);
        activityHostApi = new ActivityHostApiImpl(
            binaryMessenger,
            instanceManager
        );
        ActivityHostApi.setup(binaryMessenger, activityHostApi);

        contextFlutterApi = new ContextFlutterApiImpl(binaryMessenger, instanceManager);
        final ContextHostApiImpl contextHostApi = new ContextHostApiImpl(
            powerManagerFlutterApi,
            alarmManagerFlutterApi,
            packageManagerFlutterApi,
            binaryMessenger,
            instanceManager
        );
        ContextHostApi.setup(binaryMessenger, contextHostApi);

        final BuildVersionHostApi buildVersionHostApi = new BuildVersionHostApiImpl();
        BuildVersionHostApi.setup(binaryMessenger, buildVersionHostApi);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        final BinaryMessenger binaryMessenger = binding.getBinaryMessenger();
        setUp(binaryMessenger);

        final Context applicationContext = binding.getApplicationContext();
        contextFlutterApi.create(applicationContext);
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
        binding.addRequestPermissionsResultListener(activityHostApi);
        binding.addActivityResultListener(activityHostApi);

        attachedActivity = binding.getActivity();
        activityFlutterApi.create(attachedActivity);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        activityFlutterApi.dispose(attachedActivity);
        attachedActivity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }
}
