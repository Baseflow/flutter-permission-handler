import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'permission_handler_apple_platform_interface.dart';

/// An implementation of [PermissionHandlerApplePlatform] that uses method channels.
class MethodChannelPermissionHandlerApple extends PermissionHandlerApplePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('permission_handler_apple');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
