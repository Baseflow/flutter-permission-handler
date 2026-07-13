import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'permissions/permission_handlers.dart';
import 'pigeon/apple_permissions.g.dart';
import 'proxies/apple_permissions_proxy.dart';

/// Orchestrates permission checks, requests, and app-settings navigation.
///
/// Replaces the legacy Obj-C [PermissionManager] with a Dart implementation
/// that delegates to [PermissionHandlers].
class PermissionManager {
  /// Creates a manager with optional injectable [proxy] and [handlers].
  PermissionManager({
    ApplePermissionsProxy? proxy,
    PermissionHandlers? handlers,
  }) : _handlers = handlers ??
            PermissionHandlers(
              proxy: proxy ?? ApplePermissionsProxy(),
              isEnabled: (permission) => (proxy ?? ApplePermissionsProxy())
                  .compileFlagsHostApi()
                  .isPermissionGroupEnabled(permission.value),
            );

  final PermissionHandlers _handlers;
  bool _requestInProgress = false;

  /// Returns the current status of [permission].
  ///
  /// Unsupported permissions return [PermissionStatus.denied].
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    if (!_handlers.supports(permission)) {
      return Future.value(PermissionStatus.denied);
    }
    return _handlers.checkPermissionStatus(permission);
  }

  /// Returns whether the service related to [permission] is enabled.
  Future<ServiceStatus> checkServiceStatus(Permission permission) {
    return _handlers.checkServiceStatus(permission);
  }

  /// Requests the given [permissions] concurrently.
  ///
  /// Throws a [PlatformException] with code
  /// `ERROR_ALREADY_REQUESTING_PERMISSIONS` when a request is already in
  /// progress.
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    if (_requestInProgress) {
      throw PlatformException(
        code: 'ERROR_ALREADY_REQUESTING_PERMISSIONS',
        message:
            'A request for permissions is already running, please wait for it '
            'to finish before doing another request (note that you can request '
            'multiple permissions at the same time).',
      );
    }

    if (permissions.isEmpty) {
      return {};
    }

    _requestInProgress = true;
    try {
      final Map<Permission, PermissionStatus> results = {};
      final Set<Permission> pending = permissions.toSet();
      final completer = Completer<void>();

      for (final permission in permissions) {
        unawaited(() async {
          try {
            results[permission] = await _handlers.requestPermission(permission);
          } on PlatformException catch (error) {
            _requestInProgress = false;
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
            return;
          } catch (error) {
            _requestInProgress = false;
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
            return;
          }

          pending.remove(permission);
          if (pending.isEmpty && !completer.isCompleted) {
            completer.complete();
          }
        }());
      }

      await completer.future;
      return results;
    } finally {
      _requestInProgress = false;
    }
  }

  /// Opens the app settings page on the device.
  Future<bool> openAppSettings() {
    return UIApplication.shared.openSettingsURL();
  }
}

/// Observes app lifecycle for location-always permission flow.
class AppLifecycleObserver with WidgetsBindingObserver {
  /// Creates an observer that calls [onResumed] when the app is resumed.
  AppLifecycleObserver(this.onResumed);

  /// Called when the app returns to the foreground.
  final VoidCallback onResumed;

  /// Starts observing lifecycle changes.
  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Stops observing lifecycle changes.
  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
