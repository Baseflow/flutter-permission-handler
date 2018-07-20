package com.baseflow.permissionhandler

import android.Manifest
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.support.v4.content.ContextCompat
import android.util.Log
import com.baseflow.permissionhandler.data.PermissionGroup
import com.baseflow.permissionhandler.data.PermissionStatus
import com.baseflow.permissionhandler.utils.Codec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class PermissionHandlerPlugin(private val registrar: Registrar, private var requestedPermissions: MutableList<String>? = null): MethodCallHandler {

  companion object {
    @JvmStatic private val logTag = "permissions_handler"

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter.baseflow.com/permissions/methods")
      channel.setMethodCallHandler(PermissionHandlerPlugin(registrar))
    }

    @JvmStatic
    fun parseManifestName(permission: String) : PermissionGroup
    {
      
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
    if (call.method == "checkPermissionStatus") {
      val permission = Codec.decodePermissionGroup(call.arguments)
      checkPermissionStatus(permission, result)
    } else {
      result.notImplemented()
    }
  }

  private fun checkPermissionStatus(permission: PermissionGroup, result: Result)
  {
    val names = getManifestNames(permission)

    if (names == null)
    {
      Log.d(logTag, "No android specific permissions needed for: $permission")
      handleSuccess(PermissionStatus.GRANTED, result)
      return
    }

    //if no permissions were found then there is an issue and persmission is not set in Android manifest
    if (names.count() == 0)
    {
      Log.d(logTag, "No permissions found in manifest for: $permission")
      handleSuccess(PermissionStatus.UNKNOWN, result)
      return
    }

    val context: Context? = registrar.activity() ?: registrar.activeContext()
    if (context == null)
    {
      Log.d(logTag, "Unable to detect current Activity or App Context. Please ensure Plugin.CurrentActivity is installed in your Android project and your Application class is registering with Application.IActivityLifecycleCallbacks.")
      handleSuccess(PermissionStatus.UNKNOWN, result)
      return
    }

    val targetsMOrHigher = context.applicationInfo.targetSdkVersion >= android.os.Build.VERSION_CODES.M

    for (name in names)
    {
      if (targetsMOrHigher && ContextCompat.checkSelfPermission(context, name) != PackageManager.PERMISSION_GRANTED) {
          handleSuccess(PermissionStatus.DENIED, result)
          return
      }
    }

    handleSuccess(PermissionStatus.GRANTED, result)
  }

  private fun getManifestNames(permission: PermissionGroup) : List<String>?
  {
    val permissionNames : MutableList<String> = mutableListOf()

    when(permission) {
      PermissionGroup.CALENDAR ->
      {
        if(hasPermissionInManifest(Manifest.permission.READ_CALENDAR))
          permissionNames.add(Manifest.permission.READ_CALENDAR)
        if(hasPermissionInManifest(Manifest.permission.WRITE_CALENDAR))
          permissionNames.add(Manifest.permission.WRITE_CALENDAR)
      }
      PermissionGroup.CAMERA ->
      {
        if(hasPermissionInManifest(Manifest.permission.CAMERA))
          permissionNames.add(Manifest.permission.CAMERA)
      }
      PermissionGroup.CONTACTS ->
      {
        if(hasPermissionInManifest(Manifest.permission.READ_CONTACTS))
          permissionNames.add(Manifest.permission.READ_CONTACTS)

        if(hasPermissionInManifest(Manifest.permission.WRITE_CONTACTS))
          permissionNames.add(Manifest.permission.WRITE_CONTACTS)

        if(hasPermissionInManifest(Manifest.permission.GET_ACCOUNTS))
          permissionNames.add(Manifest.permission.GET_ACCOUNTS)
      }
      PermissionGroup.LOCATION_ALWAYS,
      PermissionGroup.LOCATION_WHEN_IN_USE,
      PermissionGroup.LOCATION ->
      {
        if(hasPermissionInManifest(Manifest.permission.ACCESS_COARSE_LOCATION))
          permissionNames.add(Manifest.permission.ACCESS_COARSE_LOCATION)


        if(hasPermissionInManifest(Manifest.permission.ACCESS_FINE_LOCATION))
          permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION)
      }
      
      PermissionGroup.SPEECH,
      PermissionGroup.MICROPHONE ->
      {
        if(hasPermissionInManifest(Manifest.permission.RECORD_AUDIO))
          permissionNames.add(Manifest.permission.RECORD_AUDIO)

      }
      
      PermissionGroup.PHONE ->
      {
        if(hasPermissionInManifest(Manifest.permission.READ_PHONE_STATE))
          permissionNames.add(Manifest.permission.READ_PHONE_STATE)

        if(hasPermissionInManifest(Manifest.permission.CALL_PHONE))
          permissionNames.add(Manifest.permission.CALL_PHONE)

        if(hasPermissionInManifest(Manifest.permission.READ_CALL_LOG))
          permissionNames.add(Manifest.permission.READ_CALL_LOG)

        if(hasPermissionInManifest(Manifest.permission.WRITE_CALL_LOG))
          permissionNames.add(Manifest.permission.WRITE_CALL_LOG)

        if(hasPermissionInManifest(Manifest.permission.ADD_VOICEMAIL))
          permissionNames.add(Manifest.permission.ADD_VOICEMAIL)

        if(hasPermissionInManifest(Manifest.permission.USE_SIP))
          permissionNames.add(Manifest.permission.USE_SIP)

        if(hasPermissionInManifest(Manifest.permission.PROCESS_OUTGOING_CALLS))
          permissionNames.add(Manifest.permission.PROCESS_OUTGOING_CALLS)
      }
      PermissionGroup.SENSORS -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
          if (hasPermissionInManifest(Manifest.permission.BODY_SENSORS)) {
            permissionNames.add(Manifest.permission.BODY_SENSORS)
          }
        }
      }
      
      PermissionGroup.SMS ->
      {
        if(hasPermissionInManifest(Manifest.permission.SEND_SMS))
          permissionNames.add(Manifest.permission.SEND_SMS)

        if(hasPermissionInManifest(Manifest.permission.RECEIVE_SMS))
          permissionNames.add(Manifest.permission.RECEIVE_SMS)

        if(hasPermissionInManifest(Manifest.permission.READ_SMS))
          permissionNames.add(Manifest.permission.READ_SMS)

        if(hasPermissionInManifest(Manifest.permission.RECEIVE_WAP_PUSH))
          permissionNames.add(Manifest.permission.RECEIVE_WAP_PUSH)

        if(hasPermissionInManifest(Manifest.permission.RECEIVE_MMS))
          permissionNames.add(Manifest.permission.RECEIVE_MMS)
      }
      
      PermissionGroup.STORAGE ->
      {
        if(hasPermissionInManifest(Manifest.permission.READ_EXTERNAL_STORAGE))
          permissionNames.add(Manifest.permission.READ_EXTERNAL_STORAGE)

        if(hasPermissionInManifest(Manifest.permission.WRITE_EXTERNAL_STORAGE))
          permissionNames.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
      }
      else -> return null
    }

    return permissionNames
  }

  private fun hasPermissionInManifest(permission: String) : Boolean
  {
    try
    {
      requestedPermissions?.let {
        return it.any { r -> r.equals(permission, true) }
      }

      val context: Context? = registrar.activity() ?: registrar.activeContext()

      if (context == null)
      {
        Log.d(logTag, "Unable to detect current Activity or App Context. Please ensure Plugin.CurrentActivity is installed in your Android project and your Application class is registering with Application.IActivityLifecycleCallbacks.")
        return false
      }

      val info: PackageInfo? = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)

      if(info == null)
      {
        Log.d(logTag, "Unable to get Package info, will not be able to determine permissions to request.")
        return false
      }

      requestedPermissions = info.requestedPermissions.toMutableList()

      if (requestedPermissions == null)
      {
        Log.d(logTag, "There are no requested permissions, please check to ensure you have marked permissions you want to request.")
        return false
      }

      requestedPermissions?.let {
        return it.any { r -> r.equals(permission, true) }
      } ?: return false
    }
    catch(ex: Exception)
    {
      Log.d(logTag,"Unable to check manifest for permission: $ex")
    }
    return false
  }

  private fun handleSuccess(permissionStatus: PermissionStatus, result: Result) {
    result.success(Codec.encodePermissionStatus(permissionStatus))
  }
}
