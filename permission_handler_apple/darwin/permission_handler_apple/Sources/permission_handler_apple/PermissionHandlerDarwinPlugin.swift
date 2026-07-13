#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

@objc(PermissionHandlerDarwinPlugin)
public class PermissionHandlerDarwinPlugin: NSObject, FlutterPlugin {
  var proxyApiRegistrar: ProxyApiRegistrar?

  init(binaryMessenger: FlutterBinaryMessenger) {
    proxyApiRegistrar = ProxyApiRegistrar(binaryMessenger: binaryMessenger)
    proxyApiRegistrar?.setUp()
    PermissionCompileFlagsHostApiSetup.setUp(
      binaryMessenger: binaryMessenger,
      api: PermissionCompileFlagsHostApiImpl()
    )
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
      let binaryMessenger = registrar.messenger()
    #else
      let binaryMessenger = registrar.messenger
    #endif
    let plugin = PermissionHandlerDarwinPlugin(binaryMessenger: binaryMessenger)
    registrar.publish(plugin)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    proxyApiRegistrar?.ignoreCallsToDart = true
    proxyApiRegistrar?.tearDown()
    proxyApiRegistrar = nil
    #if os(iOS)
      let binaryMessenger = registrar.messenger()
    #else
      let binaryMessenger = registrar.messenger
    #endif
    PermissionCompileFlagsHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: nil)
  }
}
