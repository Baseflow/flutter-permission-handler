//
//  MediaLibraryPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Foundation
import MediaPlayer

class MediaLibraryPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return MediaLibraryPermissionStrategy.getPermissionStatus()
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        if #available(iOS 9.3, *) {
            let status: MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
            
            return MediaLibraryPermissionStrategy.determinePermissionStatus(authorizationStatus: status)
        }
        
        return PermissionStatus.unknown
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) -> Void {
        let status = checkPermissionStatus(permission: permission)
        if status != PermissionStatus.unknown {
            completionHandler(status)
            return
        }

        if #available(iOS 9.3, *)  {
            MPMediaLibrary.requestAuthorization { (status: MPMediaLibraryAuthorizationStatus) in
                completionHandler(
                    MediaLibraryPermissionStrategy.determinePermissionStatus(authorizationStatus: status))
            }
        } else {
            completionHandler(PermissionStatus.unknown)
            return
        }
    }
    
    @available(iOS 9.3, *)
    private static func determinePermissionStatus(authorizationStatus: MPMediaLibraryAuthorizationStatus) -> PermissionStatus {
        switch authorizationStatus {
        case MPMediaLibraryAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case MPMediaLibraryAuthorizationStatus.denied:
            return PermissionStatus.denied
        case MPMediaLibraryAuthorizationStatus.restricted:
            return PermissionStatus.restricted
        default:
            return PermissionStatus.unknown
        }
    }
}
