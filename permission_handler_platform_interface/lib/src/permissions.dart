part of permission_handler_platform_interface;

/// A special kind of permission used to access a service. Additionally to the
/// actions that normal [Permission]s have, you can also query the status of
/// the related service.
class PermissionWithService extends Permission {
  const PermissionWithService._(int value) : super._(value);
}

/// Defines the permissions which can be checked and requested.
class Permission {
  const Permission._(this.value);
  factory Permission.byValue(int value) => values[value];

  /// Integer representation of the [Permission].
  final int value;

  /// Android: Calendar
  /// iOS: Calendar (Events)
  static const calendar = Permission._(0);

  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  static const camera = Permission._(1);

  /// Android: Contacts
  /// iOS: AddressBook
  static const contacts = Permission._(2);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  static const location = PermissionWithService._(3);

  /// Android:
  ///   When running on Android < Q: Fine and Coarse Location
  ///   When running on Android Q and above: Background Location Permission
  /// iOS: CoreLocation - Always
  static const locationAlways = PermissionWithService._(4);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  static const locationWhenInUse = PermissionWithService._(5);

  /// Android: None
  /// iOS: MPMediaLibrary
  static const mediaLibrary = Permission._(6);

  /// Android: Microphone
  /// iOS: Microphone
  static const microphone = Permission._(7);

  /// Android: Phone
  /// iOS: Nothing
  static const phone = Permission._(8);

  /// Android: Nothing
  /// iOS: Photos
  static const photos = Permission._(9);

  /// Android: Nothing
  /// iOS: Reminders
  static const reminders = Permission._(10);

  /// Android: Body Sensors
  /// iOS: CoreMotion
  static const sensors = Permission._(11);

  /// Android: Sms
  /// iOS: Nothing
  static const sms = Permission._(12);

  /// Android: Microphone
  /// iOS: Speech
  static const speech = Permission._(13);

  /// Android: External Storage
  /// iOS: Access to folders like `Documents` or `Downloads`. Implicitly
  /// granted.
  static const storage = Permission._(14);

  /// Android: Ignore Battery Optimizations
  static const ignoreBatteryOptimizations = Permission._(15);

  /// Android: Notification
  /// iOS: Notification
  static const notification = Permission._(16);

  /// Android: Allows an application to access any geographic locations
  /// persisted in the user's shared collection.
  static const accessMediaLocation = Permission._(17);

  /// When running on Android Q and above: Activity Recognition
  /// When running on Android < Q: Nothing
  /// iOS: Nothing
  static const activityRecognition = Permission._(18);

  /// The unknown only used for return type, never requested
  static const unknown = Permission._(19);

  /// Android: System Alert Window Or Draw Over Other Apps
  /// (Works only above Android M)
  /// iOS: Nothing
  static const systemAlertWindow = Permission._(20);

  /// Returns a list of all possible [PermissionGroup] values.
  static const List<Permission> values = <Permission>[
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
    systemAlertWindow,
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
    'systemAlertWindow',
  ];

  @override
  String toString() => 'Permission.${_names[value]}';
}
