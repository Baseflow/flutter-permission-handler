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
    completionHandler(PermissionStatusDenied);
}

+ (PermissionStatus)permissionStatus {
    return PermissionStatusDenied;
}


@end

#else

@implementation MediaLibraryPermissionStrategy
@end

#endif
