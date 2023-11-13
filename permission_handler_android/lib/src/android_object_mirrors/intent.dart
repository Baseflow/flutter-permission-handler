import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import '../android_permission_handler_api_impls.dart';
import 'uri.dart';

/// An intent is an abstract description of an operation to be performed.
///
/// See https://developer.android.com/reference/android/content/Intent.
class Intent extends JavaObject {
  /// Create an empty intent.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#Intent().
  Intent({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = IntentHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        ) {
    _hostApi.createFromInstance(this);
  }

  /// Create an intent with a given action.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#Intent(java.lang.String).
  Intent.action(
    String action, {
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = IntentHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        ) {
    _hostApi.createFromInstance(this);
    setAction(action);
  }

  final IntentHostApiImpl _hostApi;

  /// Activity Action: Perform a call to someone specified by the data.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#ACTION_CALL.
  static const String actionCall = 'android.intent.action.CALL';

  /// Sets the general action to be performed.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setAction(java.lang.String).
  void setAction(
    String action,
  ) {
    _hostApi.setActionFromInstance(this, action);
  }

  /// Sets the data this intent is operating on.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setData(android.net.Uri).
  void setData(
    Uri uri,
  ) {
    _hostApi.setDataFromInstance(this, uri);
  }

  /// Add a new category to the intent.
  ///
  /// Categories provide additional detail about the action the intent performs.
  /// When resolving an intent, only activities that provide all of the
  /// requested categories will be used.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addCategory(java.lang.String).
  void addCategory(
    String category,
  ) {
    _hostApi.addCategoryFromInstance(this, category);
  }

  /// Add additional flags to the intent (or with existing flags value).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addFlags(int).
  void addFlags(
    int flags,
  ) {
    _hostApi.addFlagsFromInstance(this, flags);
  }

  /// Set if the activity should be an option for the default action (center press) to perform on a piece of data.
  ///
  /// Constant Value: "android.intent.category.DEFAULT".
  ///
  /// See https://developer.android.com/reference/android/content/Intent#CATEGORY_DEFAULT.
  static const String categoryDefault = 'android.intent.category.DEFAULT';

  /// If set, this activity will become the start of a new task on this history stack.
  ///
  /// Constant Value: 268435456 (0x10000000).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#FLAG_ACTIVITY_NEW_TASK.
  static const int flagActivityNewTask = 0x10000000;

  /// If set, the new activity is not kept in the history stack.
  ///
  /// Constant Value: 1073741824 (0x40000000).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#FLAG_ACTIVITY_NO_HISTORY.
  static const int flagActivityNoHistory = 0x40000000;

  /// If set, the new activity is not kept in the list of recently launched activities.
  ///
  /// Constant Value: 8388608 (0x00800000).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS.
  static const int flagActivityExcludeFromRecents = 0x00800000;
}
