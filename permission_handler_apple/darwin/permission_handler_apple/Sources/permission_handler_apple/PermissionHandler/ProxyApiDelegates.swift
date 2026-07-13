import AVFoundation
import AppTrackingTransparency
import Contacts
import CoreBluetooth
import CoreLocation
import CoreMotion
import CoreTelephony
import EventKit
import Foundation
import Intents
import MediaPlayer
import Photos
import Speech
import UIKit
import UserNotifications

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

// MARK: - Location delegate bridge

final class LocationManagerDelegateImpl: NSObject, CLLocationManagerDelegate {
  let api: PigeonApiProtocolCLLocationManagerDelegate
  unowned let registrar: ProxyApiRegistrar

  init(
    api: PigeonApiProtocolCLLocationManagerDelegate,
    registrar: ProxyApiRegistrar
  ) {
    self.api = api
    self.registrar = registrar
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    registrar.dispatchOnMainThread { onFailure in
      self.api.locationManagerDidChangeAuthorization(
        pigeonInstance: self,
        instance: self,
        manager: manager
      ) { result in
        if case .failure(let error) = result {
          onFailure("CLLocationManagerDelegate.locationManagerDidChangeAuthorization", error)
        }
      }
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    locationManagerDidChangeAuthorization(manager)
  }
}

class CLLocationManagerDelegateProxyApiDelegate: PigeonApiDelegateCLLocationManagerDelegate {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiCLLocationManagerDelegate) throws
    -> CLLocationManagerDelegate
  {
    return LocationManagerDelegateImpl(
      api: pigeonApi,
      registrar: pigeonApi.pigeonRegistrar as! ProxyApiRegistrar
    )
  }
}

// MARK: - Bluetooth delegate bridge

final class CentralManagerDelegateImpl: NSObject, CBCentralManagerDelegate {
  let api: PigeonApiProtocolCBCentralManagerDelegate
  unowned let registrar: ProxyApiRegistrar

  init(
    api: PigeonApiProtocolCBCentralManagerDelegate,
    registrar: ProxyApiRegistrar
  ) {
    self.api = api
    self.registrar = registrar
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    registrar.dispatchOnMainThread { onFailure in
      self.api.centralManagerDidUpdateState(
        pigeonInstance: self,
        instance: self,
        manager: central
      ) { result in
        if case .failure(let error) = result {
          onFailure("CBCentralManagerDelegate.centralManagerDidUpdateState", error)
        }
      }
    }
  }
}

class CBCentralManagerDelegateProxyApiDelegate: PigeonApiDelegateCBCentralManagerDelegate {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiCBCentralManagerDelegate) throws
    -> CBCentralManagerDelegate
  {
    return CentralManagerDelegateImpl(
      api: pigeonApi,
      registrar: pigeonApi.pigeonRegistrar as! ProxyApiRegistrar
    )
  }
}

// MARK: - NSObject

class NSObjectProxyApiDelegate: PigeonApiDelegateNSObject {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiNSObject) throws -> NSObject {
    return NSObject()
  }
}

// MARK: - NSBundle

class NSBundleProxyApiDelegate: PigeonApiDelegateNSBundle {
  func mainBundle(pigeonApi: PigeonApiNSBundle) throws -> BundleWrapper {
    return BundleWrapper(Bundle.main)
  }

  func objectForInfoDictionaryKey(
    pigeonApi: PigeonApiNSBundle,
    pigeonInstance: BundleWrapper,
    key: String
  ) throws -> String? {
    return pigeonInstance.value.object(forInfoDictionaryKey: key) as? String
  }
}

// MARK: - NSUserDefaults

class NSUserDefaultsProxyApiDelegate: PigeonApiDelegateNSUserDefaults {
  func standardUserDefaults(pigeonApi: PigeonApiNSUserDefaults) throws -> UserDefaultsWrapper {
    return UserDefaultsWrapper(UserDefaults.standard)
  }

  func boolForKey(
    pigeonApi: PigeonApiNSUserDefaults,
    pigeonInstance: UserDefaultsWrapper,
    key: String
  ) throws -> Bool {
    return pigeonInstance.value.bool(forKey: key)
  }

  func setBool(
    pigeonApi: PigeonApiNSUserDefaults,
    pigeonInstance: UserDefaultsWrapper,
    value: Bool,
    key: String
  ) throws {
    pigeonInstance.value.set(value, forKey: key)
  }
}

