part of permission_handler_platform_interface;

/// Defines the state of a [Permission].
enum PermissionStatus {
  /// The user denied access to the requested feature,
  /// permission needs to be asked first.
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
  permanentlyDenied,

  /// The application is provisionally authorized to post noninterruptive user
  /// notifications.
  ///
  /// *Only supported on iOS (iOS12+).*
  provisional,

  /// The application is granted write only access to the requested feature
  ///
  /// *Only supported on iOS(iOS17+).*
  writeOnly,

  /// The application is granted full access to the requested feature
  ///
  /// *Only supported on iOS(iOS17+).*
  fullAccess
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
      case PermissionStatus.provisional:
        return 5;
      case PermissionStatus.writeOnly:
        return 6;
      case PermissionStatus.fullAccess:
        return 7;
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
      PermissionStatus.provisional,
      PermissionStatus.writeOnly,
      PermissionStatus.fullAccess
    ][value];
  }
}

/// Utility getter extensions for the [PermissionStatus] type.
extension PermissionStatusGetters on PermissionStatus {
  /// If the user denied access to the requested feature,
  /// permission needs to be asked first.
  bool get isDenied => this == PermissionStatus.denied;

  /// If the user granted access to the requested feature.
  bool get isGranted => this == PermissionStatus.granted;

  /// If the OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  bool get isRestricted => this == PermissionStatus.restricted;

  /// *On Android:*
  /// Android 11+ (API 30+): whether the user denied the permission for a second
  /// time.
  /// Below Android 11 (API 30): whether the user denied access to the requested
  /// feature and selected to never again show a request.
  /// The user may still change the permission status in the settings.
  ///
  /// *On iOS:*
  /// If the user has denied access to the requested feature.
  /// The user may still change the permission status in the settings
  ///
  /// WARNING: This can only be determined AFTER requesting this permission.
  /// Therefore make a `request` call first.
  bool get isPermanentlyDenied => this == PermissionStatus.permanentlyDenied;

  /// Indicates that permission for limited use of the resource is granted.
  bool get isLimited => this == PermissionStatus.limited;

  /// If the application is provisionally authorized to post noninterruptive
  /// user notifications.
  bool get isProvisional => this == PermissionStatus.provisional;

  /// If the application is granted write only access to the requested feature
  /// *Only supported on iOS(17+).*
  bool get isWriteOnly => this == PermissionStatus.writeOnly;

  /// If the application is granted full access to the requested feature
  /// *Only supported on iOS(17+).*
  bool get isFullAccess => this == PermissionStatus.fullAccess;
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
  ///
  /// *Only supported on iOS.*
  Future<bool> get isRestricted async => (await this).isRestricted;

  /// *On Android:*
  /// Android 11+ (API 30+): whether the user denied the permission for a second
  /// time.
  /// Below Android 11 (API 30): whether the user denied access to the requested
  /// feature and selected to never again show a request.
  /// The user may still change the permission status in the settings.
  ///
  /// *On iOS:*
  /// If the user has denied access to the requested feature.
  /// The user may still change the permission status in the settings
  Future<bool> get isPermanentlyDenied async =>
      (await this).isPermanentlyDenied;

  /// Indicates that permission for limited use of the resource is granted.
  Future<bool> get isLimited async => (await this).isLimited;

  /// If the application is provisionally authorized to post noninterruptive
  /// user notifications.
  ///
  /// *Only supported on iOS.*
  Future<bool> get isProvisional async => (await this).isProvisional;

  /// If the application is granted write only access to the requested feature
  ///
  /// *Only supported on iOS(17+).*
  Future<bool> get isWriteOnly async => (await this).isWriteOnly;

  /// If the application is granted full access to the requested feature
  ///
  /// *Only supported on iOS(17+).*
  Future<bool> get isFullAccess async => (await this).isFullAccess;
}
