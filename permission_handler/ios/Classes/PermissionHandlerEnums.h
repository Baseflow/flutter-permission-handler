//
//  PermissionHandlerEnums.h
//  permission_handler
//
//  Created by Razvan Lung on 15/02/2019.
//

// ios: PermissionGroupCalendar
// Info.plist: NSCalendarsUsageDescription
// dart: PermissionGroup.calendar
#ifndef PERMISSION_EVENTS
    #define PERMISSION_EVENTS 1
#endif

// ios: PermissionGroupReminders
// Info.plist: NSRemindersUsageDescription
// dart: PermissionGroup.reminders
#ifndef PERMISSION_REMINDERS
    #define PERMISSION_REMINDERS 1
#endif

// ios: PermissionGroupContacts
// Info.plist: NSContactsUsageDescription
// dart: PermissionGroup.contacts
#ifndef PERMISSION_CONTACTS
    #define PERMISSION_CONTACTS 1
#endif

// ios: PermissionGroupCamera
// Info.plist: NSCameraUsageDescription
// dart: PermissionGroup.camera
#ifndef PERMISSION_CAMERA
    #define PERMISSION_CAMERA 1
#endif

// ios: PermissionGroupMicrophone
// Info.plist: NSMicrophoneUsageDescription
// dart: PermissionGroup.microphone
#ifndef PERMISSION_MICROPHONE
    #define PERMISSION_MICROPHONE 1
#endif

// ios: PermissionGroupSpeech
// Info.plist: NSSpeechRecognitionUsageDescription
// dart: PermissionGroup.speech
#ifndef PERMISSION_SPEECH_RECOGNIZER
    #define PERMISSION_SPEECH_RECOGNIZER 1
#endif

// ios: PermissionGroupPhotos
// Info.plist: NSPhotoLibraryUsageDescription
// dart: PermissionGroup.photos
#ifndef PERMISSION_PHOTOS
    #define PERMISSION_PHOTOS 1
#endif

// ios: PermissionGroupPhotosAddOnly
// Info.plist: NSPhotoLibraryUsageDescription
// dart: PermissionGroup.photosAddOnly
#ifndef PERMISSION_PHOTOS_ADD_ONLY
    #define PERMISSION_PHOTOS_ADD_ONLY 1
#endif

// ios: [PermissionGroupLocation, PermissionGroupLocationAlways, PermissionGroupLocationWhenInUse]
// Info.plist: [NSLocationUsageDescription, NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationWhenInUseUsageDescription]
// dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
#ifndef PERMISSION_LOCATION
    #define PERMISSION_LOCATION 1
#endif

// ios: PermissionGroupNotification
// dart: PermissionGroup.notification
#ifndef PERMISSION_NOTIFICATIONS
    #define PERMISSION_NOTIFICATIONS 1
#endif

// ios: PermissionGroupMediaLibrary
// Info.plist: [NSAppleMusicUsageDescription, kTCCServiceMediaLibrary]
// dart: PermissionGroup.mediaLibrary
#ifndef PERMISSION_MEDIA_LIBRARY
    #define PERMISSION_MEDIA_LIBRARY 1
#endif

// ios: PermissionGroupSensors
// Info.plist: NSMotionUsageDescription
// dart: PermissionGroup.sensors
#ifndef PERMISSION_SENSORS
    #define PERMISSION_SENSORS 1
#endif

typedef NS_ENUM(int, PermissionGroup) {
    PermissionGroupCalendar = 0,
    PermissionGroupCamera,
    PermissionGroupContacts,
    PermissionGroupLocation,
    PermissionGroupLocationAlways,
    PermissionGroupLocationWhenInUse,
    PermissionGroupMediaLibrary,
    PermissionGroupMicrophone,
    PermissionGroupPhone,
    PermissionGroupPhotos,
    PermissionGroupPhotosAddOnly,
    PermissionGroupReminders,
    PermissionGroupSensors,
    PermissionGroupSms,
    PermissionGroupSpeech,
    PermissionGroupStorage,
    PermissionGroupIgnoreBatteryOptimizations,
    PermissionGroupNotification,
    PermissionGroupAccessMediaLocation,
    PermissionGroupUnknown,
};

typedef NS_ENUM(int, PermissionStatus) {
    PermissionStatusDenied = 0,
    PermissionStatusGranted,
    PermissionStatusRestricted,
    PermissionStatusNotDetermined,
    PermissionStatusLimited,
};

typedef NS_ENUM(int, ServiceStatus) {
    ServiceStatusDisabled = 0,
    ServiceStatusEnabled,
    ServiceStatusNotApplicable,
};
