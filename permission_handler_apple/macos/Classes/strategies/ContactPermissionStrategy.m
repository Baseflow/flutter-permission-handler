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

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];

    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }

    if (@available(macOS 10.11, *)) {
        [ContactPermissionStrategy requestPermissionsFromContactStore:completionHandler];
    } else {
        completionHandler(PermissionStatusPermanentlyDenied);
        return;
    }
}

+ (PermissionStatus)permissionStatus {
    if (@available(macOS 10.11, *)) {
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
        }

    } else {
        return PermissionStatusPermanentlyDenied;
    }

    return PermissionStatusDenied;
}

+ (void)requestPermissionsFromContactStore:(PermissionStatusHandler)completionHandler API_AVAILABLE(macosx(10.13)) {
    CNContactStore *contactStore = [CNContactStore new];

    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *__nullable error) {
        if (granted) {
            completionHandler(PermissionStatusGranted);
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
