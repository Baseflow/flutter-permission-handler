import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_default/permission_handler_default.dart';

void main() {
  final List<Permission> testPermissions = [
    Permission.camera,
    Permission.contacts,
    Permission.location,
    Permission.microphone,
    Permission.notification,
  ];

  final plugin = DefaultPermissionHandler();

  test('check permissions are all granted', () async {
    final permissions = await plugin.requestPermissions(testPermissions);

    for (final status in permissions.values) {
      expect(status, PermissionStatus.granted);
    }
  });

  test('check services are all enabled.', () async {
    for (final permission in testPermissions) {
      final serviceStatus = await plugin.checkServiceStatus(permission);
      expect(serviceStatus, ServiceStatus.enabled);
    }
  });

  test('never show unsupported permission rational.', () async {
    for (final permission in testPermissions) {
      final shouldIt =
          await plugin.shouldShowRequestPermissionRationale(permission);
      expect(shouldIt, false);
    }
  });

  test('never show unsupported app settings.', () async {
    final appSettings = await plugin.openAppSettings();
    expect(appSettings, false);
  });
}
