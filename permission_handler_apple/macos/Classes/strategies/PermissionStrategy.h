//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermissionHandlerEnums.h"

typedef void (^PermissionStatusHandler)(PermissionStatus permissionStatus);

@protocol PermissionStrategy <NSObject>
- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission;

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission;

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler;
@end
