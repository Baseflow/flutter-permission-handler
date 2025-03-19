//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "ContactPermissionStrategy.h"

#if PERMISSION_CONTACTS

@implementation ContactPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [ContactPermissionStrategy permissionStatus];
}

- (void)checkServiceStatus:(PermissionGroup)permission completionHandler:(ServiceStatusHandler)completionHandler {
    completionHandler(ServiceStatusNotApplicable);
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler errorHandler:(PermissionErrorHandler)errorHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];

    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }

    if (@available(iOS 9.0, *)) {
        [ContactPermissionStrategy requestPermissionsFromContactStore:completionHandler];
    } else {
        [ContactPermissionStrategy requestPermissionsFromAddressBook:completionHandler];
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(iOS 18.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

        switch (status) {
            case CNAuthorizationStatusNotDetermined:
                return PermissionStatusDenied;
            case CNAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
            case CNAuthorizationStatusDenied:
                return PermissionStatusPermanentlyDenied;
            case CNAuthorizationStatusAuthorized:
                return PermissionStatusGranted;
            case CNAuthorizationStatusLimited:
                return PermissionStatusLimited;
        }
    } else if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

        switch (status) {
            case CNAuthorizationStatusNotDetermined:
                return PermissionStatusDenied;
            case CNAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
            case CNAuthorizationStatusDenied:
                return PermissionStatusPermanentlyDenied;
            case CNAuthorizationStatusAuthorized:
                return PermissionStatusGranted;
            default:
                return PermissionStatusGranted;
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();

        switch (status) {
            case kABAuthorizationStatusNotDetermined:
                return PermissionStatusDenied;
            case kABAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
            case kABAuthorizationStatusDenied:
                return PermissionStatusPermanentlyDenied;
            case kABAuthorizationStatusAuthorized:
                return PermissionStatusGranted;
#pragma clang diagnostic pop
        }
    }

    return PermissionStatusDenied;
}

+ (void)requestPermissionsFromContactStore:(PermissionStatusHandler)completionHandler API_AVAILABLE(ios(9)) {
    CNContactStore *contactStore = [CNContactStore new];

    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *__nullable error) {
        if (granted) {
            const PermissionStatus updatedStatus = [self permissionStatus];
            completionHandler(updatedStatus);
        } else {
            completionHandler(PermissionStatusPermanentlyDenied);
        }
    }];
}

+ (void)requestPermissionsFromAddressBook:(PermissionStatusHandler)completionHandler {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate(), ^(bool granted, CFErrorRef error) {
        if (granted) {
            completionHandler(PermissionStatusGranted);
        } else {
            completionHandler(PermissionStatusPermanentlyDenied);
        }
    });
#pragma clang diagnostic pop
}
@end

#else

@implementation ContactPermissionStrategy
@end

#endif
