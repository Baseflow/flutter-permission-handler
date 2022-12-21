//
//  AppTrackingTransparency.m
//  permission_handler
//
//  Created by Jan-Derk on 21/05/2021.
//

#import "AppTrackingTransparencyPermissionStrategy.h"

#if PERMISSION_APP_TRACKING_TRANSPARENCY

@implementation AppTrackingTransparencyPermissionStrategy

PermissionStatusHandler storedCompletionHandler = nil;

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

+ (void)handleAppBecomeActive {
    if (@available(iOS 14, *)){
        if (storedCompletionHandler != nil) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                PermissionStatus permissionStatus = [AppTrackingTransparencyPermissionStrategy parsePermission:status];
                storedCompletionHandler(permissionStatus);
                storedCompletionHandler = nil;
            }];
        }
    }
}

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus attPermission = [ATTrackingManager trackingAuthorizationStatus];
        return [AppTrackingTransparencyPermissionStrategy parsePermission:attPermission];
    }
    
    return PermissionStatusGranted;
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }
    
    if (@available(iOS 14, *)){
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                PermissionStatus permissionStatus = [AppTrackingTransparencyPermissionStrategy parsePermission:status];
                completionHandler(permissionStatus);
            }];
        } else {
            // If state is not UIApplicationStateActive, iOS will not show the dialog for requesting AppTrackingTransperancy permission.
            // Store the completion handler and only start requesting when the app become Active again.
            storedCompletionHandler = completionHandler;
        }
    } else {
        completionHandler(PermissionStatusGranted);
    }
}

+ (PermissionStatus)parsePermission:(ATTrackingManagerAuthorizationStatus)attPermission API_AVAILABLE(ios(14)){
    switch(attPermission){
        case ATTrackingManagerAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
        case ATTrackingManagerAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case ATTrackingManagerAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case ATTrackingManagerAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
    }
}
@end

#else

@implementation AppTrackingTransparencyPermissionStrategy
@end

#endif

