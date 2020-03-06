part of permission_handler_platform_interface;

/// Defines the state of a permission group
class PermissionStatus {
  const PermissionStatus._(this.value);

  /// Integer representation of the [PermissionStatus].
  final int value;

  /// Permission to access the requested feature is denied by the user.
  static const PermissionStatus denied = PermissionStatus._(0);

  /// Permission to access the requested feature is granted by the user.
  static const PermissionStatus granted = PermissionStatus._(1);

  /// Permission to access the requested feature is denied by the OS (only on
  /// iOS). The user cannot change this app's status, possibly due to active
  /// restrictions such as parental controls being in place.
  static const PermissionStatus restricted = PermissionStatus._(2);

  /// Permission is in an unknown state
  static const PermissionStatus unknown = PermissionStatus._(3);

  /// Permission to access the requested feature is denied by the user and
  /// never show selected (only on Android).
  static const PermissionStatus neverAskAgain = PermissionStatus._(4);

  /// Returns a list of all possible [PermissionStatus] values.
  static const List<PermissionStatus> values = <PermissionStatus>[
    denied,
    granted,
    restricted,
    unknown,
    neverAskAgain,
  ];

  static const List<String> _names = <String>[
    'denied',
    'granted',
    'restricted',
    'unknown',
    'neverAskAgain',
  ];

  @override
  String toString() => 'PermissionStatus.${_names[value]}';
}

/// Defines the state of a service related to the permission group
class ServiceStatus {
  const ServiceStatus._(this.value);

  /// Integer representation of the [ServiceStatus].
  final int value;

  /// The service for the supplied permission group is disabled.
  static const ServiceStatus disabled = ServiceStatus._(0);

  /// The service for the supplied permission group is enabled.
  static const ServiceStatus enabled = ServiceStatus._(1);

  /// There is no service for the supplied permission group.
  static const ServiceStatus notApplicable = ServiceStatus._(2);

  /// The unknown service status indicates the state of the service could not
  /// be determined.
  static const ServiceStatus unknown = ServiceStatus._(3);

  /// Returns a list of all possible [ServiceStatus] values.
  static const List<ServiceStatus> values = <ServiceStatus>[
    disabled,
    enabled,
    notApplicable,
    unknown,
  ];

  static const List<String> _names = <String>[
    'disabled',
    'enabled',
    'notApplicable',
    'unknown',
  ];

  @override
  String toString() => 'ServiceStatus.${_names[value]}';
}

/// Defines the permission groups for which permissions can be checked or
/// requested.
class PermissionGroup {
  const PermissionGroup._(this.value);

  /// Integer representation of the [PermissionGroup].
  final int value;

  /// Android: Calendar
  /// iOS: Calendar (Events)
  static const PermissionGroup calendar = PermissionGroup._(0);

  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  static const PermissionGroup camera = PermissionGroup._(1);

  /// Android: Contacts
  /// iOS: AddressBook
  static const PermissionGroup contacts = PermissionGroup._(2);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  static const PermissionGroup location = PermissionGroup._(3);

  /// Android:
  ///   When running on Android < Q: Fine and Coarse Location
  ///   When running on Android Q and above: Background Location Permission
  /// iOS: CoreLocation - Always
  static const PermissionGroup locationAlways = PermissionGroup._(4);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  static const PermissionGroup locationWhenInUse = PermissionGroup._(5);

  /// Android: None
  /// iOS: MPMediaLibrary
  static const PermissionGroup mediaLibrary = PermissionGroup._(6);

  /// Android: Microphone
  /// iOS: Microphone
  static const PermissionGroup microphone = PermissionGroup._(7);

  /// Android: Phone
  /// iOS: Nothing
  static const PermissionGroup phone = PermissionGroup._(8);

  /// Android: Nothing
  /// iOS: Photos
  static const PermissionGroup photos = PermissionGroup._(9);

  /// Android: Nothing
  /// iOS: Reminders
  static const PermissionGroup reminders = PermissionGroup._(10);

  /// Android: Body Sensors
  /// iOS: CoreMotion
  static const PermissionGroup sensors = PermissionGroup._(11);

  /// Android: Sms
  /// iOS: Nothing
  static const PermissionGroup sms = PermissionGroup._(12);

  /// Android: Microphone
  /// iOS: Speech
  static const PermissionGroup speech = PermissionGroup._(13);

  /// Android: External Storage
  /// iOS: Access to folders like `Documents` or `Downloads`. Implicitly
  /// granted.
  static const PermissionGroup storage = PermissionGroup._(14);

  /// Android: Ignore Battery Optimizations
  static const PermissionGroup ignoreBatteryOptimizations =
      PermissionGroup._(15);

  /// Android: Notification
  /// iOS: Notification
  static const PermissionGroup notification = PermissionGroup._(16);

  /// Android: Allows an application to access any geographic locations
  /// persisted in the user's shared collection.
  static const PermissionGroup accessMediaLocation = PermissionGroup._(17);

  /// When running on Android Q and above: Activity Recognition
  /// When running on Android < Q: Nothing
  /// iOS: Nothing
  static const PermissionGroup activityRecognition = PermissionGroup._(18);

  /// The unknown permission only used for return type, never requested
  static const PermissionGroup unknown = PermissionGroup._(19);

  /// Returns a list of all possible [PermissionGroup] values.
  static const List<PermissionGroup> values = <PermissionGroup>[
    calendar,
    camera,
    contacts,
    location,
    locationAlways,
    locationWhenInUse,
    mediaLibrary,
    microphone,
    phone,
    photos,
    reminders,
    sensors,
    sms,
    speech,
    storage,
    ignoreBatteryOptimizations,
    notification,
    accessMediaLocation,
    activityRecognition,
    unknown,
  ];

  static const List<String> _names = <String>[
    'calendar',
    'camera',
    'contacts',
    'location',
    'locationAlways',
    'locationWhenInUse',
    'mediaLibrary',
    'microphone',
    'phone',
    'photos',
    'reminders',
    'sensors',
    'sms',
    'speech',
    'storage',
    'ignoreBatteryOptimizations',
    'notification',
    'access_media_location',
    'activity_recognition',
    'unknown',
  ];

  @override
  String toString() => 'PermissionGroup.${_names[value]}';
}
