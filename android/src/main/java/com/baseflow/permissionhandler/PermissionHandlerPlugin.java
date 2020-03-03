package com.baseflow.permissionhandler;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.PowerManager;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.IntDef;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class PermissionHandlerPlugin implements MethodCallHandler {
  private static final String LOG_TAG = "permissions_handler";
  private static final int PERMISSION_CODE = 24;
  private static final int PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS = 5672353;

  //PERMISSION_GROUP
  private static final int PERMISSION_GROUP_CALENDAR = 0;
  private static final int PERMISSION_GROUP_CAMERA = 1;
  private static final int PERMISSION_GROUP_CONTACTS = 2;
  private static final int PERMISSION_GROUP_LOCATION = 3;
  private static final int PERMISSION_GROUP_LOCATION_ALWAYS = 4;
  private static final int PERMISSION_GROUP_LOCATION_WHEN_IN_USE = 5;
  private static final int PERMISSION_GROUP_MEDIA_LIBRARY = 6;
  private static final int PERMISSION_GROUP_MICROPHONE = 7;
  private static final int PERMISSION_GROUP_PHONE = 8;
  private static final int PERMISSION_GROUP_PHOTOS = 9;
  private static final int PERMISSION_GROUP_REMINDERS = 10;
  private static final int PERMISSION_GROUP_SENSORS = 11;
  private static final int PERMISSION_GROUP_SMS = 12;
  private static final int PERMISSION_GROUP_SPEECH = 13;
  private static final int PERMISSION_GROUP_STORAGE = 14;
  private static final int PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS = 15;
  private static final int PERMISSION_GROUP_NOTIFICATION = 16;
  private static final int PERMISSION_GROUP_ACCESS_MEDIA_LOCATION = 17;
  private static final int PERMISSION_GROUP_ACTIVITY_RECOGNITION = 18;
  private static final int PERMISSION_GROUP_UNKNOWN = 19;

  private PermissionHandlerPlugin(Registrar mRegistrar) {
    this.mRegistrar = mRegistrar;
  }

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
      PERMISSION_GROUP_SMS,
      PERMISSION_GROUP_SPEECH,
      PERMISSION_GROUP_STORAGE,
      PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS,
      PERMISSION_GROUP_NOTIFICATION,
      PERMISSION_GROUP_ACCESS_MEDIA_LOCATION,
      PERMISSION_GROUP_ACTIVITY_RECOGNITION,
      PERMISSION_GROUP_UNKNOWN,
  })
  private @interface PermissionGroup {
  }

  //PERMISSION_STATUS
  private static final int PERMISSION_STATUS_DENIED = 0;
  private static final int PERMISSION_STATUS_GRANTED = 1;
  private static final int PERMISSION_STATUS_RESTRICTED = 2;
  private static final int PERMISSION_STATUS_UNKNOWN = 3;
  private static final int PERMISSION_STATUS_NEWER_ASK_AGAIN = 4;
  @Retention(RetentionPolicy.SOURCE)
  @IntDef({
      PERMISSION_STATUS_DENIED,
      PERMISSION_STATUS_GRANTED,
      PERMISSION_STATUS_RESTRICTED,
      PERMISSION_STATUS_UNKNOWN,
      PERMISSION_STATUS_NEWER_ASK_AGAIN,
  })
  private @interface PermissionStatus {
  }


  //SERVICE_STATUS
  private static final int SERVICE_STATUS_DISABLED = 0;
  private static final int SERVICE_STATUS_ENABLED = 1;
  private static final int SERVICE_STATUS_NOT_APPLICABLE = 2;
  private static final int SERVICE_STATUS_UNKNOWN = 3;

  @Retention(RetentionPolicy.SOURCE)
  @IntDef({
      SERVICE_STATUS_DISABLED,
      SERVICE_STATUS_ENABLED,
      SERVICE_STATUS_NOT_APPLICABLE,
      SERVICE_STATUS_UNKNOWN,
  })
  private @interface ServiceStatus {
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter.baseflow.com/permissions/methods");
    final PermissionHandlerPlugin permissionHandlerPlugin = new PermissionHandlerPlugin(registrar);
    channel.setMethodCallHandler(permissionHandlerPlugin);

    registrar.addRequestPermissionsResultListener(new PluginRegistry.RequestPermissionsResultListener() {
      @Override
      public boolean onRequestPermissionsResult(int id, String[] permissions, int[] grantResults) {
        if (id == PERMISSION_CODE) {
          permissionHandlerPlugin.handlePermissionsRequest(permissions, grantResults);
          return true;
        } else {
          return false;
        }
      }
    });

    registrar.addActivityResultListener(new ActivityResultListener() {
      @Override
      public boolean onActivityResult(int requestCode, int responseCode, Intent intent) {
        if (requestCode == PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS) {
          permissionHandlerPlugin.handleIgnoreBatteryOptimizationsRequest(responseCode == Activity.RESULT_OK);
          return true;
        }

        return false;
      }
    });
  }

  @PermissionGroup
  private static int parseManifestName(String permission) {
    switch (permission) {
      case Manifest.permission.READ_CALENDAR:
      case Manifest.permission.WRITE_CALENDAR:
        return PERMISSION_GROUP_CALENDAR;
      case Manifest.permission.CAMERA:
        return PERMISSION_GROUP_CAMERA;
      case Manifest.permission.READ_CONTACTS:
      case Manifest.permission.WRITE_CONTACTS:
      case Manifest.permission.GET_ACCOUNTS:
        return PERMISSION_GROUP_CONTACTS;
      case Manifest.permission.ACCESS_BACKGROUND_LOCATION:
        return PERMISSION_GROUP_LOCATION_ALWAYS;
      case Manifest.permission.ACCESS_COARSE_LOCATION:
      case Manifest.permission.ACCESS_FINE_LOCATION:
        return PERMISSION_GROUP_LOCATION;
      case Manifest.permission.RECORD_AUDIO:
        return PERMISSION_GROUP_MICROPHONE;
      case Manifest.permission.READ_PHONE_STATE:
      case Manifest.permission.CALL_PHONE:
      case Manifest.permission.READ_CALL_LOG:
      case Manifest.permission.WRITE_CALL_LOG:
      case Manifest.permission.ADD_VOICEMAIL:
      case Manifest.permission.USE_SIP:
      case Manifest.permission.BIND_CALL_REDIRECTION_SERVICE:
        return PERMISSION_GROUP_PHONE;
      case Manifest.permission.BODY_SENSORS:
        return PERMISSION_GROUP_SENSORS;
      case Manifest.permission.SEND_SMS:
      case Manifest.permission.RECEIVE_SMS:
      case Manifest.permission.READ_SMS:
      case Manifest.permission.RECEIVE_WAP_PUSH:
      case Manifest.permission.RECEIVE_MMS:
        return PERMISSION_GROUP_SMS;
      case Manifest.permission.READ_EXTERNAL_STORAGE:
      case Manifest.permission.WRITE_EXTERNAL_STORAGE:
        return PERMISSION_GROUP_STORAGE;
      case Manifest.permission.ACCESS_MEDIA_LOCATION:
        return PERMISSION_GROUP_ACCESS_MEDIA_LOCATION;
      case Manifest.permission.ACTIVITY_RECOGNITION:
        return PERMISSION_GROUP_ACTIVITY_RECOGNITION;
      default:
        return PERMISSION_GROUP_UNKNOWN;
    }
  }

  private final Registrar mRegistrar;
  private Result mResult;
  private ArrayList<String> mRequestedPermissions;
  @SuppressLint("UseSparseArrays")
  private Map<Integer, Integer> mRequestResults = new HashMap<>();

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "checkPermissionStatus": {
        @PermissionGroup final int permission = (int) call.arguments;
        @PermissionStatus final int permissionStatus = checkPermissionStatus(permission);

        result.success(permissionStatus);
        break;
      }
      case "checkServiceStatus": {
        @PermissionGroup final int permission = (int) call.arguments;
        @ServiceStatus final int serviceStatus = checkServiceStatus(permission);

        result.success(serviceStatus);
        break;
      }
      case "requestPermissions":
        if (mResult != null) {
          result.error(
              "ERROR_ALREADY_REQUESTING_PERMISSIONS",
              "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time).",
              null);
          return;
        }

        mResult = result;
        final List<Integer> permissions = call.arguments();
        requestPermissions(permissions);
        break;
      case "shouldShowRequestPermissionRationale": {
        @PermissionGroup final int permission = (int) call.arguments;
        result.success(shouldShowRequestPermissionRationale(permission));
        break;
      }
      case "openAppSettings":
        boolean isOpen = openAppSettings();
        result.success(isOpen);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @PermissionStatus
  private int checkPermissionStatus(@PermissionGroup int permission) {
    final Context context = mRegistrar.activity() == null ? mRegistrar.activeContext() : mRegistrar.activity();
    if (context == null) {
      Log.d(LOG_TAG, "Unable to detect current Activity or App Context.");
      return PERMISSION_STATUS_UNKNOWN;
    }

    if (permission == PERMISSION_GROUP_NOTIFICATION) {
      return checkNotificationPermissionStatus(context);
    }

    final List<String> names = getManifestNames(permission);

    if (names == null) {
      Log.d(LOG_TAG, "No android specific permissions needed for: " + permission);

      return PERMISSION_STATUS_GRANTED;
    }

    //if no permissions were found then there is an issue and permission is not set in Android manifest
    if (names.size() == 0) {
      Log.d(LOG_TAG, "No permissions found in manifest for: " + permission);
      return PERMISSION_STATUS_UNKNOWN;
    }

    final boolean targetsMOrHigher = context.getApplicationInfo().targetSdkVersion >= VERSION_CODES.M;

    for (String name : names) {
      // Only handle them if the client app actually targets a API level greater than M.
      if (targetsMOrHigher) {
        if (permission == PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
          String packageName = context.getPackageName();
          PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
          // PowerManager.isIgnoringBatteryOptimizations has been included in Android M first.
          if (VERSION.SDK_INT >= VERSION_CODES.M) {
            if (pm != null && pm.isIgnoringBatteryOptimizations(packageName)) {
              return PERMISSION_STATUS_GRANTED;
            } else {
              return PERMISSION_STATUS_DENIED;
            }
          } else {
            return PERMISSION_STATUS_RESTRICTED;
          }
        }
        final int permissionStatus = ContextCompat.checkSelfPermission(context, name);
        if (permissionStatus == PackageManager.PERMISSION_DENIED) {
          if (VERSION.SDK_INT >= VERSION_CODES.M && isNeverAskAgainSelected(permission)) {
            return PERMISSION_STATUS_NEWER_ASK_AGAIN;
          } else return PERMISSION_STATUS_DENIED;
        } else if (permissionStatus != PackageManager.PERMISSION_GRANTED) {
          return PERMISSION_STATUS_UNKNOWN;
        }
      }
    }
    
    return PERMISSION_STATUS_GRANTED;
  }

  @ServiceStatus
  private int checkServiceStatus(int permission) {
    final Context context = mRegistrar.activity() == null ? mRegistrar.activeContext() : mRegistrar.activity();

    if (context == null) {
      Log.d(LOG_TAG, "Unable to detect current Activity or App Context.");
      return SERVICE_STATUS_UNKNOWN;
    }

    if (permission == PERMISSION_GROUP_LOCATION || permission == PERMISSION_GROUP_LOCATION_ALWAYS || permission == PERMISSION_GROUP_LOCATION_WHEN_IN_USE) {
      return isLocationServiceEnabled(context) ? SERVICE_STATUS_ENABLED : SERVICE_STATUS_DISABLED;
    }

    if (permission == PERMISSION_GROUP_PHONE) {
      PackageManager pm = context.getPackageManager();
      if (!pm.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)) {
        return SERVICE_STATUS_NOT_APPLICABLE;
      }

      TelephonyManager telephonyManager = (TelephonyManager) context
          .getSystemService(Context.TELEPHONY_SERVICE);

      if (telephonyManager == null || telephonyManager.getPhoneType() == TelephonyManager.PHONE_TYPE_NONE) {
        return SERVICE_STATUS_NOT_APPLICABLE;
      }

      Intent callIntent = new Intent(Intent.ACTION_CALL);
      callIntent.setData(Uri.parse("tel:123123"));
      List<ResolveInfo> callAppsList = pm.queryIntentActivities(callIntent, 0);

      if (callAppsList.isEmpty()) {
        return SERVICE_STATUS_NOT_APPLICABLE;
      }

      if (telephonyManager.getSimState() != TelephonyManager.SIM_STATE_READY) {
        return SERVICE_STATUS_DISABLED;
      }

      return SERVICE_STATUS_ENABLED;
    }

    if (permission == PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
      return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? SERVICE_STATUS_ENABLED : SERVICE_STATUS_NOT_APPLICABLE;
    }

    return SERVICE_STATUS_NOT_APPLICABLE;
  }

  private boolean shouldShowRequestPermissionRationale(int permission) {
    Activity activity = mRegistrar.activity();
    if (activity == null) {
      Log.d(LOG_TAG, "Unable to detect current Activity.");
      return false;
    }

    List<String> names = getManifestNames(permission);

    // if isn't an android specific group then go ahead and return false;
    if (names == null) {
      Log.d(LOG_TAG, "No android specific permissions needed for: " + permission);
      return false;
    }

    if (names.isEmpty()) {
      Log.d(LOG_TAG, "No permissions found in manifest for: " + permission + " no need to show request rationale");
      return false;
    }

    //noinspection LoopStatementThatDoesntLoop
    for (String name : names) {
      return ActivityCompat.shouldShowRequestPermissionRationale(activity, name);
    }

    return false;
  }

  private void requestPermissions(List<Integer> permissions) {
    if (mRegistrar.activity() == null) {
      Log.d(LOG_TAG, "Unable to detect current Activity.");

      for (Integer permission : permissions) {
        mRequestResults.put(permission, PERMISSION_STATUS_UNKNOWN);
      }

      processResult();
      return;
    }

    ArrayList<String> permissionsToRequest = new ArrayList<>();
    for (Integer permission : permissions) {
      @PermissionStatus final int permissionStatus = checkPermissionStatus(permission);
      if (permissionStatus != PERMISSION_STATUS_GRANTED) {
        final List<String> names = getManifestNames(permission);

        //check to see if we can find manifest names
        //if we can't add as unknown and continue
        if (names == null || names.isEmpty()) {
          if (!mRequestResults.containsKey(permission)) {
            mRequestResults.put(permission, PERMISSION_STATUS_UNKNOWN);
          }

          continue;
        }

        if (VERSION.SDK_INT >= VERSION_CODES.M && permission == PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
          String packageName = mRegistrar.context().getPackageName();
          Intent intent = new Intent();
          intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
          intent.setData(Uri.parse("package:" + packageName));
          mRegistrar.activity().startActivityForResult(intent, PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS);
        } else {
          permissionsToRequest.addAll(names);
        }
      } else {
        if (!mRequestResults.containsKey(permission)) {
          mRequestResults.put(permission, PERMISSION_STATUS_GRANTED);
        }
      }
    }

    final String[] requestPermissions = permissionsToRequest.toArray(new String[0]);
    if (permissionsToRequest.size() > 0) {
      ActivityCompat.requestPermissions(mRegistrar.activity(), requestPermissions, PERMISSION_CODE);
    } else if (mRequestResults.size() > 0) {
      processResult();
    }
  }

  private void handlePermissionsRequest(String[] permissions, int[] grantResults) {
    if (mResult == null) {
      return;
    }

    for (int i = 0; i < permissions.length; i++) {
      @PermissionGroup final int permission = parseManifestName(permissions[i]);
      if (permission == PERMISSION_GROUP_UNKNOWN)
        continue;

      final int result = grantResults[i];

      if (permission == PERMISSION_GROUP_MICROPHONE) {
        if (!mRequestResults.containsKey(PERMISSION_GROUP_MICROPHONE)) {
          mRequestResults.put(PERMISSION_GROUP_MICROPHONE, toPermissionStatus(permission, result));
        }
        if (!mRequestResults.containsKey(PERMISSION_GROUP_SPEECH)) {
          mRequestResults.put(PERMISSION_GROUP_SPEECH, toPermissionStatus(permission, result));
        }
      } else if (permission == PERMISSION_GROUP_LOCATION_ALWAYS) {
        @PermissionStatus int permissionStatus = toPermissionStatus(permission, result);

        if (!mRequestResults.containsKey(PERMISSION_GROUP_LOCATION_ALWAYS)) {
          mRequestResults.put(PERMISSION_GROUP_LOCATION_ALWAYS, permissionStatus);
        }
      } else if (permission == PERMISSION_GROUP_LOCATION) {
        @PermissionStatus int permissionStatus = toPermissionStatus(permission, result);

        if (VERSION.SDK_INT < VERSION_CODES.Q) {
          if (!mRequestResults.containsKey(PERMISSION_GROUP_LOCATION_ALWAYS)) {
            mRequestResults.put(PERMISSION_GROUP_LOCATION_ALWAYS, permissionStatus);
          }
        }

        if (!mRequestResults.containsKey(PERMISSION_GROUP_LOCATION_WHEN_IN_USE)) {
          mRequestResults.put(PERMISSION_GROUP_LOCATION_WHEN_IN_USE, permissionStatus);
        }

        mRequestResults.put(permission, permissionStatus);
      } else if (!mRequestResults.containsKey(permission)) {
        mRequestResults.put(permission, toPermissionStatus(permission, result));
      }

      updatePermissionShouldShowStatus(permission);
    }

    processResult();
  }

  private void handleIgnoreBatteryOptimizationsRequest(boolean granted) {
    if (mResult == null) {
      return;
    }

    int status = granted ? PERMISSION_STATUS_GRANTED : PERMISSION_STATUS_DENIED;

    mRequestResults.put(PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS, status);

    processResult();
  }

  @PermissionStatus
  private int toPermissionStatus(@PermissionGroup int permission, int grantResult) {
    if (grantResult == PackageManager.PERMISSION_DENIED) {
      return VERSION.SDK_INT >= VERSION_CODES.M && isNeverAskAgainSelected(permission)
              ? PERMISSION_STATUS_NEWER_ASK_AGAIN
              : PERMISSION_STATUS_DENIED;
    }

    return PERMISSION_STATUS_GRANTED;
  }

  private void processResult() {
    mResult.success(mRequestResults);

    mRequestResults.clear();
    mResult = null;
  }

  private boolean openAppSettings() {
    final Context context = mRegistrar.activity() == null ? mRegistrar.activeContext() : mRegistrar.activity();
    if (context == null) {
      Log.d(LOG_TAG, "Unable to detect current Activity or App Context.");
      return false;
    }

    try {
      Intent settingsIntent = new Intent();
      settingsIntent.setAction(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
      settingsIntent.addCategory(Intent.CATEGORY_DEFAULT);
      settingsIntent.setData(android.net.Uri.parse("package:" + context.getPackageName()));
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

      context.startActivity(settingsIntent);

      return true;
    } catch (Exception ex) {
      return false;
    }
  }

  private List<String> getManifestNames(@PermissionGroup int permission) {
    final ArrayList<String> permissionNames = new ArrayList<>();

    switch (permission) {
      case PERMISSION_GROUP_CALENDAR:
        if (hasPermissionInManifest(Manifest.permission.READ_CALENDAR))
          permissionNames.add(Manifest.permission.READ_CALENDAR);
        if (hasPermissionInManifest(Manifest.permission.WRITE_CALENDAR))
          permissionNames.add(Manifest.permission.WRITE_CALENDAR);
        break;

      case PERMISSION_GROUP_CAMERA:
        if (hasPermissionInManifest(Manifest.permission.CAMERA))
          permissionNames.add(Manifest.permission.CAMERA);
        break;

      case PERMISSION_GROUP_CONTACTS:
        if (hasPermissionInManifest(Manifest.permission.READ_CONTACTS))
          permissionNames.add(Manifest.permission.READ_CONTACTS);

        if (hasPermissionInManifest(Manifest.permission.WRITE_CONTACTS))
          permissionNames.add(Manifest.permission.WRITE_CONTACTS);

        if (hasPermissionInManifest(Manifest.permission.GET_ACCOUNTS))
          permissionNames.add(Manifest.permission.GET_ACCOUNTS);
        break;

      case PERMISSION_GROUP_LOCATION_ALWAYS:
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
          if (hasPermissionInManifest(Manifest.permission.ACCESS_BACKGROUND_LOCATION))
            permissionNames.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION);
        }

      case PERMISSION_GROUP_LOCATION_WHEN_IN_USE:
      case PERMISSION_GROUP_LOCATION:
        if (hasPermissionInManifest(Manifest.permission.ACCESS_COARSE_LOCATION))
          permissionNames.add(Manifest.permission.ACCESS_COARSE_LOCATION);

        if (hasPermissionInManifest(Manifest.permission.ACCESS_FINE_LOCATION))
          permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION);
        break;


      case PERMISSION_GROUP_SPEECH:
      case PERMISSION_GROUP_MICROPHONE:
        if (hasPermissionInManifest(Manifest.permission.RECORD_AUDIO))
          permissionNames.add(Manifest.permission.RECORD_AUDIO);
        break;

      case PERMISSION_GROUP_PHONE:
        if (hasPermissionInManifest(Manifest.permission.READ_PHONE_STATE))
          permissionNames.add(Manifest.permission.READ_PHONE_STATE);

        if (hasPermissionInManifest(Manifest.permission.CALL_PHONE))
          permissionNames.add(Manifest.permission.CALL_PHONE);

        if (hasPermissionInManifest(Manifest.permission.READ_CALL_LOG))
          permissionNames.add(Manifest.permission.READ_CALL_LOG);

        if (hasPermissionInManifest(Manifest.permission.WRITE_CALL_LOG))
          permissionNames.add(Manifest.permission.WRITE_CALL_LOG);

        if (hasPermissionInManifest(Manifest.permission.ADD_VOICEMAIL))
          permissionNames.add(Manifest.permission.ADD_VOICEMAIL);

        if (hasPermissionInManifest(Manifest.permission.USE_SIP))
          permissionNames.add(Manifest.permission.USE_SIP);

        if (VERSION.SDK_INT >= VERSION_CODES.Q && hasPermissionInManifest(Manifest.permission.BIND_CALL_REDIRECTION_SERVICE))
          permissionNames.add(Manifest.permission.BIND_CALL_REDIRECTION_SERVICE);

        if (VERSION.SDK_INT >= VERSION_CODES.O && hasPermissionInManifest(Manifest.permission.ANSWER_PHONE_CALLS))
            permissionNames.add(Manifest.permission.ANSWER_PHONE_CALLS);

        break;

      case PERMISSION_GROUP_SENSORS:
        if (VERSION.SDK_INT >= VERSION_CODES.KITKAT_WATCH) {
          if (hasPermissionInManifest(Manifest.permission.BODY_SENSORS)) {
            permissionNames.add(Manifest.permission.BODY_SENSORS);
          }
        }
        break;

      case PERMISSION_GROUP_SMS:
        if (hasPermissionInManifest(Manifest.permission.SEND_SMS))
          permissionNames.add(Manifest.permission.SEND_SMS);

        if (hasPermissionInManifest(Manifest.permission.RECEIVE_SMS))
          permissionNames.add(Manifest.permission.RECEIVE_SMS);

        if (hasPermissionInManifest(Manifest.permission.READ_SMS))
          permissionNames.add(Manifest.permission.READ_SMS);

        if (hasPermissionInManifest(Manifest.permission.RECEIVE_WAP_PUSH))
          permissionNames.add(Manifest.permission.RECEIVE_WAP_PUSH);

        if (hasPermissionInManifest(Manifest.permission.RECEIVE_MMS))
          permissionNames.add(Manifest.permission.RECEIVE_MMS);
        break;

      case PERMISSION_GROUP_STORAGE:
        if (hasPermissionInManifest(Manifest.permission.READ_EXTERNAL_STORAGE))
          permissionNames.add(Manifest.permission.READ_EXTERNAL_STORAGE);

        if (hasPermissionInManifest(Manifest.permission.WRITE_EXTERNAL_STORAGE))
          permissionNames.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        break;

      case PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS:
        if (VERSION.SDK_INT >= VERSION_CODES.M && hasPermissionInManifest(Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS))
          permissionNames.add(Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
        break;

      case PERMISSION_GROUP_ACCESS_MEDIA_LOCATION:
        if (VERSION.SDK_INT >= VERSION_CODES.Q && hasPermissionInManifest(Manifest.permission.ACCESS_MEDIA_LOCATION))
            permissionNames.add(Manifest.permission.ACCESS_MEDIA_LOCATION);
        break;

      case PERMISSION_GROUP_ACTIVITY_RECOGNITION:
        if (VERSION.SDK_INT >= VERSION_CODES.Q && hasPermissionInManifest(Manifest.permission.ACTIVITY_RECOGNITION))
          permissionNames.add(Manifest.permission.ACTIVITY_RECOGNITION);
        break;

      case PERMISSION_GROUP_NOTIFICATION:
      case PERMISSION_GROUP_MEDIA_LIBRARY:
      case PERMISSION_GROUP_PHOTOS:
      case PERMISSION_GROUP_REMINDERS:
      case PERMISSION_GROUP_UNKNOWN:
        return null;
    }

    return permissionNames;
  }

  private boolean hasPermissionInManifest(String permission) {
    try {
      if (mRequestedPermissions != null) {
        for (String r : mRequestedPermissions) {
          if (r.equals(permission)) {
            return true;
          }
        }
      }

      final Context context = mRegistrar.activity() == null ? mRegistrar.activeContext() : mRegistrar.activity();

      if (context == null) {
        Log.d(LOG_TAG, "Unable to detect current Activity or App Context.");
        return false;
      }

      PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_PERMISSIONS);

      if (info == null) {
        Log.d(LOG_TAG, "Unable to get Package info, will not be able to determine permissions to request.");
        return false;
      }

      mRequestedPermissions = new ArrayList<>(Arrays.asList(info.requestedPermissions));
      for (String r : mRequestedPermissions) {
        if (r.equals(permission)) {
          return true;
        }
      }
    } catch (Exception ex) {
      Log.d(LOG_TAG, "Unable to check manifest for permission: ", ex);
    }
    return false;
  }

  private void updatePermissionShouldShowStatus(@PermissionGroup int permission) {

    List<String> names = getManifestNames(permission);

    if (names == null || names.isEmpty()) {
      return;
    }

    final Context context = mRegistrar.activity() == null ? mRegistrar.activeContext() : mRegistrar.activity();

    if (context == null) {
      return;
    }

    for (String name : names) {
      PermissionUtils.setRequestedPermission(context, name);
    }
  }

  @RequiresApi(api = Build.VERSION_CODES.M)
  private boolean isNeverAskAgainSelected(@PermissionGroup int permission) {
    List<String> names = getManifestNames(permission);

    if (names == null || names.isEmpty()) {
      return false;
    }

    final Activity activity = mRegistrar.activity();

    if (activity == null) {
      return false;
    }
    boolean isNeverAskAgainSelected = false;
    for (String name : names) {
      isNeverAskAgainSelected |= PermissionUtils.neverAskAgainSelected(activity, name);
    }

    return isNeverAskAgainSelected;
  }

  private boolean isLocationServiceEnabled(Context context) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
      final LocationManager locationManager = context.getSystemService(LocationManager.class);
      if (locationManager == null) {
        return false;
      }

      return locationManager.isLocationEnabled();
    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      return isLocationServiceEnablePrePie(context);
    } else {
      return isLocationServiceEnablePreKitKat(context);
    }
  }

  // Suppress deprecation warnings since it's purpose is to support to be backwards compatible with
  // pre Pie versions of Android.
  @SuppressWarnings("deprecation")
  private static boolean isLocationServiceEnablePrePie(Context context)
  {
      if (VERSION.SDK_INT < VERSION_CODES.P)
          return false;

      final int locationMode;

      try {
          locationMode = Settings.Secure.getInt(
                  context.getContentResolver(),
                  Settings.Secure.LOCATION_MODE);
      } catch (Settings.SettingNotFoundException e) {
          e.printStackTrace();
          return false;
      }

      return locationMode != Settings.Secure.LOCATION_MODE_OFF;
  }

  // Suppress deprecation warnings since it's purpose is to support to be backwards compatible with
  // pre KitKat versions of Android.
  @SuppressWarnings("deprecation")
  private static boolean isLocationServiceEnablePreKitKat(Context context)
  {
      if (VERSION.SDK_INT >= VERSION_CODES.KITKAT)
          return false;

      final String locationProviders = Settings.Secure.getString(
              context.getContentResolver(),
              Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
      return !TextUtils.isEmpty(locationProviders);
  }

  private int checkNotificationPermissionStatus(Context context) {
    NotificationManagerCompat manager = NotificationManagerCompat.from(context);
    boolean isGranted = manager.areNotificationsEnabled();
    if (isGranted) {
      return PERMISSION_STATUS_GRANTED;
    }
    return PERMISSION_STATUS_DENIED;
  }
}
