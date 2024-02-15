package com.baseflow.permissionhandler.next;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.bluetooth.BluetoothManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;
import android.os.PowerManager;
import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ContextHostApi;

import java.util.UUID;

/**
 * Host API implementation for `Context`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ContextHostApiImpl implements ContextHostApi {
    private final InstanceManager instanceManager;

    private final PowerManagerFlutterApiImpl powerManagerFlutterApi;

    private final AlarmManagerFlutterApiImpl alarmManagerFlutterApi;

    private final PackageManagerFlutterApiImpl packageManagerFlutterApi;

    private final NotificationManagerFlutterApiImpl notificationManagerFlutterApi;

    private final TelephonyManagerFlutterApiImpl telephonyManagerFlutterApi;

    private final LocationManagerFlutterApiImpl locationManagerFlutterApi;

    private final BluetoothManagerFlutterApiImpl bluetoothManagerFlutterApi;

    private final ContentResolverFlutterApiImpl contentResolverFlutterApi;

    /**
     * Constructs an {@link ContextHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ContextHostApiImpl(
        @NonNull PowerManagerFlutterApiImpl powerManagerFlutterApi,
        @NonNull AlarmManagerFlutterApiImpl alarmManagerFlutterApi,
        @NonNull PackageManagerFlutterApiImpl packageManagerFlutterApi,
        @NonNull NotificationManagerFlutterApiImpl notificationManagerFlutterApi,
        @NonNull TelephonyManagerFlutterApiImpl telephonyManagerFlutterApi,
        @NonNull LocationManagerFlutterApiImpl locationManagerFlutterApi,
        @NonNull BluetoothManagerFlutterApiImpl bluetoothManagerFlutterApi,
        @NonNull ContentResolverFlutterApiImpl contentResolverFlutterApi,
        @NonNull InstanceManager instanceManager
    ) {
        this.powerManagerFlutterApi = powerManagerFlutterApi;
        this.alarmManagerFlutterApi = alarmManagerFlutterApi;
        this.packageManagerFlutterApi = packageManagerFlutterApi;
        this.notificationManagerFlutterApi = notificationManagerFlutterApi;
        this.telephonyManagerFlutterApi = telephonyManagerFlutterApi;
        this.locationManagerFlutterApi = locationManagerFlutterApi;
        this.bluetoothManagerFlutterApi = bluetoothManagerFlutterApi;
        this.contentResolverFlutterApi = contentResolverFlutterApi;
        this.instanceManager = instanceManager;
    }

    @Override
    @NonNull public Long checkSelfPermission(
        @NonNull String instanceId,
        @NonNull String permission
    ) {
        final UUID contextInstanceUuid = UUID.fromString(instanceId);
        final Context context = instanceManager.getInstance(contextInstanceUuid);

        return (long) ContextCompat.checkSelfPermission(context, permission);
    }

    @Override
    public void startActivity(
        @NonNull String instanceId,
        @NonNull String intentInstanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID intentInstanceUuid = UUID.fromString(intentInstanceId);

        final Context context = instanceManager.getInstance(instanceUuid);
        final Intent intent = instanceManager.getInstance(intentInstanceUuid);

        ContextCompat.startActivity(context, intent, null);
    }

    @Override
    @NonNull public String getPackageName(
        @NonNull String instanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Context context = instanceManager.getInstance(instanceUuid);

        return context.getPackageName();
    }

    @Override
    public String getSystemService(
        @NonNull String instanceId,
        @NonNull String name
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Context context = instanceManager.getInstance(instanceUuid);

        final Object systemService = context.getSystemService(name);

        if (systemService instanceof PowerManager) {
            powerManagerFlutterApi.create((PowerManager) systemService);
        } else if (systemService instanceof AlarmManager) {
            alarmManagerFlutterApi.create((AlarmManager) systemService);
        } else if (systemService instanceof NotificationManager) {
            notificationManagerFlutterApi.create((NotificationManager) systemService);
        } else if (systemService instanceof TelephonyManager) {
            telephonyManagerFlutterApi.create((TelephonyManager) systemService);
        } else if (systemService instanceof LocationManager) {
            locationManagerFlutterApi.create((LocationManager) systemService);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            if (systemService instanceof BluetoothManager) {
                bluetoothManagerFlutterApi.create((BluetoothManager) systemService);
            }
        }

        final UUID systemServiceUuid = instanceManager.getIdentifierForStrongReference(systemService);
        
        if (systemServiceUuid == null) {
            return null;
        }
        return systemServiceUuid.toString();
    }

    @Override
    @NonNull public String getPackageManager(
        @NonNull String instanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Context context = instanceManager.getInstance(instanceUuid);

        final PackageManager packageManager = context.getPackageManager();

        packageManagerFlutterApi.create(packageManager);

        final UUID packageManagerUuid = instanceManager.getIdentifierForStrongReference(packageManager);
        return packageManagerUuid.toString();
    }

    @Override
    @NonNull public String getContentResolver(
        @NonNull String instanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Context context = instanceManager.getInstance(instanceUuid);

        final ContentResolver contentResolver = context.getContentResolver();

        contentResolverFlutterApi.create(contentResolver);

        final UUID contentResolverUuid = instanceManager.getIdentifierForStrongReference(contentResolver);
        return contentResolverUuid.toString();
    }
}
