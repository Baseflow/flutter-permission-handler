//
//  CriticalAlertsPermissionStrategy.m
//  permission_handler
//
//  Created by Neal Soni on 2021/6/8.
//

#import "CriticalAlertsPermissionStrategy.h"

#if PERMISSION_CRITICAL_ALERTS

@implementation CriticalAlertsPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
  return [CriticalAlertsPermissionStrategy permissionStatus];
}

- (void)checkPermissionStatus:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
  [CriticalAlertsPermissionStrategy permissionStatusWithCompletionHandler:completionHandler];
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    completionHandler(ServiceStatusNotApplicable);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler errorHandler:(PermissionErrorHandler)errorHandler {
  [CriticalAlertsPermissionStrategy permissionStatusWithCompletionHandler:^(PermissionStatus status) {
    // Continue on the main queue, where the request used to run synchronously.
    dispatch_async(dispatch_get_main_queue(), ^{
      if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
      }
      [CriticalAlertsPermissionStrategy requestAuthorizationWithCompletionHandler:completionHandler];
    });
  }];
}

+ (void)requestAuthorizationWithCompletionHandler:(PermissionStatusHandler)completionHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
    if(@available(iOS 12.0, *)) {
      UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
      UNAuthorizationOptions authorizationOptions = 0;
      authorizationOptions += UNAuthorizationOptionCriticalAlert;
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
    } else {
      completionHandler(PermissionStatusPermanentlyDenied);
    }
  });
}

/// Blocking variant, kept for the synchronous `PermissionStrategy` contract.
/// It must not be called on the main thread: the settings may be delivered on
/// the main queue (iOS 27 does), and waiting there never returns.
/// `PermissionManager` uses `permissionStatusWithCompletionHandler:` instead.
+ (PermissionStatus)permissionStatus {
  __block PermissionStatus permissionStatus = PermissionStatusGranted;
  if (@available(iOS 12 , *)) {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
      permissionStatus = [CriticalAlertsPermissionStrategy permissionStatusFromSettings:settings];
      dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
  } else {
    permissionStatus = PermissionStatusPermanentlyDenied;
  }

  return permissionStatus;
}

/// Reads the notification settings without blocking. `completionHandler` is
/// called on the queue that delivers the settings.
+ (void)permissionStatusWithCompletionHandler:(PermissionStatusHandler)completionHandler {
  if (@available(iOS 12 , *)) {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
      completionHandler([CriticalAlertsPermissionStrategy permissionStatusFromSettings:settings]);
    }];
  } else {
    completionHandler(PermissionStatusPermanentlyDenied);
  }
}

+ (PermissionStatus)permissionStatusFromSettings:(UNNotificationSettings *)settings API_AVAILABLE(ios(12)) {
  PermissionStatus permissionStatus = PermissionStatusGranted;
  if (settings.criticalAlertSetting == UNAuthorizationStatusDenied) {
    permissionStatus = PermissionStatusPermanentlyDenied;
  } else if (settings.criticalAlertSetting == UNAuthorizationStatusNotDetermined) {
    permissionStatus = PermissionStatusDenied;
  }
  return permissionStatus;
}

@end

#else

@implementation CriticalAlertsPermissionStrategy
@end

#endif
