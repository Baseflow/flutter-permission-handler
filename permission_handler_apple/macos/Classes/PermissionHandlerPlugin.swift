import Cocoa
import FlutterMacOS

public class PermissionHandlerPlugin: NSObject, FlutterPlugin {
    
    var _permissionManager = PermissionManager()
    var methodResult: FlutterResult? = nil
    
    init(withPermissionManager permissionManager: PermissionManager) {
        super.init()
        _permissionManager = permissionManager
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter.baseflow.com/permissions/methods", binaryMessenger: registrar.messenger)
        let permissionManager: PermissionManager = PermissionManager.init(strategyInstances: ())
        let instance = PermissionHandlerPlugin(withPermissionManager: permissionManager)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkPermissionStatus":
            guard let args = call.arguments as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Should be a number", details: nil))
                return
            }
            let number = NSNumber(value: args)
            let permission: PermissionGroup = Codec.decodePermissionGroup(from: number)
            PermissionManager.checkPermissionStatus(permission, result: result)
        case "checkServiceStatus":
            guard let args = call.arguments as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Should be a number", details: nil))
                return
            }
            let number = NSNumber(value: args)
            let permission: PermissionGroup = Codec.decodePermissionGroup(from: number)
            PermissionManager.checkServiceStatus(permission, result: result)
        case "requestPermissions":
            guard methodResult != nil else {
                result(FlutterError(code: "ERROR_ALREADY_REQUESTING_PERMISSIONS", message: "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time).", details: nil))
                return
            }
            methodResult = result
            guard let args = call.arguments as? [Int] else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Should be an array of numbers", details: nil))
                return
            }
            let argsNumbers = args.map { NSNumber(value: $0) }
            guard let permissions = Codec.decodePermissionGroups(from: argsNumbers) as? [NSNumber] else {
                result(FlutterError(code: "DECODE_ERROR", message: "Should be an array of numbers", details: nil))
                return
            }
            _permissionManager.requestPermissions(permissions) { permissionRequestResults in
                if let methodResult = self.methodResult {
                    methodResult(permissionRequestResults)
                }
                
                self.methodResult = nil
            }
        case "shouldShowRequestPermissionRationale":
            result(false)
        case "openAppSettings":
            PermissionManager.openAppSettings(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
