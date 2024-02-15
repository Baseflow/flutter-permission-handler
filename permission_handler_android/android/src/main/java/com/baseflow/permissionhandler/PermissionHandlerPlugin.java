package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.instancemanager.InstanceManagerPigeon.JavaObjectHostApi;
import com.baseflow.instancemanager.InstanceManagerPigeon.InstanceManagerHostApi;
import com.baseflow.instancemanager.JavaObjectHostApiImpl;
import com.baseflow.permissionhandler.next.ActivityFlutterApiImpl;
import com.baseflow.permissionhandler.next.ActivityHostApiImpl;
import com.baseflow.permissionhandler.next.AlarmManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.AlarmManagerHostApiImpl;
import com.baseflow.permissionhandler.next.ApplicationInfoFlagsFlutterApiImpl;
import com.baseflow.permissionhandler.next.ApplicationInfoFlagsHostApiImpl;
import com.baseflow.permissionhandler.next.BluetoothAdapterFlutterApiImpl;
import com.baseflow.permissionhandler.next.BluetoothAdapterHostApiImpl;
import com.baseflow.permissionhandler.next.BluetoothManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.BluetoothManagerHostApiImpl;
import com.baseflow.permissionhandler.next.BuildVersionHostApiImpl;
import com.baseflow.permissionhandler.next.ComponentInfoFlagsFlutterApiImpl;
import com.baseflow.permissionhandler.next.ComponentInfoFlagsHostApiImpl;
import com.baseflow.permissionhandler.next.ContentResolverFlutterApiImpl;
import com.baseflow.permissionhandler.next.ContextFlutterApiImpl;
import com.baseflow.permissionhandler.next.ContextHostApiImpl;
import com.baseflow.permissionhandler.next.EnvironmentHostApiImpl;
import com.baseflow.permissionhandler.next.FeatureInfoFlutterApiImpl;
import com.baseflow.permissionhandler.next.IntentHostApiImpl;
import com.baseflow.permissionhandler.next.LocationManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.LocationManagerHostApiImpl;
import com.baseflow.permissionhandler.next.NotificationManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.NotificationManagerHostApiImpl;
import com.baseflow.permissionhandler.next.PackageInfoFlagsFlutterApiImpl;
import com.baseflow.permissionhandler.next.PackageInfoFlagsHostApiImpl;
import com.baseflow.permissionhandler.next.PackageInfoFlutterApiImpl;
import com.baseflow.permissionhandler.next.PackageInfoHostApiImpl;
import com.baseflow.permissionhandler.next.PackageManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.PackageManagerHostApiImpl;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ActivityHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.AlarmManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.BuildVersionHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.BluetoothAdapterHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.BluetoothManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ContextHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.EnvironmentHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.IntentHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.LocationManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.NotificationManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PackageInfoFlagsHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PackageInfoHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ResolveInfoFlagsHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ComponentInfoFlagsHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ApplicationInfoFlagsHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PackageManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.PowerManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.SettingsHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.SettingsSecureHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.TelephonyManagerHostApi;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.UriHostApi;
import com.baseflow.permissionhandler.next.PowerManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.PowerManagerHostApiImpl;
import com.baseflow.permissionhandler.next.ResolveInfoFlagsFlutterApiImpl;
import com.baseflow.permissionhandler.next.ResolveInfoFlagsHostApiImpl;
import com.baseflow.permissionhandler.next.ResolveInfoFlutterApiImpl;
import com.baseflow.permissionhandler.next.SettingsHostApiImpl;
import com.baseflow.permissionhandler.next.SettingsSecureHostApiImpl;
import com.baseflow.permissionhandler.next.TelephonyManagerFlutterApiImpl;
import com.baseflow.permissionhandler.next.TelephonyManagerHostApiImpl;
import com.baseflow.permissionhandler.next.UriFlutterApiImpl;
import com.baseflow.permissionhandler.next.UriHostApiImpl;

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
        final UriHostApi uriHostApi = new UriHostApiImpl(uriFlutterApi, instanceManager);
        UriHostApi.setup(binaryMessenger, uriHostApi);

        final IntentHostApi intentHostApi = new IntentHostApiImpl(instanceManager);
        IntentHostApi.setup(binaryMessenger, intentHostApi);

        final PowerManagerFlutterApiImpl powerManagerFlutterApi = new PowerManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final PowerManagerHostApi powerManagerHostApi = new PowerManagerHostApiImpl(instanceManager);
        PowerManagerHostApi.setup(binaryMessenger, powerManagerHostApi);

        final AlarmManagerFlutterApiImpl alarmManagerFlutterApi = new AlarmManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final AlarmManagerHostApi alarmManagerHostApi = new AlarmManagerHostApiImpl(instanceManager);
        AlarmManagerHostApi.setup(binaryMessenger, alarmManagerHostApi);

        final PackageInfoFlagsFlutterApiImpl packageInfoFlagsFlutterApi = new PackageInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageInfoFlagsHostApi packageInfoFlagsHostApi = new PackageInfoFlagsHostApiImpl(packageInfoFlagsFlutterApi, instanceManager);
        PackageInfoFlagsHostApi.setup(binaryMessenger, packageInfoFlagsHostApi);

        final ResolveInfoFlagsFlutterApiImpl resolveInfoFlagsFlutterApi = new ResolveInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final ResolveInfoFlagsHostApi resolveInfoFlagsHostApi = new ResolveInfoFlagsHostApiImpl(resolveInfoFlagsFlutterApi, instanceManager);
        ResolveInfoFlagsHostApi.setup(binaryMessenger, resolveInfoFlagsHostApi);

        final ResolveInfoFlutterApiImpl resolveInfoFlutterApi = new ResolveInfoFlutterApiImpl(binaryMessenger, instanceManager);

        final ComponentInfoFlagsFlutterApiImpl componentInfoFlagsFlutterApi = new ComponentInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final ComponentInfoFlagsHostApi componentInfoFlagsHostApi = new ComponentInfoFlagsHostApiImpl(componentInfoFlagsFlutterApi, instanceManager);
        ComponentInfoFlagsHostApi.setup(binaryMessenger, componentInfoFlagsHostApi);

        final ApplicationInfoFlagsFlutterApiImpl applicationInfoFlagsFlutterApi = new ApplicationInfoFlagsFlutterApiImpl(binaryMessenger, instanceManager);
        final ApplicationInfoFlagsHostApi applicationInfoFlagsHostApi = new ApplicationInfoFlagsHostApiImpl(applicationInfoFlagsFlutterApi, instanceManager);
        ApplicationInfoFlagsHostApi.setup(binaryMessenger, applicationInfoFlagsHostApi);

        final PackageInfoFlutterApiImpl packageInfoFlutterApi = new PackageInfoFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageInfoHostApi packageInfoHostApi = new PackageInfoHostApiImpl(instanceManager);
        PackageInfoHostApi.setup(binaryMessenger, packageInfoHostApi);

        final FeatureInfoFlutterApiImpl featureInfoFlutterApi = new FeatureInfoFlutterApiImpl(binaryMessenger, instanceManager);
        
        final PackageManagerFlutterApiImpl packageManagerFlutterApi = new PackageManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final PackageManagerHostApi packageManagerHostApi = new PackageManagerHostApiImpl(
            packageInfoFlutterApi,
            resolveInfoFlutterApi,
            featureInfoFlutterApi,
            instanceManager
        );
        PackageManagerHostApi.setup(binaryMessenger, packageManagerHostApi);

        final SettingsHostApi settingsHostApi = new SettingsHostApiImpl(instanceManager);
        SettingsHostApi.setup(binaryMessenger, settingsHostApi);

        final SettingsSecureHostApiImpl settingsSecureHostApi = new SettingsSecureHostApiImpl(instanceManager);
        SettingsSecureHostApi.setup(binaryMessenger, settingsSecureHostApi);

        final NotificationManagerFlutterApiImpl notificationManagerFlutterApi = new NotificationManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final NotificationManagerHostApi notificationManagerHostApi = new NotificationManagerHostApiImpl(instanceManager);
        NotificationManagerHostApi.setup(binaryMessenger, notificationManagerHostApi);

        final EnvironmentHostApi environmentHostApi = new EnvironmentHostApiImpl(instanceManager);
        EnvironmentHostApi.setup(binaryMessenger, environmentHostApi);

        final TelephonyManagerFlutterApiImpl telephonyManagerFlutterApi = new TelephonyManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final TelephonyManagerHostApi telephonyManagerHostApi = new TelephonyManagerHostApiImpl(instanceManager);
        TelephonyManagerHostApi.setup(binaryMessenger, telephonyManagerHostApi);

        final LocationManagerFlutterApiImpl locationManagerFlutterApi = new LocationManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final LocationManagerHostApi locationManagerHostApi = new LocationManagerHostApiImpl(instanceManager);
        LocationManagerHostApi.setup(binaryMessenger, locationManagerHostApi);

        final BluetoothAdapterFlutterApiImpl bluetoothAdapterFlutterApi = new BluetoothAdapterFlutterApiImpl(binaryMessenger, instanceManager);
        final BluetoothAdapterHostApi bluetoothAdapterHostApi = new BluetoothAdapterHostApiImpl(bluetoothAdapterFlutterApi, instanceManager);
        BluetoothAdapterHostApi.setup(binaryMessenger, bluetoothAdapterHostApi);

        final BluetoothManagerFlutterApiImpl bluetoothManagerFlutterApi = new BluetoothManagerFlutterApiImpl(binaryMessenger, instanceManager);
        final BluetoothManagerHostApi bluetoothManagerHostApi = new BluetoothManagerHostApiImpl(bluetoothAdapterFlutterApi, instanceManager);
        BluetoothManagerHostApi.setup(binaryMessenger, bluetoothManagerHostApi);

        final ContentResolverFlutterApiImpl contentResolverFlutterApi = new ContentResolverFlutterApiImpl(binaryMessenger, instanceManager);

        activityFlutterApi = new ActivityFlutterApiImpl(binaryMessenger, instanceManager);
        activityHostApi = new ActivityHostApiImpl(instanceManager);
        ActivityHostApi.setup(binaryMessenger, activityHostApi);

        contextFlutterApi = new ContextFlutterApiImpl(binaryMessenger, instanceManager);
        final ContextHostApiImpl contextHostApi = new ContextHostApiImpl(
            powerManagerFlutterApi,
            alarmManagerFlutterApi,
            packageManagerFlutterApi,
            notificationManagerFlutterApi,
            telephonyManagerFlutterApi,
            locationManagerFlutterApi,
            bluetoothManagerFlutterApi,
            contentResolverFlutterApi,
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
