part of permission_handler_platform_interface;

/// The interface that implementations of permission_handler must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `permission_handler` does not consider newly added methods to be
/// breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform
/// implementations that `implements` this interface will be broken by newly
/// added [PermissionHandlerPlatform] methods.
abstract class PermissionHandlerPlatform extends PlatformInterface {
  /// Constructs a PermissionHandlerPlatform.
  PermissionHandlerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PermissionHandlerPlatform _instance = MethodChannelPermissionHandler();

  /// The default instance of [PermissionHandlerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPermissionHandler].
  static PermissionHandlerPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PermissionHandlerPlatform] when they register themselves.
  static set instance(PermissionHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Check current permission status.
  ///
  /// Returns a [Future] containing the current permission status for the
  /// supplied [PermissionGroup].
  Future<PermissionStatus> checkPermissionStatus(PermissionGroup permission) {
    throw UnimplementedError(
        'checkPermissionStatus() has not been implemented.');
  }

  /// Check current service status.
  ///
  /// Returns a [Future] containing the current service status for the supplied
  /// [PermissionGroup].
  ///
  /// Notes about specific PermissionGroups:
  /// - **PermissionGroup.phone**
  ///   - Android:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       1. the device lacks the TELEPHONY feature
  ///       1. TelephonyManager.getPhoneType() returns PHONE_TYPE_NONE
  ///       1. when no Intents can be resolved to handle the `tel:` scheme
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
  Future<ServiceStatus> checkServiceStatus(PermissionGroup permission) {
    throw UnimplementedError('checkServiceStatus() has not been implemented.');
  }

  /// Open the App settings page.
  ///
  /// Returns [true] if the app settings page could be opened,
  /// otherwise [false] is returned.
  Future<bool> openAppSettings() {
    throw UnimplementedError('openAppSettings() has not been implemented.');
  }

  /// Request the user for access to the supplied list of permissiongroups.
  ///
  /// Returns a [Map] containing the status per requested permissiongroup.
  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
      List<PermissionGroup> permissions) {
    throw UnimplementedError('requestPermissions() has not been implemented.');
  }

  /// Request to see if you should show a rationale for requesting permission.
  ///
  /// This method is only implemented on Android, calling this on iOS always
  /// returns [false].
  Future<bool> shouldShowRequestPermissionRationale(
      PermissionGroup permission) {
    throw UnimplementedError(
        'shouldShowRequestPermissionRationale() has not been implemented.');
  }
}
