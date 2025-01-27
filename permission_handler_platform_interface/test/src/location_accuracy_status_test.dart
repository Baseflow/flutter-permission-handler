import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  group('LocationAccuracyStatus', () {
    test('LocationAccuracyStatus should contain 3 options', () {
      const values = LocationAccuracyStatus.values;

      expect(values.length, 3);
    });

    test('LocationAccuracyStatus enum should have items in correct index', () {
      const values = LocationAccuracyStatus.values;

      expect(values[0], LocationAccuracyStatus.reduced);
      expect(values[1], LocationAccuracyStatus.precise);
      expect(values[2], LocationAccuracyStatus.unknown);
    });
  });

  group('LocationAccuracyStatusValue', () {
    test('LocationAccuracyStatusValue returns right integer', () {
      expect(LocationAccuracyStatus.reduced.value, 0);
      expect(LocationAccuracyStatus.precise.value, 1);
      expect(LocationAccuracyStatus.unknown.value, 2);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'statusByValue should return right index int that corresponds with the right LocationAccuracyStatus',
        () {
      expect(LocationAccuracyStatusValue.statusByValue(0),
          LocationAccuracyStatus.reduced);
      expect(LocationAccuracyStatusValue.statusByValue(1),
          LocationAccuracyStatus.precise);
      expect(LocationAccuracyStatusValue.statusByValue(2),
          LocationAccuracyStatus.unknown);
    });
  });

  group('LocationAccuracyStatusGetters', () {
    test('Getters should return true if statement is met', () {
      expect(LocationAccuracyStatus.reduced.isReduced, true);
      expect(LocationAccuracyStatus.precise.isPrecise, true);
      expect(LocationAccuracyStatus.unknown.isUnknown, true);
    });

    test('Getters should return false if statement is not met', () {
      expect(LocationAccuracyStatus.reduced.isPrecise, false);
      expect(LocationAccuracyStatus.reduced.isUnknown, false);
      expect(LocationAccuracyStatus.precise.isReduced, false);
      expect(LocationAccuracyStatus.precise.isUnknown, false);
      expect(LocationAccuracyStatus.unknown.isReduced, false);
      expect(LocationAccuracyStatus.unknown.isPrecise, false);
    });
  });

  group('FutureLocationAccuracyStatusGetters', () {
    mockFuture(LocationAccuracyStatus status) => Future.value(status);

    test('Getters should return true if statement is met', () async {
      expect(await mockFuture(LocationAccuracyStatus.reduced).isReduced, true);
      expect(await mockFuture(LocationAccuracyStatus.precise).isPrecise, true);
      expect(await mockFuture(LocationAccuracyStatus.unknown).isUnknown, true);
    });

    test('Getters should return false if statement is not met', () async {
      expect(await mockFuture(LocationAccuracyStatus.reduced).isPrecise, false);
      expect(await mockFuture(LocationAccuracyStatus.reduced).isUnknown, false);
      expect(await mockFuture(LocationAccuracyStatus.precise).isReduced, false);
      expect(await mockFuture(LocationAccuracyStatus.precise).isUnknown, false);
      expect(await mockFuture(LocationAccuracyStatus.unknown).isReduced, false);
      expect(await mockFuture(LocationAccuracyStatus.unknown).isPrecise, false);
    });
  });
}
