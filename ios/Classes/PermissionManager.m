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
    if (@available(iOS 8.0, *)) {
        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
        if (url == nil) {
            result(@false);
            return;
        }
        
        if (@available(iOS 10, *)) {
            if (![UIApplication.sharedApplication canOpenURL:url]) {
                result(@false);
                return;
            }
            
            NSDictionary *optionsKeyDictionary = @{UIApplicationOpenURLOptionUniversalLinksOnly: @true};
            [[UIApplication sharedApplication]
             openURL:url options:optionsKeyDictionary completionHandler:^(BOOL success) {
                 result([[NSNumber alloc] initWithBool:success]);
             }];
            return;
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            result([[NSNumber alloc] initWithBool:success]);
        }
    }
    
    result(@false);
    
}

+ (id)createPermissionStrategy:(PermissionGroup)permission {
    switch (permission) {
        case PermissionGroupCalendar:
            return [EventPermissionStrategy new];
        case PermissionGroupCamera:
            return [AudioVideoPermissionStrategy new];
        case PermissionGroupContacts:
            return [ContactPermissionStrategy new];
        case PermissionGroupLocation:
        case PermissionGroupLocationAlways:
        case PermissionGroupLocationWhenInUse:
            return [[LocationPermissionStrategy alloc] initWithLocationManager];
        case PermissionGroupMediaLibrary:
            return [MediaLibraryPermissionStrategy new];
        case PermissionGroupMicrophone:
            return [AudioVideoPermissionStrategy new];
        case PermissionGroupPhotos:
            return [PhotoPermissionStrategy new];
        case PermissionGroupReminders:
            return [EventPermissionStrategy new];
        case PermissionGroupSensors:
            return [SensorPermissionStrategy new];
        case PermissionGroupSpeech:
            return [SpeechPermissionStrategy new];
        default:
            return [UnknownPermissionStrategy new];
    }
}

@end
