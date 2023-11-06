import '../android_permission_handler_api_impls.dart';

/// Information about the current build, extracted from system properties.
///
/// See https://developer.android.com/reference/android/os/Build
class Build {
  Build._();

  /// Various version strings.
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION
  static _Version get version => _version;
  static const _Version _version = _Version();

  /// Enumeration of the currently known SDK version codes.
  ///
  /// These are the values that can be found in VERSION#SDK. Version numbers
  /// increment monotonically with each official platform release.
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES
  static _VersionCodes get versionCodes => _versionCodes;
  static const _VersionCodes _versionCodes = _VersionCodes();
}

/// Various version strings.
///
/// See https://developer.android.com/reference/android/os/Build.VERSION
class _Version {
  const _Version();

  /// The SDK version of the software currently running on this hardware device.
  ///
  /// This value never changes while a device is booted, but it may increase
  /// when the hardware manufacturer provides an OTA update.
  ///
  /// Possible values are defined in [Build.versionCodes].
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION#SDK_INT.
  Future<int> get sdkInt async => await _hostApi.sdkInt();

  static final BuildVersionHostApiImpl _hostApi = BuildVersionHostApiImpl();
}

/// Enumeration of the currently known SDK version codes.
///
/// These are the values that can be found in VERSION#SDK_INT. Version numbers
/// increment monotonically with each official platform release.
///
/// See https://developer.android.com/reference/android/os/Build.VERSION_CODES
class _VersionCodes {
  const _VersionCodes();

  /// The original, first, version of Android. Yay!
  ///
  /// Released publicly as Android 1.0 in September 2008.
  ///
  /// Constant Value: 1 (0x00000001).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#BASE
  int get base => 1;

  /// First Android update.
  ///
  /// Released publicly as Android 1.1 in February 2009.
  ///
  /// Constant Value: 2 (0x00000002).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#BASE_1_1
  int get base1_1 => 2;

  /// C.
  ///
  /// Released publicly as Android 1.5 in April 2009.
  ///
  /// Constant Value: 3 (0x00000003).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#CUPCAKE
  int get cupcake => 3;

  /// CUR_DEVELOPMENT.
  ///
  /// Magic version number for a current development build, which has not yet
  /// turned into an official release.
  ///
  /// Constant Value: 10000 (0x00002710).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#CUR_DEVELOPMENT
  int get curDevelopment => 10000;

  /// D.
  ///
  /// Released publicly as Android 1.6 in September 2009.
  ///
  /// Constant Value: 4 (0x00000004).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#DONUT
  int get donut => 4;

  /// E.
  ///
  /// Released publicly as Android 2.0 in October 2009.
  ///
  /// Constant Value: 5 (0x00000005).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#ECLAIR
  int get eclair => 5;

  /// E incremental update.
  ///
  /// Released publicly as Android 2.0.1 in December 2009.
  ///
  /// Constant Value: 6 (0x00000006).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#ECLAIR_0_1
  int get eclair0_1 => 6;

  /// E MR1.
  ///
  /// Released publicly as Android 2.1 in January 2010.
  ///
  /// Constant Value: 7 (0x00000007).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#ECLAIR_MR1
  int get eclairMR1 => 7;

  /// F.
  ///
  /// Released publicly as Android 2.2 in May 2010.
  ///
  /// Constant Value: 8 (0x00000008).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#FROYO
  int get froyo => 8;

  /// G.
  ///
  /// Released publicly as Android 2.3 in December 2010.
  ///
  /// Constant Value: 9 (0x00000009).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#GINGERBREAD
  int get gingerbread => 9;

  /// G MR1.
  ///
  /// Released publicly as Android 2.3.3 in February 2011.
  ///
  /// Constant Value: 10 (0x0000000a).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#GINGERBREAD_MR1
  int get gingerbreadMR1 => 10;

  /// H.
  ///
  /// Released publicly as Android 3.0 in February 2011.
  ///
  /// Constant Value: 11 (0x0000000b).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#HONEYCOMB
  int get honeycomb => 11;

  /// H MR1.
  ///
  /// Released publicly as Android 3.1 in May 2011.
  ///
  /// Constant Value: 12 (0x0000000c).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#HONEYCOMB_MR1
  int get honeycombMR1 => 12;

