import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

open class ProxyApiRegistrar: PermissionHandlerLibraryPigeonProxyApiRegistrar {
  init(binaryMessenger: FlutterBinaryMessenger) {
    super.init(binaryMessenger: binaryMessenger, apiDelegate: ProxyApiDelegate())
  }

  func createUnsupportedVersionError(method: String, versionRequirements: String) -> PigeonError {
    return PigeonError(
      code: "FWFUnsupportedVersionError",
      message: "`\(method)` requires \(versionRequirements).",
      details: nil
    )
  }

  fileprivate func assertFlutterMethodFailure(_ error: PigeonError, methodName: String) {
    assertionFailure(
      "\(String(describing: error)): Error returned from calling \(methodName): \(String(describing: error.message))"
    )
  }

  func dispatchOnMainThread(
    execute work: @escaping (
      _ onFailure: @escaping (_ methodName: String, _ error: PigeonError) -> Void
    ) -> Void
  ) {
    DispatchQueue.main.async {
      work { methodName, error in
        self.assertFlutterMethodFailure(error, methodName: methodName)
      }
    }
  }
}

class ProxyApiDelegate: PermissionHandlerLibraryPigeonProxyApiDelegate {
  func pigeonApiNSObject(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiNSObject {
    return PigeonApiNSObject(pigeonRegistrar: registrar, delegate: NSObjectProxyApiDelegate())
  }

  func pigeonApiNSBundle(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiNSBundle {
    return PigeonApiNSBundle(pigeonRegistrar: registrar, delegate: NSBundleProxyApiDelegate())
  }

  func pigeonApiNSUserDefaults(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiNSUserDefaults
  {
    return PigeonApiNSUserDefaults(pigeonRegistrar: registrar, delegate: NSUserDefaultsProxyApiDelegate())
  }

  func pigeonApiNSDate(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiNSDate {
    return PigeonApiNSDate(pigeonRegistrar: registrar, delegate: NSDateProxyApiDelegate())
  }

  func pigeonApiURL(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiURL {
    return PigeonApiURL(pigeonRegistrar: registrar, delegate: URLProxyApiDelegate())
  }

  func pigeonApiUIApplication(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiUIApplication {
    return PigeonApiUIApplication(pigeonRegistrar: registrar, delegate: UIApplicationProxyApiDelegate())
  }

  func pigeonApiCLLocationManager(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiCLLocationManager
  {
    return PigeonApiCLLocationManager(pigeonRegistrar: registrar, delegate: CLLocationManagerProxyApiDelegate())
  }

  func pigeonApiCLLocationManagerDelegate(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiCLLocationManagerDelegate
  {
    return PigeonApiCLLocationManagerDelegate(
      pigeonRegistrar: registrar,
      delegate: CLLocationManagerDelegateProxyApiDelegate()
    )
  }

  func pigeonApiAVCaptureDevice(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiAVCaptureDevice {
    return PigeonApiAVCaptureDevice(pigeonRegistrar: registrar, delegate: AVCaptureDeviceProxyApiDelegate())
  }

  func pigeonApiPHPhotoLibrary(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiPHPhotoLibrary {
    return PigeonApiPHPhotoLibrary(pigeonRegistrar: registrar, delegate: PHPhotoLibraryProxyApiDelegate())
  }

  func pigeonApiEKEventStore(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiEKEventStore {
    return PigeonApiEKEventStore(pigeonRegistrar: registrar, delegate: EKEventStoreProxyApiDelegate())
  }

  func pigeonApiCNContactStore(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiCNContactStore {
    return PigeonApiCNContactStore(pigeonRegistrar: registrar, delegate: CNContactStoreProxyApiDelegate())
  }

  func pigeonApiUNNotificationSettings(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiUNNotificationSettings
  {
    return PigeonApiUNNotificationSettings(
      pigeonRegistrar: registrar,
      delegate: UNNotificationSettingsProxyApiDelegate()
    )
  }

  func pigeonApiUNUserNotificationCenter(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiUNUserNotificationCenter
  {
    return PigeonApiUNUserNotificationCenter(
      pigeonRegistrar: registrar,
      delegate: UNUserNotificationCenterProxyApiDelegate()
    )
  }

  func pigeonApiCBCentralManager(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiCBCentralManager {
    return PigeonApiCBCentralManager(pigeonRegistrar: registrar, delegate: CBCentralManagerProxyApiDelegate())
  }

  func pigeonApiCBCentralManagerDelegate(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiCBCentralManagerDelegate
  {
    return PigeonApiCBCentralManagerDelegate(
      pigeonRegistrar: registrar,
      delegate: CBCentralManagerDelegateProxyApiDelegate()
    )
  }

  func pigeonApiCMMotionActivityManager(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiCMMotionActivityManager
  {
    return PigeonApiCMMotionActivityManager(
      pigeonRegistrar: registrar,
      delegate: CMMotionActivityManagerProxyApiDelegate()
    )
  }

  func pigeonApiSFSpeechRecognizer(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiSFSpeechRecognizer
  {
    return PigeonApiSFSpeechRecognizer(pigeonRegistrar: registrar, delegate: SFSpeechRecognizerProxyApiDelegate())
  }

  func pigeonApiMPMediaLibrary(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiMPMediaLibrary {
    return PigeonApiMPMediaLibrary(pigeonRegistrar: registrar, delegate: MPMediaLibraryProxyApiDelegate())
  }

  func pigeonApiATTrackingManager(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiATTrackingManager
  {
    return PigeonApiATTrackingManager(pigeonRegistrar: registrar, delegate: ATTrackingManagerProxyApiDelegate())
  }

  func pigeonApiINPreferences(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiINPreferences {
    return PigeonApiINPreferences(pigeonRegistrar: registrar, delegate: INPreferencesProxyApiDelegate())
  }

  func pigeonApiCTCarrier(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar) -> PigeonApiCTCarrier {
    return PigeonApiCTCarrier(pigeonRegistrar: registrar, delegate: CTCarrierProxyApiDelegate())
  }

  func pigeonApiCTTelephonyNetworkInfo(_ registrar: PermissionHandlerLibraryPigeonProxyApiRegistrar)
    -> PigeonApiCTTelephonyNetworkInfo
  {
    return PigeonApiCTTelephonyNetworkInfo(
      pigeonRegistrar: registrar,
      delegate: CTTelephonyNetworkInfoProxyApiDelegate()
    )
  }
}
