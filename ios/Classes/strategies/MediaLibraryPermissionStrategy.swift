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
    
    func requestPermission(permission: PermissionGroup) -> PermissionStatus {
        // TODO: Add implementation
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        if #available(iOS 9.3, *) {
            let status: MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
            
            switch status {
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
        
        return PermissionStatus.unknown
    }
}
