//
//  PermissionManager.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Flutter
import Foundation
import UIKit

class PermissionManager: NSObject {
    
    static func checkPermissionStatus(permission: PermissionGroup, result: @escaping FlutterResult) {
        let permissionStrategy = PermissionManager.createPermissionStrategy(permission: permission)
        let permissionStatus = permissionStrategy.checkPermissionStatus(permission: permission)
        
        result(Codec.encodePermissionStatus(permissionStatus: permissionStatus))
    }
    
    static func openAppSettings(result: @escaping FlutterResult) {
        if #available(iOS 8.0, *) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:],
                                          completionHandler: {
                                            (success) in result(success)
                                          })
            } else {
                let success = UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                result(success)
            }
        }
        
        result(false)
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
