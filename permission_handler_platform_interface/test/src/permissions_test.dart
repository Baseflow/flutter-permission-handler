import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  test('Permission has the right amount of possible Permission values', () {
    const values = Permission.values;

    expect(values.length, 40);
  });

  test('check if byValue returns corresponding Permission value', () {
    const values = Permission.values;

    for (var i = 0; i < values.length; i++) {
      expect(values[i], Permission.byValue(i));
    }
  });

  test('check if toString method returns the corresponding name', () {
    const PermissionWithService permissionWithService =
        PermissionWithService.private(0);
    var permissionName = permissionWithService.toString();
    expect(permissionName, 'Permission.calendar');
  });

  test('check if toString works on all Permission values', () {
    const values = Permission.values;

    for (var i = 0; i < values.length; i++) {
      expect(values[i].toString(), isNotNull);
    }
  });

  test(
      // ignore: lines_longer_than_80_chars
      'equality operator should return true for two instances with the same values',
      () {
    // Arrange
    final firstPermission = Permission.byValue(1);
    final secondPermission = Permission.byValue(1);

    // Act & Assert
    expect(
      firstPermission == secondPermission,
      true,
    );
  });

  test(
      // ignore: lines_longer_than_80_chars
      'equality operator should return false for two instances with different values',
      () {
    // Arrange
    final firstPermission = Permission.byValue(1);
    final secondPermission = Permission.byValue(2);

    // Act & Assert
    expect(
      firstPermission == secondPermission,
      false,
    );
  });

  test('hashCode should be the same for two instances with the same values',
      () {
    // Arrange
    final firstPermission = Permission.byValue(1);
    final secondPermission = Permission.byValue(1);

    // Act & Assert
    expect(
      firstPermission.hashCode,
      secondPermission.hashCode,
    );
  });

  test('hashCode should not match for two instances with different values', () {
    // Arrange
    final firstPermission = Permission.byValue(1);
    final secondPermission = Permission.byValue(2);

    // Act & Assert
    expect(
      firstPermission.hashCode == secondPermission.hashCode,
      false,
    );
  });
}
