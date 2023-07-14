import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_web/permission_handler_web.dart';
import 'package:permission_handler_web/permission_handler_web_platform_interface.dart';
import 'package:permission_handler_web/permission_handler_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPermissionHandlerWebPlatform
    with MockPlatformInterfaceMixin
    implements PermissionHandlerWebPlatform {

  //@override
  //Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PermissionHandlerWebPlatform initialPlatform = PermissionHandlerWebPlatform.instance;

  test('$MethodChannelPermissionHandlerWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPermissionHandlerWeb>());
  });

  test('getPlatformVersion', () async {
    PermissionHandlerWeb permissionHandlerWebPlugin = PermissionHandlerWeb();
    MockPermissionHandlerWebPlatform fakePlatform = MockPermissionHandlerWebPlatform();
    PermissionHandlerWebPlatform.instance = fakePlatform;

    //expect(await permissionHandlerWebPlugin.getPlatformVersion(), '42');
  });
}
