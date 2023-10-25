import 'dart:async';

import 'package:permission_handler_android/src/utils.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../permission_handler_android.dart';

/// An implementation of [PermissionHandlerPlatform] for Android.
class PermissionHandlerAndroid extends PermissionHandlerPlatform
    with AndroidActivity {
  /// The request code used when requesting permissions.
  ///
  /// This code has been randomly generated once, in the hope of avoiding
  /// collisions with other request code that are used on the native side.
  static const int _requestCode = 702764314;

  /// Constructor for creating a new instance of [PermissionHandlerAndroid].
  PermissionHandlerAndroid() {
    AndroidActivity.register();
  }

  /// Registers this class as the default instance of [PermissionHandlerPlatform].
  static void registerWith() {
    PermissionHandlerPlatform.setInstanceBuilder(
      () => PermissionHandlerAndroid(),
    );
  }

  /// TODO(jweener): handle special permissions.
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    final Iterable<PermissionStatus> statuses = await Future.wait(
      permission.manifestStrings.map(
        (String manifestString) async {
          final int grantResult = await checkSelfPermission(
            manifestString,
          );

          final PermissionStatus status = await grantResultToPermissionStatus(
            this,
            manifestString,
            grantResult,
          );

          return status;
        },
      ),
    );

    return statuses.strictest;
  }

  @override
  Future<bool> shouldShowPermissionRequestRationale(
    Permission permission,
  ) async {
    final Iterable<bool> shouldShowRationales = await Future.wait(
      permission.manifestStrings.map(
        (String manifestString) {
          return shouldShowRequestPermissionRationale(
            manifestString,
          );
        },
      ),
    );

    return shouldShowRationales.any((bool shouldShow) => shouldShow);
  }

  /// A [Completer] that bridges between the [requestPermission] method and the
  /// [onRequestPermissionsResult] method.
  ///
  /// The completer is created in [requestPermission], which returns its
  /// [Future]. [onRequestPermissionsResult] completes the completer.
  ///
  /// This allows us to make [requestPermission] return a [Future] to make the
  /// API more accessible for developers.
  Completer<PermissionStatus>? _completer;

  @override
  Future<PermissionStatus> requestPermission(Permission permission) {
    final List<String> permissions = permission.manifestStrings;
    requestPermissions(
      permissions,
      _requestCode,
    );
    _completer = Completer<PermissionStatus>();
    return _completer!.future;
  }

  @override
  void onRequestPermissionsResult(
    int requestCode,
    List<String> permissions,
    List<int> grantResults,
  ) async {
    final List<PermissionStatus> statuses = <PermissionStatus>[];

    for (int i = 0; i < permissions.length; i++) {
      final String permission = permissions[i];
      final int grantResult = grantResults[i];

      final PermissionStatus status = await grantResultToPermissionStatus(
        this,
        permission,
        grantResult,
      );

      statuses.add(status);
    }

    _completer?.complete(statuses.strictest);
  }
}
