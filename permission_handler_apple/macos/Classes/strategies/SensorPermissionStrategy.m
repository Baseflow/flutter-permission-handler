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
    return ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    completionHandler(PermissionStatusDenied);
}

+ (PermissionStatus)permissionStatus {
    return PermissionStatusDenied;
}

@end

#else

@implementation SensorPermissionStrategy
@end

#endif
