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
import com.baseflow.permissionhandler.PermissionHandlerPigeon.EnvironmentHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.IntentHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.NotificationManagerHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PackageInfoFlagsHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PackageInfoHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ResolveInfoFlagsHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ComponentInfoFlagsHostApi;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ApplicationInfoFlagsHostApi;
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

        final UriFlutterApiImpl uriFlutterApi = new UriFlutterApiImpl(binaryMessenger, instanceManager);
        final UriHostApi uriHostApi = new UriHostApiImpl(uriFlutterApi, binaryMessenger, instanceManager);
        UriHostApi.setup(binaryMessenger, uriHostApi);

        final IntentHostApi intentHostApi = new IntentHostApiImpl(binaryMessenger, instanceManager);
        IntentHostApi.setup(binaryMessenger, intentHostApi);

        final PowerManagerFlutterApiImpl powerManagerFlutterApi = new PowerManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final PowerManagerHostApi powerManagerHostApi = new PowerManagerHostApiImpl(binaryMessenger, instanceManager);
        PowerManagerHostApi.setup(binaryMessenger, powerManagerHostApi);

        final AlarmManagerFlutterApiImpl alarmManagerFlutterApi = new AlarmManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final AlarmManagerHostApi alarmManagerHostApi = new AlarmManagerHostApiImpl(binaryMessenger, instanceManager);
        AlarmManagerHostApi.setup(binaryMessenger, alarmManagerHostApi);

        final PackageInfoFlagsFlutterApiImpl packageInfoFlagsFlutterApi = new PackageInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageInfoFlagsHostApi packageInfoFlagsHostApi = new PackageInfoFlagsHostApiImpl(packageInfoFlagsFlutterApi, binaryMessenger, instanceManager);
        PackageInfoFlagsHostApi.setup(binaryMessenger, packageInfoFlagsHostApi);

        final ResolveInfoFlagsFlutterApiImpl resolveInfoFlagsFlutterApi = new ResolveInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final ResolveInfoFlagsHostApi resolveInfoFlagsHostApi = new ResolveInfoFlagsHostApiImpl(resolveInfoFlagsFlutterApi, binaryMessenger, instanceManager);
        ResolveInfoFlagsHostApi.setup(binaryMessenger, resolveInfoFlagsHostApi);

        final ResolveInfoFlutterApiImpl resolveInfoFlutterApi = new ResolveInfoFlutterApiImpl(binaryMessenger, instanceManager);

        final ComponentInfoFlagsFlutterApiImpl componentInfoFlagsFlutterApi = new ComponentInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final ComponentInfoFlagsHostApi componentInfoFlagsHostApi = new ComponentInfoFlagsHostApiImpl(componentInfoFlagsFlutterApi, binaryMessenger, instanceManager);
        ComponentInfoFlagsHostApi.setup(binaryMessenger, componentInfoFlagsHostApi);

        final ApplicationInfoFlagsFlutterApiImpl applicationInfoFlagsFlutterApi = new ApplicationInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final ApplicationInfoFlagsHostApi applicationInfoFlagsHostApi = new ApplicationInfoFlagsHostApiImpl(applicationInfoFlagsFlutterApi, binaryMessenger, instanceManager);
        ApplicationInfoFlagsHostApi.setup(binaryMessenger, applicationInfoFlagsHostApi);

        final PackageInfoFlutterApiImpl packageInfoFlutterApi = new PackageInfoFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageInfoHostApi packageInfoHostApi = new PackageInfoHostApiImpl(binaryMessenger, instanceManager);
        PackageInfoHostApi.setup(binaryMessenger, packageInfoHostApi);

        final FeatureInfoFlutterApiImpl featureInfoFlutterApi = new FeatureInfoFlutterApiImpl(binaryMessenger, instanceManager);

        final PackageManagerFlutterApiImpl packageManagerFlutterApi = new PackageManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageManagerHostApi packageManagerHostApi = new PackageManagerHostApiImpl(
            packageInfoFlutterApi,
            resolveInfoFlutterApi,
            featureInfoFlutterApi,
            binaryMessenger,
            instanceManager
        );
        PackageManagerHostApi.setup(binaryMessenger, packageManagerHostApi);

        final SettingsHostApi settingsHostApi = new SettingsHostApiImpl(binaryMessenger, instanceManager);
        SettingsHostApi.setup(binaryMessenger, settingsHostApi);

        final NotificationManagerFlutterApiImpl notificationManagerFlutterApi = new NotificationManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final NotificationManagerHostApi notificationManagerHostApi = new NotificationManagerHostApiImpl(binaryMessenger, instanceManager);
        NotificationManagerHostApi.setup(binaryMessenger, notificationManagerHostApi);

        final EnvironmentHostApi environmentHostApi = new EnvironmentHostApiImpl(binaryMessenger, instanceManager);
        EnvironmentHostApi.setup(binaryMessenger, environmentHostApi);

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
            notificationManagerFlutterApi,
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
