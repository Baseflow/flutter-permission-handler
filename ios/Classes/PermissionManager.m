//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "PermissionManager.h"

@implementation PermissionManager {
    NSMutableArray <id <PermissionStrategy>> *_strategyInstances;
}

- (instancetype)initWithStrategyInstances {
    self = [super init];
    if (self) {
        _strategyInstances = _strategyInstances = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (void)checkPermissionStatus:(enum PermissionGroup)permission result:(FlutterResult)result {
    id <PermissionStrategy> permissionStrategy = [PermissionManager createPermissionStrategy:permission];
    PermissionStatus status = [permissionStrategy checkPermissionStatus:permission];
    
    result([Codec encodePermissionStatus:status]);
}

+ (void)checkServiceStatus:(enum PermissionGroup)permission result:(FlutterResult)result {
    id <PermissionStrategy> permissionStrategy = [PermissionManager createPermissionStrategy:permission];
    ServiceStatus status = [permissionStrategy checkServiceStatus:permission];
    result([Codec encodeServiceStatus:status]);
}

- (void)requestPermissions:(NSArray *)permissions completion:(PermissionRequestCompletion)completion {
    NSMutableSet *requestQueue = [[NSMutableSet alloc] initWithArray:permissions];
    NSMutableDictionary *permissionStatusResult = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < permissions.count; ++i) {
        PermissionGroup value;
        [permissions[i] getValue:&value];
        PermissionGroup permission = value;
        
        id <PermissionStrategy> permissionStrategy = [PermissionManager createPermissionStrategy:permission];
        [_strategyInstances addObject:permissionStrategy];
        
        
        [permissionStrategy requestPermission:permission completionHandler:^(PermissionStatus permissionStatus) {
            permissionStatusResult[@(permission)] = @(permissionStatus);
            [requestQueue removeObject:@(permission)];
            
            [self->_strategyInstances removeObject:permissionStrategy];
            
            if (requestQueue.count == 0) {
                completion(permissionStatusResult);
                return;
            }
        }];
    }
}

+ (void)openAppSettings:(FlutterResult)result {
    if (@available(iOS 10, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                           options:[[NSDictionary alloc] init]
                                 completionHandler:^(BOOL success) {
                                     result([[NSNumber alloc] initWithBool:success]);
                                 }];
    } else if (@available(iOS 8.0, *)) {
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        result([[NSNumber alloc] initWithBool:success]);
    } else {
        result(@false);
    }
}

+ (id)createPermissionStrategy:(PermissionGroup)permission {
    switch (permission) {
            case PermissionGroupCamera:
            case PermissionGroupPhotos:
            return [PhotoPermissionStrategy new];
        default:
            return [UnknownPermissionStrategy new];
    }
}

@end

