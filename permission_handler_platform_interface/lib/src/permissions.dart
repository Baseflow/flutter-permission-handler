part of permission_handler_platform_interface;

/// A special kind of permission, used to access a service.
///
/// Additionally to the actions that normal [Permission]s have, you can also
/// query the status of the related service.
class PermissionWithService extends Permission {
  const PermissionWithService._(int value) : super._(value);

  /// Creates a [PermissionWithService] instance.
  ///
  /// This constructor is marked public for testing purposes only.
  @visibleForTesting
  const PermissionWithService.private(int value) : super._(value);
}

/// Defines the permissions which can be checked and requested.
@immutable
class Permission {
  const Permission._(this.value);

  /// Creates a [Permission] using the supplied integer value.
  factory Permission.byValue(int value) => values[value];

  /// Integer representation of the [Permission].
  final int value;

  /// Permission for accessing the device's calendar.
  ///
  /// Android: Calendar
  /// iOS: Calendar (Events)
  @Deprecated('Use [calendarWriteOnly] and [calendarFullAccess].')
  static const calendar = Permission._(0);

  /// Permission for accessing the device's camera.
  ///
  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  static const camera = Permission._(1);

  /// Permission for accessing the device's contacts.
  ///
  /// Android: Contacts
  /// iOS: AddressBook
  static const contacts = Permission._(2);

  /// Permission for accessing the device's location.
  ///
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  static const location = PermissionWithService._(3);

  /// Permission for accessing the device's location when the app is running in
  /// the background.
  ///
  /// Depending on the platform and version, the requirements are slightly
  /// different:
  ///
  /// **Android:**
  /// - When running on Android 10 (API 29) and above: Background Location
  /// Permission.
  /// <p>**Please note**: To request this permission, the user needs to grant
  /// foreground location permissions first. You can do this by using either
  /// [Permission.location] or [Permission.locationWhenInUse]. Then, requesting
  /// [Permission.locationAlways] will show an additional dialog or open the
  /// location permission app settings, allowing the user to change the location
  /// access to 'allow all the time'.
  /// - When running below Android 10 (API 29): Fine and Coarse Location
  ///
  /// **iOS:** CoreLocation - Always
  static const locationAlways = PermissionWithService._(4);

  /// Permission for accessing the device's location when the app is running in
  /// the foreground.
  ///
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  static const locationWhenInUse = PermissionWithService._(5);

  /// Permission for accessing the device's media library (iOS 9.3+ only).
  static const mediaLibrary = Permission._(6);

  /// Permission for accessing the device's microphone.
  static const microphone = Permission._(7);

  /// Permission for accessing the device's phone state (Android only).
  static const phone = PermissionWithService._(8);

  /// Permission for accessing the device's photos.
  ///
  /// Photos can be read and added. If you only want to read them, you can
  /// use the [photos] permission instead (iOS only).
  ///
  /// Depending on the platform and version, the requirements are slightly
  /// different:
  ///
  /// **iOS:**
  /// - When running Photos (iOS 14+ read & write access level)
  ///
  /// **Android:**
  /// - Devices running Android 12 (API level 32) or lower: use [Permission.storage].
  /// - Devices running Android 13 (API level 33) and above: Should use [Permission.photos].
  ///
  /// EXAMPLE: in Manifest:
  /// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
  /// <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
  ///
  /// In Flutter to check the status:
  ///
  /// if (Platform.isAndroid) {
  ///   final androidInfo = await DeviceInfoPlugin().androidInfo;
  ///   if (androidInfo.version.sdkInt <= 32) {
  ///     use [Permission.storage.status]
  ///   }  else {
  ///     use [Permission.photos.status]
  ///   }
  /// }
  static const photos = Permission._(9);

  /// Permission for adding photos to the device's photo library (iOS only).
  ///
  /// Photos can only be added. If you want to read them as well, use the
  /// [photos] permission instead.
  ///
  /// iOS: Photos (14+ read & write access level)
  static const photosAddOnly = Permission._(10);