// MARK: - NSDate

class NSDateProxyApiDelegate: PigeonApiDelegateNSDate {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiNSDate) throws -> DateWrapper {
    return DateWrapper(Date())
  }
}

// MARK: - URL

class URLProxyApiDelegate: PigeonApiDelegateURL {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiURL, urlString: String) throws -> URLWrapper {
    guard let url = URL(string: urlString) else {
      throw PigeonError(code: "invalid-url", message: "Invalid URL string.", details: urlString)
    }
    return URLWrapper(url)
  }

  func getAbsoluteString(pigeonApi: PigeonApiURL, pigeonInstance: URLWrapper) throws -> String {
    return pigeonInstance.value.absoluteString
  }
}

// MARK: - UIApplication

class UIApplicationProxyApiDelegate: PigeonApiDelegateUIApplication {
  func shared(pigeonApi: PigeonApiUIApplication) throws -> UIApplication {
    return UIApplication.shared
  }

  func getBackgroundRefreshStatus(
    pigeonApi: PigeonApiUIApplication,
    pigeonInstance: UIApplication
  ) throws -> UIBackgroundRefreshStatus {
    return pigeonUIBackgroundRefreshStatus(from: pigeonInstance.backgroundRefreshStatus)
  }

  func registerForRemoteNotifications(
    pigeonApi: PigeonApiUIApplication,
    pigeonInstance: UIApplication
  ) throws {
    DispatchQueue.main.async {
      pigeonInstance.registerForRemoteNotifications()
    }
  }

  func openSettingsURL(
    pigeonApi: PigeonApiUIApplication,
    pigeonInstance: UIApplication,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
      completion(.success(false))
      return
    }
    pigeonInstance.open(url, options: [:]) { success in
      completion(.success(success))
    }
  }

  func canOpenURL(
    pigeonApi: PigeonApiUIApplication,
    pigeonInstance: UIApplication,
    url: URLWrapper,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    completion(.success(pigeonInstance.canOpenURL(url.value)))
  }
}

// MARK: - CLLocationManager

class CLLocationManagerProxyApiDelegate: PigeonApiDelegateCLLocationManager {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiCLLocationManager) throws -> CLLocationManager {
    return CLLocationManager()
  }

  func setDelegate(
    pigeonApi: PigeonApiCLLocationManager,
    pigeonInstance: CLLocationManager,
    delegate: CLLocationManagerDelegate?
  ) throws {
    pigeonInstance.delegate = delegate
  }

  func requestWhenInUseAuthorization(
    pigeonApi: PigeonApiCLLocationManager,
    pigeonInstance: CLLocationManager
  ) throws {
    DispatchQueue.main.async {
      pigeonInstance.requestWhenInUseAuthorization()
    }
  }

  func requestAlwaysAuthorization(
    pigeonApi: PigeonApiCLLocationManager,
    pigeonInstance: CLLocationManager
  ) throws {
    DispatchQueue.main.async {
      pigeonInstance.requestAlwaysAuthorization()
    }
  }

  func getAuthorizationStatus(
    pigeonApi: PigeonApiCLLocationManager,
    pigeonInstance: CLLocationManager
  ) throws -> CLAuthorizationStatus {
    if #available(iOS 14.0, *) {
      return pigeonCLAuthorizationStatus(from: pigeonInstance.authorizationStatus)
    }
    return pigeonCLAuthorizationStatus(from: type(of: pigeonInstance).authorizationStatus())
  }

  func authorizationStatus(pigeonApi: PigeonApiCLLocationManager) throws -> CLAuthorizationStatus {
    return pigeonCLAuthorizationStatus(from: CLLocationManager.authorizationStatus())
  }

  func locationServicesEnabled(pigeonApi: PigeonApiCLLocationManager) throws -> Bool {
    return CLLocationManager.locationServicesEnabled()
  }
}

// MARK: - AVCaptureDevice

class AVCaptureDeviceProxyApiDelegate: PigeonApiDelegateAVCaptureDevice {
  func authorizationStatusForMediaType(
    pigeonApi: PigeonApiAVCaptureDevice,
    mediaType: AVMediaType
  ) throws -> AVAuthorizationStatus {
    let nativeType = nativeAVMediaType(from: mediaType)
    return pigeonAVAuthorizationStatus(
      from: AVCaptureDevice.authorizationStatus(for: nativeType)
    )
  }

