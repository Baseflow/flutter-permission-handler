import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_platform_interface/src/method_channel/utils/codec.dart';

void main() {
  group('Codec', () {
    test('decodePermissionStatus should return a PermissionStatus', () {
      expect(decodePermissionStatus(0), PermissionStatus.denied);
    });

    test('decodeServiceStatus should a corresponding ServiceStatus', () {
      expect(decodeServiceStatus(0), ServiceStatus.disabled);
    });

    test(
        'decodePermissionRequestResult should convert a map<int, int>'
        'to map<Permission, PermissionStatus>', () {
      var value = <int, int>{
        1: 1,
      };

      var permissionMap = decodePermissionRequestResult(value);

      expect(permissionMap.keys.first, isA<Permission>());
      expect(permissionMap.values.first, isA<PermissionStatus>());
    });

    test('encodePermissions should return a list of integers', () {
      var permissions = [Permission.accessMediaLocation];

      var integers = encodePermissions(permissions);

      expect(integers.first, isA<int>());
    });
  });
}
