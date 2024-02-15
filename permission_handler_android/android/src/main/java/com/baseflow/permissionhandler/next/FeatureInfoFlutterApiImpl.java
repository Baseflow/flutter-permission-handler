package com.baseflow.permissionhandler.next;

import android.content.pm.FeatureInfo;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.FeatureInfoFlutterApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Flutter API implementation for `FeatureInfo`.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class FeatureInfoFlutterApiImpl {
    private final InstanceManager instanceManager;

    private final FeatureInfoFlutterApi api;

    /**
     * Constructs a {@link FeatureInfoFlutterApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public FeatureInfoFlutterApiImpl(
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
        api = new FeatureInfoFlutterApi(binaryMessenger);
    }

    /**
     * Stores the `FeatureInfo` instance and notifies Dart to create and store a new `FeatureInfo`
     * instance that is attached to this one. If `instance` has already been added, this method does
     * nothing.
     */
    public void create(@NonNull FeatureInfo instance) {
        if (!instanceManager.containsInstance(instance)) {
            final UUID featureInfoInstanceUuid = instanceManager.addHostCreatedInstance(instance);
            api.create(featureInfoInstanceUuid.toString(), reply -> {});
        }
    }

    /**
     * Disposes of the `FeatureInfo` instance in the instance manager and notifies Dart to do the
     * same. If `instance` was already disposed, this method does nothing.
     */
    public void dispose(FeatureInfo instance) {
        final UUID featureInfoInstanceUuid = instanceManager.getIdentifierForStrongReference(instance);
        if (featureInfoInstanceUuid != null) {
            api.dispose(featureInfoInstanceUuid.toString(), reply -> {});
        }
    }
}
