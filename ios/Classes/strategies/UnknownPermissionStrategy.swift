//
//  UnknownPermissionStrategy.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 07/08/2018.
//

import Foundation

class UnknownPermissionStrategy : NSObject, PermissionStrategy {
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return PermissionStatus.unknown
    }
    
    func checkServiceStatus(permission: PermissionGroup) -> ServiceStatus {
        return ServiceStatus.unknown
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        completionHandler(PermissionStatus.unknown)
    }
}
