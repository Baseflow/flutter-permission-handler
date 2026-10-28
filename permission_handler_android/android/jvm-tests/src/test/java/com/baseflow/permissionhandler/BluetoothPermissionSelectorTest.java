package com.baseflow.permissionhandler;

import android.Manifest;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class BluetoothPermissionSelectorTest {
    private static final String[] BLUETOOTH_PERMISSIONS = {
        Manifest.permission.BLUETOOTH_SCAN,
        Manifest.permission.BLUETOOTH_CONNECT,
        Manifest.permission.BLUETOOTH_ADVERTISE
    };

    @Test
    void selectsPermissionsAcrossDeviceTargetAndManifestMatrix() {
        for (String permission : BLUETOOTH_PERMISSIONS) {
            for (int sdk : new int[] {28, 29, 30, 31, 33, 37}) {
                for (int target : new int[] {30, 31, 37}) {
                    for (int manifestMask = 0; manifestMask < 8; manifestMask++) {
                        Set<String> manifest = new HashSet<>();
                        boolean bluetooth = (manifestMask & 1) != 0;
                        boolean fine = (manifestMask & 2) != 0;
                        boolean coarse = (manifestMask & 4) != 0;
                        if (bluetooth) manifest.add(permission);
                        if (fine) manifest.add(Manifest.permission.ACCESS_FINE_LOCATION);
                        if (coarse) manifest.add(Manifest.permission.ACCESS_COARSE_LOCATION);

                        String expected;
                        if (sdk >= 31 && bluetooth) {
                            expected = permission;
                        } else if (sdk >= 31 && target >= 31) {
                            expected = null;
                        } else if (fine) {
                            expected = Manifest.permission.ACCESS_FINE_LOCATION;
                        } else if (sdk < 29 && coarse) {
                            expected = Manifest.permission.ACCESS_COARSE_LOCATION;
                        } else {
                            expected = null;
                        }

                        assertEquals(expected, BluetoothPermissionSelector.select(
                            sdk, target, permission, manifest::contains),
                            permission + ", sdk=" + sdk + ", target=" + target +
                                ", manifest=" + manifest);
                    }
                }
            }
        }
    }

    @Test
    void modernAppsNeverConsultLocationOrOtherBluetoothPermissions() {
        for (String permission : BLUETOOTH_PERMISSIONS) {
            List<String> queried = new ArrayList<>();
            String selected = BluetoothPermissionSelector.select(31, 31, permission, name -> {
                queried.add(name);
                // Both location permissions and the other Bluetooth permissions exist.
                return !name.equals(permission);
            });
            assertEquals(null, selected);
            assertEquals(List.of(permission), queried);
        }
    }

    @Test
    void declaredBluetoothPermissionTakesPrecedenceOverLocation() {
        for (String permission : BLUETOOTH_PERMISSIONS) {
            for (int target : new int[] {30, 31}) {
                List<String> queried = new ArrayList<>();
                assertEquals(permission, BluetoothPermissionSelector.select(31, target, permission, name -> {
                    queried.add(name);
                    return true;
                }));
                assertEquals(List.of(permission), queried);
            }
        }
    }
}
