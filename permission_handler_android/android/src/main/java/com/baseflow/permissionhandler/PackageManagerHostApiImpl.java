package com.baseflow.permissionhandler;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.PackageInfoFlags;
import android.content.pm.ResolveInfo;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PackageManagerHostApi;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Host API implementation for `PackageManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class PackageManagerHostApiImpl implements PackageManagerHostApi {
    private final InstanceManager instanceManager;

    private final PackageInfoFlutterApiImpl packageInfoFlutterApi;

    private final ResolveInfoFlutterApiImpl resolveInfoFlutterApi;

    /**
     * Constructs an {@link PackageManagerHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PackageManagerHostApiImpl(
        @NonNull PackageInfoFlutterApiImpl packageInfoFlutterApi,
        @NonNull ResolveInfoFlutterApiImpl resolveInfoFlutterApi,
        @NonNull InstanceManager instanceManager
    ) {
        this.packageInfoFlutterApi = packageInfoFlutterApi;
        this.resolveInfoFlutterApi = resolveInfoFlutterApi;
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @NonNull
    @Override
    public Boolean canRequestPackageInstalls(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final PackageManager packageManager = instanceManager.getInstance(instanceUuid);

        return packageManager.canRequestPackageInstalls();
    }

    @Deprecated()
    @Override
    public String getPackageInfoWithFlags(
        @NonNull String instanceId,
        @NonNull String packageName,
        @NonNull Long flags
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final PackageManager packageManager = instanceManager.getInstance(instanceUuid);

        final PackageInfo packageInfo;
        try {
            packageInfo = packageManager.getPackageInfo(packageName, flags.intValue());
        } catch (PackageManager.NameNotFoundException e) {
            return null;
        }

        packageInfoFlutterApi.create(packageInfo);

        return instanceManager.getIdentifierForStrongReference(packageInfo).toString();
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    public String getPackageInfoWithInfoFlags(
        @NonNull String instanceId,
        @NonNull String packageName,
        @NonNull String flagsInstanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID flagsInstanceUuid = UUID.fromString(flagsInstanceId);

        final PackageManager packageManager = instanceManager.getInstance(instanceUuid);
        final PackageInfoFlags packageInfoFlags = instanceManager.getInstance(flagsInstanceUuid);

        final PackageInfo packageInfo;
        try {
            packageInfo = packageManager.getPackageInfo(packageName, packageInfoFlags);
        } catch (PackageManager.NameNotFoundException e) {
            return null;
        }

        packageInfoFlutterApi.create(packageInfo);

        return instanceManager.getIdentifierForStrongReference(packageInfo).toString();
    }

    @NonNull
    @Override
    public Boolean hasSystemFeature(@NonNull String instanceId, @NonNull String featureName) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final PackageManager packageManager = instanceManager.getInstance(instanceUuid);
        return packageManager.hasSystemFeature(featureName);
    }

    @Deprecated
    @NonNull
    @Override
    public List<String> queryIntentActivitiesWithFlags(
        @NonNull String instanceId,
        @NonNull String intentInstanceId,
        @NonNull Long flags
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID intentInstanceUuid = UUID.fromString(intentInstanceId);

        final PackageManager packageManager = instanceManager.getInstance(instanceUuid);
        final Intent intent = instanceManager.getInstance(intentInstanceUuid);

        final List<ResolveInfo> resolveInfoList = packageManager.queryIntentActivities(intent, flags.intValue());
        final List<String> resolveInfoInstanceList = new ArrayList<>();

        for (ResolveInfo resolveInfo : resolveInfoList) {
            resolveInfoFlutterApi.create(resolveInfo);
            final UUID resolveInfoUuid = instanceManager.getIdentifierForStrongReference(resolveInfo);
            resolveInfoInstanceList.add(resolveInfoUuid.toString());
        }

        return resolveInfoInstanceList;
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @NonNull
    @Override
    public List<String> queryIntentActivitiesWithInfoFlags(
        @NonNull String instanceId,
        @NonNull String intentInstanceId,
        @NonNull String flagsInstanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID intentInstanceUuid = UUID.fromString(intentInstanceId);
        final UUID flagsInstanceUuid = UUID.fromString(flagsInstanceId);

        final PackageManager packageManager = instanceManager.getInstance(instanceUuid);
        final Intent intent = instanceManager.getInstance(intentInstanceUuid);
        final PackageManager.ResolveInfoFlags flags = instanceManager.getInstance(flagsInstanceUuid);

        final List<ResolveInfo> resolveInfoList = packageManager.queryIntentActivities(intent, flags);
        final List<String> resolveInfoInstanceList = new ArrayList<>();

        for (ResolveInfo resolveInfo : resolveInfoList) {
            resolveInfoFlutterApi.create(resolveInfo);
            final UUID resolveInfoUuid = instanceManager.getIdentifierForStrongReference(resolveInfo);
            resolveInfoInstanceList.add(resolveInfoUuid.toString());
        }

        return resolveInfoInstanceList;
    }
}
