import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_apple/next/src/permission_manager.dart';
import 'package:permission_handler_apple/next/src/permissions/permission_handlers.dart';
import 'package:permission_handler_apple/next/src/proxies/apple_permissions_proxy.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class _SlowPermissionHandlers extends PermissionHandlers {
  _SlowPermissionHandlers()
      : super(
          proxy: ApplePermissionsProxy(),
          isEnabled: (_) async => true,
        );

  @override
  bool supports(Permission permission) => permission == Permission.storage;

  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    return Future.value(PermissionStatus.granted);
  }

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) {
    return Future.value(ServiceStatus.disabled);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PermissionManager', () {
    test('requestPermissions returns empty map for empty input', () async {
      final manager = PermissionManager(
        handlers: PermissionHandlers(
          proxy: ApplePermissionsProxy(),
          isEnabled: (_) async => true,
        ),
      );

      expect(await manager.requestPermissions([]), isEmpty);
    });

    test('requestPermissions throws when already in progress', () async {
      final manager = PermissionManager(handlers: _SlowPermissionHandlers());

      final first = manager.requestPermissions([Permission.storage]);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(
        () => manager.requestPermissions([Permission.storage]),
        throwsA(
          isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'ERROR_ALREADY_REQUESTING_PERMISSIONS',
          ),
        ),
      );

      await first;
    });

    test('checkPermissionStatus returns denied for unsupported permission',
        () async {
      final manager = PermissionManager(
        handlers: PermissionHandlers(
          proxy: ApplePermissionsProxy(),
          isEnabled: (_) async => true,
        ),
      );

      expect(
        await manager.checkPermissionStatus(Permission.sms),
        PermissionStatus.denied,
      );
    });
  });
}
