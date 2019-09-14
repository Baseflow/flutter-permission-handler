//
// Created by Basit Mustafa (24601@GitHub) on 2019-09-13.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "AssistantPermissionStrategy.h"


@implementation AssistantPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (permission == PermissionGroupAssistant) {
        if (@available(iOS 10.0, *)) {
            return [AssistantPermissionStrategy permissionStatus];
        } else {
            // Fallback on earlier versions
        }
    }
    return PermissionStatusUnknown;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];

    if (status != PermissionStatusUnknown) {
        completionHandler(status);
        return;
    }

    if (permission != PermissionGroupAssistant) {
        completionHandler(PermissionStatusUnknown);
        return;
    }

    if (@available(iOS 10.0, *)) {
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            if (status == INSiriAuthorizationStatusAuthorized) {
                completionHandler(PermissionStatusGranted);
            } else {
                completionHandler(PermissionStatusDenied);
            }
        }];
    } else {
        // Fallback on earlier versions
    }

}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 10.0, *)) {
        INSiriAuthorizationStatus status = [INPreferences siriAuthorizationStatus];
        
        switch (status) {
            case INSiriAuthorizationStatusNotDetermined:
                return PermissionStatusUnknown;
                break;
            case INSiriAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
                break;
            case INSiriAuthorizationStatusDenied:
                return PermissionStatusDenied;
                break;
            case INSiriAuthorizationStatusAuthorized:
                return PermissionStatusGranted;
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                return PermissionStatusUnknown;
                break;
        }
    } else {
        // Fallback on earlier versions
    }

    return PermissionStatusUnknown;
}

@end
