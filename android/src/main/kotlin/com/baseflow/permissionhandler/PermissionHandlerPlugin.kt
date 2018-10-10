package com.baseflow.permissionhandler

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.util.Log
import com.baseflow.permissionhandler.data.PermissionGroup
import com.baseflow.permissionhandler.data.PermissionStatus
import com.baseflow.permissionhandler.utils.Codec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.text.TextUtils
import android.provider.Settings.SettingNotFoundException



class PermissionHandlerPlugin(private val registrar: Registrar, private var requestedPermissions: MutableList<String>? = null) : MethodCallHandler {
    private var mRequestResults = mutableMapOf<PermissionGroup, PermissionStatus>()
    private var mResult: Result? = null

    companion object {
        const val permissionCode = 25

        @JvmStatic
        private val mLogTag = "permissions_handler"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter.baseflow.com/permissions/methods")
            val instance = PermissionHandlerPlugin(registrar)
            channel.setMethodCallHandler(instance)

            registrar.addRequestPermissionsResultListener(PluginRegistry.RequestPermissionsResultListener { id, permissions, grantResults ->
                if (id == permissionCode) {
                    instance.handlePermissionsRequest(permissions, grantResults)

                    return@RequestPermissionsResultListener true
                }

                return@RequestPermissionsResultListener false
            })
        }

