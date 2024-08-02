part of permission_handler_platform_interface;

/// Defines the state of a [Permission].
enum PermissionStatus {
  /// The user denied access to the requested feature, permission needs to be
  /// asked first.
  denied,

  /// The user granted access to the requested feature.
  granted,

  /// The OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  ///
  /// *Only supported on iOS.*
  restricted,

  /// The user has authorized this application for limited access. So far this
  /// is only relevant for the Photo Library picker.
  ///
  /// *Only supported on iOS (iOS14+) and Android (Android 14+)*
  limited,

  /// Permission to the requested feature is permanently denied, the permission
  /// dialog will not be shown when requesting this permission. The user may
  /// still change the permission status in the settings.
  ///
  /// *On Android:*
  /// Android 11+ (API 30+): whether the user denied the permission for a second
  /// time.
  /// Below Android 11 (API 30): whether the user denied access to the requested
  /// feature and selected to never again show a request.
  ///
  /// *On iOS:*
  /// If the user has denied access to the requested feature.
  permanentlyDenied,

  /// The application is provisionally authorized to post non-interruptive user
  /// notifications.
  ///
  /// *Only supported on iOS (iOS12+).*
  provisional,
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
  ///
  /// *Only supported on iOS.*
  bool get isRestricted => this == PermissionStatus.restricted;

  /// If the permission to the requested feature is permanently denied, the
  /// permission dialog will not be shown when requesting this permission. The
  /// user may still change the permission status in the settings.
  ///
  /// *On Android:*
  /// Android 11+ (API 30+): whether the user denied the permission for a second
  /// time.
  /// Below Android 11 (API 30): whether the user denied access to the requested
  /// feature and selected to never again show a request.
  /// The user may still change the permission status in the settings.
  ///
  /// *On iOS:*
  /// If the user has denied access to the requested feature.
  bool get isPermanentlyDenied => this == PermissionStatus.permanentlyDenied;

  /// If the user has authorized this application for limited access. So far
  /// this is only relevant for the Photo Library picker.
  ///
  /// *Only supported on iOS (iOS14+).*
  bool get isLimited => this == PermissionStatus.limited;

  /// If the application is provisionally authorized to post non-interruptive
  /// user notifications.
  ///
  /// *Only supported on iOS (iOS12+).*
  bool get isProvisional => this == PermissionStatus.provisional;
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

  /// If the permission to the requested feature is permanently denied, the
  /// permission dialog will not be shown when requesting this permission. The
  /// user may still change the permission status in the settings.
  ///
  /// *On Android:*
  /// Android 11+ (API 30+): whether the user denied the permission for a second
  /// time.
  /// Below Android 11 (API 30): whether the user denied access to the requested
  /// feature and selected to never again show a request.
  ///
  /// *On iOS:*
  /// If the user has denied access to the requested feature.
  Future<bool> get isPermanentlyDenied async =>
      (await this).isPermanentlyDenied;

  /// If the user has authorized this application for limited access. So far
  /// this is only relevant for the Photo Library picker.
  ///
  /// *Only supported on iOS (iOS14+).*
  Future<bool> get isLimited async => (await this).isLimited;

  /// If the application is provisionally authorized to post non-interruptive
  /// user notifications.
  ///
  /// *Only supported on iOS (iOS12+).*
  Future<bool> get isProvisional async => (await this).isProvisional;
}
