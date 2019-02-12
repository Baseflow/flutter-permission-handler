package com.baseflow.permissionhandler.data

import com.google.gson.annotations.SerializedName

enum class ServiceStatus {
    @SerializedName("unknown")
    UNKNOWN,
    @SerializedName("disabled")
    DISABLED,
    @SerializedName("enabled")
    ENABLED,
    @SerializedName("notApplicable")
    NOT_APPLICABLE,
}