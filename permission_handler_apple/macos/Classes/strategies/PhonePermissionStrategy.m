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

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    // https://stackoverflow.com/a/5095058
    BOOL result = [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"tel://"]];
    if(!result) {
        return ServiceStatusNotApplicable;
    }
    return [self canDevicePlaceAPhoneCall] ? ServiceStatusEnabled : ServiceStatusDisabled;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    completionHandler(PermissionStatusPermanentlyDenied);
}


/**
 * Returns YES if the device can place a phone call.
 */
-(bool) canDevicePlaceAPhoneCall {
    return NO;
}

@end
