package com.baseflow.permissionhandler;

import android.content.ContentResolver;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ContentResolverFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `ContentResolver`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ContentResolverFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final ContentResolverFlutterApi api;

    /**
     * Constructs a {@link ContentResolverFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ContentResolverFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new ContentResolverFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `ContentResolver` instance and notifies Dart to create and store a new
     * `ContentResolver` instance that is attached to this one. If `instance` has already been
     * added, this method does nothing.
     */
    public void create(@NonNull ContentResolver instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID contentResolverInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(contentResolverInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `ContentResolver` instance in the instance manager and notifies Dart to do
     * the same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(ContentResolver instance) {
        final UUID contentResolverInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (contentResolverInstanceUuid != null) {
            api.dispose(contentResolverInstanceUuid.toString(), reply -> {});
        }
    }
}
