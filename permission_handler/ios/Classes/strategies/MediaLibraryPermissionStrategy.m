//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "MediaLibraryPermissionStrategy.h"

#if PERMISSION_MEDIA_LIBRARY

@implementation MediaLibraryPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [MediaLibraryPermissionStrategy permissionStatus];
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if (status != PermissionStatusNotDetermined) {
        completionHandler(status);
        return;
    }

    if (@available(iOS 9.3, *)) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            completionHandler([MediaLibraryPermissionStrategy determinePermissionStatus:status]);
        }];
    } else {
        completionHandler(PermissionStatusNotDetermined);
        return;
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];

        return [MediaLibraryPermissionStrategy determinePermissionStatus:status];
    }

    return PermissionStatusNotDetermined;
}

+ (PermissionStatus)determinePermissionStatus:(MPMediaLibraryAuthorizationStatus)authorizationStatus  API_AVAILABLE(ios(9.3)){
    switch (authorizationStatus) {
        case MPMediaLibraryAuthorizationStatusNotDetermined:
            return PermissionStatusNotDetermined;
        case MPMediaLibraryAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case MPMediaLibraryAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case MPMediaLibraryAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }

    return PermissionStatusNotDetermined;
}

@end

#else

@implementation MediaLibraryPermissionStrategy
@end

#endif
