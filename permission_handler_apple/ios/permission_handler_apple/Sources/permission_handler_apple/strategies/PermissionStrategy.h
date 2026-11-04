//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermissionHandlerEnums.h"

typedef void (^ServiceStatusHandler)(ServiceStatus serviceStatus);
typedef void (^PermissionStatusHandler)(PermissionStatus permissionStatus);
typedef void (^PermissionErrorHandler)(NSString* errorCode, NSString* errorDescription);

@protocol PermissionStrategy <NSObject>
- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission;

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler;

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler errorHandler:(PermissionErrorHandler)errorHandler;

@optional
/// Asynchronous status check, for strategies whose status is only available
/// through a completion handler. When implemented, `PermissionManager` calls it
/// instead of the blocking `checkPermissionStatus:`, so the platform (main)
/// thread is never parked waiting for the system to answer. The handler may be
/// called on any queue.
- (void)checkPermissionStatus:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler;
@end
