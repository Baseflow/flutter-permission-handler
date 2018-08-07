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
    
    private static func getPermissionStatus() -> PermissionStatus {
        if #available(iOS 10.0, *) {
            let status: SFSpeechRecognizerAuthorizationStatus = SFSpeechRecognizer.authorizationStatus()
            
            return SpeechPermissionStrategy.determinePermissionStatus(authorizationStatus: status)
        }
        
        return PermissionStatus.unknown
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let status = checkPermissionStatus(permission: permission)
        
        if status != PermissionStatus.unknown {
            completionHandler(status)
            return
        }
        
        if #available(iOS 10.0, *) {
            SFSpeechRecognizer.requestAuthorization { (authorizationStatus: SFSpeechRecognizerAuthorizationStatus) in
                completionHandler(
                    SpeechPermissionStrategy.determinePermissionStatus(authorizationStatus: authorizationStatus))
                return
            }
        }
        
        completionHandler(PermissionStatus.unknown)
    }
    
    @available(iOS 10.0, *)
    private static func determinePermissionStatus(authorizationStatus: SFSpeechRecognizerAuthorizationStatus) -> PermissionStatus {
        switch authorizationStatus {
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
}
