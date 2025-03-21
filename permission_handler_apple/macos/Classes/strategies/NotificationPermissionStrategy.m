//
//  NotificationPermissionStrategy.m
//  permission_handler
//
//  Created by Tong on 2019/10/21.
//

#import "NotificationPermissionStrategy.h"

#if PERMISSION_NOTIFICATIONS

@implementation NotificationPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
  return [NotificationPermissionStrategy permissionStatus];
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
  dispatch_async(dispatch_get_main_queue(), ^{
    if(@available(macOS 10.14, *)) {
      UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
      UNAuthorizationOptions authorizationOptions = 0;
      authorizationOptions += UNAuthorizationOptionSound;
      authorizationOptions += UNAuthorizationOptionAlert;
      authorizationOptions += UNAuthorizationOptionBadge;
      [center requestAuthorizationWithOptions:(authorizationOptions) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error != nil || !granted) {
          completionHandler(PermissionStatusPermanentlyDenied);
          return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSApplication sharedApplication] registerForRemoteNotifications];
            completionHandler(PermissionStatusGranted);
        });
      }];

    } else {
        completionHandler(PermissionStatusDenied);
    }
  });
}

+ (PermissionStatus)permissionStatus {
  __block PermissionStatus permissionStatus = PermissionStatusGranted;
  if (@available(macOS 10.14, *)) {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
      if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
        permissionStatus = PermissionStatusPermanentlyDenied;
      } else if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
        permissionStatus = PermissionStatusDenied;
      }
      dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
  } else {
      permissionStatus = PermissionStatusPermanentlyDenied;
  }
  return permissionStatus;
}

@end

#else

@implementation NotificationPermissionStrategy
@end

#endif
