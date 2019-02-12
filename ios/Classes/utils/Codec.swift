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
    
    static func decodePermissionGroups(from arguments: Any?) -> [PermissionGroup] {
        let data = (arguments as! String).data(using: .utf8)
        let permissions = try! jsonDecoder.decode([PermissionGroup].self, from: data!)

        return permissions
    }
    
    static func encodePermissionStatus(permissionStatus: PermissionStatus) -> String? {
        let status = "\"" + permissionStatus.rawValue + "\""
        return status
    }
    
    static func encodeServiceStatus(serviceStatus: ServiceStatus) -> String? {
        let status = "\"" + serviceStatus.rawValue + "\""
        return status
    }
    
    static func encodePermissionRequestResult(permissionStatusResult: [PermissionGroup: PermissionStatus]) -> String? {
        let jsonDict = Dictionary(uniqueKeysWithValues:
            permissionStatusResult.map {
                (key: PermissionGroup, value: PermissionStatus) in (key.rawValue, value.rawValue)
                
        })
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!

        return jsonString
    }
}
