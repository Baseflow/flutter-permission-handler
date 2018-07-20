#import "PermissionHandlerPlugin.h"
#import <permission_handler/permission_handler-Swift.h>

@implementation PermissionHandlerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPermissionHandlerPlugin registerWithRegistrar:registrar];
}
@end
