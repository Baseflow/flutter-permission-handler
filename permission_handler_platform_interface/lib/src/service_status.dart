part of permission_handler_platform_interface;

enum ServiceStatus {
  /// The service for the permission is disabled.
  disabled,

  /// The service for the permission is enabled.
  enabled,

  /// The permission does not have an associated service on the current
  /// platform.
  notApplicable,
}

extension ServiceStatusValue on ServiceStatus {
  int get value {
    switch (this) {
      case ServiceStatus.disabled:
        return 0;
      case ServiceStatus.enabled:
        return 1;
      case ServiceStatus.notApplicable:
        return 2;
      default:
        throw UnimplementedError();
    }
  }

  static ServiceStatus statusByValue(int value) {
    return [
      ServiceStatus.disabled,
      ServiceStatus.enabled,
      ServiceStatus.notApplicable,
    ][value];
  }
}

extension ServiceStatusGetters on ServiceStatus {
  /// If the service for the permission is disabled.
  bool get isDisabled => this == ServiceStatus.disabled;

  /// If the service for the permission is enabled.
  bool get isEnabled => this == ServiceStatus.enabled;

  /// If the permission does not have an associated service on the current
  /// platform.
  bool get isNotApplicable => this == ServiceStatus.notApplicable;
}

extension FutureServiceStatusGetters on Future<ServiceStatus> {
  /// If the service for the permission is disabled.
  Future<bool> get isDisabled async => (await this).isDisabled;

  /// If the service for the permission is enabled.
  Future<bool> get isEnabled async => (await this).isEnabled;

  /// If the permission does not have an associated service on the current
  /// platform.
  Future<bool> get isNotApplicable async => (await this).isNotApplicable;
}
