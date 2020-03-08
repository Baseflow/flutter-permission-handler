import 'dart:io';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

export 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    show Permission, PermissionStatus, ServiceStatus;

PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

/// Opens the app settings page.
///
/// Returns [true] if the app settings page could be opened, otherwise [false].
Future<bool> openAppSettings() => _handler.openAppSettings();

/// Actions that can be executed on a permission.
extension PermissionActions on Permission {
  /// The current status of this permission.
  Future<PermissionStatus> get status => _handler.checkPermissionStatus(this);

  /// If you should show a rationale for requesting permission.
  ///
  /// This is only implemented on Android, calling this on iOS always returns
  /// [false].
  Future<bool> get shouldShowRequestRationale {
    if (!Platform.isAndroid) {
      return Future.value(false);
    }

    return _handler.shouldShowRequestPermissionRationale(this);
  }

  /// Request the user for access to this permission.
  ///
  /// Returns the new [PermissionStatus].
  Future<PermissionStatus> request() async {
    return (await [this].request())[this];
  }

  /// Request the user for access to this permission if it [isDenied].
  ///
  /// Returns the new [PermissionStatus].
  Future<PermissionStatus> requestIfDenied() async {
    final status = await this.status;

    if (status.isDenied) {
      return request();
    }
    return status;
  }
}

/// Shortcuts for checking the [status] of a permission.
extension PermissionCheckShortcuts on Permission {
  /// If the user denied access to the requested feature.
  Future<bool> get isDenied => status.isDenied;

  /// If the user granted access to the requested feature.
  Future<bool> get isGranted => status.isGranted;

  /// If the OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  Future<bool> get isRestricted => status.isRestricted;

  /// If the permission is in an unknown state.
  Future<bool> get isUnknown => status.isUnknown;

  /// If the user denied access to the requested feature and selected to never
  /// again show a request for this permission.
  /// *Only supported on Android.*
  Future<bool> get isNeverAskedAgain => status.isNeverAskAgain;
}

/// Actions that apply only to permissions that have an associated service.
extension ServicePermissionActions on ServicePermission {
  /// The current status of the service associated with this permission.
  ///
  /// Notes about specific permissions:
  /// - **[Permission.phone]**
  ///   - Android:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       1. the device lacks the TELEPHONY feature
  ///       2. TelephonyManager.getPhoneType() returns PHONE_TYPE_NONE
  ///       3. when no Intents can be resolved to handle the `tel:` scheme
  ///     - The method will return [ServiceStatus.disabled] when:
  ///       1. the SIM card is missing
  ///   - iOS:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       1. the native code can not find a handler for the `tel:` scheme
  ///     - The method will return [ServiceStatus.disabled] when:
  ///       1. the mobile network code (MNC) is either 0 or 65535. See
  ///          https://stackoverflow.com/a/11595365 for details
  ///   - **PLEASE NOTE that this is still not a perfect indication** of the
  ///     devices' capability to place & connect phone calls
  ///     as it also depends on the network condition.
  Future<ServiceStatus> get serviceStatus => _handler.checkServiceStatus(this);
}

/// Actions that can be taken on a [List] of [Permission]s.
extension PermissionListActions on List<Permission> {
  /// Request the user for access to this list of permissions.
  ///
  /// Returns a [Map] containing the [PermissionStatus] per requested
  /// [Permission].
  Future<Map<Permission, PermissionStatus>> request() {
    return _handler.requestPermissions(this);
  }
}
