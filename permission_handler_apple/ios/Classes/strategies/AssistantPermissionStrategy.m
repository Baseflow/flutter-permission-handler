//
//  Assistant.m
//  permission_handler
//
//  Created by Baptiste Dupuch (dupuchba) on Tue Sep  5 08:50:04 2023
//

#import "AssistantPermissionStrategy.h"

#if PERMISSION_ASSISTANT

@implementation AssistantPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (@available(iOS 10, *)) {
        INSiriAuthorizationStatus assistantPermission = [INPreferences siriAuthorizationStatus];
        return [AssistantPermissionStrategy parsePermission:assistantPermission];
    }

    return PermissionStatusGranted;
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    completionHandler(ServiceStatusNotApplicable);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler errorHandler:(PermissionErrorHandler)errorHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }

    if (@available(iOS 10, *)){
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            PermissionStatus permissionStatus = [AssistantPermissionStrategy parsePermission:status];
            completionHandler(permissionStatus);
        }];
    } else {
        completionHandler(PermissionStatusGranted);
    }
}

+ (PermissionStatus)parsePermission:(INSiriAuthorizationStatus)assistantPermission API_AVAILABLE(ios(10)){
    switch(assistantPermission){
        case INSiriAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
        case INSiriAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case INSiriAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case INSiriAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
    }
}
@end

#else

@implementation AssistantPermissionStrategy
@end

#endif
