// ignore_for_file: avoid_unused_constructor_parameters

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'permission_handler_apple',
    dartOut: 'lib/next/src/pigeon/apple_permissions.g.dart',
    swiftOut:
        'darwin/permission_handler_apple/Sources/permission_handler_apple/PermissionHandler/PermissionHandlerLibrary.g.swift',
  ),
)
// ---------------------------------------------------------------------------
// Foundation
// ---------------------------------------------------------------------------

@ProxyApi()
abstract class NSObject {
  NSObject();
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(name: 'BundleWrapper'))
abstract class NSBundle extends NSObject {
  @static
  late NSBundle mainBundle;

  String? objectForInfoDictionaryKey(String key);
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(name: 'UserDefaultsWrapper'))
abstract class NSUserDefaults extends NSObject {
  @static
  late NSUserDefaults standardUserDefaults;

  bool boolForKey(String key);
  void setBool(bool value, String key);
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(name: 'DateWrapper'))
abstract class NSDate extends NSObject {
  NSDate();
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(name: 'URLWrapper'))
abstract class URL extends NSObject {
  URL(String urlString);
  String getAbsoluteString();
}

// ---------------------------------------------------------------------------
// UIKit
// ---------------------------------------------------------------------------

enum UIBackgroundRefreshStatus {
  restricted,
  denied,
  available,
}

@ProxyApi(
  swiftOptions: SwiftProxyApiOptions(import: 'UIKit', supportsMacos: false),
)
abstract class UIApplication extends NSObject {
  @static
  late UIApplication shared;

  UIBackgroundRefreshStatus getBackgroundRefreshStatus();
  void registerForRemoteNotifications();
  @async
  bool openSettingsURL();
  @async
  bool canOpenURL(URL url);
}

// ---------------------------------------------------------------------------
// Core Location
// ---------------------------------------------------------------------------

enum CLAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorizedAlways,
  authorizedWhenInUse,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreLocation'))
abstract class CLLocationManager extends NSObject {
  CLLocationManager();

  void setDelegate(CLLocationManagerDelegate? delegate);
  void requestWhenInUseAuthorization();
  void requestAlwaysAuthorization();
  CLAuthorizationStatus getAuthorizationStatus();

  @static
  CLAuthorizationStatus authorizationStatus();

  @static
  bool locationServicesEnabled();
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreLocation'))
abstract class CLLocationManagerDelegate extends NSObject {
  CLLocationManagerDelegate();

  late void Function(
    CLLocationManagerDelegate instance,
    CLLocationManager manager,
  )? locationManagerDidChangeAuthorization;
}

// ---------------------------------------------------------------------------
// AVFoundation
// ---------------------------------------------------------------------------

enum AVMediaType {
  video,
  audio,
}

enum AVAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'AVFoundation'))
abstract class AVCaptureDevice extends NSObject {
  @static
  AVAuthorizationStatus authorizationStatusForMediaType(AVMediaType mediaType);

  @static
  @async
  bool requestAccessForMediaType(AVMediaType mediaType);
}

// ---------------------------------------------------------------------------
// Photos
// ---------------------------------------------------------------------------

enum PHAccessLevel {
  addOnly,
  readWrite,
}

enum PHAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
  limited,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'Photos'))
abstract class PHPhotoLibrary extends NSObject {
  @static
  PHAuthorizationStatus authorizationStatusForAccessLevel(
      PHAccessLevel accessLevel);

  @static
  @async
  PHAuthorizationStatus requestAuthorizationForAccessLevel(
      PHAccessLevel accessLevel);

  @static
  PHAuthorizationStatus authorizationStatus();

  @static
  @async
  PHAuthorizationStatus requestAuthorization();
}

// ---------------------------------------------------------------------------
// EventKit
// ---------------------------------------------------------------------------

enum EKEntityType {
  event,
  reminder,
}

enum EKAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
  writeOnly,
  fullAccess,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'EventKit'))
abstract class EKEventStore extends NSObject {
  EKEventStore();

  @static
  EKAuthorizationStatus authorizationStatusForEntityType(
      EKEntityType entityType);

  @async
  bool requestFullAccessToEvents();

  @async
  bool requestWriteOnlyAccessToEvents();

  @async
  bool requestFullAccessToReminders();

  @async
  bool requestAccessToEntityType(EKEntityType entityType);
}

// ---------------------------------------------------------------------------
// Contacts
// ---------------------------------------------------------------------------

enum CNEntityType {
  contacts,
}

enum CNAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
  limited,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'Contacts'))
abstract class CNContactStore extends NSObject {
  CNContactStore();

  @static
  CNAuthorizationStatus authorizationStatusForEntityType(
      CNEntityType entityType);

