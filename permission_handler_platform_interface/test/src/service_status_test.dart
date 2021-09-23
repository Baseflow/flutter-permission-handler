import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  group('ServiceStatus', () {
    test('ServiceStatus should contain 3 options', () {
      const values = ServiceStatus.values;

      expect(values.length, 3);
    });

    test('ServiceStatus enum should have items in correct index', () {
      const values = ServiceStatus.values;

      expect(values[0], ServiceStatus.disabled);
      expect(values[1], ServiceStatus.enabled);
      expect(values[2], ServiceStatus.notApplicable);
    });
  });

  group('ServiceStatusValue', () {
    test('ServiceStatusValue returns right integer', () {
      expect(ServiceStatus.disabled.value, 0);
      expect(ServiceStatus.enabled.value, 1);
      expect(ServiceStatus.notApplicable.value, 2);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'statusByValue should return right index int that corresponds with the right PermissionStatus',
        () {
      expect(ServiceStatusValue.statusByValue(0), ServiceStatus.disabled);
      expect(ServiceStatusValue.statusByValue(1), ServiceStatus.enabled);
      expect(ServiceStatusValue.statusByValue(2), ServiceStatus.notApplicable);
    });
  });

  group('ServiceStatusGetters', () {
    test('Getters should return true if statement is met', () {
      expect(ServiceStatus.disabled.isDisabled, true);
      expect(ServiceStatus.enabled.isEnabled, true);
      expect(ServiceStatus.notApplicable.isNotApplicable, true);
    });

    test('Getters should return false if statement is not met', () {
      expect(ServiceStatus.disabled.isEnabled, false);
      expect(ServiceStatus.enabled.isDisabled, false);
      expect(ServiceStatus.notApplicable.isDisabled, false);
    });
  });
}
