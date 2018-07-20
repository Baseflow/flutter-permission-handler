package com.baseflow.permissionhandler.data

import com.google.gson.annotations.SerializedName

enum class PermissionStatus {
    @SerializedName("unknown")
    UNKNOWN,
    @SerializedName("denied")
    DENIED,
    @SerializedName("disabled")
    DISABLED,
    @SerializedName("granted")
    GRANTED,
}