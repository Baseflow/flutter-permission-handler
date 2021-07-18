part of permission_handler_platform_interface;

/// A special kind of permission used to access a service. Additionally to the
/// actions that normal [Permission]s have, you can also query the status of
/// the related service.
class PermissionWithService extends Permission {
  const PermissionWithService._(int value) : super._(value);

  @visibleForTesting
  const PermissionWithService.private(int value) : super._(value);
}

/// Defines the permissions which can be checked and requested.
@immutable
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
  ///   When requesting this permission the user needs to grant permission
  ///   for the `locationWhenInUse` permission first, clicking on
  ///   the `Àllow While Using App` option on the popup.
  ///   After allowing the permission the user can request the `locationAlways`
  ///   permission and can click on the `Change To Always Allow` option.
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
  static const phone = PermissionWithService._(8);

  /// Android: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  static const photos = Permission._(9);

  /// Android: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  static const photosAddOnly = Permission._(10);

  /// Android: Nothing
  /// iOS: Reminders
  static const reminders = Permission._(11);

  /// Android: Body Sensors
  /// iOS: CoreMotion
  static const sensors = Permission._(12);

  /// Android: Sms
  /// iOS: Nothing
  static const sms = Permission._(13);

  /// Android: Microphone
  /// iOS: Speech
  static const speech = Permission._(14);

  /// Android: External Storage
  /// iOS: Access to folders like `Documents` or `Downloads`. Implicitly
  /// granted.
  static const storage = Permission._(15);

  /// Android: Ignore Battery Optimizations
  static const ignoreBatteryOptimizations = Permission._(16);

  /// Android: Notification
  /// iOS: Notification
  static const notification = Permission._(17);

  /// Android: Allows an application to access any geographic locations
  /// persisted in the user's shared collection.
  static const accessMediaLocation = Permission._(18);

  /// When running on Android Q and above: Activity Recognition
  /// When running on Android < Q: Nothing
  /// iOS: Nothing
  static const activityRecognition = Permission._(19);

  /// The unknown only used for return type, never requested
  static const unknown = Permission._(20);

  /// iOS 13 and above: The authorization state of Core Bluetooth manager.
  /// When running < iOS 13 or Android this is always allowed.
  static const bluetooth = Permission._(21);

  /// Android: Allows an application a broad access to external storage in
  /// scoped storage.
  /// iOS: Nothing
  ///
  /// You should request the Manage External Storage permission only when
  /// your app cannot effectively make use of the more privacy-friendly APIs.
  /// For more information: https://developer.android.com/training/data-storage/manage-all-files
  ///
  /// When the privacy-friendly APIs (i.e. [Storage Access Framework](https://developer.android.com/guide/topics/providers/document-provider)
  /// or the [MediaStore](https://developer.android.com/training/data-storage/shared/media) APIs) is all your app needs the
  /// [PermissionGroup.storage] are the only permissions you need to request.
  ///
  /// If the usage of the Manage External Storage permission is needed,
  /// you have to fill out the Permission Declaration Form upon submitting
  /// your app to the Google Play Store. More details can be found here:
  /// https://support.google.com/googleplay/android-developer/answer/9214102#zippy=
  static const manageExternalStorage = Permission._(22);

  ///Android: Allows an app to create windows shown on top of all other apps
  ///iOS: Nothing
  static const systemAlertWindow = Permission._(23);

  ///Android: Allows an app to request installing packages.
  ///iOS: Nothing
  static const requestInstallPackages = Permission._(24);

  ///Android: Nothing
  ///iOS: Allows user to accept that your app collects data about end users and
  ///shares it with other companies for purposes of tracking across apps and
  ///websites.
  static const appTrackingTransparency = Permission._(25);

  ///Android: Nothing
  ///iOS: Notifications that override your ringer
  static const criticalAlerts = Permission._(26);

  ///Android: Allows the user to access the notification policy of the phone.
  /// EX: Allows app to turn on and off do-not-disturb.
  ///iOS: Nothing
  static const accessNotificationPolicy = Permission._(27);

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
    photosAddOnly,
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
    bluetooth,
    manageExternalStorage,
    systemAlertWindow,
    requestInstallPackages,
    appTrackingTransparency,
    criticalAlerts,
    accessNotificationPolicy,
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
    'photosAddOnly',
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
    'bluetooth',
    'manageExternalStorage',
    'systemAlertWindow',
    'requestInstallPackages',
    'appTrackingTransparency',
    'criticalAlerts',
    'accessNotificationPolicy',
  ];

  @override
  String toString() => 'Permission.${_names[value]}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Permission && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