  /// Permission for accessing the device's reminders (iOS only).
  static const reminders = Permission._(11);

  /// Permission for accessing the device's sensors.
  ///
  /// Android: Body Sensors
  /// iOS: CoreMotion
  static const sensors = Permission._(12);

  /// Permission for sending and reading SMS messages (Android only).
  static const sms = Permission._(13);

  /// Permission for accessing speech recognition.
  ///
  /// **Android:**
  /// - Requests access to microphone (identical to requesting
  /// [Permission.microphone]).
  ///
  /// **iOS:**
  /// - Requests speech access (different from requesting
  /// [Permission.microphone]).
  static const speech = Permission._(14);

  /// Permission for accessing external storage.
  ///
  /// Depending on the platform and version, the requirements are slightly
  /// different:
  ///
  /// **Android:**
  /// - On Android 13 (API 33) and above, this permission is deprecated and
  /// always returns `PermissionStatus.denied`. Instead use `Permission.photos`,
  /// `Permission.video`, `Permission.audio` or
  /// `Permission.manageExternalStorage`. For more information see our
  /// [FAQ](https://pub.dev/packages/permission_handler#faq).
  /// - Below Android 13 (API 33), the `READ_EXTERNAL_STORAGE` and
  /// `WRITE_EXTERNAL_STORAGE` permissions are requested (depending on the
  /// definitions in the AndroidManifest.xml) file.
  ///
  /// **iOS:**
  /// - Access to folders like `Documents` or `Downloads`. Implicitly granted.
  static const storage = Permission._(15);

  /// Permission for accessing ignore battery optimizations (Android only).
  static const ignoreBatteryOptimizations = Permission._(16);

  /// Permission for pushing notifications.
  static const notification = Permission._(17);

  /// Permission for accessing the device's media library.
  ///
  /// Android 10+ (API 29+)
  ///
  /// Allows an application to access any geographic locations persisted in the
  /// user's shared collection.
  static const accessMediaLocation = Permission._(18);

  /// Permission for accessing the activity recognition.
  ///
  /// Android 10+ (API 29+)
  static const activityRecognition = Permission._(19);

  /// The unknown only used for return type, never requested.
  static const unknown = Permission._(20);

  /// Permission for accessing the device's bluetooth adapter state.
  ///
  /// Depending on the platform and version, the requirements are slightly
  /// different:
  ///
  /// **Android:**
  /// - Always allowed.
  ///
  /// **iOS:**
  /// - iOS 13 and above: The authorization state of Core Bluetooth manager.
  /// - iOS below 13: always allowed.
  ///
  /// Limitations:
  /// - iOS 13.0 only: [bluetooth.status] is always [PermissionStatus.denied],
  /// regardless of the actual status. For the actual permission state, use
  /// [bluetooth.request]. Note that this will show a permission dialog if the
  /// permission was not yet requested.
  /// - All iOS versions: [bluetooth.serviceStatus] will **always** return
  /// [ServiceStatus.disabled] when the Bluetooth permission was denied by the
  /// user. It is impossible to obtain the actual Bluetooth service status
  /// without having the Bluetooth permission granted. The method will prompt
  /// the user for Bluetooth permission if the permission was not yet requested.
  static const bluetooth = PermissionWithService._(21);

  /// Permission for accessing the device's external storage.
  ///
  /// Android 11+ (API 30+)
  ///
  /// Allows an application a broad access to external storage in scoped
  /// storage.
  ///
  /// You should request the Manage External Storage permission only when
  /// your app cannot effectively make use of the more privacy-friendly APIs.
  /// For more information:
  /// https://developer.android.com/training/data-storage/manage-all-files
  ///
  /// When the privacy-friendly APIs (i.e. [Storage Access Framework](https://developer.android.com/guide/topics/providers/document-provider)
  /// or the [MediaStore](https://developer.android.com/training/data-storage/shared/media) APIs)
  /// is all your app needs, the [PermissionGroup.storage] are the only
  /// permissions you need to request.
  ///
  /// If the usage of the Manage External Storage permission is needed,
  /// you have to fill out the Permission Declaration Form upon submitting
  /// your app to the Google Play Store. More details can be found here:
  /// https://support.google.com/googleplay/android-developer/answer/9214102#zippy=
  static const manageExternalStorage = Permission._(22);

