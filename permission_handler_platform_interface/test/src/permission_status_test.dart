import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  test('PermissionStatus should contain 5 options', () {
    final values = PermissionStatus.values;

    expect(values.length, 5);
  });

  test('PermissionStatus enum should have items in correct index', () {
    final values = PermissionStatus.values;

    expect(values[0], PermissionStatus.granted);
    expect(values[1], PermissionStatus.denied);
    expect(values[2], PermissionStatus.restricted);
    expect(values[3], PermissionStatus.limited);
    expect(values[4], PermissionStatus.permanentlyDenied);
  });

  test(
      // ignore: lines_longer_than_80_chars
      'statusByValue should return right index int that corresponds with the right PermissionStatus',
      () {
    expect(PermissionStatusValue.statusByValue(0), PermissionStatus.granted);
    expect(PermissionStatusValue.statusByValue(1), PermissionStatus.denied);
    expect(PermissionStatusValue.statusByValue(2), PermissionStatus.restricted);
    expect(PermissionStatusValue.statusByValue(3), PermissionStatus.limited);
    expect(PermissionStatusValue.statusByValue(4),
        PermissionStatus.permanentlyDenied);
  });

  //TODO: Kan je de Getters testen?
}
