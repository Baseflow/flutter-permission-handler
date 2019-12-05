/// Defines the state of a permission group
class PermissionStatus {
  const PermissionStatus._(this.value);

  final int value;

  /// Permission to access the requested feature is denied by the user.
  static const PermissionStatus denied = PermissionStatus._(0);

  /// The feature is disabled (or not available) on the device.
  static const PermissionStatus disabled = PermissionStatus._(1);

  /// Permission to access the requested feature is granted by the user.
  static const PermissionStatus granted = PermissionStatus._(2);

  /// Permission to access the requested feature is denied by the OS (only on iOS).
  /// The user cannot change this app's status, possibly due to active restrictions such as
  /// parental controls being in place.
  static const PermissionStatus restricted = PermissionStatus._(3);

  /// Permission is in an unknown state
  static const PermissionStatus unknown = PermissionStatus._(4);

  static const List<PermissionStatus> values = <PermissionStatus>[
    denied,
    disabled,
    granted,
    restricted,
    unknown,
  ];

  static const List<String> _names = <String>[
    'denied',
    'disabled',
    'granted',
    'restricted',
    'unknown',
  ];

  @override
  String toString() => 'PermissionStatus.${_names[value]}';
}

/// Defines the state of a service related to the permission group
class ServiceStatus {
  const ServiceStatus._(this.value);

  final int value;

  /// The service for the supplied permission group is disabled.
  static const ServiceStatus disabled = ServiceStatus._(0);

  /// The service for the supplied permission group is enabled.
  static const ServiceStatus enabled = ServiceStatus._(1);

  /// There is no service for the supplied permission group.
  static const ServiceStatus notApplicable = ServiceStatus._(2);

  /// The unknown service status indicates the state of the service could not be determined.
  static const ServiceStatus unknown = ServiceStatus._(3);

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

/// Defines the permission groups for which permissions can be checked or requested.
class PermissionGroup {
  const PermissionGroup._(this.value);

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
  /// iOS: Access to folders like `Documents` or `Downloads`. Implicitly granted.
  static const PermissionGroup storage = PermissionGroup._(14);

  /// Android: Ignore Battery Optimizations
  static const PermissionGroup ignoreBatteryOptimizations =
      PermissionGroup._(15);

  /// Android: Notification
  /// iOS: Notification
  static const PermissionGroup notification = PermissionGroup._(16);

  /// The unknown permission only used for return type, never requested
  static const PermissionGroup unknown = PermissionGroup._(17);

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
    unknown,
    //bluetooth
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
    'unknown',
    //bluetooth permission 蓝牙权限
  ];

  @override
  String toString() => 'PermissionGroup.${_names[value]}';
}
