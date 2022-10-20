import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_apple/permission_handler_apple.dart';
import 'package:permission_handler_apple/permission_handler_apple_platform_interface.dart';
import 'package:permission_handler_apple/permission_handler_apple_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPermissionHandlerApplePlatform
    with MockPlatformInterfaceMixin
    implements PermissionHandlerApplePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PermissionHandlerApplePlatform initialPlatform = PermissionHandlerApplePlatform.instance;

  test('$MethodChannelPermissionHandlerApple is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPermissionHandlerApple>());
  });

  test('getPlatformVersion', () async {
    PermissionHandlerApple permissionHandlerApplePlugin = PermissionHandlerApple();
    MockPermissionHandlerApplePlatform fakePlatform = MockPermissionHandlerApplePlatform();
    PermissionHandlerApplePlatform.instance = fakePlatform;

    expect(await permissionHandlerApplePlugin.getPlatformVersion(), '42');
  });
}
