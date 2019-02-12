//
//  ServiceStatus.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 12/02/2019.
//

import Foundation

enum ServiceStatus : String, Codable {
    case disabled = "disabled"
    case enabled = "enabled"
    case notApplicable = "notApplicable"
    case unknown = "unknown"
}
