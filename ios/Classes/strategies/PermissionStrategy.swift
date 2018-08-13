//
//  Task.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Foundation

typealias PermissionStatusHandler = (_ permissionStatus: PermissionStatus) -> Void

protocol PermissionStrategy {
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler)
}
