//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "SpeechPermissionStrategy.h"

#if PERMISSION_SPEECH_RECOGNIZER

@implementation SpeechPermissionStrategy
- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [SpeechPermissionStrategy permissionStatus];
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    
    if (status != PermissionStatusNotDetermined) {
        completionHandler(status);
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus authorizationStatus) {
            completionHandler([SpeechPermissionStrategy determinePermissionStatus:authorizationStatus]);
        }];
    } else {
        completionHandler(PermissionStatusNotDetermined);
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
        
        return [SpeechPermissionStrategy determinePermissionStatus:status];
    }
    
    return PermissionStatusNotDetermined;
}

+ (PermissionStatus)determinePermissionStatus:(SFSpeechRecognizerAuthorizationStatus)authorizationStatus  API_AVAILABLE(ios(10.0)){
    switch (authorizationStatus) {
        case SFSpeechRecognizerAuthorizationStatusNotDetermined:
            return PermissionStatusNotDetermined;
        case SFSpeechRecognizerAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case SFSpeechRecognizerAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case SFSpeechRecognizerAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }
    
    return PermissionStatusNotDetermined;
}

@end

#else

@implementation SpeechPermissionStrategy
@end

#endif
