package com.baseflow.permissionhandler;

import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ApplicationInfoFlagsHostApi;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Host API implementation for `ApplicationInfoFlags`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ApplicationInfoFlagsHostApiImpl implements ApplicationInfoFlagsHostApi {
    // To ease adding additional methods, this value is added prematurely.
    @SuppressWarnings({"unused", "FieldCanBeLocal"})
    private final BinaryMessenger binaryMessenger;

    private final InstanceManager instanceManager;

    private final ApplicationInfoFlagsFlutterApiImpl flutterApi;

    /**
     * Constructs an {@link ApplicationInfoFlagsHostApiImpl}.
     *
     * @param binaryMessenger used to communicate with Dart over asynchronous messages
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ApplicationInfoFlagsHostApiImpl(
        @NonNull ApplicationInfoFlagsFlutterApiImpl flutterApi,
        @NonNull BinaryMessenger binaryMessenger,
        @NonNull InstanceManager instanceManager
    ) {
        this.flutterApi = flutterApi;
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @NonNull
    @Override
    public String of(@NonNull Long value) {
        final PackageManager.ApplicationInfoFlags flags = PackageManager.ApplicationInfoFlags.of(value);
        flutterApi.create(flags);
        return instanceManager.getIdentifierForStrongReference(flags).toString();
    }
}