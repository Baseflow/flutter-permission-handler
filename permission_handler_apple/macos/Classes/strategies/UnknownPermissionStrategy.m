//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "UnknownPermissionStrategy.h"


@implementation UnknownPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return PermissionStatusDenied;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    completionHandler(PermissionStatusPermanentlyDenied);
}
@end
