package com.baseflow.permissionhandler;

import android.content.pm.PackageInfo;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.PackageInfoHostApi;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `PackageInfo`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class PackageInfoHostApiImpl implements PackageInfoHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link PackageInfoHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public PackageInfoHostApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @NonNull
    @Override
    public List<String> getRequestedPermissions(@NonNull String instanceId) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final PackageInfo packageInfo = instanceManager.getInstance(instanceUuid);
        final String[] requestedPermissions = packageInfo.requestedPermissions;
        if (requestedPermissions == null) {
            return new ArrayList<>();
        }
        return Arrays.asList(requestedPermissions);
    }
}
