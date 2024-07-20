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

/// Conversion extension methods for the [LocationAccuracyStatus] type.
extension LocationAccuracyStatusValue on LocationAccuracyStatus {
  /// Converts the [LocationAccuracyStatus] value into an integer.
  int get value {
    switch (this) {
      case LocationAccuracyStatus.reduced:
        return 0;
      case LocationAccuracyStatus.precise:
        return 1;
      case LocationAccuracyStatus.unknown:
        return 2;
      default:
        throw UnimplementedError();
    }
  }

  /// Converts the supplied integer value into a [LocationAccuracyStatus] enum.
  static LocationAccuracyStatus statusByValue(int value) {
    return [
      LocationAccuracyStatus.reduced,
      LocationAccuracyStatus.precise,
      LocationAccuracyStatus.unknown,
    ][value];
  }
}
