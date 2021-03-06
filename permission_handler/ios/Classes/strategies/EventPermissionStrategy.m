//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "EventPermissionStrategy.h"

#if PERMISSION_EVENTS | PERMISSION_REMINDERS

@implementation EventPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (permission == PermissionGroupCalendar) {
        #if PERMISSION_EVENTS
        return [EventPermissionStrategy permissionStatus:EKEntityTypeEvent];
        #endif
    } else if (permission == PermissionGroupReminders) {
        #if PERMISSION_REMINDERS
        return [EventPermissionStrategy permissionStatus:EKEntityTypeReminder];
        #endif
    }
    
    return PermissionStatusDenied;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus permissionStatus = [self checkPermissionStatus:permission];
    
    if (permissionStatus != PermissionStatusDenied) {
        completionHandler(permissionStatus);
        return;
    }
    
    EKEntityType entityType;
    
    if (permission == PermissionGroupCalendar) {
        #if PERMISSION_EVENTS
        entityType = EKEntityTypeEvent;
        #else
        completionHandler(PermissionStatusDenied);
        return;
        #endif
    } else if (permission == PermissionGroupReminders) {
        #if PERMISSION_REMINDERS
        entityType = EKEntityTypeReminder;
        #else
        completionHandler(PermissionStatusDenied);
        return;
        #endif
    } else {
        completionHandler(PermissionStatusPermanentlyDenied);
        return;
    }
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:entityType completion:^(BOOL granted, NSError *error) {
        if (granted) {
            completionHandler(PermissionStatusGranted);
        } else {
            completionHandler(PermissionStatusPermanentlyDenied);
        }
    }];
}

+ (PermissionStatus)permissionStatus:(EKEntityType)entityType {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:entityType];
    
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
        case EKAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case EKAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case EKAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }
    
    return PermissionStatusDenied;
}

@end

#else

@implementation EventPermissionStrategy
@end

#endif
