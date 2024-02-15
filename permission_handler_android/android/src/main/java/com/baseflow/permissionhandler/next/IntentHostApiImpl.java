package com.baseflow.permissionhandler.next;

import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.IntentHostApi;

import java.util.UUID;

/**
 * Host API implementation for `Intent`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class IntentHostApiImpl implements IntentHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link IntentHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public IntentHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
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
