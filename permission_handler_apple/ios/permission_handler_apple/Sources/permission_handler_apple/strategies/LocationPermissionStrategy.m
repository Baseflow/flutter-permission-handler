//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "LocationPermissionStrategy.h"

#if PERMISSION_LOCATION || PERMISSION_LOCATION_WHENINUSE || PERMISSION_LOCATION_ALWAYS

NSString *const UserDefaultPermissionRequestedKey = @"org.baseflow.permission_handler_apple.permission_requested";

// Every prompt measured on the iOS 26.5 simulator made the app resign active within 0.6 seconds.
static const NSTimeInterval DefaultPromptTimeout = 2.0;

// A location request ends in one of three ways:
// 1. The delegate reports a status that differs from the one before the request: the user picked an
//    option that changed it.
// 2. The prompt made the app resign active and the app is active again. This covers "Keep Only While
//    Using" in the Always upgrade prompt, which changes nothing, and a prompt dismissed by locking the
//    screen.
// 3. The app did not resign active within the prompt timeout, so no prompt is coming. After "Allow Once",
//    Core Location ignores requestAlwaysAuthorization.
// The delegate also reports the current status when the location manager is created and right after
// requestAlwaysAuthorization. Those callbacks repeat the status from before the request and are ignored.
@implementation LocationPermissionStrategy {
    CLLocationManager *_locationManager;
    NSNotificationCenter *_notificationCenter;
    NSUserDefaults *_userDefaults;
    NSTimeInterval _promptTimeout;
    PermissionStatusHandler _permissionStatusHandler;
    PermissionGroup _requestedPermission;
    CLAuthorizationStatus _statusBeforeRequest;
    BOOL _requestedAlways;
    BOOL _promptShown;
}

- (instancetype)initWithLocationManager {
    return [self initWithLocationManager:[CLLocationManager new]
                      notificationCenter:[NSNotificationCenter defaultCenter]
                            userDefaults:[NSUserDefaults standardUserDefaults]
                           promptTimeout:DefaultPromptTimeout];
}

- (instancetype)initWithLocationManager:(CLLocationManager *)locationManager
                     notificationCenter:(NSNotificationCenter *)notificationCenter
                           userDefaults:(NSUserDefaults *)userDefaults
                          promptTimeout:(NSTimeInterval)promptTimeout {
    self = [super init];
    if (self) {
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _notificationCenter = notificationCenter;
        _userDefaults = userDefaults;
        _promptTimeout = promptTimeout;
    }
    
    return self;
}

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [self permissionStatus:permission];
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isEnabled = [CLLocationManager locationServicesEnabled];

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler(isEnabled ? ServiceStatusEnabled : ServiceStatusDisabled);
        });
    });
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler errorHandler:(PermissionErrorHandler)errorHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if ([self authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse && permission == PermissionGroupLocationAlways) {
        BOOL alreadyRequested = [_userDefaults boolForKey:UserDefaultPermissionRequestedKey]; // check if already requested the permantent permission
        if(alreadyRequested) {
            completionHandler(status);
            return;
        }
    } else if (status != PermissionStatusDenied) { // handles undetermined always permission and denied whenInUse permission
        completionHandler(status);
        return;
    }
    
    if (permission == PermissionGroupLocation) {
#if PERMISSION_LOCATION
        bool hasAlwaysInInfoPlist = ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil || [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUseUsageDescription"] != nil);
        
        if (hasAlwaysInInfoPlist && [self authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self startRequest:permission always:YES completionHandler:completionHandler];
        } else if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil) {
            [self startRequest:permission always:NO completionHandler:completionHandler];
        } else {
            errorHandler(@"MISSING_USAGE_DESCRIPTION", @"To use location from iOS8 you need to define at least NSLocationWhenInUseUsageDescription and optionally NSLocationAlwaysAndWhenInUseUsageDescription in the app bundle's Info.plist file");
            return;
        }
#else
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil ) {
            [self startRequest:permission always:NO completionHandler:completionHandler];
        } else {
            errorHandler(@"MISSING_USAGE_DESCRIPTION", @"To use location from iOS8 you need to define at least NSLocationWhenInUseUsageDescription and optionally NSLocationAlwaysAndWhenInUseUsageDescription in the app bundle's Info.plist file");
            return;
        }
#endif
    } else if (permission == PermissionGroupLocationAlways) {
#if PERMISSION_LOCATION
        if ([self authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            errorHandler(@"MISSING_WHENINUSE_PERMISSION", @"Must have \"When in use\" permission before it is allowed to request \"Always\" permission.");
            return;
        }
        
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil || [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUseUsageDescription"] != nil ) {
            [self startRequest:permission always:YES completionHandler:completionHandler];
        } else {
            errorHandler(@"MISSING_USAGE_DESCRIPTION", @"To always use location from iOS8 you need to define at least NSLocationWhenInUseUsageDescription and optionally NSLocationAlwaysAndWhenInUseUsageDescription in the app bundle's Info.plist file");
            return;
        }
#endif
    } else if (permission == PermissionGroupLocationWhenInUse) {
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil ) {
            [self startRequest:permission always:NO completionHandler:completionHandler];
        } else {
            errorHandler(@"MISSING_USAGE_DESCRIPTION", @"To use location from iOS8 you need to define at least NSLocationWhenInUseUsageDescription and optionally NSLocationAlwaysAndWhenInUseUsageDescription in the app bundle's Info.plist file");
            return;
        }
    }
}

