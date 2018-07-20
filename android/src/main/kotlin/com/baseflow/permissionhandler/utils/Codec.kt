package com.baseflow.permissionhandler.utils

import com.baseflow.permissionhandler.data.PermissionGroup
import com.baseflow.permissionhandler.data.PermissionStatus
import com.google.gson.Gson

class Codec {
    companion object {
        @JvmStatic val gsonDecoder : Gson = Gson()

        @JvmStatic
        fun decodePermissionGroup(arguments: Any) : PermissionGroup {
            return Codec.gsonDecoder.fromJson(arguments.toString(), PermissionGroup::class.java)
        }

        @JvmStatic
        fun encodePermissionStatus(permissionStatus: PermissionStatus) : String {
            return gsonDecoder.toJson(permissionStatus)
        }
    }
}