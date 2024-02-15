package com.baseflow.permissionhandler.next;

import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.next.PermissionHandlerPigeon.ResolveInfoFlagsHostApi;

/**
 * Host API implementation for `ResolveInfoFlags`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class ResolveInfoFlagsHostApiImpl implements ResolveInfoFlagsHostApi {
    private final InstanceManager instanceManager;

    private final ResolveInfoFlagsFlutterApiImpl flutterApi;

    /**
     * Constructs an {@link ResolveInfoFlagsHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public ResolveInfoFlagsHostApiImpl(
        @NonNull ResolveInfoFlagsFlutterApiImpl flutterApi,
        @NonNull InstanceManager instanceManager
    ) {
        this.flutterApi = flutterApi;
        this.instanceManager = instanceManager;
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @NonNull
    @Override
    public String of(@NonNull Long value) {
        final PackageManager.ResolveInfoFlags flags = PackageManager.ResolveInfoFlags.of(value);
        flutterApi.create(flags);
        return instanceManager.getIdentifierForStrongReference(flags).toString();
    }
}
