part of permission_handler_platform_interface;

/// Represent the current Location Accuracy Status on iOS 14.0 and higher and
/// Android 12 and higher.
enum LocationAccuracyStatus {
  /// An approximate location will be returned.
  reduced,

  /// A precise location will be returned.
  precise,

  /// We can't determine the location accuracy status.
  unknown,
}
