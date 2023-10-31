import 'package:permission_handler_android/src/activity_aware.dart';
import 'package:permission_handler_android/src/android_object_mirrors/activity.dart';
import 'package:permission_handler_android/src/android_object_mirrors/context.dart';

/// A simple helper class that implements [ActivityAware] and holds references
/// to the [Context] and [Activity] instances.
class ActivityManager with ActivityAware {
  /// Creates a new instance of [ActivityManager] and registers for updates.
  ActivityManager() {
    registerForUpdates();
  }

  /// The Android application context.
  Context get applicationContext => _applicationContext;
  late final Context _applicationContext;

  /// The activity the Flutter engine is attached to.
  Activity? get activity => _activity;
  Activity? _activity;

  @override
  void onAttachedToApplication(Context applicationContext) {
    _applicationContext = applicationContext;
  }

  @override
  void onAttachedToActivity(Activity activity) {
    _activity = activity;
  }

  @override
  void onDetachedFromActivity() {
    _activity = null;
  }
}
