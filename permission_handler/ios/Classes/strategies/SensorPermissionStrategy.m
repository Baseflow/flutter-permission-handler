//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "SensorPermissionStrategy.h"

#if PERMISSION_SENSORS

@implementation SensorPermissionStrategy
- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [SensorPermissionStrategy permissionStatus];
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    if (@available(iOS 11.0, *)) {
        return [CMMotionActivityManager isActivityAvailable]
        ? ServiceStatusEnabled
        : ServiceStatusDisabled;
    }
    
    return ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    
    if (status != PermissionStatusNotDetermined) {
        completionHandler(status);
        return;
    }
    
    if (@available(iOS 11.0, *)) {
        CMMotionActivityManager *motionManager = [[CMMotionActivityManager alloc] init];
        
        NSDate *today = [NSDate new];
        [motionManager queryActivityStartingFromDate:today toDate:today toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray<CMMotionActivity *> *__nullable activities, NSError *__nullable error) {
            if (error != nil && error.code == CMErrorMotionActivityNotAuthorized) {
                completionHandler(PermissionStatusDenied);
            } else {
                completionHandler(PermissionStatusGranted);
            }
        }];
    } else {
        completionHandler(PermissionStatusNotDetermined);
    }
    
}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 11.0, *)) {
        CMAuthorizationStatus status = [CMMotionActivityManager authorizationStatus];
        PermissionStatus permissionStatus;
        
        switch (status) {
            case CMAuthorizationStatusNotDetermined:
                permissionStatus = PermissionStatusNotDetermined;
                break;
            case CMAuthorizationStatusRestricted:
                permissionStatus = PermissionStatusRestricted;
                break;
            case CMAuthorizationStatusDenied:
                permissionStatus = PermissionStatusDenied;
                break;
            case CMAuthorizationStatusAuthorized:
                permissionStatus = PermissionStatusGranted;
                break;
            default:
                permissionStatus = PermissionStatusGranted;
        }
        
        return permissionStatus;
    }
    
    return PermissionStatusNotDetermined;
}

@end

#else

@implementation SensorPermissionStrategy
@end

#endif
