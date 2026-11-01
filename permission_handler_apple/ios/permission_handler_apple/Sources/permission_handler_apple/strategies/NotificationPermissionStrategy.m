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

- (void)checkPermissionStatus:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
  [NotificationPermissionStrategy permissionStatusWithCompletionHandler:completionHandler];
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    completionHandler(ServiceStatusNotApplicable);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler  errorHandler:(PermissionErrorHandler)errorHandler {
  [NotificationPermissionStrategy permissionStatusWithCompletionHandler:^(PermissionStatus status) {
    // Continue on the main queue, where the request used to run synchronously.
    dispatch_async(dispatch_get_main_queue(), ^{
      if (@available(iOS 12.0, *)) {
        if (status != PermissionStatusDenied && status != PermissionStatusProvisional) {
          completionHandler(status);
          return;
        }
      } else if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
      }
      [NotificationPermissionStrategy requestAuthorizationWithCompletionHandler:completionHandler];
    });
  }];
}

+ (void)requestAuthorizationWithCompletionHandler:(PermissionStatusHandler)completionHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
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
          [[UIApplication sharedApplication] registerForRemoteNotifications];
          completionHandler(PermissionStatusGranted);
      });
    }];
  });
}

/// Blocking variant, kept for the synchronous `PermissionStrategy` contract.
/// It must not be called on the main thread: the settings may be delivered on
/// the main queue (iOS 27 does), and waiting there never returns.
/// `PermissionManager` uses `permissionStatusWithCompletionHandler:` instead.
+ (PermissionStatus)permissionStatus {
  __block PermissionStatus permissionStatus = PermissionStatusGranted;
  dispatch_semaphore_t sem = dispatch_semaphore_create(0);
  [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    permissionStatus = [NotificationPermissionStrategy permissionStatusFromSettings:settings];
    dispatch_semaphore_signal(sem);
  }];
  dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
  return permissionStatus;
}

/// Reads the notification settings without blocking. `completionHandler` is
/// called on the queue that delivers the settings.
+ (void)permissionStatusWithCompletionHandler:(PermissionStatusHandler)completionHandler {
  [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    completionHandler([NotificationPermissionStrategy permissionStatusFromSettings:settings]);
  }];
}

+ (PermissionStatus)permissionStatusFromSettings:(UNNotificationSettings *)settings {
  PermissionStatus permissionStatus = PermissionStatusGranted;
  if (@available(iOS 12 , *) && settings.authorizationStatus == UNAuthorizationStatusProvisional) {
    permissionStatus = PermissionStatusProvisional;
  } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
    permissionStatus = PermissionStatusPermanentlyDenied;
  } else if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
    permissionStatus = PermissionStatusDenied;
  }
  return permissionStatus;
}

@end

#else

@implementation NotificationPermissionStrategy
@end

#endif
