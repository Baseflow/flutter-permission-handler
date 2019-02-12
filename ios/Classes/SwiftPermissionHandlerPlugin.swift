
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
    private var _methodResult: FlutterResult?
    
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
        } else if call.method == "checkServiceStatus" {
            let permission: PermissionGroup = Codec.decodePermissionGroup(from: call.arguments)
            
            PermissionManager.checkServiceStatus(
                permission: permission,
                result: result)
        } else if call.method == "requestPermissions" {
            if _methodResult != nil {
                result(FlutterError(
                    code: "ERROR_ALREADY_REQUESTING_PERMISSIONS",
                    message: "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time).",
                    details: nil))
            }
            
            _methodResult = result
            let permissions: [PermissionGroup] = Codec.decodePermissionGroups(from: call.arguments)
            
            _permissionManager.requestPermissions(permissions: permissions) {
                (permissionRequestResults: [PermissionGroup:PermissionStatus]) in
                
                if self._methodResult != nil {
                    self._methodResult!(Codec.encodePermissionRequestResult(permissionStatusResult: permissionRequestResults))
                }
                
                self._methodResult = nil
            }
        } else if call.method == "shouldShowRequestPermissionRationale" {
            result(false)
        } else if call.method == "openAppSettings" {
            PermissionManager.openAppSettings(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
