//
//  PermissionManager.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Foundation

class PermissionManager: NSObject {
    
    static func checkPermissionStatus(permission: PermissionGroup, result: @escaping FlutterResult) {
        let permissionStrategy = PermissionManager.createPermissionStrategy(permission: permission)
        let permissionStatus = permissionStrategy.checkPermissionStatus(permission: permission)
        
        result(Codec.encodePermissionStatus(permissionStatus: permissionStatus))
    }
    
    private static func createPermissionStrategy(permission: PermissionGroup) -> PermissionStrategy {
        switch permission {
        case PermissionGroup.calendar:
            return EventPermissionStrategy()
        case PermissionGroup.camera:
            return AudioVideoPermissionStrategy()
        case PermissionGroup.contacts:
            return ContactPermissionStrategy()
        case PermissionGroup.location,
             PermissionGroup.locationAlways,
             PermissionGroup.locationWhenInUse:
            return LocationPermissionStrategy()
        case PermissionGroup.mediaLibrary:
            return MediaLibraryPermissionStrategy()
        case PermissionGroup.microphone:
            return AudioVideoPermissionStrategy()
        case PermissionGroup.photos:
            return PhotoPermissionStrategy()
        case PermissionGroup.reminders:
            return EventPermissionStrategy()
        case PermissionGroup.sensors:
            return SensorPermissionStrategy()
        case PermissionGroup.speech:
            return SpeechPermissionStrategy()
        }
    }
}
