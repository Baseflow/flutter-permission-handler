package com.baseflow.permissionhandler;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.PowerManager;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ContextHostApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `Context`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ContextHostApiImpl implements ContextHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final PowerManagerFlutterApiImpl powerManagerFlutterApi;

    private final AlarmManagerFlutterApiImpl alarmManagerFlutterApi;

    private final PackageManagerFlutterApiImpl packageManagerFlutterApi;

    private final NotificationManagerFlutterApiImpl notificationManagerFlutterApi;

    /**
     * Constructs an {@link ContextHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ContextHostApiImpl(
        @NonNull PowerManagerFlutterApiImpl powerManagerFlutterApi,
        @NonNull AlarmManagerFlutterApiImpl alarmManagerFlutterApi,
        @NonNull PackageManagerFlutterApiImpl packageManagerFlutterApi,
        @NonNull NotificationManagerFlutterApiImpl notificationManagerFlutterApi,
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.powerManagerFlutterApi = powerManagerFlutterApi;
        this.alarmManagerFlutterApi = alarmManagerFlutterApi;
        this.packageManagerFlutterApi = packageManagerFlutterApi;
        this.notificationManagerFlutterApi = notificationManagerFlutterApi;
        this.binaryMessenger = binaryMessenger;
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
    @NonNull public String getSystemService(
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
        }

        final UUID systemServiceUuid = instanceManager.getIdentifierForStrongReference(systemService);
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
}