- (void)startRequest:(PermissionGroup)permission always:(BOOL)always completionHandler:(PermissionStatusHandler)completionHandler {
    _permissionStatusHandler = completionHandler;
    _requestedPermission = permission;
    _statusBeforeRequest = [self authorizationStatus];
    _requestedAlways = always;
    _promptShown = NO;

    [_notificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [_notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    if (always) {
        [_locationManager requestAlwaysAuthorization];
    } else {
        [_locationManager requestWhenInUseAuthorization];
    }

    __weak LocationPermissionStrategy *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_promptTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf promptTimeoutElapsed];
    });
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    _promptShown = YES;

    // Core Location shows the Always prompt only once. A call it ignores, as after "Allow Once", does not
    // use it up.
    if (_requestedAlways) {
        [_userDefaults setBool:YES forKey:UserDefaultPermissionRequestedKey];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (_promptShown) {
        [self finishWithStatus:[self permissionStatus:_requestedPermission]];
    }
}

- (void)promptTimeoutElapsed {
    if (_promptShown) {
        return;
    }
    [self finishWithStatus:[self permissionStatus:_requestedPermission]];
}

- (void)finishWithStatus:(PermissionStatus)status {
    PermissionStatusHandler handler = _permissionStatusHandler;
    if (handler == nil) {
        return;
    }
    _permissionStatusHandler = nil;

    [_notificationCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [_notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    handler(status);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (_permissionStatusHandler == nil || status == _statusBeforeRequest) {
        return;
    }

    [self finishWithStatus:[LocationPermissionStrategy determinePermissionStatus:_requestedPermission authorizationStatus:status]];
}

- (CLAuthorizationStatus)authorizationStatus {
    if (@available(iOS 14.0, *)) {
        return _locationManager.authorizationStatus;
    }
    return [CLLocationManager authorizationStatus];
}

- (PermissionStatus)permissionStatus:(PermissionGroup)permission {
    CLAuthorizationStatus authorizationStatus = [self authorizationStatus];

    // iOS shows the "Always" prompt once after "When In Use" is granted. Until this plugin has
    // asked for it, it can still be requested.
    if (permission == PermissionGroupLocationAlways &&
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse &&
        ![_userDefaults boolForKey:UserDefaultPermissionRequestedKey]) {
        return PermissionStatusDenied;
    }

    PermissionStatus status = [LocationPermissionStrategy
                               determinePermissionStatus:permission authorizationStatus:authorizationStatus];
    
    return status;
}


+ (PermissionStatus)determinePermissionStatus:(PermissionGroup)permission authorizationStatus:(CLAuthorizationStatus)authorizationStatus {
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    switch (authorizationStatus) {
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
