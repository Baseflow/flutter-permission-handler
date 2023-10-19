import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$PermissionHandlerPlatform', () {
    test('Throws an `Exception` if no instance builder is provided', () {
      expect(
        () => PermissionHandlerPlatform.instance,
        throwsException,
      );
    });

    test('Cannot be implemented with `implements`', () {
      PermissionHandlerPlatform.setInstanceBuilder(
        () => ImplementsPermissionHandlerPlatform(),
      );

      expect(
        () => PermissionHandlerPlatform.instance,
        throwsA(anything),
      );
    });

    test('Can be extended with `extend`', () {
      PermissionHandlerPlatform.setInstanceBuilder(
        () => ExtendsPermissionHandlerPlatform(),
      );

      PermissionHandlerPlatform.instance;
    });

    test('Can be mocked with `implements`', () {
      final mock = MockPermissionHandlerPlatform();
      PermissionHandlerPlatform.setInstanceBuilder(() => mock);

      PermissionHandlerPlatform.instance;
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of checkPermissionStatus should throw unimplemented error',
        () {
      final permissionHandlerPlatform = ExtendsPermissionHandlerPlatform();

      expect(() {
        permissionHandlerPlatform
            .checkPermissionStatus(Permission.accessMediaLocation);
      }, throwsUnimplementedError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of checkServiceStatus should throw unimplemented error',
        () {
      final permissionHandlerPlatform = ExtendsPermissionHandlerPlatform();

      expect(() {
        permissionHandlerPlatform
            .checkServiceStatus(Permission.accessMediaLocation);
      }, throwsUnimplementedError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of openAppSettings should throw unimplemented error',
        () {
      final permissionHandlerPlatform = ExtendsPermissionHandlerPlatform();

      expect(
          permissionHandlerPlatform.openAppSettings, throwsUnimplementedError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of requestPermissions should throw unimplemented error',
        () {
      final permissionHandlerPlatform = ExtendsPermissionHandlerPlatform();
      var permission = <Permission>[Permission.accessMediaLocation];

      expect(() {
        permissionHandlerPlatform.requestPermissions(permission);
      }, throwsUnimplementedError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of shouldShowRequestPermissionRationale should throw unimplemented error',
        () {
      final permissionHandlerPlatform = ExtendsPermissionHandlerPlatform();
      expect(() {
        permissionHandlerPlatform.shouldShowRequestPermissionRationale(
            Permission.accessMediaLocation);
      }, throwsUnimplementedError);
    });
  });
}

class ImplementsPermissionHandlerPlatform implements PermissionHandlerPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ExtendsPermissionHandlerPlatform extends PermissionHandlerPlatform {}

class MockPermissionHandlerPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PermissionHandlerPlatform {}
