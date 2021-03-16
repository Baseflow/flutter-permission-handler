import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('PermissionHandler', () {
    setUp(() {
      PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
    });

    test('openAppSettings', () async {
      final hasOpened = await openAppSettings();

      expect(hasOpened, true);
    });

    test('PermissionActions on Permission: get status', () async {
      final permissionStatus = await Permission.calendar.status;

      expect(permissionStatus, PermissionStatus.granted);
    });

    test('PermissionActions on Permission: get shouldShowRequestRationale',
        () async {
      final requestRationale =
          await Permission.calendar.shouldShowRequestRationale;

      expect(requestRationale, false);
    });

    test('PermissionActions on Permission: request()', () async {
      final permissionRequest = Permission.calendar.request();

      expect(permissionRequest, isA<Future<PermissionStatus>>());
    });

    test('PermissionCheckShortcuts on Permission: get isGranted', () async {
      final isGranted = await Permission.calendar.isGranted;
      expect(isGranted, true);
    });

    test('PermissionCheckShortcuts on Permission: get isDenied', () async {
      final isDenied = await Permission.calendar.isDenied;
      expect(isDenied, false);
    });

    test('PermissionCheckShortcuts on Permission: get isRestricted', () async {
      final isRestricted = await Permission.calendar.isRestricted;
      expect(isRestricted, false);
    });

    test('PermissionCheckShortcuts on Permission: get isLimited', () async {
      final isLimited = await Permission.calendar.isLimited;
      expect(isLimited, false);
    });

    test('PermissionCheckShortcuts on Permission: get isPermanentlyDenied',
        () async {
      final isPermanentlyDenied = await Permission.calendar.isPermanentlyDenied;
      expect(isPermanentlyDenied, false);
    });
  });
}

class MockPermissionHandlerPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PermissionHandlerPlatform {
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) =>
      Future.value(PermissionStatus.granted);

  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) =>
      Future.value(ServiceStatus.enabled);

  @override
  Future<bool> openAppSettings() => Future.value(true);

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    var permissionsMap = <Permission, PermissionStatus>{};
    return Future.value(permissionsMap);
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(Permission permission) =>
      Future.value(true);
}
