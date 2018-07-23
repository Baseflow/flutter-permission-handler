package com.baseflow.permissionhandler.utils

import com.baseflow.permissionhandler.data.PermissionGroup
import com.baseflow.permissionhandler.data.PermissionStatus
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken

class Codec {
    companion object {
        @JvmStatic
        private val gsonDecoder : Gson = GsonBuilder().enableComplexMapKeySerialization().create()

        @JvmStatic
        fun decodePermissionGroup(arguments: Any) : PermissionGroup {
            return Codec.gsonDecoder.fromJson(arguments.toString(), PermissionGroup::class.java)
        }

        @JvmStatic
        fun decodePermissionGroups(arguments: Any) : Array<PermissionGroup> {

            var permissionGroupsType = object: TypeToken<Array<PermissionGroup>>() {}.type
            return Codec.gsonDecoder.fromJson(arguments.toString(), permissionGroupsType)
        }

        @JvmStatic
        fun encodePermissionStatus(permissionStatus: PermissionStatus) : String {
            return gsonDecoder.toJson(permissionStatus)
        }

        @JvmStatic
        fun encodePermissionRequestResult(permissionResults: Map<PermissionGroup, PermissionStatus>) : String {
            val jsonString = gsonDecoder.toJson(permissionResults)
            return jsonString
        }
    }
}