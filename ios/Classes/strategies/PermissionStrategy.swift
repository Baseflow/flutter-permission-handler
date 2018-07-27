//
//  Task.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import Foundation

protocol PermissionStrategy {
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus
    func requestPermission(permission: PermissionGroup) -> PermissionStatus
}
