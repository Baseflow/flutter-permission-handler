import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../permission_manager.dart';
import '../permission_status_mapper.dart';
import '../pigeon/apple_permissions.g.dart';
import '../proxies/apple_permissions_proxy.dart';

/// Callback that reports whether a [Permission] is enabled at compile time.
typedef IsPermissionEnabled = Future<bool> Function(Permission permission);

/// Permission check, request, and service-status logic for Apple platforms.
///
/// Each [Permission] maps to the appropriate Apple framework API via Pigeon
/// proxy classes.
class PermissionHandlers {
  /// Creates handlers with injectable [proxy] and compile-time [isEnabled] gate.
  PermissionHandlers({
    required ApplePermissionsProxy proxy,
    required IsPermissionEnabled isEnabled,
  })  : _proxy = proxy,
        _isEnabled = isEnabled;

  final ApplePermissionsProxy _proxy;
  final IsPermissionEnabled _isEnabled;

  static const _locationRequestedKey =
      'org.baseflow.permission_handler_apple.permission_requested';

  /// Whether [permission] is supported on Apple platforms.
  bool supports(Permission permission) {
    switch (permission) {
      case Permission.calendarWriteOnly:
      case Permission.calendarFullAccess:
      case Permission.camera:
      case Permission.contacts:
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
      case Permission.mediaLibrary:
      case Permission.microphone:
      case Permission.phone:
      case Permission.photos:
      case Permission.photosAddOnly:
      case Permission.reminders:
      case Permission.sensors:
      case Permission.speech:
      case Permission.storage:
      case Permission.notification:
      case Permission.bluetooth:
      case Permission.appTrackingTransparency:
      case Permission.criticalAlerts:
      case Permission.assistant:
      case Permission.backgroundRefresh:
        return true;
      default:
        return false;
    }
  }

  /// Returns the current status of [permission].
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    if (!await _isEnabled(permission)) {
      return PermissionStatus.denied;
    }

