package com.baseflow.permissionhandler.next;

import android.content.pm.ResolveInfo;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ResolveInfoFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `ResolveInfo`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class ResolveInfoFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final ResolveInfoFlutterApi api;

    /**
     * Constructs a {@link ResolveInfoFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ResolveInfoFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new ResolveInfoFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `ResolveInfo` instance and notifies Dart to create and store a new `ResolveInfo`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull ResolveInfo instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID resolveInfoInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(resolveInfoInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `ResolveInfo` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(ResolveInfo instance) {
        final UUID resolveInfoInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (resolveInfoInstanceUuid != null) {
            api.dispose(resolveInfoInstanceUuid.toString(), reply -> {});
        }
    }
}
