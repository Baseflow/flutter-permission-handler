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

  static PermissionHandlerPlatform? _instance;

  /// The instance of [PermissionHandlerPlatform] to use.
  ///
  /// Returns the instance, if it has been created, or a newly created instance
  /// through the builder provided in [setInstanceBuilder]. Throws an
  /// [Exception] if there is no instance, and [setInstanceBuilder] has not been
  /// called.
  static PermissionHandlerPlatform get instance {
    if (_instance == null) {
      if (_instanceBuilder == null) {
        throw Exception(
            'No instance builder was provided. Did you call `setInstanceBuilder`?');
      }

      _instance = _instanceBuilder!();
      PlatformInterface.verifyToken(_instance!, _token);
    }

    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PermissionHandlerPlatform] when they register
  /// themselves.
  @Deprecated('Use [setPlatformInstanceBuilder] instead.')
  static set instance(PermissionHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static PermissionHandlerPlatform Function()? _instanceBuilder;

  /// Sets the builder function that creates a new instance of the
  /// platform-specific implementation of [PermissionHandlerPlatform].
  ///
  /// This function allows for delayed initialisation of the handler. This is
  /// especially useful in the plugin environment, where the handler is
  /// registered early during start-up. As platform channels are not established
  /// at that point, the implementation cannot directly be created.
  static void setInstanceBuilder(
    PermissionHandlerPlatform Function() builder,
  ) {
    _instanceBuilder = builder;
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
