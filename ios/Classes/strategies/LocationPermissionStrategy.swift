//
//  LocationPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import CoreLocation
import Foundation

class LocationPermissionStrategy : NSObject, PermissionStrategy, CLLocationManagerDelegate {
    private var _permissionStatusHandler: PermissionStatusHandler? = nil
    private var _requestedPermission: PermissionGroup? = nil
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return LocationPermissionStrategy.getPermissionStatus(permission: permission)
    }
    
    private static func getPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        if !CLLocationManager.locationServicesEnabled() {
            return PermissionStatus.disabled
        }
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        return LocationPermissionStrategy.determinePermissionStatus(
            permission: permission,
            authorizationStatus: status)
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let permissionStatus = checkPermissionStatus(permission: permission)
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse && permission == PermissionGroup.locationAlways {
            // don't do anything and continue requesting permissions
        } else if permissionStatus != PermissionStatus.unknown {
            completionHandler(permissionStatus)
            return
        }
        
        _permissionStatusHandler = completionHandler
        _requestedPermission = permission
        let locationManager = CLLocationManager.init()
        locationManager.delegate = self
        
        if(permission != PermissionGroup.location) {
            if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
                locationManager.requestWhenInUseAuthorization()
            } else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
                locationManager.requestAlwaysAuthorization();
            } else {
                NSException(name: NSExceptionName.internalInconsistencyException, reason:"To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file", userInfo: nil).raise()
            }
        } else if permission == PermissionGroup.locationAlways {
            if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
                locationManager.requestAlwaysAuthorization();
            } else {
                NSException(name: NSExceptionName.internalInconsistencyException, reason:"To use location in iOS8 you need to define NSLocationAlwaysUsageDescription in the app bundle's Info.plist file", userInfo: nil).raise()
            }
        } else if permission == PermissionGroup.locationWhenInUse {
            if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
                locationManager.requestWhenInUseAuthorization();
            } else {
                NSException(name: NSExceptionName.internalInconsistencyException, reason:"To use location in iOS8 you need to define NSLocationWhenInUseUsageDescription in the app bundle's Info.plist file", userInfo: nil).raise()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let completionHandler = _permissionStatusHandler else { return }
        
        completionHandler(
            LocationPermissionStrategy.determinePermissionStatus(
                permission: _requestedPermission!,
                authorizationStatus: status))
    }
    
    private static func determinePermissionStatus(permission: PermissionGroup, authorizationStatus: CLAuthorizationStatus) -> PermissionStatus {
        if #available(iOS 8.0, *) {
            if permission == PermissionGroup.locationAlways {
                switch authorizationStatus {
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
            
            switch authorizationStatus {
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
        
        switch authorizationStatus {
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
