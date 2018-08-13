
import CoreLocation
import CoreMotion
import EventKit
import Flutter
import Foundation
import Photos
import UIKit
    
public class SwiftPermissionHandlerPlugin: NSObject, FlutterPlugin {
    private static let METHOD_CHANNEL_NAME = "flutter.baseflow.com/permissions/methods";
    private let _permissionManager: PermissionManager = PermissionManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftPermissionHandlerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "checkPermissionStatus" {
            let permission: PermissionGroup = Codec.decodePermissionGroup(from: call.arguments)
            
            PermissionManager.checkPermissionStatus(
                permission: permission,
                result: result)
        } else if call.method == "requestPermissions" {
            let permissions: [PermissionGroup] = Codec.decodePermissionGroups(from: call.arguments)
            
            _permissionManager.requestPermission(
                permissions: permissions,
                result: result)
        } else if call.method == "shouldShowRequestPermissionRationale" {
            result(false)
        } else if call.method == "openAppSettings" {
            PermissionManager.openAppSettings(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
