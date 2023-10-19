import 'dart:async';

import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:flutter_instance_manager/test/test_instance_manager.pigeon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_android/permission_handler_android.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final MockTestInstanceManagerHostApi mockInstanceManagerHostApi;

  setUpAll(() {
    mockInstanceManagerHostApi = MockTestInstanceManagerHostApi();
    TestInstanceManagerHostApi.setup(mockInstanceManagerHostApi);
  });

  tearDown(() {
    Android.reset();
  });

  tearDown(() {
    TestInstanceManagerHostApi.setup(null);
  });

  group('Android', () {
    group('`register`', () {
      group('`onActivityAttached`', () {
        test('does not emit initially', () async {
          // > Arrange
          final Completer<void> callbackCompleter = Completer<void>();

          // > Act
          Android.register(
            onAttachedToActivityCallback: callbackCompleter.complete,
            onDetachedFromActivityCallback: () {},
          );

          // > Assert
          expect(callbackCompleter.isCompleted, isFalse);
        });

        test('emits activity if it was already attached', () async {
          // > Arrange
          final Completer<Activity> activityCompleter = Completer<Activity>();
          final Activity activity = Activity.detached();
          final ActivityFlutterApiImpl activityFlutterApi =
              ActivityFlutterApiImpl();
          activityFlutterApi.attachToActivity(activity);

          // > Act
          Android.register(
            onAttachedToActivityCallback: activityCompleter.complete,
            onDetachedFromActivityCallback: () {},
            activityFlutterApi: activityFlutterApi,
          );

          // > Assert
          expect(activityCompleter.isCompleted, isTrue);
          expect(activityCompleter.future, completion(activity));
        });

        test('emits a new activity if it attaches', () async {
          // > Arrange
          final Completer<Activity> activityCompleter = Completer<Activity>();

          final Activity activity = Activity.detached();

          final ActivityFlutterApiImpl activityFlutterApiImpl =
              ActivityFlutterApiImpl();

          Android.register(
            onAttachedToActivityCallback: activityCompleter.complete,
            onDetachedFromActivityCallback: () {},
            activityFlutterApi: activityFlutterApiImpl,
          );

          // > Act
          activityFlutterApiImpl.attachToActivity(activity);

          // > Assert
          expect(activityCompleter.isCompleted, isTrue);
          expect(
            activityCompleter.future,
            completion(activity),
          );
        });
      });

      group('`onActivityDetached`', () {
        test('does not emit initially', () async {
          // > Arrange
          final Completer<void> callbackCompleter = Completer<void>();

          // > Act
          Android.register(
            onAttachedToActivityCallback: (Activity activity) {},
            onDetachedFromActivityCallback: callbackCompleter.complete,
          );

          // > Assert
          expect(callbackCompleter.isCompleted, isFalse);
        });

        test('does not emit when activity was already attached', () async {
          // > Arrange
          final Completer<void> callbackCompleter = Completer<void>();
          final ActivityFlutterApiImpl activityFlutterApiImpl =
              ActivityFlutterApiImpl();
          final Activity activity = Activity.detached();
          activityFlutterApiImpl.attachToActivity(activity);

          // > Act
          Android.register(
            onAttachedToActivityCallback: (Activity activity) {},
            onDetachedFromActivityCallback: callbackCompleter.complete,
            activityFlutterApi: activityFlutterApiImpl,
          );

          // > Assert
          expect(callbackCompleter.isCompleted, isFalse);
        });

        test('does not emit when an activity attaches', () async {
          // > Arrange
          final Completer<void> callbackCompleter = Completer<void>();
          final ActivityFlutterApiImpl activityFlutterApiImpl =
              ActivityFlutterApiImpl();
          final Activity activity = Activity.detached();
          activityFlutterApiImpl.attachToActivity(activity);
          Android.register(
            onAttachedToActivityCallback: (Activity activity) {},
            onDetachedFromActivityCallback: callbackCompleter.complete,
            activityFlutterApi: activityFlutterApiImpl,
          );

          // > Act
          activityFlutterApiImpl.attachToActivity(activity);

          // > Assert
          expect(callbackCompleter.isCompleted, isFalse);
        });
      });
    });

    group('`unregister`', () {
      test('Successfully unregisters callbacks', () async {
        // > Arrange
        final ActivityFlutterApiImpl activityFlutterApiImpl =
            ActivityFlutterApiImpl();
        final Completer<void> attachCompleter = Completer<void>();
        final Completer<void> detachCompleter = Completer<void>();
        onAttachCallback(Activity activity) => attachCompleter.complete();
        onDetachCallback() => detachCompleter.complete();
        Android.register(
          onAttachedToActivityCallback: onAttachCallback,
          onDetachedFromActivityCallback: onDetachCallback,
          activityFlutterApi: activityFlutterApiImpl,
        );
        Android.unregister(
          onAttachedToActivityCallback: onAttachCallback,
          onDetachedFromActivityCallback: onDetachCallback,
        );

        // > Act
        activityFlutterApiImpl.attachToActivity(Activity.detached());
        activityFlutterApiImpl.detachFromActivity();

        // > Assert
        expect(attachCompleter.isCompleted, isFalse);
        expect(detachCompleter.isCompleted, isFalse);
      });
    });
  });
}
