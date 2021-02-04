package com.baseflow.permissionhandler;

import androidx.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

final class PermissionConstants {
    static final String LOG_TAG = "permissions_handler";
    static final int PERMISSION_CODE = 24;
    static final int PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS = 5672353;

    //PERMISSION_GROUP
    static final int PERMISSION_GROUP_CALENDAR = 0;
    static final int PERMISSION_GROUP_CAMERA = 1;
    static final int PERMISSION_GROUP_CONTACTS = 2;
    static final int PERMISSION_GROUP_LOCATION = 3;
    static final int PERMISSION_GROUP_LOCATION_ALWAYS = 4;
    static final int PERMISSION_GROUP_LOCATION_WHEN_IN_USE = 5;
    static final int PERMISSION_GROUP_MEDIA_LIBRARY = 6;
    static final int PERMISSION_GROUP_MICROPHONE = 7;
    static final int PERMISSION_GROUP_PHONE = 8;
    static final int PERMISSION_GROUP_PHOTOS = 9;
    static final int PERMISSION_GROUP_PHOTOS_ADD_ONLY = 10;
    static final int PERMISSION_GROUP_REMINDERS = 11;
    static final int PERMISSION_GROUP_SENSORS = 12;
    static final int PERMISSION_GROUP_SMS = 13;
    static final int PERMISSION_GROUP_SPEECH = 14;
    static final int PERMISSION_GROUP_STORAGE = 15;
    static final int PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS = 16;
    static final int PERMISSION_GROUP_NOTIFICATION = 17;
    static final int PERMISSION_GROUP_ACCESS_MEDIA_LOCATION = 18;
    static final int PERMISSION_GROUP_ACTIVITY_RECOGNITION = 19;
    static final int PERMISSION_GROUP_UNKNOWN = 20;

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            PERMISSION_GROUP_CALENDAR,
            PERMISSION_GROUP_CAMERA,
            PERMISSION_GROUP_CONTACTS,
            PERMISSION_GROUP_LOCATION,
            PERMISSION_GROUP_LOCATION_ALWAYS,
            PERMISSION_GROUP_LOCATION_WHEN_IN_USE,
            PERMISSION_GROUP_MEDIA_LIBRARY,
            PERMISSION_GROUP_MICROPHONE,
            PERMISSION_GROUP_PHONE,
            PERMISSION_GROUP_PHOTOS,
            PERMISSION_GROUP_REMINDERS,
            PERMISSION_GROUP_SENSORS,
            PERMISSION_GROUP_SMS,
            PERMISSION_GROUP_SPEECH,
            PERMISSION_GROUP_STORAGE,
            PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS,
            PERMISSION_GROUP_NOTIFICATION,
            PERMISSION_GROUP_ACCESS_MEDIA_LOCATION,
            PERMISSION_GROUP_ACTIVITY_RECOGNITION,
            PERMISSION_GROUP_UNKNOWN,
    })
    @interface PermissionGroup {
    }

    //PERMISSION_STATUS
    static final int PERMISSION_STATUS_DENIED = 0;
    static final int PERMISSION_STATUS_GRANTED = 1;
    static final int PERMISSION_STATUS_RESTRICTED = 2;
    static final int PERMISSION_STATUS_NOT_DETERMINED = 3;
    static final int PERMISSION_STATUS_LIMITED = 4;
    static final int PERMISSION_STATUS_NEVER_ASK_AGAIN = 5;

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            PERMISSION_STATUS_DENIED,
            PERMISSION_STATUS_GRANTED,
            PERMISSION_STATUS_RESTRICTED,
            PERMISSION_STATUS_NOT_DETERMINED,
            PERMISSION_STATUS_LIMITED,
            PERMISSION_STATUS_NEVER_ASK_AGAIN,
    })
    @interface PermissionStatus {
    }

    //SERVICE_STATUS
    static final int SERVICE_STATUS_DISABLED = 0;
    static final int SERVICE_STATUS_ENABLED = 1;
    static final int SERVICE_STATUS_NOT_APPLICABLE = 2;

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            SERVICE_STATUS_DISABLED,
            SERVICE_STATUS_ENABLED,
            SERVICE_STATUS_NOT_APPLICABLE
    })
    @interface ServiceStatus {
    }
}
