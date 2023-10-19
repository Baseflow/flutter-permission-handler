import 'package:flutter/material.dart';

import 'android_permission_handler_api_impls.dart';
import 'android_object_mirrors/activity.dart';
import 'permission_handler.pigeon.dart';

/// Provides access to the attached Android Activity.
///
/// Usage:
/// ```dart
/// void main() {
///   Android.register(
///     onAttachedToActivityCallback((Activity activity) => this.activity = activity),
///     onDetachedFromActivityCallback(() => this.activity = null),
///   );
/// }
///
/// void someMethod() {
///   if (activity != null) {
///     activity.getSystemService(Context.LOCATION_SERVICE);
///
///     ActivityCompat.shouldShowRequestPermissionRationale(
///       activity,
///       'permission_name',
///     );
///   }
/// }
/// ```
class Android {
  /// Private constructor for creating a new instance of [Android].
  const Android._({
    required ActivityFlutterApiImpl activityFlutterApi,
  }) : _activityFlutterApi = activityFlutterApi;

  static Android? _instance;

  /// Resets the [Android] singleton instance, by setting it to `null`.
  ///
  /// For testing purposes only.
  @visibleForTesting
  static void reset() {
    _instance = null;
  }

  /// The [ActivityFlutterApiImpl] instance used to receive callbacks from the
  /// Android side.
  final ActivityFlutterApiImpl? _activityFlutterApi;

  /// Register callbacks for [Activity] changes from Android.
  ///
  /// The [Activity] can be used to access Android APIs.
  /// If [onDetachedFromActivityCallback] is called, the [Activity] received in
  /// [onAttachedToActivityCallback] is no longer valid and should not be used.
  ///
  /// **Note:** If an activity is already attached before registration,
  /// [onAttachedToActivityCallback] is called immediately.
  factory Android.register({
    required void Function(Activity activity) onAttachedToActivityCallback,
    required void Function() onDetachedFromActivityCallback,
    @visibleForTesting ActivityFlutterApiImpl? activityFlutterApi,
  }) {
    if (_instance == null) {
      final ActivityFlutterApiImpl activityFlutterApiImpl =
          activityFlutterApi ?? ActivityFlutterApiImpl();
      ActivityFlutterApi.setup(activityFlutterApiImpl);
      _instance = Android._(activityFlutterApi: activityFlutterApiImpl);
    }

    _instance!._activityFlutterApi!
        .addOnAttachedToActivityCallback(onAttachedToActivityCallback);
    _instance!._activityFlutterApi!
        .addOnDetachedFromActivityCallback(onDetachedFromActivityCallback);

    return _instance!;
  }

  /// Unregister callbacks for [Activity] changes from Android.
  ///
  /// Unregister callbacks so garbage collection can occur. For example, when
  /// calling `Android.register(...)` directly from a [Widget], the widget
  /// might not be garbage collected when it is disposed. This can happen when
  /// one of the callbacks alters the state of the widget. This causes memory
  /// leaks and should be avoided.
  static void unregister({
    void Function(Activity activity)? onAttachedToActivityCallback,
    void Function()? onDetachedFromActivityCallback,
  }) {
    if (_instance == null) return;

    if (onAttachedToActivityCallback != null) {
      _instance!._activityFlutterApi!
          .removeOnAttachedToActivityCallback(onAttachedToActivityCallback);
    }

    if (onDetachedFromActivityCallback != null) {
      _instance!._activityFlutterApi!
          .removeOnDetachedFromActivityCallback(onDetachedFromActivityCallback);
    }
  }
}
