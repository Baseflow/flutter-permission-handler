import '../../../permission_handler_platform_interface.dart';

/// Provides utility methods for encoding messages that are send on the Flutter
/// message channel.
class Codec {
  /// Converts the supplied integer value into a [PermissionStatus] instance.
  static PermissionStatus decodePermissionStatus(int value) {
    return PermissionStatus.values[value];
  }

  /// Converts the supplied integer value into a [ServiceStatus] instance.
  static ServiceStatus decodeServiceStatus(int value) {
    return ServiceStatus.values[value];
  }

  /// Converts the supplied [Map] of integers into a [Map] of
  /// [PermissionGroup] key and [PermissionStatus] value instances.
  static Map<PermissionGroup, PermissionStatus> decodePermissionRequestResult(
      Map<int, int> value) {
    return value.map((key, value) =>
        MapEntry<PermissionGroup, PermissionStatus>(
            PermissionGroup.values[key], PermissionStatus.values[value]));
  }

  /// Converts the supplied [List] containing [PermissionGroup] instances into
  /// a [List] containing integers which can be used to send on the Flutter
  /// method channel.
  static List<int> encodePermissionGroups(List<PermissionGroup> permissions) {
    return permissions.map((it) => it.value).toList();
  }
}
