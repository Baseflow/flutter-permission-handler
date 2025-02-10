//
//  LocationAccuracyHandler.m
//  permission_handler_apple
//
//  Created by Pierre Monier on 09/02/2025.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAccuracyHandler.h"
#import "PermissionHandlerEnums.h"
#import "util/Codec.h"

@interface LocationAccuracyHandler()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationAccuracyHandler

- (id) init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  self.locationManager = [[CLLocationManager alloc] init];
  return self;
}

- (LocationAccuracy) getLocationAccuracy {
#if TARGET_OS_OSX
  return LocationAccuracyPrecise;
#else
  if (@available(iOS 14, macOS 10.16, *)) {
      switch (_locationManager.accuracyAuthorization) {
      case CLAccuracyAuthorizationFullAccuracy:
        return LocationAccuracyPrecise;
      case CLAccuracyAuthorizationReducedAccuracy:
        return LocationAccuracyReduced;
      default:
        // Reduced location accuracy is the default on iOS 14+ and macOS 11+.
        return LocationAccuracyReduced;
    }
  } else {
    // Approximate location is not available, return precise location.
    return LocationAccuracyPrecise;
  }
#endif
}

- (void)requestTemporaryFullAccuracyWithResult:(FlutterResult)result purposeKey:(NSString * _Nullable)purposeKey {
  if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationTemporaryUsageDescriptionDictionary"] == nil) {
      result([NSException exceptionWithName:@"MISSING_USAGE_DESCRIPTION"
                                            reason:@"The temporary accuracy dictionary key is not set in the Info.plist"
                                          userInfo:nil]);
  }
    
  #if TARGET_OS_OSX
    return result([Codec encodeLocationAccuracy:LocationAccuracyPrecise]);
  #else
    
    if (@available(iOS 14.0, macOS 10.16, *)) {
      [_locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:purposeKey
                                                                         completion:^(NSError *_Nullable error) {
        if ([self->_locationManager accuracyAuthorization] == CLAccuracyAuthorizationFullAccuracy) {
            return result([Codec encodeLocationAccuracy:LocationAccuracyPrecise]);
        } else {
            return result([Codec encodeLocationAccuracy:LocationAccuracyReduced]);
        }
      }];
    } else {
      return result([Codec encodeLocationAccuracy:LocationAccuracyPrecise]);
    }
  #endif
}

@end
