import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

    test(
        // ignore: lines_longer_than_80_chars
        'PermissionActions on Permission: get shouldShowRequestRationale should return true when on android',
        () async {
      final mockPermissionHandlerPlatform = PermissionHandlerPlatform.instance;

      when(mockPermissionHandlerPlatform
              .shouldShowRequestPermissionRationale(Permission.calendar))
          .thenAnswer((_) => Future.value(true));

      await Permission.calendar.shouldShowRequestRationale;

      verify(mockPermissionHandlerPlatform
              .shouldShowRequestPermissionRationale(Permission.calendar))
          .called(1);
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

    test('PermissionCheckShortcuts on Permission: get isProvisional', () async {
      final isProvisional = await Permission.calendar.isProvisional;
      expect(isProvisional, false);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'ServicePermissionActions on PermissionWithService: get ServiceStatus returns the right service status',
        () async {
      var serviceStatus = await Permission.phone.serviceStatus;

      expect(serviceStatus, ServiceStatus.enabled);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'PermissionListActions on List<Permission>: request() on  a list returns a Map<Permission, PermissionStatus>',
        () async {
      var permissionList = <Permission>[];
      final permissionMap = await permissionList.request();

      expect(permissionMap, isA<Map<Permission, PermissionStatus>>());
    });
  });

  group('PermissionCallbacks', () {
    setUp(() {
      PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
    });

    test('onDeniedCallback sets onDenied', () {
      final permission = Permission.camera;
      final callback = () => print('Permission denied');
      permission.onDeniedCallback(callback);
      expect(PermissionCallbacks.onDenied, equals(callback));
    });

    test('onGrantedCallback sets onGranted', () {
      final permission = Permission.camera;
      final callback = () => print('Permission granted');
      permission.onGrantedCallback(callback);
      expect(PermissionCallbacks.onGranted, equals(callback));
    });

    test('onPermanentlyDeniedCallback sets onPermanentlyDenied', () {
      final permission = Permission.camera;
      final callback = () => print('Permission permanently denied');
      permission.onPermanentlyDeniedCallback(callback);
      expect(PermissionCallbacks.onPermanentlyDenied, equals(callback));
    });

    test('onRestrictedCallback sets onRestricted', () {
      final permission = Permission.camera;
      final callback = () => print('Permission restricted');
      permission.onRestrictedCallback(callback);
      expect(PermissionCallbacks.onRestricted, equals(callback));
    });

    test('onLimitedCallback sets onLimited', () {
      final permission = Permission.camera;
      final callback = () => print('Permission limited');
      permission.onLimitedCallback(callback);
      expect(PermissionCallbacks.onLimited, equals(callback));
    });

    test('onProvisionalCallback sets onProvisional', () {
      final permission = Permission.camera;
      final callback = () => print('Permission provisional');
      permission.onProvisionalCallback(callback);
      expect(PermissionCallbacks.onProvisional, equals(callback));
    });

    test('ask calls the appropriate callback', () async {
      final status = Permission.camera.onDeniedCallback(() {
        print('Permission denied');
      }).onGrantedCallback(() {
        print('Permission granted');
      }).onPermanentlyDeniedCallback(() {
        print('Permission permanently denied');
      }).onRestrictedCallback(() {
        print('Permission restricted');
      }).onLimitedCallback(() {
        print('Permission limited');
      }).onProvisionalCallback(() {
        print('Permission provisional');
      }).ask();

      expect(status, isA<Future<PermissionStatus>>());
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
  Future<bool> shouldShowRequestPermissionRationale(Permission? permission) {
    return super.noSuchMethod(
      Invocation.method(
        #shouldShowPermissionRationale,
        [permission],
      ),
      returnValue: Future.value(true),
    );
  }
}
