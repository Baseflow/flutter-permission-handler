//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "MediaLibraryPermissionStrategy.h"


@implementation MediaLibraryPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [MediaLibraryPermissionStrategy permissionStatus];
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

    if (@available(iOS 9.3, *)) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            completionHandler([MediaLibraryPermissionStrategy determinePermissionStatus:status]);
        }];
    } else {
        completionHandler(PermissionStatusUnknown);
        return;
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];

        return [MediaLibraryPermissionStrategy determinePermissionStatus:status];
    }

    return PermissionStatusUnknown;
}

+ (PermissionStatus)determinePermissionStatus:(MPMediaLibraryAuthorizationStatus)authorizationStatus {
    switch (authorizationStatus) {
        case MPMediaLibraryAuthorizationStatusNotDetermined:
            return PermissionStatusUnknown;
        case MPMediaLibraryAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case MPMediaLibraryAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case MPMediaLibraryAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }

    return PermissionStatusUnknown;
}

@end