  /// H MR2.
  ///
  /// Released publicly as Android 3.2 in July 2011.
  ///
  /// Constant Value: 13 (0x0000000d).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#HONEYCOMB_MR2
  int get honeycombMR2 => 13;

  /// I.
  ///
  /// Released publicly as Android 4.0 in October 2011.
  ///
  /// Constant Value: 14 (0x0000000e).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#ICE_CREAM_SANDWICH
  int get iceCreamSandwich => 14;

  /// I MR1.
  ///
  /// Released publicly as Android 4.0.3 in December 2011.
  ///
  /// Constant Value: 15 (0x0000000f).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#ICE_CREAM_SANDWICH_MR1
  int get iceCreamSandwichMR1 => 15;

  /// J.
  ///
  /// Released publicly as Android 4.1 in July 2012.
  ///
  /// Constant Value: 16 (0x00000010).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#JELLY_BEAN
  int get jellyBean => 16;

  /// J MR1.
  ///
  /// Released publicly as Android 4.2 in November 2012.
  ///
  /// Constant Value: 17 (0x00000011).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#JELLY_BEAN_MR1
  int get jellyBeanMR1 => 17;

  /// J MR2.
  ///
  /// Released publicly as Android 4.3 in July 2013.
  ///
  /// Constant Value: 18 (0x00000012).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#JELLY_BEAN_MR2
  int get jellyBeanMR2 => 18;

  /// K.
  ///
  /// Released publicly as Android 4.4 in October 2013.
  ///
  /// Constant Value: 19 (0x00000013).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#KITKAT
  int get kitKat => 19;

  /// K for watches.
  ///
  /// Released publicly as Android 4.4W in June 2014.
  ///
  /// Constant Value: 20 (0x00000014).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#KITKAT_WATCH
  int get kitKatWatch => 20;

  /// L.
  ///
  /// Released publicly as Android 5.0 in November 2014.
  ///
  /// Constant Value: 21 (0x00000015).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#LOLLIPOP
  int get lollipop => 21;

  /// L MR1.
  ///
  /// Released publicly as Android 5.1 in March 2015.
  ///
  /// Constant Value: 22 (0x00000016).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#LOLLIPOP_MR1
  int get lollipopMR1 => 22;

  /// M.
  ///
  /// Released publicly as Android 6.0 in October 2015.
  ///
  /// Constant Value: 23 (0x00000017).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#M
  int get m => 23;

  /// N.
  ///
  /// Released publicly as Android 7.0 in August 2016.
  ///
  /// Constant Value: 24 (0x00000018).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#N
  int get n => 24;

  /// N MR1.
  ///
  /// Released publicly as Android 7.1 in October 2016.
  ///
  /// Constant Value: 25 (0x00000019).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#N_MR1
  int get nMR1 => 25;

  /// O.
  ///
  /// Released publicly as Android 8.0 in August 2017.
  ///
  /// Constant Value: 26 (0x0000001a).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#O
  int get o => 26;

  /// O MR1.
  ///
  /// Released publicly as Android 8.1 in December 2017.
  ///
  /// Constant Value: 27 (0x0000001b).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#O_MR1
  int get oMR1 => 27;

  /// P.
  ///
  /// Released publicly as Android 9 in August 2018.
  ///
  /// Constant Value: 28 (0x0000001c).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#P
  int get p => 28;

  /// Q.
  ///
  /// Released publicly as Android 10 in September 2019.
  ///
  /// Constant Value: 29 (0x0000001d).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#Q
  int get q => 29;

  /// R.
  ///
  /// Released publicly as Android 11 in September 2020.
  ///
  /// Constant Value: 30 (0x0000001e).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#R
  int get r => 30;

  /// S.
  ///
  /// Constant Value: 31 (0x0000001f).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#S
  int get s => 31;

  /// S V2.
  ///
  /// Once more unto the breach, dear friends, once more.
  ///
  /// Constant Value: 32 (0x00000020).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#S_V2
  int get sV2 => 32;

  /// Tiramisu.
  ///
  /// Constant Value: 33 (0x00000021).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#TIRAMISU
  int get tiramisu => 33;

  /// Upside Down Cake.
  ///
  /// Constant Value: 34 (0x00000022).
  ///
  /// See https://developer.android.com/reference/android/os/Build.VERSION_CODES#UPSIDE_DOWN_CAKE
  int get upsideDownCake => 34;
}
