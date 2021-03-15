import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  test('ServiceStatus should contain 3 options', () {
    final values = ServiceStatus.values;

    expect(values.length, 3);
  });

  test('PermissionStatus enum should have items in correct index', () {
    final values = ServiceStatus.values;

    expect(values[0], ServiceStatus.disabled);
    expect(values[1], ServiceStatus.enabled);
    expect(values[2], ServiceStatus.notApplicable);
  });

  test(
      // ignore: lines_longer_than_80_chars
      'statusByValue should return right index int that corresponds with the right PermissionStatus',
      () {
    expect(ServiceStatusValue.statusByValue(0), ServiceStatus.disabled);
    expect(ServiceStatusValue.statusByValue(1), ServiceStatus.enabled);
    expect(ServiceStatusValue.statusByValue(2), ServiceStatus.notApplicable);
  });

  //TODO: Kan je de Getters testen?
}
