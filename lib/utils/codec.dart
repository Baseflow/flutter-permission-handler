import 'dart:convert';

import 'package:permission_handler/permission_enums.dart';

class Codec {
  static PermissionStatus decodePermissionStatus(dynamic value) {
    final permission = json.decode(value);

    return PermissionStatus.values.firstWhere((e) => e.toString().split('.').last == permission);
  }
  
  static String encodePermissionGroup(PermissionGroup permissionGroup) =>
      json.encode(_encodeEnum(permissionGroup));

  static String _encodeEnum(dynamic value) {
    return value.toString().split('.').last;
  }
}