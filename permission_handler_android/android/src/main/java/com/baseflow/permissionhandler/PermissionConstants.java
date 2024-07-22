package com.baseflow.permissionhandler;

import androidx.annotation.IntDef;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

final class PermissionConstants {
    static final String LOG_TAG = "permissions_handler";
    static final int PERMISSION_CODE = 24;
    static final int PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS = 209;
    static final int PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE = 210;
    static final int PERMISSION_CODE_SYSTEM_ALERT_WINDOW = 211;
    static final int PERMISSION_CODE_REQUEST_INSTALL_PACKAGES = 212;
    static final int PERMISSION_CODE_ACCESS_NOTIFICATION_POLICY = 213;
    static final int PERMISSION_CODE_SCHEDULE_EXACT_ALARM = 214;


    // PERMISSION_GROUP

    // Deprecated in favor of PERMISSION_GROUP_CALENDAR_WRITE_ONLY and
    // PERMISSION_GROUP_CALENDAR_FULL_ACCESS.
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
    static final int PERMISSION_GROUP_BLUETOOTH = 21;
    static final int PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE = 22;
    static final int PERMISSION_GROUP_SYSTEM_ALERT_WINDOW = 23;
    static final int PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES = 24;
    static final int PERMISSION_GROUP_APP_TRACK_TRANSPARENCY = 25;
    static final int PERMISSION_GROUP_CRITICAL_ALERTS = 26;
    static final int PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY = 27;
    static final int PERMISSION_GROUP_BLUETOOTH_SCAN = 28;
    static final int PERMISSION_GROUP_BLUETOOTH_ADVERTISE = 29;
    static final int PERMISSION_GROUP_BLUETOOTH_CONNECT = 30;
    static final int PERMISSION_GROUP_NEARBY_WIFI_DEVICES = 31;
    static final int PERMISSION_GROUP_VIDEOS = 32;
    static final int PERMISSION_GROUP_AUDIO = 33;
    static final int PERMISSION_GROUP_SCHEDULE_EXACT_ALARM = 34;
    static final int PERMISSION_GROUP_SENSORS_ALWAYS = 35;
    static final int PERMISSION_GROUP_CALENDAR_WRITE_ONLY = 36;
    static final int PERMISSION_GROUP_CALENDAR_FULL_ACCESS = 37;
    static final int PERMISSION_GROUP_ASSISTANT = 38;
    static final int PERMISSION_GROUP_BACKGROUND_REFRESH = 39;

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
            PERMISSION_GROUP_SENSORS_ALWAYS,
            PERMISSION_GROUP_SMS,
            PERMISSION_GROUP_SPEECH,
            PERMISSION_GROUP_STORAGE,
            PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS,
            PERMISSION_GROUP_NOTIFICATION,
            PERMISSION_GROUP_ACCESS_MEDIA_LOCATION,
            PERMISSION_GROUP_ACTIVITY_RECOGNITION,
            PERMISSION_GROUP_UNKNOWN,
            PERMISSION_GROUP_BLUETOOTH,
            PERMISSION_GROUP_MANAGE_EXTERNAL_STORAGE,
            PERMISSION_GROUP_SYSTEM_ALERT_WINDOW,
            PERMISSION_GROUP_REQUEST_INSTALL_PACKAGES,
            PERMISSION_GROUP_ACCESS_NOTIFICATION_POLICY,
            PERMISSION_GROUP_BLUETOOTH_SCAN,
            PERMISSION_GROUP_BLUETOOTH_ADVERTISE,
            PERMISSION_GROUP_BLUETOOTH_CONNECT,
            PERMISSION_GROUP_NEARBY_WIFI_DEVICES,
            PERMISSION_GROUP_VIDEOS,
            PERMISSION_GROUP_AUDIO,
            PERMISSION_GROUP_SCHEDULE_EXACT_ALARM,
            PERMISSION_GROUP_CALENDAR_WRITE_ONLY,
            PERMISSION_GROUP_CALENDAR_FULL_ACCESS,
            PERMISSION_GROUP_ASSISTANT,
    })
    @interface PermissionGroup {
    }

    //PERMISSION_STATUS
    static final int PERMISSION_STATUS_DENIED = 0;
    static final int PERMISSION_STATUS_GRANTED = 1;
    static final int PERMISSION_STATUS_RESTRICTED = 2;
    static final int PERMISSION_STATUS_LIMITED = 3;
    static final int PERMISSION_STATUS_NEVER_ASK_AGAIN = 4;

    @Target(ElementType.TYPE_USE)
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            PERMISSION_STATUS_DENIED,
            PERMISSION_STATUS_GRANTED,
            PERMISSION_STATUS_RESTRICTED,
            PERMISSION_STATUS_LIMITED,
            PERMISSION_STATUS_NEVER_ASK_AGAIN
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