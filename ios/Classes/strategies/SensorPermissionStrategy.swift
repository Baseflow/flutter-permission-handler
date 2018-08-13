//
//  SensorPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import CoreMotion
import Foundation

class SensorPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return SensorPermissionStrategy.getPermissionStatus()
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        if !CMMotionActivityManager.isActivityAvailable() {
            return PermissionStatus.disabled
        }
        
        if #available(iOS 11.0, *) {
            let status: CMAuthorizationStatus = CMMotionActivityManager.authorizationStatus()
            
            switch status {
            case CMAuthorizationStatus.authorized:
                return PermissionStatus.granted
            case CMAuthorizationStatus.denied:
                return PermissionStatus.denied
            case CMAuthorizationStatus.restricted:
                return PermissionStatus.restricted
            default:
                return PermissionStatus.unknown
            }
        }
        
        return PermissionStatus.unknown
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let status = checkPermissionStatus(permission: permission)
        
        if status != PermissionStatus.unknown {
            completionHandler(status)
            return
        }
        
        if #available(iOS 11.0, *) {
            let motionManager = CMMotionActivityManager.init()
            
            motionManager.startActivityUpdates(to: OperationQueue.main) { (_) in
                motionManager.stopActivityUpdates()
                
                completionHandler(.granted)
            }
        } else {
            completionHandler(.unknown)
        }
    }
}
