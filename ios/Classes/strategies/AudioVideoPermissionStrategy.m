//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "AudioVideoPermissionStrategy.h"


@implementation AudioVideoPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    if (permission == PermissionGroupCamera) {
        return [AudioVideoPermissionStrategy permissionStatus:AVMediaTypeVideo];
    } else if (permission == PermissionGroupMicrophone) {
        return [AudioVideoPermissionStrategy permissionStatus:AVMediaTypeAudio];
    }
    return PermissionStatusUnknown;
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

    AVMediaType mediaType;

    if (permission == PermissionGroupCamera) {
        mediaType = AVMediaTypeVideo;
    } else if (permission == PermissionGroupMicrophone) {
        mediaType = AVMediaTypeAudio;
    } else {
        completionHandler(PermissionStatusUnknown);
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
            return PermissionStatusUnknown;
        case AVAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case AVAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case AVAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }

    return PermissionStatusUnknown;
}

@end