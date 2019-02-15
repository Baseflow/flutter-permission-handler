//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "PermissionStrategy.h"


@interface LocationPermissionStrategy : NSObject <PermissionStrategy, CLLocationManagerDelegate>
- (instancetype)initWithLocationManager;
@end
