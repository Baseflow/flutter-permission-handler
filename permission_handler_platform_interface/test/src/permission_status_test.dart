import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  group('PermissionStatus', () {
    test('PermissionStatus should contain 6 options', () {
      const values = PermissionStatus.values;

      expect(values.length, 6);
    });

    test('PermissionStatus enum should have items in correct index', () {
      const values = PermissionStatus.values;

      expect(values[0], PermissionStatus.denied);
      expect(values[1], PermissionStatus.granted);
      expect(values[2], PermissionStatus.restricted);
      expect(values[3], PermissionStatus.limited);
      expect(values[4], PermissionStatus.permanentlyDenied);
      expect(values[5], PermissionStatus.provisional);
    });
  });

  group('PermissionStatusValue', () {
    test('PermissionStatusValue returns right integer', () {
      expect(PermissionStatus.denied.value, 0);
      expect(PermissionStatus.granted.value, 1);
      expect(PermissionStatus.restricted.value, 2);
      expect(PermissionStatus.limited.value, 3);
      expect(PermissionStatus.permanentlyDenied.value, 4);
      expect(PermissionStatus.provisional.value, 5);
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
      expect(
          PermissionStatusValue.statusByValue(5), PermissionStatus.provisional);
    });
  });

  group('PermissionStatusGetters', () {
    test('Getters should return true if statement is met', () {
      expect(PermissionStatus.denied.isDenied, true);
      expect(PermissionStatus.granted.isGranted, true);
      expect(PermissionStatus.restricted.isRestricted, true);
      expect(PermissionStatus.limited.isLimited, true);
      expect(PermissionStatus.permanentlyDenied.isPermanentlyDenied, true);
      expect(PermissionStatus.provisional.isProvisional, true);
    });

    test('Getters should return false if statement is not met', () {
      expect(PermissionStatus.denied.isGranted, false);
      expect(PermissionStatus.granted.isDenied, false);
      expect(PermissionStatus.restricted.isDenied, false);
      expect(PermissionStatus.limited.isDenied, false);
      expect(PermissionStatus.permanentlyDenied.isDenied, false);
      expect(PermissionStatus.provisional.isDenied, false);
    });
  });

  group('FuturePermissionStatusGetters', () {
    mockFuture(PermissionStatus status) => Future.value(status);

    test('Getters should return true if statement is met', () async {
      expect(await mockFuture(PermissionStatus.denied).isDenied, true);
      expect(await mockFuture(PermissionStatus.granted).isGranted, true);
      expect(await mockFuture(PermissionStatus.restricted).isRestricted, true);
      expect(await mockFuture(PermissionStatus.limited).isLimited, true);
      expect(
          await mockFuture(PermissionStatus.permanentlyDenied)
              .isPermanentlyDenied,
          true);
      expect(
          await mockFuture(PermissionStatus.provisional).isProvisional, true);
    });

    test('Getters should return false if statement is not met', () async {
      expect(await mockFuture(PermissionStatus.denied).isGranted, false);
      expect(await mockFuture(PermissionStatus.granted).isDenied, false);
      expect(await mockFuture(PermissionStatus.restricted).isDenied, false);
      expect(await mockFuture(PermissionStatus.limited).isDenied, false);
      expect(
          await mockFuture(PermissionStatus.permanentlyDenied).isDenied, false);
      expect(await mockFuture(PermissionStatus.provisional).isDenied, false);
    });
  });

  test('test', () {});
}
