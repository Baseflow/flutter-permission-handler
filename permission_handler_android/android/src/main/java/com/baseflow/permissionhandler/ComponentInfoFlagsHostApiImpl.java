package com.baseflow.permissionhandler;

import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.ComponentInfoFlagsHostApi;

/**
 * Host API implementation for `ComponentInfoFlags`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ComponentInfoFlagsHostApiImpl implements ComponentInfoFlagsHostApi {
    private final InstanceManager instanceManager;

    private final ComponentInfoFlagsFlutterApiImpl flutterApi;

    /**
     * Constructs an {@link ComponentInfoFlagsHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ComponentInfoFlagsHostApiImpl(
        @NonNull ComponentInfoFlagsFlutterApiImpl flutterApi,
        @NonNull InstanceManager instanceManager
    ) {
        this.flutterApi = flutterApi;
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @NonNull
    @Override
    public String of(@NonNull Long value) {
        final PackageManager.ComponentInfoFlags flags = PackageManager.ComponentInfoFlags.of(value);
        flutterApi.create(flags);
        return instanceManager.getIdentifierForStrongReference(flags).toString();
    }
}
