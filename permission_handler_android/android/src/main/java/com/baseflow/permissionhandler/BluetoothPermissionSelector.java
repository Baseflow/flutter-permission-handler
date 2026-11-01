package com.baseflow.permissionhandler;

import android.Manifest;
import android.os.Build;
import java.util.function.Predicate;

/** Selects the manifest permission used for a Bluetooth permission group. */
final class BluetoothPermissionSelector {
    private BluetoothPermissionSelector() {}

    static String select(
        int sdkVersion,
        int targetSdkVersion,
        String permission,
        Predicate<String> hasPermissionInManifest
    ) {
        if (sdkVersion >= Build.VERSION_CODES.S) {
            if (hasPermissionInManifest.test(permission)) {
                return permission;
            }
            // Apps targeting Android S or later require the specific Nearby Devices
            // permission. Location cannot stand in for a missing declaration.
            if (targetSdkVersion >= Build.VERSION_CODES.S) {
                return null;
            }
        }

        if (hasPermissionInManifest.test(Manifest.permission.ACCESS_FINE_LOCATION)) {
            return Manifest.permission.ACCESS_FINE_LOCATION;
        }
        if (sdkVersion < Build.VERSION_CODES.Q &&
            hasPermissionInManifest.test(Manifest.permission.ACCESS_COARSE_LOCATION)) {
            return Manifest.permission.ACCESS_COARSE_LOCATION;
        }
        return null;
    }
}