  @async
  bool requestAccessForEntityType(CNEntityType entityType);
}

// ---------------------------------------------------------------------------
// UserNotifications
// ---------------------------------------------------------------------------

enum UNAuthorizationStatus {
  notDetermined,
  denied,
  authorized,
  provisional,
  ephemeral,
}

enum UNAuthorizationOption {
  badge,
  sound,
  alert,
  criticalAlert,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'UserNotifications'))
abstract class UNNotificationSettings extends NSObject {
  UNAuthorizationStatus getAuthorizationStatus();
  UNAuthorizationStatus getCriticalAlertSetting();
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'UserNotifications'))
abstract class UNUserNotificationCenter extends NSObject {
  @static
  late UNUserNotificationCenter current;

  @async
  bool requestAuthorization(List<UNAuthorizationOption> options);

  @async
  UNNotificationSettings getNotificationSettings();
}

// ---------------------------------------------------------------------------
// CoreBluetooth
// ---------------------------------------------------------------------------

enum CBManagerState {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

enum CBManagerAuthorization {
  notDetermined,
  restricted,
  denied,
  allowedAlways,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreBluetooth'))
abstract class CBCentralManager extends NSObject {
  CBCentralManager(CBCentralManagerDelegate? delegate);

  CBManagerState getState();

  @static
  CBManagerAuthorization authorization();
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreBluetooth'))
abstract class CBCentralManagerDelegate extends NSObject {
  CBCentralManagerDelegate();

  late void Function(
    CBCentralManagerDelegate instance,
    CBCentralManager manager,
  )? centralManagerDidUpdateState;
}

// ---------------------------------------------------------------------------
// CoreMotion
// ---------------------------------------------------------------------------

enum CMAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreMotion'))
abstract class CMMotionActivityManager extends NSObject {
  CMMotionActivityManager();

  @static
  CMAuthorizationStatus authorizationStatus();

  @static
  bool isActivityAvailable();

  @async
  void queryActivityStartingFromDate(NSDate from, NSDate to);
}

// ---------------------------------------------------------------------------
// Speech
// ---------------------------------------------------------------------------

enum SFSpeechRecognizerAuthorizationStatus {
  notDetermined,
  denied,
  restricted,
  authorized,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'Speech'))
abstract class SFSpeechRecognizer extends NSObject {
  @static
  SFSpeechRecognizerAuthorizationStatus authorizationStatus();

  @static
  @async
  SFSpeechRecognizerAuthorizationStatus requestAuthorization();
}

// ---------------------------------------------------------------------------
// MediaPlayer
// ---------------------------------------------------------------------------

enum MPMediaLibraryAuthorizationStatus {
  notDetermined,
  denied,
  restricted,
  authorized,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'MediaPlayer'))
abstract class MPMediaLibrary extends NSObject {
  @static
  MPMediaLibraryAuthorizationStatus authorizationStatus();

  @static
  @async
  MPMediaLibraryAuthorizationStatus requestAuthorization();
}

// ---------------------------------------------------------------------------
// AppTrackingTransparency
// ---------------------------------------------------------------------------

enum ATTrackingManagerAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'AppTrackingTransparency'))
abstract class ATTrackingManager extends NSObject {
  @static
  ATTrackingManagerAuthorizationStatus trackingAuthorizationStatus();

  @static
  @async
  ATTrackingManagerAuthorizationStatus requestTrackingAuthorization();
}

// ---------------------------------------------------------------------------
// Intents (Siri)
// ---------------------------------------------------------------------------

enum INSiriAuthorizationStatus {
  notDetermined,
  restricted,
  denied,
  authorized,
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'Intents'))
abstract class INPreferences extends NSObject {
  @static
  INSiriAuthorizationStatus siriAuthorizationStatus();

  @static
  @async
  INSiriAuthorizationStatus requestSiriAuthorization();
}

// ---------------------------------------------------------------------------
// CoreTelephony
// ---------------------------------------------------------------------------

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreTelephony'))
abstract class CTCarrier extends NSObject {
  String? getMobileNetworkCode();
}

@ProxyApi(swiftOptions: SwiftProxyApiOptions(import: 'CoreTelephony'))
abstract class CTTelephonyNetworkInfo extends NSObject {
  CTTelephonyNetworkInfo();

  CTCarrier? getSubscriberCellularProvider();
  Map<String?, CTCarrier?>? getServiceSubscriberCellularProviders();
}

// ---------------------------------------------------------------------------
// Compile-time permission flags
// ---------------------------------------------------------------------------

@HostApi()
abstract class PermissionCompileFlagsHostApi {
  bool isPermissionGroupEnabled(int permissionGroup);
}
