//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "EventPermissionStrategy.h"

#if PERMISSION_EVENTS | PERMISSION_EVENTS_FULL_ACCESS | PERMISSION_REMINDERS

@implementation EventPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (permission == PermissionGroupCalendar || permission == PermissionGroupCalendarReadOnly || permission == PermissionGroupCalendarFullAccess) {
        #if PERMISSION_EVENTS | PERMISSION_EVENTS_FULL_ACCESS
        return [EventPermissionStrategy permissionStatus:EKEntityTypeEvent];
        #endif
    } else if (permission == PermissionGroupReminders) {
        #if PERMISSION_REMINDERS
        return [EventPermissionStrategy permissionStatus:EKEntityTypeReminder];
        #endif
    }
    
    return PermissionStatusDenied;
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    completionHandler(ServiceStatusNotApplicable);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus permissionStatus = [self checkPermissionStatus:permission];
    
    if (permissionStatus != PermissionStatusDenied) {
        completionHandler(permissionStatus);
        return;
    }
    
    EKEntityType entityType;
    
    if (permission == PermissionGroupCalendar || permission == PermissionGroupCalendarReadOnly) {
        #if PERMISSION_EVENTS
        entityType = EKEntityTypeEvent;
        #else
        completionHandler(PermissionStatusDenied);
        return;
        #endif
    } else if (permission == PermissionGroupCalendarFullAccess) {
        #if PERMISSION_EVENTS_FULL_ACCESS
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
    }

    else {
        completionHandler(PermissionStatusPermanentlyDenied);
        return;
    }

    EKEventStore *eventStore = [[EKEventStore alloc] init];

    if (@available(iOS 17.0, *)) {
        if (entityType == EKEntityTypeEvent) {
            #if PERMISSION_EVENTS_FULL_ACCESS
            [eventStore requestFullAccessToEventsWithCompletion:^(BOOL granted, NSError *error) {
                    if (granted) {
                        completionHandler(PermissionStatusGranted);
                    } else {
                        completionHandler(PermissionStatusPermanentlyDenied);
                    }
                }];
            #elif PERMISSION_EVENTS
            [eventStore requestWriteOnlyAccessToEventsWithCompletion:^(BOOL granted, NSError *error) {
                    if (granted) {
                        completionHandler(PermissionStatusGranted);
                    } else {
                        completionHandler(PermissionStatusPermanentlyDenied);
                    }
                }];
            #endif
        } else {
            #if PERMISSION_REMINDERS
            [eventStore requestFullAccessToRemindersWithCompletion:^(BOOL granted, NSError *error) {
                                if (granted) {
                                    completionHandler(PermissionStatusGranted);
                                } else {
                                    completionHandler(PermissionStatusPermanentlyDenied);
                                }
                   }];
            #endif
        }
    } else {
        [eventStore requestAccessToEntityType:entityType completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    completionHandler(PermissionStatusGranted);
                } else {
                    completionHandler(PermissionStatusPermanentlyDenied);
                }
            }];
    }

}

+ (PermissionStatus)permissionStatus:(EKEntityType)entityType {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:entityType];

    if (@available(iOS 17.0, *)) {
        switch (status) {
                case EKAuthorizationStatusNotDetermined:
                    return PermissionStatusDenied;
                case EKAuthorizationStatusRestricted:
                    return PermissionStatusRestricted;
                case EKAuthorizationStatusDenied:
                    return PermissionStatusPermanentlyDenied;
                case EKAuthorizationStatusFullAccess:
                    return PermissionStatusGranted;
                case EKAuthorizationStatusWriteOnly:
                    #if PERMISSION_EVENTS_FULL_ACCESS
                    return PermissionStatusDenied;
                    #elif PERMISSION_EVENTS
                    return PermissionStatusGranted;
                    #endif
            }
    } else {
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
    }
    

    
    return PermissionStatusDenied;
}

@end

#else

@implementation EventPermissionStrategy
@end

#endif
