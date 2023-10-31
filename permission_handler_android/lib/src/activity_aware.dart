import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

import 'android_object_mirrors/activity.dart';
import 'android_object_mirrors/context.dart';

/// Manages registered [ActivityAware] instances.
///
/// This class provided static methods for notifying registered [ActivityAware]
/// instances of changes to the [Activity] and [Context] instances in Android.
///
/// By splitting these methods out into an extension, we avoid the risk of
/// developers accidentally calling these methods directly from an
/// [ActivityAware] instance.
extension ActivityAwareManager on ActivityAware {
  static final List<ActivityAware> _registeredInstances = [];
  static late final Context _applicationContext;
  static Activity? _attachedActivity;

  /// Notifies all registered [ActivityAware] instances that the Flutter engine
  /// attached to the application.
  static void notifyAttachedToApplication(Context applicationContext) {
    for (final ActivityAware instance in _registeredInstances) {
      instance.onAttachedToApplication(applicationContext);
    }
  }

  /// Notifies all registered [ActivityAware] instances that the Flutter engine
  /// attached to an [Activity].
  static void notifyAttachedToActivity(Activity activity) {
    for (final ActivityAware instance in _registeredInstances) {
      instance.onAttachedToActivity(activity);
    }
  }

  /// Notifies all registered [ActivityAware] instances that the Flutter engine
  /// detached from an [Activity].
  static void notifyDetachedFromActivity() {
    for (final ActivityAware instance in _registeredInstances) {
      instance.onDetachedFromActivity();
    }
  }
}

/// Abstract class for classes that need to hook into the Android system.
///
/// **NOTE**: make sure to call [registerForUpdates] to receive updates.
///
/// Obtains references, through callbacks, to the Android application context
/// and the activity the Flutter engine is attached to.
abstract class ActivityAware {
  /// Register this [ActivityAware] instance for updates about the Android system.
  ///
  /// Updates are delivered through the different callbacks.
  ///
  /// This method should usually be called as soon as the [ActivityAware]
  /// instance is created.
  void registerForUpdates() {
    AndroidPermissionHandlerFlutterApis.instance.ensureSetUp();

    _registeredInstances.add(this);

    onAttachedToApplication(_applicationContext);
    if (_attachedActivity != null) {
      onAttachedToActivity(_attachedActivity!);
    }
  }

  /// This [ActivityAware] has been associated with an application.
  ///
  /// The provided [applicationContext] may be cached and referenced forever, as
  /// it will be valid for the lifetime of the application.
  void onAttachedToApplication(Context applicationContext);

  /// This [ActivityAware] is now associated with an [Activity].
  ///
  /// This method can be invoked in 1 of 2 situations:
  /// - This [ActivityAware] was just registered an a running [Activity] was
  /// already connected.
  /// - This [ActivityAware] was already registered and the Flutter engine just
  /// attached to an [Activity].
  ///
  /// [activity] may be referenced until [onDetachedFromActivity] is invoked.
  /// At the conclusion of that method, the binding is no longer valid. Clear
  /// any references to [activity], and do not invoke any further methods on it.
  void onAttachedToActivity(Activity activity);

  /// This plugin has been detached from an [Activity].
  ///
  /// Detachment can occur for a number of reasons.
  /// - The app is no longer visible and the [Activity] instance has been
  /// destroyed.
  /// - The Flutter engine that this plugin is connected to has been detached
  /// from its FlutterView.
  /// - The plugin has been removed from its Flutter engine.
  ///
  /// By the end of this method, the [Activity] that was made available in
  /// [onAttachedToActivity] is no longer valid. Any references to the
  /// associated [Activity] should be cleared.
  ///
  /// Any listeners that were registered in [onAttachedToActivity] should be
  /// deregistered here to avoid a possible memory leak and other side effects.
  void onDetachedFromActivity();
}
