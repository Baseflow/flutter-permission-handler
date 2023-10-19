import 'package:flutter/foundation.dart';

import '../android_permission_handler_api_impls.dart';
import 'activity.dart';

/// Helper for accessing features in android.app.Activity.
///
/// See https://developer.android.com/reference/androidx/core/app/ActivityCompat.
class ActivityCompat {
  static ActivityCompatHostApiImpl _api = ActivityCompatHostApiImpl();

  @visibleForTesting
  static set api(ActivityCompatHostApiImpl api) => _api = api;

  /// Gets whether you should show UI with rationale before requesting a permission.
  static Future<bool> shouldShowRequestPermissionRationale(
    Activity activity,
    String permission,
  ) {
    return _api.shouldShowRequestPermissionRationaleFromInstance(
      activity,
      permission,
    );
  }
}
