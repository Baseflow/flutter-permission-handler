//
//  SpeechPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Foundation
import Speech

class SpeechPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return SpeechPermissionStrategy.getPermissionStatus()
    }
    
    func requestPermission(permission: PermissionGroup) -> PermissionStatus {
        // TODO: Add implementation
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        if #available(iOS 10.0, *) {
            let status: SFSpeechRecognizerAuthorizationStatus = SFSpeechRecognizer.authorizationStatus()
            
            switch status {
            case SFSpeechRecognizerAuthorizationStatus.authorized:
                return PermissionStatus.granted
            case SFSpeechRecognizerAuthorizationStatus.denied:
                return PermissionStatus.denied
            case SFSpeechRecognizerAuthorizationStatus.restricted:
                return PermissionStatus.restricted
            default:
                return PermissionStatus.unknown
            }
        }
        
        return PermissionStatus.unknown
    }
}
