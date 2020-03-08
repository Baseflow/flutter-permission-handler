part of permission_handler_platform_interface;

enum ServiceStatus {
  /// The service for the permission is disabled.
  disabled,

  /// The service for the permission is enabled.
  enabled,

  /// The permission does not have an associated service.
  notApplicable,

  /// The state of the service could not be determined.
  unknown,
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
      case ServiceStatus.unknown:
        return 3;
      default:
        throw UnimplementedError();
    }
  }

  static ServiceStatus statusByValue(int value) {
    return [
      ServiceStatus.disabled,
      ServiceStatus.enabled,
      ServiceStatus.notApplicable,
      ServiceStatus.unknown,
    ][value];
  }
}

extension ServiceStatusGetters on ServiceStatus {
  /// If the service for the permission is disabled.
  bool get isDisabled => this == ServiceStatus.disabled;

  /// If the service for the permission is enabled.
  bool get isEnabled => this == ServiceStatus.enabled;

  /// If the permission does not have an associated service.
  bool get isNotApplicable => this == ServiceStatus.notApplicable;

  /// If the state of the service could not be determined.
  bool get isUnknown => this == ServiceStatus.unknown;
}

extension FutureServiceStatusGetters on Future<ServiceStatus> {
  /// If the service for the permission is disabled.
  Future<bool> get isDisabled async => (await this).isDisabled;

  /// If the service for the permission is enabled.
  Future<bool> get isEnabled async => (await this).isEnabled;

  /// If the permission does not have an associated service.
  Future<bool> get isNotApplicable async => (await this).isNotApplicable;

  /// If the state of the service could not be determined.
  Future<bool> get isUnknown async => (await this).isUnknown;
}
