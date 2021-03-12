//
//  BluetoothPermissionStrategy.m
//  permission_handler
//
//  Created by Rene Floor on 12/03/2021.
//

#import "BluetoothPermissionStrategy.h"

#if PERMISSION_BLUETOOTH

@implementation BluetoothPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (@available(iOS 13.1, *)) {
        CBManagerAuthorization blePermission = [CBCentralManager authorization];
        return [BluetoothPermissionStrategy parsePermission:blePermission];
    } else if (@available(iOS 13.0, *)){
        CBCentralManager* manager = [[CBCentralManager alloc] init];
        CBManagerAuthorization blePermission =  [manager authorization];
        return [BluetoothPermissionStrategy parsePermission:blePermission];
    }
    return PermissionStatusGranted;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    CBCentralManager* manager = [[CBCentralManager alloc] init];
    if (@available(iOS 10, *)) {
        return [manager state] == CBManagerStatePoweredOn ? ServiceStatusEnabled : ServiceStatusDisabled;
    }
    return [manager state] == CBCentralManagerStatePoweredOn ? ServiceStatusEnabled : ServiceStatusDisabled;
    
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    completionHandler([self checkPermissionStatus:permission]);
}

+ (PermissionStatus)parsePermission:(CBManagerAuthorization)bluetoothPermission API_AVAILABLE(ios(13)){
    switch(bluetoothPermission){
        case CBManagerAuthorizationNotDetermined:
            return PermissionStatusDenied;
        case CBManagerAuthorizationRestricted:
            return PermissionStatusRestricted;
        case CBManagerAuthorizationDenied:
            return PermissionStatusDenied;
        case CBManagerAuthorizationAllowedAlways:
            return PermissionStatusGranted;
    }
}
@end

#else

@implementation BluetoothPermissionStrategy
@end

#endif
