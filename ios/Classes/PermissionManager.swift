//
//  PermissionManager.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Flutter
import Foundation
import UIKit
import Swift

typealias PermissionRequestCompletion = (_ permissionRequestResults: [PermissionGroup:PermissionStatus]) -> ()

class PermissionManager: NSObject {
    private var _strategyInstances: [ObjectIdentifier: PermissionStrategy] = [:]
    
    static func checkPermissionStatus(permission: PermissionGroup, result: @escaping FlutterResult) {
        let permissionStrategy = PermissionManager.createPermissionStrategy(permission: permission)
        let permissionStatus = permissionStrategy.checkPermissionStatus(permission: permission)
        
        result(Codec.encodePermissionStatus(permissionStatus: permissionStatus))
    }
    
    func requestPermissions(permissions: [PermissionGroup], completion: @escaping PermissionRequestCompletion) {
        var requestQueue = Set(permissions.map { $0 })
        var permissionStatusResult: [PermissionGroup: PermissionStatus] = [:]
        
        for permission in permissions {
            let permissionStrategy = PermissionManager.createPermissionStrategy(permission: permission)
            let identifier = ObjectIdentifier(permissionStrategy as AnyObject)
            _strategyInstances[identifier] = permissionStrategy

            permissionStrategy.requestPermission(permission: permission) { (permissionStatus: PermissionStatus) in
                permissionStatusResult[permission] = permissionStatus
                requestQueue.remove(permission)
                self._strategyInstances.removeValue(forKey: ObjectIdentifier(permissionStrategy as AnyObject))
                
                if requestQueue.count == 0 {
                    completion(permissionStatusResult)
                    return
                }
            }
        }
    }
    
    static func openAppSettings(result: @escaping FlutterResult) {
        if #available(iOS 8.0, *) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                          completionHandler: {
                                            (success) in result(success)
                                          })
            } else {
                let success = UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
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
        default:
            return UnknownPermissionStrategy()
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
