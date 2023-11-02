import 'permission_handler_apple_platform_interface.dart';

class PermissionHandlerApple {
  Future<String?> getPlatformVersion() {
    return PermissionHandlerApplePlatform.instance.getPlatformVersion();
  }
}
