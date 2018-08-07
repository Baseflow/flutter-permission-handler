//
//  PhotoPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Foundation
import Photos

class PhotoPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return PhotoPermissionStrategy.getPermissionStatus()
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        return PhotoPermissionStrategy.determinePermissionStatus(authorizationStatus: status)
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let status = checkPermissionStatus(permission: permission)
        
        if status != PermissionStatus.unknown {
            completionHandler(status)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { (authorizationStatus: PHAuthorizationStatus) in
            completionHandler(
                PhotoPermissionStrategy.determinePermissionStatus(authorizationStatus: authorizationStatus))
        }
    }
    
    private static func determinePermissionStatus(authorizationStatus: PHAuthorizationStatus) -> PermissionStatus {
        switch authorizationStatus {
        case PHAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case PHAuthorizationStatus.denied:
            return PermissionStatus.denied
        case PHAuthorizationStatus.restricted:
            return PermissionStatus.restricted
        default:
            return PermissionStatus.unknown
        }
    }
}
