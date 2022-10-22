//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "LocationPermissionStrategy.h"

#if PERMISSION_LOCATION

NSString *const UserDefaultPermissionRequestedKey = @"org.baseflow.permission_handler_apple.permission_requested";

@interface LocationPermissionStrategy ()
- (void) receiveActivityNotification:(NSNotification *)notification;
@end

@implementation LocationPermissionStrategy {
    CLLocationManager *_locationManager;
    PermissionStatusHandler _permissionStatusHandler;
    PermissionGroup _requestedPermission;
}

- (instancetype)initWithLocationManager {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    
    return self;
}

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [LocationPermissionStrategy permissionStatus:permission];
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return [CLLocationManager locationServicesEnabled] ? ServiceStatusEnabled : ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized && permission == PermissionGroupLocationAlways) {
        BOOL alreadyRequested = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultPermissionRequestedKey]; // check if already requested the permanent permission
        if(alreadyRequested) {
            completionHandler(status);
            return;
        }
    } else if (status != PermissionStatusDenied) { // handles undetermined always permission and denied whenInUse permission
        completionHandler(status);
        return;
    }
    
    _permissionStatusHandler = completionHandler;
    _requestedPermission = permission;
    
    if (permission == PermissionGroupLocation || permission == PermissionGroupLocationAlways || permission == PermissionGroupLocationWhenInUse) {
        
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationUsageDescription"] != nil) {
            if (@available(macOS 10.15, *)) {
                [_locationManager requestAlwaysAuthorization];
            } else {
                [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"You need macOS 10.15 to request Always Authroization" userInfo:nil] raise];
                
            }
        } else {
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"To use location in macOS 10.14 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file" userInfo:nil] raise];
        }
    }
}

- (void) receiveActivityNotification:(NSNotification *) notification {
    CLAuthorizationStatus status;
    if(@available(macOS 11.0, *)){
        status = _locationManager.authorizationStatus;
    } else {
        status = [CLLocationManager authorizationStatus];
    }

    if (@available(macOS 10.12, *)) {
        if (((_requestedPermission == PermissionGroupLocationAlways || _requestedPermission == PermissionGroupLocationWhenInUse || _requestedPermission == PermissionGroupLocation) && status != kCLAuthorizationStatusAuthorizedAlways)) {
            PermissionStatus permissionStatus = [LocationPermissionStrategy determinePermissionStatus:_requestedPermission authorizationStatus:status];
            
            _permissionStatusHandler(permissionStatus);
        } else {
            _permissionStatusHandler(PermissionStatusGranted);
        }
    } else {
        // Fallback on earlier versions
        _permissionStatusHandler(PermissionStatusDenied);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidBecomeActiveNotification object:nil];
}

// {WARNING}
// This is called when the location manager is first initialized and raises the following situations:
// 1. When we first request [PermissionGroupLocationWhenInUse] and then [PermissionGroupLocationAlways]
//    this will be called when the [CLLocationManager] is first initialized with
//    [kCLAuthorizationStatusAuthorizedWhenInUse]. As a consequence we send back the result to early.
// 2. When we first request [PermissionGroupLocationWhenInUse] and then [PermissionGroupLocationAlways]
//    and the user doesn't allow for [kCLAuthorizationStatusAuthorizedAlways] this method is not called
//    at all.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    
    if (_permissionStatusHandler == nil || @(_requestedPermission) == nil) {
        return;
    }

    if ((_requestedPermission == PermissionGroupLocationAlways && status == kCLAuthorizationStatusAuthorized)) {
        _permissionStatusHandler(PermissionStatusGranted);
        return;
    }

    PermissionStatus permissionStatus = [LocationPermissionStrategy
                                         determinePermissionStatus:_requestedPermission authorizationStatus:status];
    
    _permissionStatusHandler(permissionStatus);
}


+ (PermissionStatus)permissionStatus:(PermissionGroup)permission {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    
    PermissionStatus status = [LocationPermissionStrategy
                               determinePermissionStatus:permission authorizationStatus:authorizationStatus];
    
    return status;
}


+ (PermissionStatus)determinePermissionStatus:(PermissionGroup)permission authorizationStatus:(CLAuthorizationStatus)authorizationStatus {
    switch (authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
        case kCLAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case kCLAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }
}

@end

#else

@implementation LocationPermissionStrategy
@end

#endif