  /// Permission for creating system alert window (Android only).
  ///
  /// Allows an app to create windows shown on top of all other apps.
  static const systemAlertWindow = Permission._(23);

  /// Permission for requesting installing packages.
  ///
  /// Android Marshmallow+ (API 23+)
  static const requestInstallPackages = Permission._(24);

  /// Permission for accessing the device's tracking state (iOS only).
  ///
  /// Allows user to accept that your app collects data about end users and
  /// shares it with other companies for purposes of tracking across apps and
  /// websites.
  static const appTrackingTransparency = Permission._(25);

  /// Permission for sending critical alerts (iOS only).
  ///
  /// Allow for sending notifications that override the ringer.
  static const criticalAlerts = Permission._(26);

  /// Permission for accessing the device's notification policy.
  ///
  /// Android Marshmallow+ (API 23+)
  ///
  /// Allows the user to access the notification policy of the phone.
  /// EX: Allows app to turn on and off do-not-disturb.
  static const accessNotificationPolicy = Permission._(27);

  /// Permission for scanning for Bluetooth devices.
  ///
  /// Android 12+ (API 31+)
  static const bluetoothScan = Permission._(28);

  /// Permission for advertising Bluetooth devices
  ///
  /// Android 12+ (API 31+)
  ///
  /// Allows the user to make this device discoverable to other Bluetooth
  /// devices.
  static const bluetoothAdvertise = Permission._(29);

  /// Permission for connecting to Bluetooth devices.
  ///
  /// Android 12+ (API 31+)
  ///
  /// Allows the user to connect with already paired Bluetooth devices.
  static const bluetoothConnect = Permission._(30);

  /// Permission for connecting to nearby devices via Wi-Fi.
  ///
  /// Android 13+ (API 33+)
  static const nearbyWifiDevices = Permission._(31);

  /// Permission for accessing the device's video files from external storage.
  ///
  /// Android 13+ (API 33+)
  static const videos = Permission._(32);

  /// Permission for accessing the device's audio files from external storage.
  ///
  /// Android 13+ (API 33+)
  static const audio = Permission._(33);

  /// Permission for scheduling exact alarms.
  ///
  /// Android 12+ (API 31+)
  static const scheduleExactAlarm = Permission._(34);

  /// Permission for accessing the device's sensors in background.
  ///
  /// Android 13+ (API 33+)
  static const sensorsAlways = Permission._(35);

  /// Permission for writing to the device's calendar.
  ///
  /// On iOS 16 and lower, this permission is identical to [Permission.calendarFullAccess].
  static const calendarWriteOnly = Permission._(36);

  /// Permission for reading from and writing to the device's calendar.
  static const calendarFullAccess = Permission._(37);

  /// Android: Nothing
  /// iOS: SiriKit
  static const assistant = Permission._(38);

  /// Permission for reading the current background refresh status. (iOS only)
  static const backgroundRefresh = Permission._(39);

  /// Returns a list of all possible [PermissionGroup] values.
  static const List<Permission> values = <Permission>[
    // ignore: deprecated_member_use_from_same_package
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
    bluetoothScan,
    bluetoothAdvertise,
    bluetoothConnect,
    nearbyWifiDevices,
    videos,
    audio,
    scheduleExactAlarm,
    sensorsAlways,
    calendarWriteOnly,
    calendarFullAccess,
    assistant,
    backgroundRefresh,
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
    'bluetoothScan',
    'bluetoothAdvertise',
    'bluetoothConnect',
    'nearbyWifiDevices',
    'videos',
    'audio',
    'scheduleExactAlarm',
    'sensorsAlways',
    'calendarWriteOnly',
    'calendarFullAccess',
    'assistant',
    'backgroundRefresh',
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
