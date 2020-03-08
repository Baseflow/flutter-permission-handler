import '../../../permission_handler_platform_interface.dart';

/// Provides utility methods for encoding messages that are send on the Flutter
/// message channel.
class Codec {
  /// Converts the supplied integer value into a [PermissionStatus] instance.
  static PermissionStatus decodePermissionStatus(int value) {
    return PermissionStatusValue.statusByValue(value);
  }

  /// Converts the supplied integer value into a [ServiceStatus] instance.
  static ServiceStatus decodeServiceStatus(int value) {
    return ServiceStatusValue.statusByValue(value);
  }

  /// Converts the supplied [Map] of integers into a [Map] of [Permission] key
  /// and [PermissionStatus] value instances.
  static Map<Permission, PermissionStatus> decodePermissionRequestResult(
      Map<int, int> value) {
    return value.map((key, value) => MapEntry<Permission, PermissionStatus>(
        Permission.byValue(key), PermissionStatusValue.statusByValue(value)));
  }

  /// Converts the supplied [List] containing [Permission] instances into
  /// a [List] containing integers which can be used to send on the Flutter
  /// method channel.
  static List<int> encodePermissions(List<Permission> permissions) {
    return permissions.map((it) => it.value).toList();
  }
}
