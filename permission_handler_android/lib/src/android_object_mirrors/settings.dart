import '../android_permission_handler_api_impls.dart';
import 'build.dart';
import 'context.dart';

/// The Settings provider contains global system-level device preferences.
///
/// See https://developer.android.com/reference/android/provider/Settings.
class Settings {
  const Settings._();

  static final SettingsHostApiImpl _hostApi = SettingsHostApiImpl();

  /// Activity Action: Show screen of details about a particular application.
  ///
  /// Constant Value: "android.settings.APPLICATION_DETAILS_SETTINGS".
  static const String actionApplicationDetailsSettings =
      'android.settings.APPLICATION_DETAILS_SETTINGS';

  /// Activity Action: Ask the user to allow an app to ignore battery optimizations.
  ///
  /// Note: most applications should not use this; there are many facilities
  /// provided by the platform for applications to operate correctly in the
  /// various power saving modes.
  ///
  /// This is only for unusual applications that need to deeply control their
  /// own execution, at the potential expense of the user's battery life.
  ///
  /// Note that these applications greatly run the risk of showing to the user
  /// as high power consumers on their device.
  ///
  /// Input: The Intent's data URI must specify the application package name to
  /// be shown, with the "package" scheme.  That is "package:com.my.app".
  ///
  /// You can use [PowerManager#isIgnoringBatteryOptimizations] to determine if
  /// an application is already ignoring optimizations.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS.
  static const String actionRequestIgnoreBatteryOptimizations =
      'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS';

  /// Activity Action: Show screen for controlling if the app specified in the data URI of the intent can manage external storage.
  ///
  /// Input: The Intent's data URI MUST specify the application package name
  /// whose ability of managing external storage you want to control. For
  /// example "package:com.my.app".
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION.
  static const String actionManagerAppAllFilesAccessPermission =
      'android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION';

  /// Activity Action: Show screen for controlling which apps can draw on top of other apps.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#ACTION_MANAGE_OVERLAY_PERMISSION.
  static const String actionManageOverlayPermission =
      'android.settings.action.MANAGE_OVERLAY_PERMISSION';

  /// Activity Action: Show settings to allow configuration of trusted external sources.
  ///
  /// Input: Optionally, the Intent's data URI can specify the application
  /// package name to directly invoke the management GUI specific to the package
  /// name. For example "package:com.my.app".
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#ACTION_MANAGE_UNKNOWN_APP_SOURCES.
  static const String actionManageUnknownAppSources =
      'android.settings.MANAGE_UNKNOWN_APP_SOURCES';

  /// Activity Action: Show Do Not Disturb access settings.
  ///
  /// Users can grant and deny access to Do Not Disturb configuration from here.
  /// Managed profiles cannot grant Do Not Disturb access.
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS.
  static const String actionNotificationPolicyAccessSettings =
      'android.settings.NOTIFICATION_POLICY_ACCESS_SETTINGS';

  /// Activity Action: Show settings to allow configuration of [Manifest.permission#SYSTEM_ALERT_WINDOW] permission.
  ///
  /// Input: Optionally, the Intent's data URI can specify the application
  /// package name to directly invoke the management GUI specific to the package
  /// name. For example "package:com.my.app".
  ///
  /// Output: When a package data uri is passed as input, the activity result is
  /// set to [Activity#RESULT_OK] if the permission was granted to the app.
  /// Otherwise, the result is set to [Activity#RESULT_CANCELED].
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#ACTION_MANAGE_OVERLAY_PERMISSION.
  static const String actionRequestScheduleExactAlarm =
      'android.settings.REQUEST_SCHEDULE_EXACT_ALARM';

  /// Checks if the specified context can draw on top of other apps.
  ///
  /// As of API level 23, an app cannot draw on top of other apps unless it
  /// declares the [Manifest.permission.systemAlertWindow] permission in its
  /// manifest, **and** the user specifically grants the app this capability. To
  /// prompt the user to grant this approval, the app must send an intent with
  /// the action [Settings.actionManageOverlayPermission], which causes the
  /// system to display a permission management screen.
  ///
  /// Always returns true on devices running Android versions older than
  /// [Build.versionCodes.m].
  ///
  /// See https://developer.android.com/reference/android/provider/Settings#canDrawOverlays(android.content.Context).
  static Future<bool> canDrawOverlays(
    Context context,
  ) async {
    final int sdkVersion = await Build.version.sdkInt;
    if (sdkVersion < Build.versionCodes.m) {
      return true;
    }

    return _hostApi.canDrawOverlaysFromInstance(
      context,
    );
  }
}
