//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "LocationPermissionStrategy.h"

#if PERMISSION_LOCATION

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
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse && permission == PermissionGroupLocationAlways) {
        // don't do anything and continue requesting permissions
    } else if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }
    
    _permissionStatusHandler = completionHandler;
    _requestedPermission = permission;
    
    if (permission == PermissionGroupLocation) {
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil) {
            [_locationManager requestAlwaysAuthorization];
        } else if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil) {
            [_locationManager requestWhenInUseAuthorization];
        } else {
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file" userInfo:nil] raise];
        }
    } else if (permission == PermissionGroupLocationAlways) {
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil) {
            [_locationManager requestAlwaysAuthorization];
        } else {
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"To use location in iOS8 you need to define NSLocationAlwaysUsageDescription in the app bundle's Info.plist file" userInfo:nil] raise];
        }
    } else if (permission == PermissionGroupLocationWhenInUse) {
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil) {
            [_locationManager requestWhenInUseAuthorization];
        } else {
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"To use location in iOS8 you need to define NSLocationWhenInUseUsageDescription in the app bundle's Info.plist file" userInfo:nil] raise];
        }
    }
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

    if ((_requestedPermission == PermissionGroupLocationAlways && status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
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
    if (@available(iOS 8.0, *)) {
        if (permission == PermissionGroupLocationAlways) {
            switch (authorizationStatus) {
                case kCLAuthorizationStatusNotDetermined:
                    return PermissionStatusDenied;
                case kCLAuthorizationStatusRestricted:
                    return PermissionStatusRestricted;
                case kCLAuthorizationStatusAuthorizedWhenInUse:
                case kCLAuthorizationStatusDenied:
                    return PermissionStatusPermanentlyDenied;
                case kCLAuthorizationStatusAuthorizedAlways:
                    return PermissionStatusGranted;
            }
        }
        
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                return PermissionStatusDenied;
            case kCLAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
            case kCLAuthorizationStatusDenied:
                return PermissionStatusPermanentlyDenied;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
                return PermissionStatusGranted;
        }
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    switch (authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
        case kCLAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case kCLAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
        default:
            return PermissionStatusDenied;
    }

#pragma clang diagnostic pop

}

@end

#else

@implementation LocationPermissionStrategy
@end

#endif
