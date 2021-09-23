import '../../../permission_handler_platform_interface.dart';

/// Converts the given [value] into a [PermissionStatus] instance.
PermissionStatus decodePermissionStatus(int value) {
  return PermissionStatusValue.statusByValue(value);
}

/// Converts the given [value] into a [ServiceStatus] instance.
ServiceStatus decodeServiceStatus(int value) {
  return ServiceStatusValue.statusByValue(value);
}

/// Converts the given [Map] of [int]s into a [Map] with [Permission]s as
/// keys and their respective [PermissionStatus] as value.
Map<Permission, PermissionStatus> decodePermissionRequestResult(
    Map<int, int> value) {
  return value.map((key, value) => MapEntry<Permission, PermissionStatus>(
      Permission.byValue(key), PermissionStatusValue.statusByValue(value)));
}

/// Converts the given [List] of [Permission]s into a [List] of [int]s which
/// can be sent on the Flutter method channel.
List<int> encodePermissions(List<Permission> permissions) {
  return permissions.map((it) => it.value).toList();
}
