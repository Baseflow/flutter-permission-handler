
import CoreLocation
import CoreMotion
import EventKit
import Flutter
import Foundation
import Photos
import UIKit
    
public class SwiftPermissionHandlerPlugin: NSObject, FlutterPlugin {
    private static let METHOD_CHANNEL_NAME = "flutter.baseflow.com/permissions/methods";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftPermissionHandlerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "checkPermissionStatus" {
            PermissionManager.checkPermissionStatus(
                permission: Codec.decodePermissionGroup(from: call.arguments),
                result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