  func requestAccessForMediaType(
    pigeonApi: PigeonApiAVCaptureDevice,
    mediaType: AVMediaType,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    let nativeType = nativeAVMediaType(from: mediaType)
    AVCaptureDevice.requestAccess(for: nativeType) { granted in
      completion(.success(granted))
    }
  }
}

// MARK: - PHPhotoLibrary

class PHPhotoLibraryProxyApiDelegate: PigeonApiDelegatePHPhotoLibrary {
  func authorizationStatusForAccessLevel(
    pigeonApi: PigeonApiPHPhotoLibrary,
    accessLevel: PHAccessLevel
  ) throws -> PHAuthorizationStatus {
    if #available(iOS 14, *) {
      return pigeonPHAuthorizationStatus(
        from: PHPhotoLibrary.authorizationStatus(for: nativePHAccessLevel(from: accessLevel))
      )
    }
    return pigeonPHAuthorizationStatus(from: PHPhotoLibrary.authorizationStatus())
  }

  func requestAuthorizationForAccessLevel(
    pigeonApi: PigeonApiPHPhotoLibrary,
    accessLevel: PHAccessLevel,
    completion: @escaping (Result<PHAuthorizationStatus, Error>) -> Void
  ) {
    if #available(iOS 14, *) {
      PHPhotoLibrary.requestAuthorization(for: nativePHAccessLevel(from: accessLevel)) { status in
        completion(.success(pigeonPHAuthorizationStatus(from: status)))
      }
    } else {
      PHPhotoLibrary.requestAuthorization { status in
        completion(.success(pigeonPHAuthorizationStatus(from: status)))
      }
    }
  }

  func authorizationStatus(pigeonApi: PigeonApiPHPhotoLibrary) throws -> PHAuthorizationStatus {
    return pigeonPHAuthorizationStatus(from: PHPhotoLibrary.authorizationStatus())
  }

  func requestAuthorization(
    pigeonApi: PigeonApiPHPhotoLibrary,
    completion: @escaping (Result<PHAuthorizationStatus, Error>) -> Void
  ) {
    PHPhotoLibrary.requestAuthorization { status in
      completion(.success(pigeonPHAuthorizationStatus(from: status)))
    }
  }
}

// MARK: - EKEventStore

class EKEventStoreProxyApiDelegate: PigeonApiDelegateEKEventStore {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiEKEventStore) throws -> EKEventStore {
    return EKEventStore()
  }

  func authorizationStatusForEntityType(
    pigeonApi: PigeonApiEKEventStore,
    entityType: EKEntityType
  ) throws -> EKAuthorizationStatus {
    return pigeonEKAuthorizationStatus(
      from: EKEventStore.authorizationStatus(for: nativeEKEntityType(from: entityType))
    )
  }

  func requestFullAccessToEvents(
    pigeonApi: PigeonApiEKEventStore,
    pigeonInstance: EKEventStore,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    if #available(iOS 17.0, *) {
      pigeonInstance.requestFullAccessToEvents { granted, _ in
        completion(.success(granted))
      }
    } else {
      completion(.success(false))
    }
  }

  func requestWriteOnlyAccessToEvents(
    pigeonApi: PigeonApiEKEventStore,
    pigeonInstance: EKEventStore,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    if #available(iOS 17.0, *) {
      pigeonInstance.requestWriteOnlyAccessToEvents { granted, _ in
        completion(.success(granted))
      }
    } else {
      completion(.success(false))
    }
  }

  func requestFullAccessToReminders(
    pigeonApi: PigeonApiEKEventStore,
    pigeonInstance: EKEventStore,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    if #available(iOS 17.0, *) {
      pigeonInstance.requestFullAccessToReminders { granted, _ in
        completion(.success(granted))
      }
    } else {
      completion(.success(false))
    }
  }

  func requestAccessToEntityType(
    pigeonApi: PigeonApiEKEventStore,
    pigeonInstance: EKEventStore,
    entityType: EKEntityType,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    pigeonInstance.requestAccess(to: nativeEKEntityType(from: entityType)) { granted, _ in
      completion(.success(granted))
    }
  }
}

// MARK: - CNContactStore