    switch (permission) {
      case Permission.calendarWriteOnly:
      case Permission.calendarFullAccess:
        return _checkEventPermission(permission);
      case Permission.camera:
        return mapAVAuthorizationStatus(
          await AVCaptureDevice.authorizationStatusForMediaType(
              AVMediaType.video),
        );
      case Permission.microphone:
        return mapAVAuthorizationStatus(
          await AVCaptureDevice.authorizationStatusForMediaType(
              AVMediaType.audio),
        );
      case Permission.contacts:
        return mapCNAuthorizationStatus(
          await CNContactStore.authorizationStatusForEntityType(
            CNEntityType.contacts,
          ),
        );
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return mapCLAuthorizationStatus(
          await CLLocationManager.authorizationStatus(),
          isAlwaysRequest: permission == Permission.locationAlways,
        );
      case Permission.mediaLibrary:
        return mapMPMediaAuthorizationStatus(
          await MPMediaLibrary.authorizationStatus(),
        );
      case Permission.phone:
        return PermissionStatus.denied;
      case Permission.photos:
        return _checkPhotoPermission(addOnly: false);
      case Permission.photosAddOnly:
        return _checkPhotoPermission(addOnly: true);
      case Permission.reminders:
        return mapEKAuthorizationStatus(
          await EKEventStore.authorizationStatusForEntityType(
            EKEntityType.reminder,
          ),
          isWriteOnlyRequest: false,
        );
      case Permission.sensors:
        return mapCMAuthorizationStatus(
          await CMMotionActivityManager.authorizationStatus(),
        );
      case Permission.speech:
        return mapSFSpeechAuthorizationStatus(
          await SFSpeechRecognizer.authorizationStatus(),
        );
      case Permission.storage:
        return PermissionStatus.granted;
      case Permission.notification:
        return _checkNotificationPermission();
      case Permission.bluetooth:
        return _checkBluetoothPermission();
      case Permission.appTrackingTransparency:
        return mapATTAuthorizationStatus(
          await ATTrackingManager.trackingAuthorizationStatus(),
        );
      case Permission.criticalAlerts:
        return _checkCriticalAlertsPermission();
      case Permission.assistant:
        return mapINSiriAuthorizationStatus(
          await INPreferences.siriAuthorizationStatus(),
        );
      case Permission.backgroundRefresh:
        return mapUIBackgroundRefreshStatus(
          await UIApplication.shared.getBackgroundRefreshStatus(),
        );
      default:
        return PermissionStatus.denied;
    }
  }

  /// Returns whether the service related to [permission] is enabled.
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    switch (permission) {
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        final enabled = await CLLocationManager.locationServicesEnabled();
        return enabled ? ServiceStatus.enabled : ServiceStatus.disabled;
      case Permission.bluetooth:
        return _checkBluetoothServiceStatus();
      case Permission.sensors:
        final available = await CMMotionActivityManager.isActivityAvailable();
        return available ? ServiceStatus.enabled : ServiceStatus.disabled;
      case Permission.phone:
        return _checkPhoneServiceStatus();
      default:
        return ServiceStatus.notApplicable;
    }
  }

  /// Requests [permission] and returns the resulting status.
  Future<PermissionStatus> requestPermission(Permission permission) async {
    if (!await _isEnabled(permission)) {
      return PermissionStatus.denied;
    }

    final status = await checkPermissionStatus(permission);
    if (status != PermissionStatus.denied) {
      return status;
    }

    switch (permission) {
      case Permission.calendarWriteOnly:
      case Permission.calendarFullAccess:
        return _requestEventPermission(permission);
      case Permission.camera:
        return _requestAVPermission(AVMediaType.video);
      case Permission.microphone:
        return _requestAVPermission(AVMediaType.audio);
      case Permission.contacts:
        return _requestContactsPermission();
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return _requestLocationPermission(permission);
      case Permission.mediaLibrary:
        return mapMPMediaAuthorizationStatus(
          await MPMediaLibrary.requestAuthorization(),
        );
      case Permission.phone:
        return PermissionStatus.permanentlyDenied;
      case Permission.photos:
        return _requestPhotoPermission(addOnly: false);
      case Permission.photosAddOnly:
        return _requestPhotoPermission(addOnly: true);
      case Permission.reminders:
        return _requestRemindersPermission();
      case Permission.sensors:
        return _requestSensorsPermission();
      case Permission.speech:
        return mapSFSpeechAuthorizationStatus(
          await SFSpeechRecognizer.requestAuthorization(),
        );
      case Permission.storage:
        return PermissionStatus.granted;
      case Permission.notification:
        return _requestNotificationPermission();
      case Permission.bluetooth:
        return _requestBluetoothPermission();
      case Permission.appTrackingTransparency:
        return mapATTAuthorizationStatus(
          await ATTrackingManager.requestTrackingAuthorization(),
        );
      case Permission.criticalAlerts:
        return _requestCriticalAlertsPermission();
      case Permission.assistant:
        return mapINSiriAuthorizationStatus(
          await INPreferences.requestSiriAuthorization(),
        );
      case Permission.backgroundRefresh:
        return checkPermissionStatus(permission);
      default:
        return PermissionStatus.denied;
    }
  }

  Future<PermissionStatus> _checkEventPermission(Permission permission) {
    final entityType = permission == Permission.reminders
        ? EKEntityType.reminder
        : EKEntityType.event;
    return EKEventStore.authorizationStatusForEntityType(entityType).then(
      (status) => mapEKAuthorizationStatus(
        status,
        isWriteOnlyRequest: permission == Permission.calendarWriteOnly,
      ),
    );
  }

  Future<PermissionStatus> _requestEventPermission(
      Permission permission) async {
    final store = _proxy.newEKEventStore();
    bool granted;
    // Permission.calendar (value 0) is deprecated; treat it like full access.
    if (permission == Permission.calendarFullAccess || permission.value == 0) {
      granted = await store.requestFullAccessToEvents();
    } else if (permission == Permission.calendarWriteOnly) {
      granted = await store.requestWriteOnlyAccessToEvents();
    } else {
      granted = await store.requestFullAccessToReminders();
    }
    return granted
        ? PermissionStatus.granted
        : PermissionStatus.permanentlyDenied;
  }

  Future<PermissionStatus> _requestRemindersPermission() async {
    final granted =
        await _proxy.newEKEventStore().requestFullAccessToReminders();
    return granted
        ? PermissionStatus.granted
        : PermissionStatus.permanentlyDenied;
  }

  Future<PermissionStatus> _requestAVPermission(AVMediaType mediaType) async {
    final granted = await AVCaptureDevice.requestAccessForMediaType(mediaType);
    return granted
        ? PermissionStatus.granted
        : PermissionStatus.permanentlyDenied;
  }

  Future<PermissionStatus> _requestContactsPermission() async {
    final granted = await _proxy
        .newCNContactStore()
        .requestAccessForEntityType(CNEntityType.contacts);
    if (!granted) {
      return PermissionStatus.permanentlyDenied;
    }
    return checkPermissionStatus(Permission.contacts);
  }

  Future<PermissionStatus> _checkPhotoPermission(
      {required bool addOnly}) async {
    try {
      final status = await PHPhotoLibrary.authorizationStatusForAccessLevel(
        addOnly ? PHAccessLevel.addOnly : PHAccessLevel.readWrite,
      );
      return mapPHAuthorizationStatus(status);
    } catch (_) {
      final status = await PHPhotoLibrary.authorizationStatus();
      return mapPHAuthorizationStatus(status);
    }
  }

  Future<PermissionStatus> _requestPhotoPermission(
      {required bool addOnly}) async {
    try {
      final status = await PHPhotoLibrary.requestAuthorizationForAccessLevel(
        addOnly ? PHAccessLevel.addOnly : PHAccessLevel.readWrite,
      );
      return mapPHAuthorizationStatus(status);
    } catch (_) {
      final status = await PHPhotoLibrary.requestAuthorization();
      return mapPHAuthorizationStatus(status);
    }
  }

  Future<PermissionStatus> _checkNotificationPermission() async {
    final settings =
        await UNUserNotificationCenter.current.getNotificationSettings();
    return mapUNAuthorizationStatus(await settings.getAuthorizationStatus());
  }

  Future<PermissionStatus> _requestNotificationPermission() async {
    final granted = await UNUserNotificationCenter.current.requestAuthorization(
      <UNAuthorizationOption>[
        UNAuthorizationOption.sound,
        UNAuthorizationOption.alert,
        UNAuthorizationOption.badge,
      ],
    );
    if (!granted) {
      return PermissionStatus.permanentlyDenied;
    }
    UIApplication.shared.registerForRemoteNotifications();
    return PermissionStatus.granted;
  }

  Future<PermissionStatus> _checkCriticalAlertsPermission() async {
    final settings =
        await UNUserNotificationCenter.current.getNotificationSettings();
    return mapUNAuthorizationStatus(await settings.getCriticalAlertSetting());
  }

  Future<PermissionStatus> _requestCriticalAlertsPermission() async {
    final granted = await UNUserNotificationCenter.current.requestAuthorization(
      <UNAuthorizationOption>[UNAuthorizationOption.criticalAlert],
    );
    if (!granted) {
      return PermissionStatus.permanentlyDenied;
    }
    UIApplication.shared.registerForRemoteNotifications();
    return PermissionStatus.granted;
  }

  Future<PermissionStatus> _checkBluetoothPermission() async {
    final auth = await CBCentralManager.authorization();
    if (auth == CBManagerAuthorization.notDetermined) {
      return PermissionStatus.denied;
    }
    return mapCBManagerAuthorization(auth);
  }

  Future<PermissionStatus> _requestBluetoothPermission() async {
    final completer = Completer<PermissionStatus>();
    final delegate = _proxy.newCBCentralManagerDelegate(
      centralManagerDidUpdateState: (pigeonInstance, instance, manager) async {
        final auth = await CBCentralManager.authorization();
        if (!completer.isCompleted) {
          completer.complete(mapCBManagerAuthorization(auth));
        }
      },
    );
    _proxy.newCBCentralManager(delegate: delegate);
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => _checkBluetoothPermission(),
    );
  }

  Future<ServiceStatus> _checkBluetoothServiceStatus() async {
    final completer = Completer<ServiceStatus>();
    final delegate = _proxy.newCBCentralManagerDelegate(
      centralManagerDidUpdateState: (pigeonInstance, instance, manager) async {
        if (!completer.isCompleted) {
          final state = await manager.getState();
          final enabled = state == CBManagerState.poweredOn;
          completer.complete(
            enabled ? ServiceStatus.enabled : ServiceStatus.disabled,
          );
        }
      },
    );
    _proxy.newCBCentralManager(delegate: delegate);
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => ServiceStatus.disabled,
    );
  }

  Future<PermissionStatus> _requestSensorsPermission() async {
    final manager = _proxy.newCMMotionActivityManager();
    final today = _proxy.newNSDate();
    await manager.queryActivityStartingFromDate(today, today);
    return checkPermissionStatus(Permission.sensors);
  }

  Future<PermissionStatus> _requestLocationPermission(
    Permission permission,
  ) async {
    final bundle = NSBundle.mainBundle;
    final manager = _proxy.newCLLocationManager();
    final completer = Completer<PermissionStatus>();
    var previousWasNotDetermined = false;
    AppLifecycleObserver? lifecycleObserver;

    void complete(PermissionStatus result) {
      lifecycleObserver?.stop();
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }

    Future<void> validatePlistKeys() async {
      final whenInUse = await bundle.objectForInfoDictionaryKey(
        'NSLocationWhenInUseUsageDescription',
      );
      final always = await bundle.objectForInfoDictionaryKey(
            'NSLocationAlwaysAndWhenInUseUsageDescription',
          ) ??
          await bundle
              .objectForInfoDictionaryKey('NSLocationAlwaysUsageDescription');

      if (permission == Permission.locationAlways) {
        final current = await CLLocationManager.authorizationStatus();
        if (current == CLAuthorizationStatus.notDetermined) {
          throw PlatformException(
            code: 'MISSING_WHENINUSE_PERMISSION',
            message:
                'Must have "When in use" permission before it is allowed to request "Always" permission.',
          );
        }
        if (always == null) {
          throw PlatformException(
            code: 'MISSING_USAGE_DESCRIPTION',
            message:
                'To always use location from iOS8 you need to define at least NSLocationWhenInUseUsageDescription and optionally NSLocationAlwaysAndWhenInUseUsageDescription in the app bundle\'s Info.plist file',
          );
        }
      } else if (whenInUse == null) {
        throw PlatformException(
          code: 'MISSING_USAGE_DESCRIPTION',
          message:
              'To use location from iOS8 you need to define at least NSLocationWhenInUseUsageDescription and optionally NSLocationAlwaysAndWhenInUseUsageDescription in the app bundle\'s Info.plist file',
        );
      }
    }

    await validatePlistKeys();

    if (permission == Permission.locationAlways) {
      final current = await CLLocationManager.authorizationStatus();
      if (current == CLAuthorizationStatus.authorizedWhenInUse) {
        final alreadyRequested = await NSUserDefaults.standardUserDefaults
            .boolForKey(_locationRequestedKey);
        if (alreadyRequested) {
          return checkPermissionStatus(permission);
        }
      }
    }

    final delegate = _proxy.newCLLocationManagerDelegate(
      locationManagerDidChangeAuthorization:
          (pigeonInstance, instance, locManager) async {
        final status = await locManager.getAuthorizationStatus();
        if (status == CLAuthorizationStatus.notDetermined) {
          if (previousWasNotDetermined) {
            complete(PermissionStatus.denied);
          }
          previousWasNotDetermined = true;
          return;
        }
        previousWasNotDetermined = false;

        if (permission == Permission.locationAlways &&
            status == CLAuthorizationStatus.authorizedWhenInUse) {
          complete(PermissionStatus.denied);
          return;
        }

        complete(
          mapCLAuthorizationStatus(
            status,
            isAlwaysRequest: permission == Permission.locationAlways,
          ),
        );
      },
    );

    await manager.setDelegate(delegate);

    if (permission == Permission.location) {
      final hasAlways = await bundle.objectForInfoDictionaryKey(
                'NSLocationAlwaysUsageDescription',
              ) !=
              null ||
          await bundle.objectForInfoDictionaryKey(
                'NSLocationAlwaysAndWhenInUseUsageDescription',
              ) !=
              null;
      final current = await CLLocationManager.authorizationStatus();
      if (hasAlways && current == CLAuthorizationStatus.authorizedWhenInUse) {
        await manager.requestAlwaysAuthorization();
      } else {
        await manager.requestWhenInUseAuthorization();
      }
    } else if (permission == Permission.locationAlways) {
      lifecycleObserver = AppLifecycleObserver(() async {
        final status = await CLLocationManager.authorizationStatus();
        if (status != CLAuthorizationStatus.authorizedAlways) {
          complete(await checkPermissionStatus(permission));
        }
      })
        ..start();
      await manager.requestAlwaysAuthorization();
      await NSUserDefaults.standardUserDefaults.setBool(
        true,
        _locationRequestedKey,
      );
    } else {
      await manager.requestWhenInUseAuthorization();
    }

    return completer.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => checkPermissionStatus(permission),
    );
  }

  Future<ServiceStatus> _checkPhoneServiceStatus() async {
    final canOpen = await UIApplication.shared.canOpenURL(
      _proxy.newURL(urlString: 'tel://'),
    );
    if (!canOpen) {
      return ServiceStatus.notApplicable;
    }

    final info = _proxy.newCTTelephonyNetworkInfo();
    if (await _canPlacePhoneCall(info)) {
      return ServiceStatus.enabled;
    }
    return ServiceStatus.disabled;
  }

  Future<bool> _canPlacePhoneCall(CTTelephonyNetworkInfo info) async {
    final providers = await info.getServiceSubscriberCellularProviders();
    if (providers != null) {
      for (final carrier in providers.values) {
        if (carrier != null && await _carrierCanPlaceCall(carrier)) {
          return true;
        }
      }
      return false;
    }

    final carrier = await info.getSubscriberCellularProvider();
    return carrier != null && await _carrierCanPlaceCall(carrier);
  }

  Future<bool> _carrierCanPlaceCall(CTCarrier carrier) async {
    final code = await carrier.getMobileNetworkCode();
    if (code == null || code.isEmpty || code == '65535') {
      return false;
    }
    return true;
  }
}
