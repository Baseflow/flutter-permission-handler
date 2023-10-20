/// Class for retrieving various kinds of information related to the application
/// packages that are currently installed on the device. You can find this class
/// through Context#getPackageManager.
///
/// See https://developer.android.com/reference/android/content/pm/PackageManager.
class PackageManager {
  const PackageManager._();

  /// Permission check result: this is returned by checkPermission(String, String) if the permission has not been granted to the given package.
  ///
  /// Constant Value: -1 (0xffffffff)
  static const int permissionDenied = -1;

  /// Permission check result: this is returned by checkPermission(String, String) if the permission has been granted to the given package.
  ///
  /// Constant Value: 0 (0x00000000)
  static const int permissionGranted = 0;
}
