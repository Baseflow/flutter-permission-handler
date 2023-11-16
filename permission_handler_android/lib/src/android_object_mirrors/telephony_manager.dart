import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';
import 'package:permission_handler_android/src/android_permission_handler_api_impls.dart';

/// Provides access to information about the telephony services on the device.
///
/// Applications can use the methods in this class to determine telephony
/// services and states, as well as to access some types of subscriber
/// information. Applications can also register a listener to receive
/// notification of telephony state changes.
///
/// TelephonyManager is intended for use on devices that implement
/// [PackageManage.featureTelephony]. On devices that do not implement this
/// feature, the behavior is not reliable.
///
/// Requires the [PackageManager.featureTelephony] feature which can be detected
/// using [PackageManager.hasSystemFeature].
class TelephonyManager extends JavaObject {
  /// Instantiates a [TelephonyManager] without creating and attaching to an
  /// instance of the associated native class.
  TelephonyManager.detached({
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  })  : _hostApi = TelephonyManagerHostApiImpl(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        super.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        );

  final TelephonyManagerHostApiImpl _hostApi;

  /// Phone radio is CDMA.
  ///
  /// Constant Value: 2 (0x00000002).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#PHONE_TYPE_CDMA.
  static const int phoneTypeCdma = 2;

  /// Phone radio is GSM.
  ///
  /// Constant Value: 1 (0x00000001).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#PHONE_TYPE_GSM.
  static const int phoneTypeGsm = 1;

  /// No phone radio.
  ///
  /// Constant Value: 0 (0x00000000).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#PHONE_TYPE_NONE.
  static const int phoneTypeNone = 0;

  /// Phone radio is SIP.
  ///
  /// Constant Value: 3 (0x00000003).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#PHONE_TYPE_SIP.
  static const int phoneTypeSip = 3;

  /// SIM card state: no SIM card is available in the device.
  ///
  /// Constant Value: 1 (0x00000001).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_ABSENT.
  static const int simStateAbsent = 1;

  /// SIM card state: SIM Card Error, present but faulty.
  ///
  /// Constant Value: 8 (0x00000008).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_CARD_IO_ERROR.
  static const int simStateCardIoError = 8;

  /// SIM card state: SIM Card restricted, present but not usable due to carrier restrictions.
  ///
  /// Constant Value: 7 (0x00000007).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_CARD_RESTRICTED.
  static const int simStateCardRestricted = 7;

  /// SIM card state: Locked: requires a network PIN to unlock.
  ///
  /// Constant Value: 4 (0x00000004).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_NETWORK_LOCKED.
  static const int simStateNetworkLocked = 4;

  /// SIM card state: SIM Card is NOT READY.
  ///
  /// Constant Value: 6 (0x00000006).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_NOT_READY.
  static const int simStateNotReady = 6;

  /// SIM card state: SIM Card Error, permanently disabled.
  ///
  /// Constant Value: 9 (0x00000009).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_PERM_DISABLED.
  static const int simStatePermDisabled = 9;

  /// SIM card state: Locked: requires the user's SIM PIN to unlock.
  ///
  /// Constant Value: 2 (0x00000002).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_PIN_REQUIRED.
  static const int simStatePinRequired = 2;

  /// SIM card state: Locked: requires the user's SIM PUK to unlock.
  ///
  /// Constant Value: 3 (0x00000003).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_PUK_REQUIRED.
  static const int simStatePukRequired = 3;

  /// SIM card state: Ready.
  ///
  /// Constant Value: 5 (0x00000005).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_READY.
  static const int simStateReady = 5;

  /// SIM card state: Unknown.
  ///
  /// Constant Value: 0 (0x00000000).
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#SIM_STATE_UNKNOWN.
  static const int simStateUnknown = 0;

  /// Returns a constant indicating the device phone type. This indicates the type of radio used to transmit voice calls.
  ///
  /// Requires the [PackageManager.featureTelephony] feature which can be
  /// detected using [PackageManager.hasSystemFeature].
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#getPhoneType().
  Future<int> getPhoneType() {
    return _hostApi.getPhoneTypeFromInstance(this);
  }

  /// Returns a constant indicating the state of the default SIM card.
  ///
  /// Requires the [PackageManager.featureTelephonySubscription] feature which
  /// can be detected using [PackageManager.hasSystemFeature].
  ///
  /// See https://developer.android.com/reference/android/telephony/TelephonyManager#getSimState(int).
  Future<int> getSimState() {
    return _hostApi.getSimeStateFromInstance(this);
  }
}
