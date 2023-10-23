import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:flutter_instance_manager/test/test_instance_manager.pigeon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_android/permission_handler_android.dart';
import 'package:permission_handler_android/src/android_object_mirrors/package_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<List<Object?>> requestLog;
  late final MockTestInstanceManagerHostApi mockInstanceManagerHostApi;

  setUpAll(() {
    mockInstanceManagerHostApi = MockTestInstanceManagerHostApi();
    TestInstanceManagerHostApi.setup(mockInstanceManagerHostApi);
  });

  setUp(() {
    requestLog = <List<Object?>>[];
  });

  tearDown(() {
    TestInstanceManagerHostApi.setup(null);
  });

  group('ActivityFlutterApiImpl', () {
    test('`create` calls attached callback', () async {
      // > Arrange
      final Completer<Activity?> completer = Completer<Activity?>();
      final ActivityFlutterApiImpl activityFlutterApiImpl =
          ActivityFlutterApiImpl(
        instanceManager: InstanceManager(onWeakReferenceRemoved: (_) {}),
      );
      activityFlutterApiImpl.addOnAttachedToActivityCallback(
        (activity) => completer.complete(activity),
      );

      // > Act
      activityFlutterApiImpl.create('activity_instance_id');

      // > Assert
      expect(completer.isCompleted, isTrue);
      expect(await completer.future, isA<Activity>());
    });

    test('`dispose` calls detached callback', () async {
      // > Arrange
      final Completer<void> completer = Completer<void>();
      final ActivityFlutterApiImpl activityFlutterApiImpl =
          ActivityFlutterApiImpl(
        instanceManager: InstanceManager(onWeakReferenceRemoved: (_) {}),
      );
      activityFlutterApiImpl.create('activity_instance_id');
      activityFlutterApiImpl
          .addOnDetachedFromActivityCallback(() => completer.complete());

      // > Act
      activityFlutterApiImpl.dispose('activity_instance_id');

      // > Assert
      expect(completer.isCompleted, isTrue);
    });
  });

  group('PermissionHandlerAndroid', () {
    group('shouldShowRequestPermissionRationale', () {
      setUpAll(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler(
          'dev.flutter.pigeon.permission_handler_android.ActivityCompatHostApi.shouldShowRequestPermissionRationale',
          (ByteData? message) async {
            const MessageCodec codec = StandardMessageCodec();

            final List<Object?> request = codec.decodeMessage(message);
            requestLog.add(request);

            final response = [true];
            return codec.encodeMessage(response);
          },
        );
      });

      test(
          'throws `MissingAndroidActivityException` if no activity is attached',
          () async {
        // > Arrange
        final instanceManager = InstanceManager(
          onWeakReferenceRemoved: (_) {},
        );
        ActivityCompat.api = ActivityCompatHostApiImpl(
          instanceManager: instanceManager,
        );

        final activity = Activity.detached();
        instanceManager.addHostCreatedInstance(
          activity,
          'activity_instance_id',
        );

        final permissionHandler = PermissionHandlerAndroid();

        // > Act
        shouldShowRequestPermissionRationale() async =>
            await permissionHandler.shouldShowRequestPermissionRationale(
                Permission.calendarFullAccess);

        // > Assert
        expect(
          shouldShowRequestPermissionRationale(),
          throwsA(isA<MissingAndroidActivityException>()),
        );
      });

      test('returns properly', () async {
        // > Arrange
        final instanceManager = InstanceManager(
          onWeakReferenceRemoved: (_) {},
        );
        ActivityCompat.api = ActivityCompatHostApiImpl(
          instanceManager: instanceManager,
        );
        final activity = Activity.detached();
        instanceManager.addHostCreatedInstance(
          activity,
          'activity_instance_id',
        );

        final permissionHandler = PermissionHandlerAndroid();
        permissionHandler.activity = activity;

        // > Act
        final shouldShowRequestPermissionRationale =
            await permissionHandler.shouldShowRequestPermissionRationale(
                Permission.calendarFullAccess);

        // > Assert
        expect(
          requestLog,
          [
            [
              'activity_instance_id',
              'android.permission.READ_CALENDAR',
            ],
            [
              'activity_instance_id',
              'android.permission.WRITE_CALENDAR',
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
          'dev.flutter.pigeon.permission_handler_android.ActivityCompatHostApi.checkSelfPermission',
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
          'dev.flutter.pigeon.permission_handler_android.ActivityCompatHostApi.shouldShowRequestPermissionRationale',
          (ByteData? message) async {
            const MessageCodec codec = StandardMessageCodec();

            final response = [true];
            return codec.encodeMessage(response);
          },
        );
      });

      test(
          'throws `MissingAndroidActivityException` if no activity is attached',
          () async {
        // > Arrange
        final instanceManager = InstanceManager(
          onWeakReferenceRemoved: (_) {},
        );
        ActivityCompat.api = ActivityCompatHostApiImpl(
          instanceManager: instanceManager,
        );

        final activity = Activity.detached();
        instanceManager.addHostCreatedInstance(
          activity,
          'activity_instance_id',
        );

        final permissionHandler = PermissionHandlerAndroid();

        // > Act
        checkPermissionStatus() async => await permissionHandler
            .checkPermissionStatus(Permission.calendarFullAccess);

        // > Assert
        expect(
          checkPermissionStatus(),
          throwsA(isA<MissingAndroidActivityException>()),
        );
      });

      test('returns properly', () async {
        // > Arrange
        final instanceManager = InstanceManager(
          onWeakReferenceRemoved: (_) {},
        );
        ActivityCompat.api = ActivityCompatHostApiImpl(
          instanceManager: instanceManager,
        );
        final activity = Activity.detached();
        instanceManager.addHostCreatedInstance(
          activity,
          'activity_instance_id',
        );

        final permissionHandler = PermissionHandlerAndroid();
        permissionHandler.activity = activity;
        SharedPreferences.setMockInitialValues({
          Manifest.permission.readCalendar: true,
          Manifest.permission.writeCalendar: true,
        });

        // > Act
        final permissionStatus = await permissionHandler
            .checkPermissionStatus(Permission.calendarFullAccess);

        // > Assert
        expect(
          requestLog,
          [
            [
              'activity_instance_id',
              'android.permission.READ_CALENDAR',
            ],
            [
              'activity_instance_id',
              'android.permission.WRITE_CALENDAR',
            ],
          ],
        );
        expect(permissionStatus, PermissionStatus.granted);
      });
    });
  });
}
