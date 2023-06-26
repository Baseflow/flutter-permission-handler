//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermissionStrategy.h"

#if PERMISSION_LOCATION

#import <CoreLocation/CoreLocation.h>

@interface LocationPermissionStrategy : NSObject <PermissionStrategy, CLLocationManagerDelegate>
- (instancetype)initWithLocationManager;
@end

#else

#import "UnknownPermissionStrategy.h"
@interface LocationPermissionStrategy : UnknownPermissionStrategy
@end

#endif
