package com.baseflow.permissionhandler;

import android.os.Build;

import androidx.annotation.NonNull;

import com.baseflow.permissionhandler.PermissionHandlerPigeon.BuildVersionHostApi;

/**
 * Host API implementation for `Build.VERSION`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class BuildVersionHostApiImpl implements BuildVersionHostApi {
    @NonNull
    @Override
    public Long sdkInt() {
        return (long) Build.VERSION.SDK_INT;
    }
}
