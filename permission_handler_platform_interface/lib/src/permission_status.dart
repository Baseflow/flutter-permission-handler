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

  /// The permission is in an unknown state.
  unknown,

  /// The user denied access to the requested feature and selected to never
  /// again show a request for this permission.
  /// *Only supported on Android.*
  neverAskAgain,
}

extension PermissionStatusValue on PermissionStatus {
  int get value {
    switch (this) {
      case PermissionStatus.denied:
        return 0;
      case PermissionStatus.granted:
        return 1;
      case PermissionStatus.restricted:
        return 2;
      case PermissionStatus.unknown:
        return 3;
      case PermissionStatus.neverAskAgain:
        return 4;
      default:
        throw UnimplementedError();
    }
  }

  static PermissionStatus statusByValue(int value) {
    return [
      PermissionStatus.denied,
      PermissionStatus.granted,
      PermissionStatus.restricted,
      PermissionStatus.unknown,
      PermissionStatus.neverAskAgain,
    ][value];
  }
}

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

  /// If the permission is in an unknown state.
  bool get isUnknown => this == PermissionStatus.unknown;

  /// If the user denied access to the requested feature and selected to never
  /// again show a request for this permission.
  /// *Only supported on Android.*
  bool get isNeverAskAgain => this == PermissionStatus.neverAskAgain;
}

extension FuturePermissionStatusGetters on Future<PermissionStatus> {
  /// If the user denied access to the requested feature.
  Future<bool> get isDenied async => (await this).isDenied;

  /// If the user granted access to the requested feature.
  Future<bool> get isGranted async => (await this).isGranted;

  /// If the OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  Future<bool> get isRestricted async => (await this).isRestricted;

  /// If the permission is in an unknown state.
  Future<bool> get isUnknown async => (await this).isUnknown;

  /// If the user denied access to the requested feature and selected to never
  /// again show a request for this permission.
  /// *Only supported on Android.*
  Future<bool> get isNeverAskAgain async => (await this).isNeverAskAgain;
}
