package com.baseflow.permissionhandler;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

public class PermissionUtils {

  @RequiresApi(api = Build.VERSION_CODES.M)
   static boolean neverAskAgainSelected(final Activity activity, final String permission) {
    final boolean prevShouldShowStatus = getRationaleDisplayStatus(activity, permission);
    final boolean currShouldShowStatus = ActivityCompat.shouldShowRequestPermissionRationale(activity, permission);
    return prevShouldShowStatus != currShouldShowStatus;
  }

   static void setShouldShowStatus(final Context context, final String permission) {
    SharedPreferences genPrefs = context.getSharedPreferences("GENERIC_PREFERENCES", Context.MODE_PRIVATE);
    SharedPreferences.Editor editor = genPrefs.edit();
    editor.putBoolean(permission, true);
    editor.apply();
  }

  private static boolean getRationaleDisplayStatus(final Context context, final String permission) {
    SharedPreferences genPrefs = context.getSharedPreferences("GENERIC_PREFERENCES", Context.MODE_PRIVATE);
    return genPrefs.getBoolean(permission, false);
  }
}