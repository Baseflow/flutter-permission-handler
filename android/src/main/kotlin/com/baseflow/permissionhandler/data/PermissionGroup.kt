package com.baseflow.permissionhandler.data

import com.google.gson.annotations.SerializedName

enum class PermissionGroup {
    @SerializedName("unknown")
    UNKNOWN,
    @SerializedName("calendar")
    CALENDAR,
    @SerializedName("camera")
    CAMERA,
    @SerializedName("contacts")
    CONTACTS,
    @SerializedName("location")
    LOCATION,
    @SerializedName("microphone")
    MICROPHONE,
    @SerializedName("phone")
    PHONE,
    @SerializedName("photos")
    PHOTOS,
    @SerializedName("reminders")
    REMINDERS,
    @SerializedName("sensors")
    SENSORS,
    @SerializedName("sms")
    SMS,
    @SerializedName("storage")
    STORAGE,
    @SerializedName("speech")
    SPEECH,
    @SerializedName("locationAlways")
    LOCATION_ALWAYS,
    @SerializedName("locationWhenInUse")
    LOCATION_WHEN_IN_USE,
    @SerializedName("mediaLibrary")
    MEDIA_LIBRARY
}