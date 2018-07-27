//
//  ContactPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import AddressBook
import Foundation

class ContactPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return ContactPermissionStrategy.getPermissionStatus()
    }
    
    func requestPermission(permission: PermissionGroup) -> PermissionStatus {
        // TODO: Add implementation
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        let status: ABAuthorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch status {
        case ABAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case ABAuthorizationStatus.denied:
            return PermissionStatus.denied
        case ABAuthorizationStatus.restricted:
            return PermissionStatus.restricted
        default:
            return PermissionStatus.unknown
        }
    }
}
