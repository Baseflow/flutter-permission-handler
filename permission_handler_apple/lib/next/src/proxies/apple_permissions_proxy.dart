import 'package:flutter/services.dart';

import '../pigeon/apple_permissions.g.dart';

/// Injectable proxy wrappers for Apple permission native APIs.
///
/// Provides dependency injection for constructing Pigeon proxy objects,
/// improving testability by allowing mocks to replace native constructors.
class ApplePermissionsProxy {
  /// Constructs a [CLLocationManager] instance.
  final CLLocationManager Function() newCLLocationManager;

  /// Constructs a [CLLocationManagerDelegate] with optional callbacks.
  final CLLocationManagerDelegate Function({
    void Function(
      CLLocationManagerDelegate pigeonInstance,
      CLLocationManagerDelegate instance,
      CLLocationManager manager,
    )? locationManagerDidChangeAuthorization,
  }) newCLLocationManagerDelegate;

  /// Constructs a [CBCentralManagerDelegate] with optional callbacks.
  final CBCentralManagerDelegate Function({
    void Function(
      CBCentralManagerDelegate pigeonInstance,
      CBCentralManagerDelegate instance,
      CBCentralManager manager,
    )? centralManagerDidUpdateState,
  }) newCBCentralManagerDelegate;

  /// Constructs a [CBCentralManager] with an optional delegate.
  final CBCentralManager Function({CBCentralManagerDelegate? delegate})
      newCBCentralManager;

  /// Constructs an [EKEventStore] instance.
  final EKEventStore Function() newEKEventStore;

  /// Constructs a [CNContactStore] instance.
  final CNContactStore Function() newCNContactStore;

  /// Constructs a [CMMotionActivityManager] instance.
  final CMMotionActivityManager Function() newCMMotionActivityManager;

  /// Constructs a [CTTelephonyNetworkInfo] instance.
  final CTTelephonyNetworkInfo Function() newCTTelephonyNetworkInfo;

  /// Constructs an [NSDate] instance.
  final NSDate Function() newNSDate;

  /// Constructs a [URL] from a string.
  final URL Function({required String urlString}) newURL;

  /// Constructs a [PermissionCompileFlagsHostApi] for compile-time flag checks.
  final PermissionCompileFlagsHostApi Function({
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix,
  }) compileFlagsHostApi;

  /// Creates a proxy that delegates to the default Pigeon constructors.
  ApplePermissionsProxy({
    CLLocationManager Function()? locationManagerFactory,
    CLLocationManagerDelegate Function({
      void Function(
        CLLocationManagerDelegate pigeonInstance,
        CLLocationManagerDelegate instance,
        CLLocationManager manager,
      )? locationManagerDidChangeAuthorization,
    })? locationManagerDelegateFactory,
    CBCentralManagerDelegate Function({
      void Function(
        CBCentralManagerDelegate pigeonInstance,
        CBCentralManagerDelegate instance,
        CBCentralManager manager,
      )? centralManagerDidUpdateState,
    })? centralManagerDelegateFactory,
    CBCentralManager Function({CBCentralManagerDelegate? delegate})?
        centralManagerFactory,
    EKEventStore Function()? eventStoreFactory,
    CNContactStore Function()? contactStoreFactory,
    CMMotionActivityManager Function()? motionActivityManagerFactory,
    CTTelephonyNetworkInfo Function()? telephonyNetworkInfoFactory,
    NSDate Function()? dateFactory,
    URL Function({required String urlString})? urlFactory,
    PermissionCompileFlagsHostApi Function({
      BinaryMessenger? binaryMessenger,
      String messageChannelSuffix,
    })? compileFlagsHostApiFactory,
  })  : newCLLocationManager = locationManagerFactory ?? CLLocationManager.new,
        newCLLocationManagerDelegate =
            locationManagerDelegateFactory ?? CLLocationManagerDelegate.new,
        newCBCentralManagerDelegate =
            centralManagerDelegateFactory ?? CBCentralManagerDelegate.new,
        newCBCentralManager = centralManagerFactory ?? CBCentralManager.new,
        newEKEventStore = eventStoreFactory ?? EKEventStore.new,
        newCNContactStore = contactStoreFactory ?? CNContactStore.new,
        newCMMotionActivityManager =
            motionActivityManagerFactory ?? CMMotionActivityManager.new,
        newCTTelephonyNetworkInfo =
            telephonyNetworkInfoFactory ?? CTTelephonyNetworkInfo.new,
        newNSDate = dateFactory ?? NSDate.new,
        newURL = urlFactory ?? URL.new,
        compileFlagsHostApi =
            compileFlagsHostApiFactory ?? PermissionCompileFlagsHostApi.new;
}
