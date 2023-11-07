package com.baseflow.permissionhandler;

import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.IntentHostApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `Intent`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class IntentHostApiImpl implements IntentHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link IntentHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public IntentHostApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @Override
    public void create(@NonNull String instanceId) {
        final Intent intent = new Intent();
        final UUID instanceUuid = UUID.fromString(instanceId);
        instanceManager.addDartCreatedInstance(intent, instanceUuid);
    }

    @Override
    public void setAction(
        @NonNull String instanceId,
        @NonNull String action
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Intent intent = instanceManager.getInstance(instanceUuid);

        intent.setAction(action);
    }

    @Override
    public void setData(
        @NonNull String instanceId,
        @NonNull String uriInstanceId
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final UUID uriInstanceUuid = UUID.fromString(uriInstanceId);
        final Intent intent = instanceManager.getInstance(instanceUuid);
        final Uri uri = instanceManager.getInstance(uriInstanceUuid);

        intent.setData(uri);
    }

    @Override
    public void addCategory(
        @NonNull String instanceId,
        @NonNull String category
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Intent intent = instanceManager.getInstance(instanceUuid);

        intent.addCategory(category);
    }

    @Override
    public void addFlags(
        @NonNull String instanceId,
        Long flags
    ) {
        final UUID instanceUuid = UUID.fromString(instanceId);
        final Intent intent = instanceManager.getInstance(instanceUuid);

        intent.addFlags(flags.intValue());
    }
}
