import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:flutter_instance_manager/test/test_instance_manager.pigeon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_android/permission_handler_android.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<List<Object?>> requestLog;
  late final MockTestInstanceManagerHostApi mockInstanceManagerHostApi;

  late InstanceManager instanceManager;
  late AndroidActivityMixinUser androidActivityUser;
  late ActivityHostApiImpl hostApi;
  late ActivityFlutterApiImpl flutterApi;

  setUpAll(() {
    mockInstanceManagerHostApi = MockTestInstanceManagerHostApi();
    TestInstanceManagerHostApi.setup(mockInstanceManagerHostApi);
  });

  setUp(() {
    requestLog = <List<Object?>>[];

    instanceManager = InstanceManager(onWeakReferenceRemoved: (_) {});

    androidActivityUser = AndroidActivityMixinUser();
    hostApi = ActivityHostApiImpl(instanceManager: instanceManager);
    flutterApi = ActivityFlutterApiImpl(instanceManager: instanceManager);
    androidActivityUser.hostApi = hostApi;
    androidActivityUser.flutterApi = flutterApi;
    AndroidActivity.register();
    flutterApi.create('activity_instance_id');
  });

  tearDown(() {
    TestInstanceManagerHostApi.setup(null);
  });

  group('shouldShowRationale', () {
    setUpAll(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale',
        (ByteData? message) async {
          const MessageCodec codec = StandardMessageCodec();

          final List<Object?> request = codec.decodeMessage(message);
          requestLog.add(request);

          final response = [true];
          return codec.encodeMessage(response);
        },
      );
    });

    test('returns properly', () async {
      // > Act
      final shouldShowRequestPermissionRationale =
          await androidActivityUser.shouldShowRequestPermissionRationale(
        Manifest.permission.readCalendar,
      );

      // > Assert
      expect(
        requestLog,
        [
          [
            'activity_instance_id',
            'android.permission.READ_CALENDAR',
          ],
        ],
      );
      expect(shouldShowRequestPermissionRationale, isTrue);
    });
  });

  group('checkPermissionStatus', () {
    setUpAll(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.checkSelfPermission',
        (ByteData? message) async {
          const MessageCodec codec = StandardMessageCodec();

          final List<Object?> request = codec.decodeMessage(message);
          requestLog.add(request);

          final response = [PackageManager.permissionGranted];
          return codec.encodeMessage(response);
        },
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale',
        (ByteData? message) async {
          const MessageCodec codec = StandardMessageCodec();

          final response = [true];
          return codec.encodeMessage(response);
        },
      );
    });

    test('returns properly', () async {
      // > Arrange
      SharedPreferences.setMockInitialValues({
        Manifest.permission.readCalendar: true,
      });

      // > Act
      final permissionStatus = await androidActivityUser.checkSelfPermission(
        Manifest.permission.readCalendar,
      );

      // > Assert
      expect(
        requestLog,
        [
          [
            'activity_instance_id',
            'android.permission.READ_CALENDAR',
          ],
        ],
      );
      expect(permissionStatus, PackageManager.permissionGranted);
    });
  });

  group('requestPermissions', () {
    setUpAll(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.requestPermissions',
        (ByteData? message) async {
          const MessageCodec codec = StandardMessageCodec();

          final List<Object?> request = codec.decodeMessage(message);
          requestLog.add(request);

          flutterApi.onRequestPermissionsResult(
            314,
            [Manifest.permission.readCalendar],
            [PackageManager.permissionGranted],
          );

          final response = [PackageManager.permissionGranted];
          return codec.encodeMessage(response);
        },
      );
    });

    test('returns properly via onRequestPermissionsResult', () async {
      // > Arrange
      const int requestCode = 314;
      final List<String> permissions = [
        Manifest.permission.readCalendar,
        Manifest.permission.writeCalendar,
      ];

      // > Act
      await androidActivityUser.requestPermissions(
        permissions,
        requestCode,
      );

      // > Assert
      expect(androidActivityUser.onRequestPermissionsResultCallCount, 1);
    });
  });
}

class AndroidActivityMixinUser extends Mock with AndroidActivity {
  int onRequestPermissionsResultCallCount = 0;

  @override
  void onRequestPermissionsResult(
    int requestCode,
    List<String> permissions,
    List<int> grantResults,
  ) {
    onRequestPermissionsResultCallCount++;
  }
}
