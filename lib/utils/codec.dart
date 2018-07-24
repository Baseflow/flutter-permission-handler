import 'dart:convert';

import 'package:permission_handler/permission_enums.dart';

class Codec {
  static PermissionStatus decodePermissionStatus(dynamic value) {
    final permission = json.decode(value);

    return PermissionStatus.values
        .firstWhere((e) => e.toString().split('.').last == permission);
  }

  static Map<PermissionGroup, PermissionStatus> decodePermissionRequestResult(
      dynamic value) {
    final jsonObject = json.decode(value);

    final permissionResults = Map<PermissionGroup, PermissionStatus>();
    jsonObject.forEach((key, value) {
      final permissionGroup = PermissionGroup.values
          .firstWhere((e) => e.toString().split('.').last == key.toString());
      final permissionStatus = PermissionStatus.values
          .firstWhere((e) => e.toString().split('.').last == value.toString());

      permissionResults[permissionGroup] = permissionStatus;
    });

    return permissionResults;
  }

  static String encodePermissionGroup(PermissionGroup permissionGroup) =>
      json.encode(_encodeEnum(permissionGroup));

  static String encodePermissionGroups(List<PermissionGroup> permissions) =>
      json.encode(permissions.map((p) => _encodeEnum(p)).toList());

  static String _encodeEnum(dynamic value) {
    return value.toString().split('.').last;
  }
}
