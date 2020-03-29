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
    return PermissionStatusNotDetermined;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    // https://stackoverflow.com/a/5095058
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        return ServiceStatusNotApplicable;
    }

    return [self canDevicePlaceAPhoneCall] ? ServiceStatusEnabled : ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    completionHandler(PermissionStatusNotDetermined);
}


// https://stackoverflow.com/a/11595365
-(bool) canDevicePlaceAPhoneCall {
    /*
     * Returns YES if the device can place a phone call
     */

    // Device supports phone calls, lets confirm it can place one right now
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
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
