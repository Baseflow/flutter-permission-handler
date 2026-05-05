//
//  PhonePermissionStrategy.m
//  permission_handler
//
//  Created by Sebastian Roth on 5/20/19.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "PhonePermissionStrategy.h"

@implementation PhonePermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
  return PermissionStatusDenied;
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
  // https://stackoverflow.com/a/5095058
  if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
      completionHandler(ServiceStatusNotApplicable);
  }
  completionHandler([self canDevicePlaceAPhoneCall] ? ServiceStatusEnabled : ServiceStatusDisabled);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler errorHandler:(PermissionErrorHandler)errorHandler {
  completionHandler(PermissionStatusPermanentlyDenied);
}


/**
 * Returns YES if the device can place a phone call.
 */
-(bool) canDevicePlaceAPhoneCall {
  CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
  
  if(@available(iOS 12.0, *)) {
    NSDictionary<NSString *, CTCarrier *> *providers = [netInfo serviceSubscriberCellularProviders];
    for (NSString *key in providers) {
      CTCarrier *carrier = [providers objectForKey:key];
      if ([self canPlacePhoneCallWithCarrier:carrier]) {
        return YES;
      }
    }
    
    return NO;
  } else {
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    return [self canPlacePhoneCallWithCarrier:carrier];
  }
}

-(bool)canPlacePhoneCallWithCarrier:(CTCarrier *)carrier {
  // https://stackoverflow.com/a/11595365
  NSString *mnc = [carrier mobileNetworkCode];
  if (([mnc length] == 0) || ([mnc isEqualToString:@"65535"])) {
    // Device cannot place a call at this time.  SIM might be removed.
    return NO;
  } else {
    // Device can place a phone call
    return YES;
  }
}

@end