class CNContactStoreProxyApiDelegate: PigeonApiDelegateCNContactStore {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiCNContactStore) throws -> CNContactStore {
    return CNContactStore()
  }

  func authorizationStatusForEntityType(
    pigeonApi: PigeonApiCNContactStore,
    entityType: CNEntityType
  ) throws -> CNAuthorizationStatus {
    return pigeonCNAuthorizationStatus(
      from: CNContactStore.authorizationStatus(for: nativeCNEntityType(from: entityType))
    )
  }

  func requestAccessForEntityType(
    pigeonApi: PigeonApiCNContactStore,
    pigeonInstance: CNContactStore,
    entityType: CNEntityType,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    pigeonInstance.requestAccess(for: nativeCNEntityType(from: entityType)) { granted, _ in
      completion(.success(granted))
    }
  }
}

// MARK: - UNNotificationSettings

class UNNotificationSettingsProxyApiDelegate: PigeonApiDelegateUNNotificationSettings {
  func getAuthorizationStatus(
    pigeonApi: PigeonApiUNNotificationSettings,
    pigeonInstance: UNNotificationSettings
  ) throws -> UNAuthorizationStatus {
    return pigeonUNAuthorizationStatus(from: pigeonInstance.authorizationStatus)
  }

  func getCriticalAlertSetting(
    pigeonApi: PigeonApiUNNotificationSettings,
    pigeonInstance: UNNotificationSettings
  ) throws -> UNAuthorizationStatus {
    if #available(iOS 12.0, *) {
      return pigeonUNAuthorizationStatus(from: pigeonInstance.criticalAlertSetting)
    }
    return .denied
  }
}

// MARK: - UNUserNotificationCenter

class UNUserNotificationCenterProxyApiDelegate: PigeonApiDelegateUNUserNotificationCenter {
  func current(pigeonApi: PigeonApiUNUserNotificationCenter) throws -> UNUserNotificationCenter {
    return UNUserNotificationCenter.current()
  }

  func requestAuthorization(
    pigeonApi: PigeonApiUNUserNotificationCenter,
    pigeonInstance: UNUserNotificationCenter,
    options: [UNAuthorizationOption],
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    pigeonInstance.requestAuthorization(options: nativeUNAuthorizationOptions(from: options)) {
      granted, _ in
      completion(.success(granted))
    }
  }

  func getNotificationSettings(
    pigeonApi: PigeonApiUNUserNotificationCenter,
    pigeonInstance: UNUserNotificationCenter,
    completion: @escaping (Result<UNNotificationSettings, Error>) -> Void
  ) {
    pigeonInstance.getNotificationSettings { settings in
      completion(.success(settings))
    }
  }
}

// MARK: - CBCentralManager

class CBCentralManagerProxyApiDelegate: PigeonApiDelegateCBCentralManager {
  func pigeonDefaultConstructor(
    pigeonApi: PigeonApiCBCentralManager,
    delegate: CBCentralManagerDelegate?
  ) throws -> CBCentralManager {
    let options = [CBCentralManagerOptionShowPowerAlertKey: false]
    return CBCentralManager(delegate: delegate, queue: nil, options: options)
  }

  func getState(pigeonApi: PigeonApiCBCentralManager, pigeonInstance: CBCentralManager) throws -> CBManagerState {
    return pigeonCBManagerState(from: pigeonInstance.state)
  }

  func authorization(pigeonApi: PigeonApiCBCentralManager) throws -> CBManagerAuthorization {
    if #available(iOS 13.1, *) {
      return pigeonCBManagerAuthorization(from: CBCentralManager.authorization)
    }
    return .denied
  }
}

// MARK: - CMMotionActivityManager

class CMMotionActivityManagerProxyApiDelegate: PigeonApiDelegateCMMotionActivityManager {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiCMMotionActivityManager) throws -> CMMotionActivityManager {
    return CMMotionActivityManager()
  }

  func authorizationStatus(pigeonApi: PigeonApiCMMotionActivityManager) throws -> CMAuthorizationStatus {
    return pigeonCMAuthorizationStatus(from: CMMotionActivityManager.authorizationStatus())
  }

  func isActivityAvailable(pigeonApi: PigeonApiCMMotionActivityManager) throws -> Bool {
    return CMMotionActivityManager.isActivityAvailable()
  }

  func queryActivityStartingFromDate(
    pigeonApi: PigeonApiCMMotionActivityManager,
    pigeonInstance: CMMotionActivityManager,
    from: DateWrapper,
    to: DateWrapper,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    pigeonInstance.queryActivityStarting(from: from.value, to: to.value, to: OperationQueue.main) { _, _ in
      completion(.success(()))
    }
  }
}

// MARK: - SFSpeechRecognizer

