//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermissionStrategy.h"

#if PERMISSION_LOCATION || PERMISSION_LOCATION_WHENINUSE || PERMISSION_LOCATION_ALWAYS

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationPermissionStrategy : NSObject <PermissionStrategy, CLLocationManagerDelegate>
- (instancetype)initWithLocationManager;

/// `promptTimeout` is how long a request waits for a prompt to make the app resign active before it
/// returns the current status. The other initializer uses the default dependencies and 2 seconds.
- (instancetype)initWithLocationManager:(CLLocationManager *)locationManager
                     notificationCenter:(NSNotificationCenter *)notificationCenter
                           userDefaults:(NSUserDefaults *)userDefaults
                          promptTimeout:(NSTimeInterval)promptTimeout;
@end

#else

#import "UnknownPermissionStrategy.h"
@interface LocationPermissionStrategy : UnknownPermissionStrategy
@end

#endif
