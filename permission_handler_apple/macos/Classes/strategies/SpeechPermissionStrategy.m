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
    
    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }
    
    if (@available(macOS 10.15, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus authorizationStatus) {
            completionHandler([SpeechPermissionStrategy determinePermissionStatus:authorizationStatus]);
        }];
    } else {
        completionHandler(PermissionStatusDenied);
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(macOS 10.15, *)) {
        SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
        
        return [SpeechPermissionStrategy determinePermissionStatus:status];
    }
    
    return PermissionStatusDenied;
}

+ (PermissionStatus)determinePermissionStatus:(SFSpeechRecognizerAuthorizationStatus)authorizationStatus  API_AVAILABLE(macosx(10.15)){
    switch (authorizationStatus) {
        case SFSpeechRecognizerAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
        case SFSpeechRecognizerAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case SFSpeechRecognizerAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case SFSpeechRecognizerAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }
    
    return PermissionStatusDenied;
}

@end

#else

@implementation SpeechPermissionStrategy
@end

#endif
