import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_apple/next/permission_handler_apple.dart';
import 'package:permission_handler_apple/next/src/permission_handler_apple_impl.dart';
import 'package:permission_handler_apple/next/src/permission_manager.dart';
import 'package:permission_handler_apple/next/src/permissions/permission_handlers.dart';
import 'package:permission_handler_apple/next/src/proxies/apple_permissions_proxy.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class _FakePermissionManager extends PermissionManager {
  _FakePermissionManager()
      : super(
          handlers: PermissionHandlers(
            proxy: ApplePermissionsProxy(),
            isEnabled: (_) async => true,
          ),
        );

  @override
  Future<bool> openAppSettings() async => true;
}

void main() {
  group('PermissionHandlerApple', () {
    test('shouldShowRequestPermissionRationale always returns false', () async {
      final handler = PermissionHandlerApple();
      expect(
        await handler.shouldShowRequestPermissionRationale(Permission.camera),
        isFalse,
      );
    });

    test('delegates openAppSettings to implementation', () async {
      final impl = PermissionHandlerAppleImpl(
        permissionManager: _FakePermissionManager(),
      );
      expect(await impl.openAppSettings(), isTrue);
    });
  });
}
