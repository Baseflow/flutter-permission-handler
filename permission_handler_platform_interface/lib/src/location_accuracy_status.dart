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

/// Utility getter extensions for the [LocationAccuracyStatus] type.
extension LocationAccuracyStatusGetters on LocationAccuracyStatus {
  /// If the location accuracy is reduced.
  bool get isReduced => this == LocationAccuracyStatus.reduced;

  /// If the location accuracy is precise.
  bool get isPrecise => this == LocationAccuracyStatus.precise;

  /// If the location accuracy status is unknown.
  bool get isUnknown => this == LocationAccuracyStatus.unknown;
}

/// Utility getter extensions for the `Future<LocationAccuracyStatus>` type.
extension FutureLocationAccuracyStatusGetters
    on Future<LocationAccuracyStatus> {
  /// If the location accuracy is reduced.
  Future<bool> get isReduced async => (await this).isReduced;

  /// If the location accuracy is precise.
  Future<bool> get isPrecise async => (await this).isPrecise;

  /// If the location accuracy status is unknown.
  Future<bool> get isUnknown async => (await this).isUnknown;
}
