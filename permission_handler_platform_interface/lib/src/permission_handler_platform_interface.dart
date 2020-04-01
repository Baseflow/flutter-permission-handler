part of permission_handler_platform_interface;

/// The interface that implementations of `permission_handler` must implement.
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

  /// Platform-specific plugins should set this with their own
  /// platform-specific class that extends
  /// [PermissionHandlerPlatform] when they register themselves.
  static set instance(PermissionHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks the current status of the given [Permission].
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    throw UnimplementedError(
        'checkPermissionStatus() has not been implemented.');
  }

  /// Checks the current status of the service associated with the given
  /// [Permission].
  ///
  /// Notes about specific permissions:
  /// - **[Permission.phone]**
  ///   - Android:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       - the device lacks the TELEPHONY feature
  ///       - TelephonyManager.getPhoneType() returns PHONE_TYPE_NONE
  ///       - when no Intents can be resolved to handle the `tel:` scheme
  ///     - The method will return [ServiceStatus.disabled] when:
  ///       - the SIM card is missing
  ///   - iOS:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       - the native code can not find a handler for the `tel:` scheme
  ///     - The method will return [ServiceStatus.disabled] when:
  ///       - the mobile network code (MNC) is either 0 or 65535. See
  ///          https://stackoverflow.com/a/11595365 for details
  ///   - **PLEASE NOTE that this is still not a perfect indication** of the
  ///     device's capability to place & connect phone calls as it also depends
  ///     on the network condition.
  Future<ServiceStatus> checkServiceStatus(Permission permission) {
    throw UnimplementedError('checkServiceStatus() has not been implemented.');
  }

  /// Opens the app settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise
  /// [false].
  Future<bool> openAppSettings() {
    throw UnimplementedError('openAppSettings() has not been implemented.');
  }

  /// Requests the user for access to the supplied list of [Permission]s, if
  /// they have not already been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    throw UnimplementedError('requestPermissions() has not been implemented.');
  }

  /// Checks if you should show a rationale for requesting permission.
  ///
  /// This method is only implemented on Android, calling this on iOS always
  /// returns [false].
  Future<bool> shouldShowRequestPermissionRationale(Permission permission) {
    throw UnimplementedError(
        'shouldShowRequestPermissionRationale() has not been implemented.');
  }
}
