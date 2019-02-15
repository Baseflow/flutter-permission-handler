//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "SpeechPermissionStrategy.h"


@implementation SpeechPermissionStrategy
- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [SpeechPermissionStrategy permissionStatus];
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    
    if (status != PermissionStatusUnknown) {
        completionHandler(status);
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus authorizationStatus) {
            completionHandler([SpeechPermissionStrategy determinePermissionStatus:authorizationStatus]);
        }];
    } else {
        completionHandler(PermissionStatusUnknown);
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
        
        return [SpeechPermissionStrategy determinePermissionStatus:status];
    }
    
    return PermissionStatusUnknown;
}

+ (PermissionStatus)determinePermissionStatus:(SFSpeechRecognizerAuthorizationStatus)authorizationStatus {
    switch (authorizationStatus) {
        case SFSpeechRecognizerAuthorizationStatusNotDetermined:
            return PermissionStatusUnknown;
        case SFSpeechRecognizerAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case SFSpeechRecognizerAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case SFSpeechRecognizerAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }
    
    return PermissionStatusUnknown;
}

@end
