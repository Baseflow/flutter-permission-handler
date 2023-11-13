package com.baseflow.permissionhandler;

import android.net.Uri;

import androidx.annotation.NonNull;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.UriHostApi;

import java.util.UUID;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `Uri`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class UriHostApiImpl implements UriHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final UriFlutterApiImpl flutterApi;

    /**
     * Constructs an {@link UriHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public UriHostApiImpl(
        @NonNull UriFlutterApiImpl flutterApi,
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.flutterApi = flutterApi;
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @Override
    @NonNull
    public String parse(
        @NonNull String uriString
    ) {
        final Uri uri = Uri.parse(uriString);
        flutterApi.create(uri);
        final UUID instanceId = instanceManager.getIdentifierForStrongReference(uri);
        return instanceId.toString();
    }

    @Override
    @NonNull public String toStringAsync(
        @NonNull String uriInstanceId
    ) {
        final UUID instanceId = UUID.fromString(uriInstanceId);
        final Uri uri = instanceManager.getInstance(instanceId);
        return uri.toString();
    }
}
