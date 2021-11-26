//
//  BluetoothPermissionStrategy.m
//  permission_handler
//
//  Created by Rene Floor on 12/03/2021.
//

#import "BluetoothPermissionStrategy.h"

#if PERMISSION_BLUETOOTH

@implementation BluetoothPermissionStrategy {
    CBCentralManager *_centralManager;
    PermissionStatusHandler _permissionStatusHandler;
    PermissionGroup _requestedPermission;
}

- (void)initManagerIfNeeded {
    if (_centralManager == nil) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    [self initManagerIfNeeded];
    if (@available(iOS 13.1, *)) {
        CBManagerAuthorization blePermission = [_centralManager authorization];
        return [BluetoothPermissionStrategy parsePermission:blePermission];
    } else if (@available(iOS 13.0, *)){
        CBManagerAuthorization blePermission =  [_centralManager authorization];
        return [BluetoothPermissionStrategy parsePermission:blePermission];
    }
    return PermissionStatusGranted;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    [self initManagerIfNeeded];
    if (@available(iOS 10, *)) {
        return [_centralManager state] == CBManagerStatePoweredOn ? ServiceStatusEnabled : ServiceStatusDisabled;
    }
    return [_centralManager state] == CBCentralManagerStatePoweredOn ? ServiceStatusEnabled : ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    [self initManagerIfNeeded];
    PermissionStatus status = [self checkPermissionStatus:permission];
    
    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }
    
    _permissionStatusHandler = completionHandler;
    _requestedPermission = permission;
}

+ (PermissionStatus)parsePermission:(CBManagerAuthorization)bluetoothPermission API_AVAILABLE(ios(13)){
    switch(bluetoothPermission){
        case CBManagerAuthorizationNotDetermined:
            return PermissionStatusDenied;
        case CBManagerAuthorizationRestricted:
            return PermissionStatusRestricted;
        case CBManagerAuthorizationDenied:
            return PermissionStatusPermanentlyDenied;
        case CBManagerAuthorizationAllowedAlways:
            return PermissionStatusGranted;
    }
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)centralManager {
    PermissionStatus permissionStatus = [self checkPermissionStatus:_requestedPermission];
    _permissionStatusHandler(permissionStatus);
}

@end

#else

@implementation BluetoothPermissionStrategy
@end

#endif
