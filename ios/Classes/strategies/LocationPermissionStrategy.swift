//
//  LocationPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import CoreLocation
import Foundation

class LocationPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return LocationPermissionStrategy.getPermissionStatus(permission: permission)
    }
    
    func requestPermission(permission: PermissionGroup) -> PermissionStatus {
        // TODO: Add implementation
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        if !CLLocationManager.locationServicesEnabled() {
            return PermissionStatus.disabled
        }
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if #available(iOS 8.0, *) {
            if permission == PermissionGroup.locationAlways {
                switch status {
                case CLAuthorizationStatus.authorizedAlways:
                    return PermissionStatus.granted
                case CLAuthorizationStatus.authorizedWhenInUse,
                     CLAuthorizationStatus.denied:
                    return PermissionStatus.denied
                case CLAuthorizationStatus.restricted:
                    return PermissionStatus.restricted
                default:
                    return PermissionStatus.unknown
                }
            }
            
            switch status {
            case CLAuthorizationStatus.authorizedAlways,
                 CLAuthorizationStatus.authorizedWhenInUse:
                return PermissionStatus.granted
            case CLAuthorizationStatus.denied:
                return PermissionStatus.denied
            case CLAuthorizationStatus.restricted:
                return PermissionStatus.restricted
            default:
                return PermissionStatus.unknown
            }
        }
        
        switch status {
        case CLAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case CLAuthorizationStatus.denied:
            return PermissionStatus.denied
        case CLAuthorizationStatus.restricted:
            return PermissionStatus.restricted
        default:
            return PermissionStatus.unknown
        }
    }
}
