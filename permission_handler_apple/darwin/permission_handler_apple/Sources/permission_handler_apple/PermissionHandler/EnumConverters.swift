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

// MARK: - Struct wrappers

class BundleWrapper {
  var value: Bundle
  init(_ value: Bundle) { self.value = value }
}

class UserDefaultsWrapper {
  var value: UserDefaults
  init(_ value: UserDefaults) { self.value = value }
}

class DateWrapper {
  var value: Date
  init(_ value: Date) { self.value = value }
}

class URLWrapper {
  var value: URL
  init(_ value: URL) { self.value = value }
}

// MARK: - Enum converters (pigeon <-> native)

func pigeonCLAuthorizationStatus(
  from native: CoreLocation.CLAuthorizationStatus
) -> CLAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorizedAlways: return .authorizedAlways
  case .authorizedWhenInUse: return .authorizedWhenInUse
  @unknown default: return .denied
  }
}

func nativeAVMediaType(from pigeon: AVMediaType) -> AVFoundation.AVMediaType {
  switch pigeon {
  case .video: return .video
  case .audio: return .audio
  }
}

func pigeonAVAuthorizationStatus(
  from native: AVFoundation.AVAuthorizationStatus
) -> AVAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  @unknown default: return .denied
  }
}

func nativePHAccessLevel(from pigeon: PHAccessLevel) -> Photos.PHAccessLevel {
  switch pigeon {
  case .addOnly: return .addOnly
  case .readWrite: return .readWrite
  }
}

func pigeonPHAuthorizationStatus(
  from native: Photos.PHAuthorizationStatus
) -> PHAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  case .limited: return .limited
  @unknown default: return .denied
  }
}

func nativeEKEntityType(from pigeon: EKEntityType) -> EventKit.EKEntityType {
  switch pigeon {
  case .event: return .event
  case .reminder: return .reminder
  }
}

func pigeonEKAuthorizationStatus(
  from native: EventKit.EKAuthorizationStatus
) -> EKAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  case .writeOnly: return .writeOnly
  case .fullAccess: return .fullAccess
  @unknown default: return .denied
  }
}

func nativeCNEntityType(from pigeon: CNEntityType) -> Contacts.CNEntityType {
  switch pigeon {
  case .contacts: return .contacts
  }
}

func pigeonCNAuthorizationStatus(
  from native: Contacts.CNAuthorizationStatus
) -> CNAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  case .limited: return .limited
  @unknown default: return .denied
  }
}

func pigeonUNAuthorizationStatus(
  from native: UserNotifications.UNAuthorizationStatus
) -> UNAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .denied: return .denied
  case .authorized: return .authorized
  case .provisional: return .provisional
  case .ephemeral: return .ephemeral
  @unknown default: return .denied
  }
}

func pigeonUNAuthorizationStatus(
  from notificationSetting: UNNotificationSetting
) -> UNAuthorizationStatus {
  switch notificationSetting {
  case .notSupported: return .notDetermined
  case .disabled: return .denied
  case .enabled: return .authorized
  @unknown default: return .denied
  }
}

func nativeUNAuthorizationOptions(from pigeon: [UNAuthorizationOption]) -> UNAuthorizationOptions {
  var result: UNAuthorizationOptions = []
  for option in pigeon {
    switch option {
    case .badge: result.insert(.badge)
    case .sound: result.insert(.sound)
    case .alert: result.insert(.alert)
    case .criticalAlert: result.insert(.criticalAlert)
    }
  }
  return result
}

func pigeonCBManagerState(from native: CoreBluetooth.CBManagerState) -> CBManagerState {
  switch native {
  case .unknown: return .unknown
  case .resetting: return .resetting
  case .unsupported: return .unsupported
  case .unauthorized: return .unauthorized
  case .poweredOff: return .poweredOff
  case .poweredOn: return .poweredOn
  @unknown default: return .unknown
  }
}

func pigeonCBManagerAuthorization(
  from native: CoreBluetooth.CBManagerAuthorization
) -> CBManagerAuthorization {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .allowedAlways: return .allowedAlways
  @unknown default: return .denied
  }
}

func pigeonCMAuthorizationStatus(
  from native: CoreMotion.CMAuthorizationStatus
) -> CMAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  @unknown default: return .denied
  }
}

func pigeonSFSpeechAuthorizationStatus(
  from native: Speech.SFSpeechRecognizerAuthorizationStatus
) -> SFSpeechRecognizerAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .denied: return .denied
  case .restricted: return .restricted
  case .authorized: return .authorized
  @unknown default: return .denied
  }
}

func pigeonMPMediaAuthorizationStatus(
  from native: MediaPlayer.MPMediaLibraryAuthorizationStatus
) -> MPMediaLibraryAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .denied: return .denied
  case .restricted: return .restricted
  case .authorized: return .authorized
  @unknown default: return .denied
  }
}

func pigeonATTAuthorizationStatus(
  from native: ATTrackingManager.AuthorizationStatus
) -> ATTrackingManagerAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  @unknown default: return .denied
  }
}

func pigeonINSiriAuthorizationStatus(
  from native: Intents.INSiriAuthorizationStatus
) -> INSiriAuthorizationStatus {
  switch native {
  case .notDetermined: return .notDetermined
  case .restricted: return .restricted
  case .denied: return .denied
  case .authorized: return .authorized
  @unknown default: return .denied
  }
}

func pigeonUIBackgroundRefreshStatus(
  from native: UIKit.UIBackgroundRefreshStatus
) -> UIBackgroundRefreshStatus {
  switch native {
  case .restricted: return .restricted
  case .denied: return .denied
  case .available: return .available
  @unknown default: return .denied
  }
}

var locationDelegateKey: UInt8 = 0
var centralDelegateKey: UInt8 = 0
