import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'permission_handler_apple_method_channel.dart';

abstract class PermissionHandlerApplePlatform extends PlatformInterface {
  /// Constructs a PermissionHandlerApplePlatform.
  PermissionHandlerApplePlatform() : super(token: _token);

  static final Object _token = Object();

  static PermissionHandlerApplePlatform _instance = MethodChannelPermissionHandlerApple();

  /// The default instance of [PermissionHandlerApplePlatform] to use.
  ///
  /// Defaults to [MethodChannelPermissionHandlerApple].
  static PermissionHandlerApplePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PermissionHandlerApplePlatform] when
  /// they register themselves.
  static set instance(PermissionHandlerApplePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