class SFSpeechRecognizerProxyApiDelegate: PigeonApiDelegateSFSpeechRecognizer {
  func authorizationStatus(pigeonApi: PigeonApiSFSpeechRecognizer) throws -> SFSpeechRecognizerAuthorizationStatus {
    return pigeonSFSpeechAuthorizationStatus(from: SFSpeechRecognizer.authorizationStatus())
  }

  func requestAuthorization(
    pigeonApi: PigeonApiSFSpeechRecognizer,
    completion: @escaping (Result<SFSpeechRecognizerAuthorizationStatus, Error>) -> Void
  ) {
    SFSpeechRecognizer.requestAuthorization { status in
      completion(.success(pigeonSFSpeechAuthorizationStatus(from: status)))
    }
  }
}

// MARK: - MPMediaLibrary

class MPMediaLibraryProxyApiDelegate: PigeonApiDelegateMPMediaLibrary {
  func authorizationStatus(pigeonApi: PigeonApiMPMediaLibrary) throws -> MPMediaLibraryAuthorizationStatus {
    return pigeonMPMediaAuthorizationStatus(from: MPMediaLibrary.authorizationStatus())
  }

  func requestAuthorization(
    pigeonApi: PigeonApiMPMediaLibrary,
    completion: @escaping (Result<MPMediaLibraryAuthorizationStatus, Error>) -> Void
  ) {
    MPMediaLibrary.requestAuthorization { status in
      completion(.success(pigeonMPMediaAuthorizationStatus(from: status)))
    }
  }
}

// MARK: - ATTrackingManager

class ATTrackingManagerProxyApiDelegate: PigeonApiDelegateATTrackingManager {
  func trackingAuthorizationStatus(pigeonApi: PigeonApiATTrackingManager) throws
    -> ATTrackingManagerAuthorizationStatus
  {
    if #available(iOS 14, *) {
      return pigeonATTAuthorizationStatus(from: ATTrackingManager.trackingAuthorizationStatus)
    }
    return .authorized
  }

  func requestTrackingAuthorization(
    pigeonApi: PigeonApiATTrackingManager,
    completion: @escaping (Result<ATTrackingManagerAuthorizationStatus, Error>) -> Void
  ) {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        completion(.success(pigeonATTAuthorizationStatus(from: status)))
      }
    } else {
      completion(.success(.authorized))
    }
  }
}

// MARK: - INPreferences

class INPreferencesProxyApiDelegate: PigeonApiDelegateINPreferences {
  func siriAuthorizationStatus(pigeonApi: PigeonApiINPreferences) throws -> INSiriAuthorizationStatus {
    return pigeonINSiriAuthorizationStatus(from: INPreferences.siriAuthorizationStatus())
  }

  func requestSiriAuthorization(
    pigeonApi: PigeonApiINPreferences,
    completion: @escaping (Result<INSiriAuthorizationStatus, Error>) -> Void
  ) {
    INPreferences.requestSiriAuthorization { status in
      completion(.success(pigeonINSiriAuthorizationStatus(from: status)))
    }
  }
}

// MARK: - CTCarrier

class CTCarrierProxyApiDelegate: PigeonApiDelegateCTCarrier {
  func getMobileNetworkCode(pigeonApi: PigeonApiCTCarrier, pigeonInstance: CTCarrier) throws -> String? {
    return pigeonInstance.mobileNetworkCode
  }
}

// MARK: - CTTelephonyNetworkInfo

class CTTelephonyNetworkInfoProxyApiDelegate: PigeonApiDelegateCTTelephonyNetworkInfo {
  func pigeonDefaultConstructor(pigeonApi: PigeonApiCTTelephonyNetworkInfo) throws -> CTTelephonyNetworkInfo {
    return CTTelephonyNetworkInfo()
  }

  func getSubscriberCellularProvider(
    pigeonApi: PigeonApiCTTelephonyNetworkInfo,
    pigeonInstance: CTTelephonyNetworkInfo
  ) throws -> CTCarrier? {
    return pigeonInstance.subscriberCellularProvider
  }

  func getServiceSubscriberCellularProviders(
    pigeonApi: PigeonApiCTTelephonyNetworkInfo,
    pigeonInstance: CTTelephonyNetworkInfo
  ) throws -> [String?: CTCarrier?]? {
    if #available(iOS 12.0, *) {
      return pigeonInstance.serviceSubscriberCellularProviders
    }
    return nil
  }
}
