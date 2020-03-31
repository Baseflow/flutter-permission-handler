//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "AudioVideoPermissionStrategy.h"

#if PERMISSION_CAMERA | PERMISSION_MICROPHONE

@implementation AudioVideoPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (permission == PermissionGroupCamera) {
        #if PERMISSION_CAMERA
        return [AudioVideoPermissionStrategy permissionStatus:AVMediaTypeVideo];
        #endif
    } else if (permission == PermissionGroupMicrophone) {
        #if PERMISSION_MICROPHONE
        return [AudioVideoPermissionStrategy permissionStatus:AVMediaTypeAudio];
        #endif
    }
    return PermissionStatusNotDetermined;
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

    AVMediaType mediaType;

    if (permission == PermissionGroupCamera) {
        #if PERMISSION_CAMERA
        mediaType = AVMediaTypeVideo;
        #else
        completionHandler(PermissionStatusNotDetermined);
        return;
        #endif
    } else if (permission == PermissionGroupMicrophone) {
        #if PERMISSION_MICROPHONE
        mediaType = AVMediaTypeAudio;
        #else
        completionHandler(PermissionStatusNotDetermined);
        return;
        #endif
    } else {
        completionHandler(PermissionStatusNotDetermined);
        return;
    }

    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            completionHandler(PermissionStatusGranted);
        } else {
            completionHandler(PermissionStatusDenied);
        }
    }];
}

+ (PermissionStatus)permissionStatus:(AVMediaType const)mediaType {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            return PermissionStatusNotDetermined;
        case AVAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case AVAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case AVAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }

    return PermissionStatusNotDetermined;
}

@end

#else

@implementation AudioVideoPermissionStrategy
@end

#endif
