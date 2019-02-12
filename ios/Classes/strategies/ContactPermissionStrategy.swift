//
//  ContactPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import AddressBook
import Contacts
import Foundation

class ContactPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return ContactPermissionStrategy.getPermissionStatus()
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        if #available(iOS 9.0, *) {
            let status: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            
            switch status {
            case CNAuthorizationStatus.authorized:
                return PermissionStatus.granted
            case CNAuthorizationStatus.denied:
                return PermissionStatus.denied
            case CNAuthorizationStatus.restricted:
                return PermissionStatus.restricted
            default:
                return PermissionStatus.unknown
            }
        }
        
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
    
    func checkServiceStatus(permission: PermissionGroup) -> ServiceStatus {
        return ServiceStatus.notApplicable
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let permissionStatus = checkPermissionStatus(permission: permission)
        
        if permissionStatus != PermissionStatus.unknown {
            completionHandler(permissionStatus)
            return
        }
        
        if #available(iOS 9.0, *) {
            ContactPermissionStrategy.requestPermissionsFromContactStore(completionHandler: completionHandler)
        } else {
            ContactPermissionStrategy.requestPermissionsFromAddressBook(completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    private static func requestPermissionsFromContactStore(completionHandler: @escaping PermissionStatusHandler) {
        let contactStore = CNContactStore.init()
        
        contactStore.requestAccess(for: .contacts, completionHandler: {
            (authorized: Bool, error: Error?) in
                if authorized {
                    completionHandler(PermissionStatus.granted)
                } else {
                    completionHandler(PermissionStatus.denied)
                }
        })
    }
    
    private static func requestPermissionsFromAddressBook(completionHandler: @escaping PermissionStatusHandler) {
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate() as ABAddressBook, {
            (granted: Bool, error: CFError?) in
                if granted {
                    completionHandler(PermissionStatus.granted)
                } else {
                    completionHandler(PermissionStatus.denied)
                }
        })
    }
}
