import Foundation

class PermissionCompileFlagsHostApiImpl: PermissionCompileFlagsHostApi {
  func isPermissionGroupEnabled(permissionGroup: Int64) throws -> Bool {
    switch permissionGroup {
    case 0, 36, 37: // calendar, calendarWriteOnly, calendarFullAccess
      #if PERMISSION_EVENTS || PERMISSION_EVENTS_FULL_ACCESS
      return true
      #else
      return false
      #endif
    case 11: // reminders
      #if PERMISSION_REMINDERS
      return true
      #else
      return false
      #endif
    case 2: // contacts
      #if PERMISSION_CONTACTS
      return true
      #else
      return false
      #endif
    case 1: // camera
      #if PERMISSION_CAMERA
      return true
      #else
      return false
      #endif
    case 7: // microphone
      #if PERMISSION_MICROPHONE
      return true
      #else
      return false
      #endif
    case 15: // speech
      #if PERMISSION_SPEECH_RECOGNIZER
      return true
      #else
      return false
      #endif
    case 8, 9: // photos, photosAddOnly
      #if PERMISSION_PHOTOS
      return true
      #else
      return false
      #endif
    case 3, 4, 5: // location, locationAlways, locationWhenInUse
      #if PERMISSION_LOCATION || PERMISSION_LOCATION_WHENINUSE || PERMISSION_LOCATION_ALWAYS
      return true
      #else
      return false
      #endif
    case 17: // notification
      #if PERMISSION_NOTIFICATIONS
      return true
      #else
      return false
      #endif
    case 6: // mediaLibrary
      #if PERMISSION_MEDIA_LIBRARY
      return true
      #else
      return false
      #endif
    case 12: // sensors
      #if PERMISSION_SENSORS
      return true
      #else
      return false
      #endif
    case 19: // bluetooth
      #if PERMISSION_BLUETOOTH
      return true
      #else
      return false
      #endif
    case 24: // appTrackingTransparency
      #if PERMISSION_APP_TRACKING_TRANSPARENCY
      return true
      #else
      return false
      #endif
    case 25: // criticalAlerts
      #if PERMISSION_CRITICAL_ALERTS
      return true
      #else
      return false
      #endif
    case 38: // assistant
      #if PERMISSION_ASSISTANT
      return true
      #else
      return false
      #endif
    case 16: // storage - always enabled on iOS
      return true
    case 39: // backgroundRefresh - always enabled on iOS
      return true
    default:
      return false
    }
  }
}
