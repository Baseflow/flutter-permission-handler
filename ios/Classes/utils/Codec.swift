//
//  Codec.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 25/07/2018.
//

import Foundation

struct Codec {
    private static let jsonDecoder = JSONDecoder()
    private static let jsonEncoder = JSONEncoder()
    
    static func decodePermissionGroup(from arguments: Any?) -> PermissionGroup {
        var permissionString: String = arguments as! String
        permissionString.removeFirst()
        permissionString.removeLast()
        
        return PermissionGroup(rawValue: permissionString)!
    }
    
    static func encodePermissionStatus(permissionStatus: PermissionStatus) -> String {
        return permissionStatus.rawValue
    }
}
