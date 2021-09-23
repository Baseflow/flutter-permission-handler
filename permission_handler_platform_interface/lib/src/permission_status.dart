part of permission_handler_platform_interface;

/// Defines the state of a [Permission].
enum PermissionStatus {
  /// The user denied access to the requested feature.
  denied,

  /// The user granted access to the requested feature.
  granted,

  /// The OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  restricted,

  ///User has authorized this application for limited access.
  /// *Only supported on iOS (iOS14+).*
  limited,

  /// Permission to the requested feature is permanently denied, the permission
  /// dialog will not be shown when requesting this permission. The user may
  /// still change the permission status in the settings.
  /// *Only supported on Android.*
  permanentlyDenied,
}

/// Conversion extension methods for the [PermissionStatus] type.
extension PermissionStatusValue on PermissionStatus {
  /// Converts the [PermissionStatus] value into an integer.
  int get value {
    switch (this) {
      case PermissionStatus.denied:
        return 0;
      case PermissionStatus.granted:
        return 1;
      case PermissionStatus.restricted:
        return 2;
      case PermissionStatus.limited:
        return 3;
      case PermissionStatus.permanentlyDenied:
        return 4;
      default:
        throw UnimplementedError();
    }
  }

  /// Converts the supplied integer value into a [PermissionStatus] enum.
  static PermissionStatus statusByValue(int value) {
    return [
      PermissionStatus.denied,
      PermissionStatus.granted,
      PermissionStatus.restricted,
      PermissionStatus.limited,
      PermissionStatus.permanentlyDenied,
    ][value];
  }
}

/// Utility getter extensions for the [PermissionStatus] type.
extension PermissionStatusGetters on PermissionStatus {
  /// If the user denied access to the requested feature.
  bool get isDenied => this == PermissionStatus.denied;

  /// If the user granted access to the requested feature.
  bool get isGranted => this == PermissionStatus.granted;

  /// If the OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  bool get isRestricted => this == PermissionStatus.restricted;

  /// If the user denied access to the requested feature and selected to never
  /// again show a request for this permission. The user may still change the
  /// permission status in the settings.
  /// *Only supported on Android.*
  ///
  /// WARNING: This can only be determined AFTER requesting this permission.
  /// Therefore make a `request` call first.
  bool get isPermanentlyDenied => this == PermissionStatus.permanentlyDenied;

  /// Indicates that permission for limited use of the resource is granted.
  bool get isLimited => this == PermissionStatus.limited;
}

/// Utility getter extensions for the `Future<PermissionStatus>` type.
extension FuturePermissionStatusGetters on Future<PermissionStatus> {
  /// If the user granted access to the requested feature.
  Future<bool> get isGranted async => (await this).isGranted;

  /// If the user denied access to the requested feature.
  Future<bool> get isDenied async => (await this).isDenied;

  /// If the OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  Future<bool> get isRestricted async => (await this).isRestricted;

  /// If the user denied access to the requested feature and selected to never
  /// again show a request for this permission. The user may still change the
  /// permission status in the settings.
  /// *Only supported on Android.*
  Future<bool> get isPermanentlyDenied async =>
      (await this).isPermanentlyDenied;

  /// Indicates that permission for limited use of the resource is granted.
  Future<bool> get isLimited async => (await this).isLimited;
}
