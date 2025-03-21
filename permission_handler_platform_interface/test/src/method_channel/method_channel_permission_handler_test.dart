import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_platform_interface/src/method_channel/method_channel_permission_handler.dart';
import 'method_channel_mock.dart';

List<Permission> get mockPermissions => List.of(<Permission>{
      Permission.contacts,
      Permission.camera,
      Permission.calendarWriteOnly,
    });

Map<Permission, PermissionStatus> get mockPermissionMap => {};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('checkPermissionStatus: When checking for permission', () {
    test('Should receive granted if user wants access to the requested feature',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkPermissionStatus',
        result: PermissionStatus.denied.value,
      );

      final permissionStatus = await MethodChannelPermissionHandler()
          .checkPermissionStatus(Permission.contacts);

      expect(permissionStatus, PermissionStatus.denied);
    });

    test('Should receive denied if user denied access to the requested feature',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkPermissionStatus',
        result: PermissionStatus.denied.value,
      );

      final permissionStatus = await MethodChannelPermissionHandler()
          .checkPermissionStatus(Permission.contacts);

      expect(permissionStatus, PermissionStatus.denied);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Should receive restricted if OS denied rights for to the requested feature',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkPermissionStatus',
        result: PermissionStatus.restricted.value,
      );

      final permissionStatus = await MethodChannelPermissionHandler()
          .checkPermissionStatus(Permission.contacts);

      expect(permissionStatus, PermissionStatus.restricted);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Should receive limited if user has authorized this application for limited access',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkPermissionStatus',
        result: PermissionStatus.limited.value,
      );

      final permissionStatus = await MethodChannelPermissionHandler()
          .checkPermissionStatus(Permission.contacts);

      expect(permissionStatus, PermissionStatus.limited);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Should receive permanentlyDenied if user denied access and selected to never show a request for this permission again',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkPermissionStatus',
        result: PermissionStatus.permanentlyDenied.value,
      );

      final permissionStatus = await MethodChannelPermissionHandler()
          .checkPermissionStatus(Permission.contacts);

      expect(permissionStatus, PermissionStatus.permanentlyDenied);
    });
  });

  group('checkServiceStatus: When checking for service', () {
    // ignore: lines_longer_than_80_chars
    test(
        'Should receive disabled if the service for the permission is disabled',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkServiceStatus',
        result: ServiceStatus.disabled.value,
      );

      final serviceStatus = await MethodChannelPermissionHandler()
          .checkServiceStatus(Permission.contacts);

      expect(serviceStatus, ServiceStatus.disabled);
    });

    test('Should receive enabled if the service for the permission is enabled',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkServiceStatus',
        result: ServiceStatus.enabled.value,
      );

      final serviceStatus = await MethodChannelPermissionHandler()
          .checkServiceStatus(Permission.contacts);

      expect(serviceStatus, ServiceStatus.enabled);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Should receive notApplicable if the permission does not have an associated service on the current platform',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'checkServiceStatus',
        result: ServiceStatus.notApplicable.value,
      );

      final serviceStatus = await MethodChannelPermissionHandler()
          .checkServiceStatus(Permission.contacts);

      expect(serviceStatus, ServiceStatus.notApplicable);
    });
  });

  group('openAppSettings: When opening the App settings', () {
    test('Should receive true if the page can be opened', () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'openAppSettings',
        result: true,
      );

      final hasOpenedAppSettings =
          await MethodChannelPermissionHandler().openAppSettings();

      expect(hasOpenedAppSettings, true);
    });

    test('Should receive false if an error occurred', () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'openAppSettings',
        result: false,
      );

      final hasOpenedAppSettings =
          await MethodChannelPermissionHandler().openAppSettings();

      expect(hasOpenedAppSettings, false);
    });
  });

  group('requestPermissions: When requesting for permission', () {
    // ignore: lines_longer_than_80_chars
    test('returns a Map with all the PermissionStatus of the given permissions',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'requestPermissions',
        result: mockPermissionMap,
      );

      final result = await MethodChannelPermissionHandler()
          .requestPermissions(mockPermissions);

      expect(result, isA<Map<Permission, PermissionStatus>>());
    });
  });

  group('shouldShowRequestPermissionRationale:', () {
    test(
        // ignore: lines_longer_than_80_chars
        'should return true when you should show a rationale for requesting permission.',
        () async {
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/permissions/methods',
        method: 'shouldShowRequestPermissionRationale',
        result: true,
      );

      final shouldShowRationale = await MethodChannelPermissionHandler()
          .shouldShowRequestPermissionRationale(mockPermissions.first);

      expect(shouldShowRationale, true);
    });
  });
}
