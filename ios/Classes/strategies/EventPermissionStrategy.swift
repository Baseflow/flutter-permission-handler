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
    
    func requestPermission(permission: PermissionGroup) -> PermissionStatus {
        // TODO: Add implementation
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
}
