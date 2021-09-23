import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  group('PermissionSatus', () {
    test('PermissionStatus should contain 5 options', () {
      const values = PermissionStatus.values;

      expect(values.length, 5);
    });

    test('PermissionStatus enum should have items in correct index', () {
      const values = PermissionStatus.values;

      expect(values[0], PermissionStatus.denied);
      expect(values[1], PermissionStatus.granted);
      expect(values[2], PermissionStatus.restricted);
      expect(values[3], PermissionStatus.limited);
      expect(values[4], PermissionStatus.permanentlyDenied);
    });
  });

  group('PermissionStatusValue', () {
    test('PermissonStatusValue returns right integer', () {
      expect(PermissionStatus.denied.value, 0);
      expect(PermissionStatus.granted.value, 1);
      expect(PermissionStatus.restricted.value, 2);
      expect(PermissionStatus.limited.value, 3);
      expect(PermissionStatus.permanentlyDenied.value, 4);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'statusByValue should return right index int that corresponds with the right PermissionStatus',
        () {
      expect(PermissionStatusValue.statusByValue(0), PermissionStatus.denied);
      expect(PermissionStatusValue.statusByValue(1), PermissionStatus.granted);
      expect(
          PermissionStatusValue.statusByValue(2), PermissionStatus.restricted);
      expect(PermissionStatusValue.statusByValue(3), PermissionStatus.limited);
      expect(PermissionStatusValue.statusByValue(4),
          PermissionStatus.permanentlyDenied);
    });
  });

  group('PermissionStatusGetters', () {
    test('Getters should return true if statement is met', () {
      expect(PermissionStatus.denied.isDenied, true);
      expect(PermissionStatus.granted.isGranted, true);
      expect(PermissionStatus.restricted.isRestricted, true);
      expect(PermissionStatus.limited.isLimited, true);
      expect(PermissionStatus.permanentlyDenied.isPermanentlyDenied, true);
    });

    test('Getters should return false if statement is not met', () {
      expect(PermissionStatus.denied.isGranted, false);
      expect(PermissionStatus.granted.isDenied, false);
      expect(PermissionStatus.restricted.isDenied, false);
      expect(PermissionStatus.limited.isDenied, false);
      expect(PermissionStatus.permanentlyDenied.isDenied, false);
    });
  });

  test('test', () {});
}
