//
//  PermissionStatus.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 25/07/2018.
//

import Foundation

enum PermissionStatus : String, Codable {
    case denied = "denied"
    case disabled = "disabled"
    case granted = "granted"
    case restricted = "restricted"
    case unknown = "unknown"
}
