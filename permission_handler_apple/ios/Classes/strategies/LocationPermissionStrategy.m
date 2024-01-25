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
    BOOL _previousStatusWasNotDetermined;
}

- (instancetype)initWithLocationManager {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _previousStatusWasNotDetermined = NO;
    }
    
    return self;
}

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [LocationPermissionStrategy permissionStatus:permission];
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    completionHandler([CLLocationManager locationServicesEnabled] ? ServiceStatusEnabled : ServiceStatusDisabled);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse && permission == PermissionGroupLocationAlways) {
        BOOL alreadyRequested = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultPermissionRequestedKey]; // check if already requested the permantent permission
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
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveActivityNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
            [_locationManager requestAlwaysAuthorization];
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:UserDefaultPermissionRequestedKey];
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

- (void) receiveActivityNotification:(NSNotification *) notification {
    CLAuthorizationStatus status;
    if(@available(iOS 14.0, *)){
        status = _locationManager.authorizationStatus;
    } else {
        status = [CLLocationManager authorizationStatus];
    }

    if ((_requestedPermission == PermissionGroupLocationAlways && status != kCLAuthorizationStatusAuthorizedAlways)) {
        PermissionStatus permissionStatus = [LocationPermissionStrategy determinePermissionStatus:_requestedPermission authorizationStatus:status];

        _permissionStatusHandler(permissionStatus);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];    
}

// {WARNING}
// This is called when the location manager is first initialized and raises the following situations:
// 1. When we first request [PermissionGroupLocationWhenInUse] and then [PermissionGroupLocationAlways]
//    this will be called when the [CLLocationManager] is first initialized with
//    [kCLAuthorizationStatusAuthorizedWhenInUse]. As a consequence we send back the result too early.
// 2. When we first request [PermissionGroupLocationWhenInUse] and then [PermissionGroupLocationAlways]
//    and the user doesn't allow for [kCLAuthorizationStatusAuthorizedAlways] this method is not called
//    at all.
// 3. When the permission dialog is opened, this method is called with [kCLAuthorizationStatusNotDetermined].
//    The method should not return at this point, but instead wait for the next [CLAuthorizationStatus] to
//    determine what to send back. If the method is called with [kCLAuthorizationStatusNotDetermined] for a
//    second time, assume that the permission was not granted. This might catch situations where the user
//    dismisses the dialog without making a decision.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (_permissionStatusHandler == nil || @(_requestedPermission) == nil) {
        return;
    }
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        if (_previousStatusWasNotDetermined) {
            _permissionStatusHandler(PermissionStatusDenied);
        }
        _previousStatusWasNotDetermined = YES;
        return;
    }
    _previousStatusWasNotDetermined = NO;

    if ((_requestedPermission == PermissionGroupLocationAlways && status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        _permissionStatusHandler(PermissionStatusDenied);
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
