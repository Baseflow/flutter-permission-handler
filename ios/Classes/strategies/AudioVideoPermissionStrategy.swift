//
//  AudioVideoPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//
import AVFoundation
import Foundation

class AudioVideoPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        if permission == PermissionGroup.camera {
            return AudioVideoPermissionStrategy.getPermissionStatus(mediaType: AVMediaType.video)
        } else if permission == PermissionGroup.microphone {
            return AudioVideoPermissionStrategy.getPermissionStatus(mediaType: AVMediaType.audio)
        }
        
        return PermissionStatus.unknown
    }
    
    func requestPermission(permission: PermissionGroup) -> PermissionStatus {
        // TODO: Add implementation
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus(mediaType: AVMediaType) -> PermissionStatus {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch status {
        case AVAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case AVAuthorizationStatus.denied:
            return PermissionStatus.denied
        case AVAuthorizationStatus.restricted:
            return PermissionStatus.restricted
        default:
            return PermissionStatus.unknown
        }
    }
}
