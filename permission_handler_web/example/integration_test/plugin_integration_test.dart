// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction
import 'dart:html' as html;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_web/permission_handler_web.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('check permission status test', (WidgetTester tester) async {
    final WebPermissionHandler plugin = WebPermissionHandler();

    final List<Permission> test_permissions = [
      Permission.contacts,
      Permission.microphone,
    ];

    // check permissions status
    // for (Permission permission in test_permissions) {
    //   final actual_status = await plugin.checkPermissionStatus(permission);

    //   expect(actual_status, PermissionStatus.denied);
    // }

    // request permissions
    final test_permissions_map =
        await plugin.requestPermissions(test_permissions);

    // check that requesting permissions works
    //expect(test_permissions_map[Permission.camera], PermissionStatus.granted);
    await expectLater(
        test_permissions_map[Permission.microphone], PermissionStatus.granted);

    // check permissions status again
    // for (Permission permission in test_permissions) {
    //   final actual_status = await plugin.checkPermissionStatus(permission);

    //   expect(actual_status, PermissionStatus.denied);
    // }
  });
}
