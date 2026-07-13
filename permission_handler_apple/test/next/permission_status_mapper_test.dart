import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_apple/next/src/permission_status_mapper.dart';
import 'package:permission_handler_apple/next/src/pigeon/apple_permissions.g.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  group('mapAVAuthorizationStatus', () {
    test('maps all values', () {
      expect(
        mapAVAuthorizationStatus(AVAuthorizationStatus.notDetermined),
        PermissionStatus.denied,
      );
      expect(
        mapAVAuthorizationStatus(AVAuthorizationStatus.restricted),
        PermissionStatus.restricted,
      );
      expect(
        mapAVAuthorizationStatus(AVAuthorizationStatus.denied),
        PermissionStatus.permanentlyDenied,
      );
      expect(
        mapAVAuthorizationStatus(AVAuthorizationStatus.authorized),
        PermissionStatus.granted,
      );
    });
  });

  group('mapPHAuthorizationStatus', () {
    test('maps limited to limited', () {
      expect(
        mapPHAuthorizationStatus(PHAuthorizationStatus.limited),
        PermissionStatus.limited,
      );
    });
  });

  group('mapEKAuthorizationStatus', () {
    test('writeOnly granted only for write-only requests', () {
      expect(
        mapEKAuthorizationStatus(
          EKAuthorizationStatus.writeOnly,
          isWriteOnlyRequest: true,
        ),
        PermissionStatus.granted,
      );
      expect(
        mapEKAuthorizationStatus(
          EKAuthorizationStatus.writeOnly,
          isWriteOnlyRequest: false,
        ),
        PermissionStatus.denied,
      );
    });
  });

  group('mapUNAuthorizationStatus', () {
    test('maps provisional', () {
      expect(
        mapUNAuthorizationStatus(UNAuthorizationStatus.provisional),
        PermissionStatus.provisional,
      );
    });
  });

  group('mapCLAuthorizationStatus', () {
    test('always request treats whenInUse as permanentlyDenied', () {
      expect(
        mapCLAuthorizationStatus(
          CLAuthorizationStatus.authorizedWhenInUse,
          isAlwaysRequest: true,
        ),
        PermissionStatus.permanentlyDenied,
      );
    });

    test('whenInUse request grants whenInUse and always', () {
      expect(
        mapCLAuthorizationStatus(
          CLAuthorizationStatus.authorizedWhenInUse,
          isAlwaysRequest: false,
        ),
        PermissionStatus.granted,
      );
      expect(
        mapCLAuthorizationStatus(
          CLAuthorizationStatus.authorizedAlways,
          isAlwaysRequest: false,
        ),
        PermissionStatus.granted,
      );
    });
  });

  group('mapUIBackgroundRefreshStatus', () {
    test('maps available to granted', () {
      expect(
        mapUIBackgroundRefreshStatus(UIBackgroundRefreshStatus.available),
        PermissionStatus.granted,
      );
    });
  });
}
