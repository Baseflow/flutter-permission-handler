// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/permission_handler_web.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final WebPermissionHandler plugin = WebPermissionHandler();

    final List<Permission> test_permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.contacts,
      Permission.notification,
      Permission.location
    ];

    final test_permissions_map =
        await plugin.requestPermissions(test_permissions);

    expect(test_permissions_map[Permission.notification],
        PermissionStatus.denied);
    expect(test_permissions_map[Permission.contacts], PermissionStatus.denied);
    expect(test_permissions_map[Permission.location], PermissionStatus.denied);
  });
}
