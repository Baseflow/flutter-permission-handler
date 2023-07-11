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
    PermissionGroup _requestedPermission;
    PermissionStatusHandler _permissionStatusHandler;
    ServiceStatusHandler _serviceStatusHandler;
}

- (void)initManagerIfNeeded {
    if (_centralManager == nil) {
        NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey: @NO};
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    }
}

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (@available(iOS 13.0, *)) {
        CBManagerAuthorization blePermission = [_centralManager authorization];
        return [BluetoothPermissionStrategy parsePermission:blePermission];
    }
    return PermissionStatusGranted;
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    [self initManagerIfNeeded];
    
    _serviceStatusHandler = completionHandler;
    _requestedPermission = permission;
}

- (void)handleCheckServiceStatusCallback {
    if (@available(iOS 10, *)) {
        ServiceStatus serviceStatus = [_centralManager state] == CBManagerStatePoweredOn ? ServiceStatusEnabled : ServiceStatusDisabled;
        _serviceStatusHandler(serviceStatus);
    }
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ServiceStatus serviceStatus = [_centralManager state] == CBCentralManagerStatePoweredOn ? ServiceStatusEnabled : ServiceStatusDisabled;
    _serviceStatusHandler(serviceStatus);
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

- (void)handleRequestPermissionCallback {
    PermissionStatus permissionStatus = [self checkPermissionStatus:_requestedPermission];
    _permissionStatusHandler(permissionStatus);
}

+ (PermissionStatus)parsePermission:(CBManagerAuthorization)bluetoothPermission API_AVAILABLE(ios(13)) {
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
    if (_permissionStatusHandler != nil) {
        [self handleRequestPermissionCallback];
    }
    
    if (_serviceStatusHandler != nil) {
        [self handleCheckServiceStatusCallback];
    }
}

@end

#else

@implementation BluetoothPermissionStrategy
@end

#endif
