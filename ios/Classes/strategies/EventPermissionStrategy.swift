//
//  EventPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import EventKit
import Foundation

class EventPermissionStrategy : NSObject, PermissionStrategy {

    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        if permission == PermissionGroup.calendar {
            return EventPermissionStrategy.getPermissionStatus(entityType: EKEntityType.event)
        } else if permission == PermissionGroup.reminders {
            return EventPermissionStrategy.getPermissionStatus(entityType: EKEntityType.reminder)
        }
        
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus(entityType: EKEntityType) -> PermissionStatus {
        let status: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: entityType)
        
        switch status {
        case EKAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case EKAuthorizationStatus.denied:
            return PermissionStatus.denied
        case EKAuthorizationStatus.restricted:
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
        
        var entityType: EKEntityType
        
        if permission == PermissionGroup.calendar {
            entityType = EKEntityType.event
        } else if permission == PermissionGroup.reminders {
            entityType = EKEntityType.reminder
        } else {
            completionHandler(PermissionStatus.unknown)
            return
        }
        
        let eventStore: EKEventStore = EKEventStore.init()
        eventStore.requestAccess(to: entityType) { (granted: Bool, error: Error?) in
            if granted {
                completionHandler(PermissionStatus.granted)
            } else {
                completionHandler(PermissionStatus.denied)
            }
        }
    }
}
