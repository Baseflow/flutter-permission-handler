import '../permission_handler.pigeon.dart';

/// Provides access to environment variables.
///
/// See https://developer.android.com/reference/android/os/Environment.
class Environment {
  const Environment._();

  static final EnvironmentHostApi _hostApi = EnvironmentHostApi();

  /// Returns whether the calling app has All Files Access on the primary shared/external storage media.
  ///
  /// Declaring the permission [Manifest.permission.manageExternalStorage] is
  /// not enough to gain the access. To request access, use
  /// [Settings.actionManageAppAllFilesAccessPermission].
  ///
  /// See https://developer.android.com/reference/android/os/Environment#isExternalStorageManager().
  static Future<bool> isExternalStorageManager() {
    return _hostApi.isExternalStorageManager();
  }
}