        @JvmStatic
        fun parseManifestName(permission: String): PermissionGroup {

            when (permission) {
                Manifest.permission.READ_CALENDAR,
                Manifest.permission.WRITE_CALENDAR ->
                    return PermissionGroup.CALENDAR
                Manifest.permission.CAMERA ->
                    return PermissionGroup.CAMERA
                Manifest.permission.READ_CONTACTS,
                Manifest.permission.WRITE_CONTACTS,
                Manifest.permission.GET_ACCOUNTS ->
                    return PermissionGroup.CONTACTS
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION ->
                    return PermissionGroup.LOCATION
                Manifest.permission.RECORD_AUDIO ->
                    return PermissionGroup.MICROPHONE
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.CALL_PHONE,
                Manifest.permission.READ_CALL_LOG,
                Manifest.permission.WRITE_CALL_LOG,
                Manifest.permission.ADD_VOICEMAIL,
                Manifest.permission.USE_SIP,
                Manifest.permission.PROCESS_OUTGOING_CALLS ->
                    return PermissionGroup.PHONE
                Manifest.permission.BODY_SENSORS ->
                    return PermissionGroup.SENSORS
                Manifest.permission.SEND_SMS,
                Manifest.permission.RECEIVE_SMS,
                Manifest.permission.READ_SMS,
                Manifest.permission.RECEIVE_WAP_PUSH,
                Manifest.permission.RECEIVE_MMS ->
                    return PermissionGroup.SMS
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE ->
                    return PermissionGroup.STORAGE
            }

            return PermissionGroup.UNKNOWN
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "checkPermissionStatus" -> {
                val permission = Codec.decodePermissionGroup(call.arguments)
                val permissionStatus = checkPermissionStatus(permission)
                handleSuccess(permissionStatus, result)
            }
            call.method == "requestPermissions" -> {
                if (mResult != null) {
                    result.error(
                            "ERROR_ALREADY_REQUESTING_PERMISSIONS",
                            "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time).",
                            null)
                }

                mResult = result
                val permissions = Codec.decodePermissionGroups(call.arguments)
                requestPermissions(permissions)
            }
            call.method == "shouldShowRequestPermissionRationale" -> {
                val permission = Codec.decodePermissionGroup(call.arguments)
                result.success(shouldShowRequestPermissionRationale(permission))
            }
            call.method == "openAppSettings" -> {
                val isOpen = openAppSettings()
                result.success(isOpen)
            }
            else -> result.notImplemented()
        }
    }

    private fun checkPermissionStatus(permission: PermissionGroup): PermissionStatus {
        val names = getManifestNames(permission)

        if (names == null) {
            Log.d(mLogTag, "No android specific permissions needed for: $permission")

            return PermissionStatus.GRANTED
        }

        //if no permissions were found then there is an issue and permission is not set in Android manifest
        if (names.count() == 0) {
            Log.d(mLogTag, "No permissions found in manifest for: $permission")
            return PermissionStatus.UNKNOWN
        }

        val context: Context? = registrar.activity() ?: registrar.activeContext()
        if (context == null) {
            Log.d(mLogTag, "Unable to detect current Activity or App Context.")
            return PermissionStatus.UNKNOWN
        }

        val targetsMOrHigher = context.applicationInfo.targetSdkVersion >= android.os.Build.VERSION_CODES.M

        for (name in names) {
            if (targetsMOrHigher && ContextCompat.checkSelfPermission(context, name) != PackageManager.PERMISSION_GRANTED) {
                return PermissionStatus.DENIED
            }
        }

        if (permission == PermissionGroup.LOCATION || permission == PermissionGroup.LOCATION_ALWAYS || permission == PermissionGroup.LOCATION_WHEN_IN_USE) {
            if (!isLocationServiceEnabled(context)) {
                return PermissionStatus.DISABLED
            }
        }

        return PermissionStatus.GRANTED
    }

    private fun shouldShowRequestPermissionRationale(permission: PermissionGroup) : Boolean {
        val activity = registrar.activity()
        if(activity == null)
        {
            Log.d(mLogTag, "Unable to detect current Activity.")
            return false
        }

        val names = getManifestNames(permission)

        // if isn't an android specific group then go ahead and return false;
        if (names == null)
        {
            Log.d(mLogTag, "No android specific permissions needed for: $permission")
            return false
        }

        if (names.isEmpty())
        {
            Log.d(mLogTag,"No permissions found in manifest for: $permission no need to show request rationale")
            return false
        }

        for(name in names)
        {
            return ActivityCompat.shouldShowRequestPermissionRationale(activity, name)
        }

        return false
    }

    private fun requestPermissions(permissions: Array<PermissionGroup>) {
        if (registrar.activity() == null) {
            Log.d(mLogTag, "Unable to detect current Activity.")

            for (permission in permissions) {
                mRequestResults[permission] = PermissionStatus.UNKNOWN
            }

            processResult()
            return
        }

        val permissionsToRequest = mutableListOf<String>()
        for (permission in permissions) {
            val permissionStatus = checkPermissionStatus(permission)

            if (permissionStatus != PermissionStatus.GRANTED) {
                val names = getManifestNames(permission)

                //check to see if we can find manifest names
                //if we can't add as unknown and continue
                if (names == null || names.isEmpty()) {
                    if (!mRequestResults.containsKey(permission)) {
                        mRequestResults[permission] = PermissionStatus.UNKNOWN
                    }

                    continue
                }

                names.let { permissionsToRequest.addAll(it) }
            } else {
                if (!mRequestResults.containsKey(permission)) {
                    mRequestResults[permission] = PermissionStatus.GRANTED
                }
            }
        }

        if (permissionsToRequest.count() > 0) {
            ActivityCompat.requestPermissions(
                    registrar.activity(),
                    permissionsToRequest.toTypedArray(),
                    permissionCode)
        } else if (mRequestResults.count() > 0) {
            processResult()
        }
    }

    private fun handlePermissionsRequest(permissions: Array<String>, grantResults: IntArray) {
        if (mResult == null) {
            return
        }

        for (i in permissions.indices) {
            val permission = parseManifestName(permissions[i])
            if (permission == PermissionGroup.UNKNOWN)
                continue

            if (permission == PermissionGroup.MICROPHONE) {
                if (!mRequestResults.containsKey(PermissionGroup.SPEECH)) {
                    mRequestResults[PermissionGroup.SPEECH] = grantResults[i].toPermissionStatus()
                }
            } else if (permission == PermissionGroup.LOCATION) {
                val context: Context? = registrar.activity() ?: registrar.activeContext()
                val isLocationServiceEnabled= if (context == null) false else isLocationServiceEnabled(context)
                val permissionStatus = if (isLocationServiceEnabled) grantResults[i].toPermissionStatus() else PermissionStatus.DISABLED

                if (!mRequestResults.containsKey(PermissionGroup.LOCATION_ALWAYS)) {
                    mRequestResults[PermissionGroup.LOCATION_ALWAYS] = permissionStatus
                }

                if (!mRequestResults.containsKey(PermissionGroup.LOCATION_WHEN_IN_USE)) {
                    mRequestResults[PermissionGroup.LOCATION_WHEN_IN_USE] = permissionStatus
                }

                mRequestResults[permission] = permissionStatus
            } else if (!mRequestResults.containsKey(permission)) {
                mRequestResults[permission] = grantResults[i].toPermissionStatus()
            }

        }

        processResult()
    }

    private fun Int.toPermissionStatus(): PermissionStatus {
        return if (this == PackageManager.PERMISSION_GRANTED) PermissionStatus.GRANTED else PermissionStatus.DENIED
    }

    private fun processResult() {
        mResult?.success(Codec.encodePermissionRequestResult(mRequestResults))

        mRequestResults.clear()
        mResult = null
    }

    private fun openAppSettings(): Boolean {
        val context: Context? = registrar.activity() ?: registrar.activeContext()
        if (context == null) {
            Log.d(mLogTag, "Unable to detect current Activity or App Context.")
            return false
        }

        return try {
            val settingsIntent = Intent()
            settingsIntent.action = android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS
            settingsIntent.addCategory(Intent.CATEGORY_DEFAULT)
            settingsIntent.data = android.net.Uri.parse("package:" + context.packageName)
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS)

            context.startActivity(settingsIntent)

            true
        } catch(ex: Exception) {
            false
        }
    }

    private fun getManifestNames(permission: PermissionGroup): List<String>? {
        val permissionNames: MutableList<String> = mutableListOf()

        when (permission) {
            PermissionGroup.CALENDAR -> {
                if (hasPermissionInManifest(Manifest.permission.READ_CALENDAR))
                    permissionNames.add(Manifest.permission.READ_CALENDAR)
                if (hasPermissionInManifest(Manifest.permission.WRITE_CALENDAR))
                    permissionNames.add(Manifest.permission.WRITE_CALENDAR)
            }
            PermissionGroup.CAMERA -> {
                if (hasPermissionInManifest(Manifest.permission.CAMERA))
                    permissionNames.add(Manifest.permission.CAMERA)
            }
            PermissionGroup.CONTACTS -> {
                if (hasPermissionInManifest(Manifest.permission.READ_CONTACTS))
                    permissionNames.add(Manifest.permission.READ_CONTACTS)

                if (hasPermissionInManifest(Manifest.permission.WRITE_CONTACTS))
                    permissionNames.add(Manifest.permission.WRITE_CONTACTS)

                if (hasPermissionInManifest(Manifest.permission.GET_ACCOUNTS))
                    permissionNames.add(Manifest.permission.GET_ACCOUNTS)
            }
            PermissionGroup.LOCATION_ALWAYS,
            PermissionGroup.LOCATION_WHEN_IN_USE,
            PermissionGroup.LOCATION -> {
                if (hasPermissionInManifest(Manifest.permission.ACCESS_COARSE_LOCATION))
                    permissionNames.add(Manifest.permission.ACCESS_COARSE_LOCATION)


                if (hasPermissionInManifest(Manifest.permission.ACCESS_FINE_LOCATION))
                    permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION)
            }

            PermissionGroup.SPEECH,
            PermissionGroup.MICROPHONE -> {
                if (hasPermissionInManifest(Manifest.permission.RECORD_AUDIO))
                    permissionNames.add(Manifest.permission.RECORD_AUDIO)

            }

            PermissionGroup.PHONE -> {
                if (hasPermissionInManifest(Manifest.permission.READ_PHONE_STATE))
                    permissionNames.add(Manifest.permission.READ_PHONE_STATE)

                if (hasPermissionInManifest(Manifest.permission.CALL_PHONE))
                    permissionNames.add(Manifest.permission.CALL_PHONE)

                if (hasPermissionInManifest(Manifest.permission.READ_CALL_LOG))
                    permissionNames.add(Manifest.permission.READ_CALL_LOG)

                if (hasPermissionInManifest(Manifest.permission.WRITE_CALL_LOG))
                    permissionNames.add(Manifest.permission.WRITE_CALL_LOG)

                if (hasPermissionInManifest(Manifest.permission.ADD_VOICEMAIL))
                    permissionNames.add(Manifest.permission.ADD_VOICEMAIL)

                if (hasPermissionInManifest(Manifest.permission.USE_SIP))
                    permissionNames.add(Manifest.permission.USE_SIP)

                if (hasPermissionInManifest(Manifest.permission.PROCESS_OUTGOING_CALLS))
                    permissionNames.add(Manifest.permission.PROCESS_OUTGOING_CALLS)
            }
            PermissionGroup.SENSORS -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
                    if (hasPermissionInManifest(Manifest.permission.BODY_SENSORS)) {
                        permissionNames.add(Manifest.permission.BODY_SENSORS)
                    }
                }
            }

            PermissionGroup.SMS -> {
                if (hasPermissionInManifest(Manifest.permission.SEND_SMS))
                    permissionNames.add(Manifest.permission.SEND_SMS)

                if (hasPermissionInManifest(Manifest.permission.RECEIVE_SMS))
                    permissionNames.add(Manifest.permission.RECEIVE_SMS)

                if (hasPermissionInManifest(Manifest.permission.READ_SMS))
                    permissionNames.add(Manifest.permission.READ_SMS)

                if (hasPermissionInManifest(Manifest.permission.RECEIVE_WAP_PUSH))
                    permissionNames.add(Manifest.permission.RECEIVE_WAP_PUSH)

                if (hasPermissionInManifest(Manifest.permission.RECEIVE_MMS))
                    permissionNames.add(Manifest.permission.RECEIVE_MMS)
            }

            PermissionGroup.STORAGE -> {
                if (hasPermissionInManifest(Manifest.permission.READ_EXTERNAL_STORAGE))
                    permissionNames.add(Manifest.permission.READ_EXTERNAL_STORAGE)

                if (hasPermissionInManifest(Manifest.permission.WRITE_EXTERNAL_STORAGE))
                    permissionNames.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            }
            else -> return null
        }

        return permissionNames
    }

    private fun hasPermissionInManifest(permission: String): Boolean {
        try {
            requestedPermissions?.let {
                return it.any { r -> r.equals(permission, true) }
            }

            val context: Context? = registrar.activity() ?: registrar.activeContext()

            if (context == null) {
                Log.d(mLogTag, "Unable to detect current Activity or App Context.")
                return false
            }

            val info: PackageInfo? = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)

            if (info == null) {
                Log.d(mLogTag, "Unable to get Package info, will not be able to determine permissions to request.")
                return false
            }

            requestedPermissions = info.requestedPermissions.toMutableList()

            if (requestedPermissions == null) {
                Log.d(mLogTag, "There are no requested permissions, please check to ensure you have marked permissions you want to request.")
                return false
            }

            requestedPermissions?.let {
                return it.any { r -> r.equals(permission, true) }
            } ?: return false
        } catch (ex: Exception) {
            Log.d(mLogTag, "Unable to check manifest for permission: $ex")
        }
        return false
    }

    private fun isLocationServiceEnabled(context: Context): Boolean {
        val locationMode: Int
        val locationProviders: String

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            try {
                locationMode = Settings.Secure.getInt(context.contentResolver, Settings.Secure.LOCATION_MODE)

            } catch (e: SettingNotFoundException) {
                e.printStackTrace()
                return false
            }

            return locationMode != Settings.Secure.LOCATION_MODE_OFF

        } else {
            locationProviders = Settings.Secure.getString(context.contentResolver, Settings.Secure.LOCATION_PROVIDERS_ALLOWED)
            return !TextUtils.isEmpty(locationProviders)
        }
    }

    private fun handleSuccess(permissionStatus: PermissionStatus, result: Result?) {
        result?.success(Codec.encodePermissionStatus(permissionStatus))
    }
}
