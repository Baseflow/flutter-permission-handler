import 'package:permission_handler/src/permission_enums.dart';

class Codec {
  static PermissionStatus decodePermissionStatus(int value) {
    return PermissionStatus.values[value];
  }

  static ServiceStatus decodeServiceStatus(int value) {
    return ServiceStatus.values[value];
  }

  static Map<PermissionGroup, PermissionStatus> decodePermissionRequestResult(
      Map<int, int> value) {
    print('decodePermissionRequestResult called with: value:[$value]');
    return value.map((int key, int value) =>
        MapEntry<PermissionGroup, PermissionStatus>(
            PermissionGroup.values[key], PermissionStatus.values[value]));
  }

  static List<int> encodePermissionGroups(List<PermissionGroup> permissions) {
    return permissions.map((PermissionGroup it) => it.value).toList();
  }
}
