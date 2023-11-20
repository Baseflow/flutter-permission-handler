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
      final permissionStatus = await Permission.contacts.status;

      expect(permissionStatus, PermissionStatus.granted);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'PermissionActions on Permission: get shouldShowRequestRationale should return true when on android',
        () async {
      final mockPermissionHandlerPlatform = PermissionHandlerPlatform.instance;

      when(mockPermissionHandlerPlatform
              .shouldShowRequestPermissionRationale(Permission.contacts))
          .thenAnswer((_) => Future.value(true));

      await Permission.contacts.shouldShowRequestRationale;

      verify(mockPermissionHandlerPlatform
              .shouldShowRequestPermissionRationale(Permission.contacts))
          .called(1);
    });

    test('PermissionActions on Permission: request()', () async {
      final permissionRequest = Permission.contacts.request();

      expect(permissionRequest, isA<Future<PermissionStatus>>());
    });

    test('PermissionCheckShortcuts on Permission: get isGranted', () async {
      final isGranted = await Permission.contacts.isGranted;
      expect(isGranted, true);
    });

    test('PermissionCheckShortcuts on Permission: get isDenied', () async {
      final isDenied = await Permission.contacts.isDenied;
      expect(isDenied, false);
    });

    test('PermissionCheckShortcuts on Permission: get isRestricted', () async {
      final isRestricted = await Permission.contacts.isRestricted;
      expect(isRestricted, false);
    });

    test('PermissionCheckShortcuts on Permission: get isLimited', () async {
      final isLimited = await Permission.contacts.isLimited;
      expect(isLimited, false);
    });

    test('PermissionCheckShortcuts on Permission: get isPermanentlyDenied',
        () async {
      final isPermanentlyDenied = await Permission.contacts.isPermanentlyDenied;
      expect(isPermanentlyDenied, false);
    });

    test('PermissionCheckShortcuts on Permission: get isProvisional', () async {
      final isProvisional = await Permission.contacts.isProvisional;
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

    test('onDeniedCallback sets onDenied', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onDeniedCallback(callback).request();
      expect(callbackCalled, isTrue);
    });

    test('onGrantedCallback sets onGranted', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onGrantedCallback(callback).request();
      expect(callbackCalled, isFalse);
    });

    test('onPermanentlyDeniedCallback sets onPermanentlyDenied', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onPermanentlyDeniedCallback(callback).request();
      expect(callbackCalled, isFalse);
    });

    test('onRestrictedCallback sets onRestricted', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onRestrictedCallback(callback).request();
      expect(callbackCalled, isFalse);
    });

    test('onLimitedCallback sets onLimited', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onLimitedCallback(callback).request();
      expect(callbackCalled, isFalse);
    });

    test('onProvisionalCallback sets onProvisional', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onProvisionalCallback(callback).request();
      expect(callbackCalled, isFalse);
    });

    test('onGrantedCallback sets onGranted', () async {
      bool callbackCalled = false;
      callback() => callbackCalled = true;
      await Permission.location.onGrantedCallback(callback).request();
      expect(callbackCalled, isFalse);
    });

    test('ask calls the appropriate callback', () async {
      List<String> callbackCalled = [];

      await Permission.camera
          .onDeniedCallback(() => callbackCalled.add('Denied'))
          .onGrantedCallback(() => callbackCalled.add('Granted'))
          .onPermanentlyDeniedCallback(
              () => callbackCalled.add('PermanentlyDenied'))
          .onRestrictedCallback(() => callbackCalled.add('Restricted'))
          .onLimitedCallback(() => callbackCalled.add('Limited'))
          .onProvisionalCallback(() => callbackCalled.add('Provisional'))
          .request();

      expect(callbackCalled, ['Denied']);
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
