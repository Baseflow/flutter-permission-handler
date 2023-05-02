#include <string>

class PermissionConstants {
public:
    inline static int PERMISSION_CODE = 24;
    inline static int PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS = 209;
    inline static int PERMISSION_CODE_MANAGE_EXTERNAL_STORAGE = 210;
    inline static int PERMISSION_CODE_SYSTEM_ALERT_WINDOW = 211;
    inline static int PERMISSION_CODE_REQUEST_INSTALL_PACKAGES = 212;
    inline static int PERMISSION_CODE_ACCESS_NOTIFICATION_POLICY = 213;

    //PERMISSION_GROUP
    enum class PermissionGroup {
        CALENDAR = 0,
        CAMERA = 1,
        CONTACTS = 2,
        LOCATION = 3,
        LOCATION_ALWAYS = 4,
        LOCATION_WHEN_IN_USE = 5,
        MEDIA_LIBRARY = 6,
        MICROPHONE = 7,
        PHONE = 8,
        PHOTOS = 9,
        PHOTOS_ADD_ONLY = 10,
        REMINDERS = 11,
        SENSORS = 12,
        SENSORS_ALWAYS = 13,
        SMS = 14,
        SPEECH = 15,
        STORAGE = 16,
        IGNORE_BATTERY_OPTIMIZATIONS = 17,
        NOTIFICATION = 18,
        ACCESS_MEDIA_LOCATION = 19,
        ACTIVITY_RECOGNITION = 20,
        UNKNOWN = 21,
        BLUETOOTH = 22,
        MANAGE_EXTERNAL_STORAGE = 23,
        SYSTEM_ALERT_WINDOW = 24,
        REQUEST_INSTALL_PACKAGES = 25,
        APP_TRACK_TRANSPARENCY = 26,
        CRITICAL_ALERTS = 27,
        ACCESS_NOTIFICATION_POLICY = 28,
        BLUETOOTH_SCAN = 29,
        BLUETOOTH_ADVERTISE = 30,
        BLUETOOTH_CONNECT = 31,
        NEARBY_WIFI_DEVICES = 32,
        VIDEOS = 33,
        AUDIO = 34,
        SCHEDULE_EXACT_ALARM = 35
    };

    //PERMISSION_STATUS
    enum class PermissionStatus {
        DENIED = 0,
        GRANTED = 1,
        RESTRICTED = 2,
        LIMITED = 3,
        NEVER_ASK_AGAIN = 4
    };

    //SERVICE_STATUS
    enum class ServiceStatus {
        DISABLED = 0,
        ENABLED = 1,
        NOT_APPLICABLE = 2
    };
};
