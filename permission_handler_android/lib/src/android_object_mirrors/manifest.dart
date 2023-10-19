/// See https://developer.android.com/reference/android/Manifest.
class Manifest {
  const Manifest._();

  /// Provides access to all permission strings known to Android.
  static _ManifestPermission get permission => _permission;
  static const _ManifestPermission _permission = _ManifestPermission();

  /// Provides access to all permission group strings known to Android.
  static _ManifestPermissionGroup get permissionGroup => _permissionGroup;
  static const _ManifestPermissionGroup _permissionGroup =
      _ManifestPermissionGroup();
}

/// See https://developer.android.com/reference/android/Manifest.permission.
class _ManifestPermission {
  const _ManifestPermission();

  /// Allows a calling app to continue a call which was started in another app. An example is a video calling app that wants to continue a voice call on the user's mobile network.
  ///
  /// When the handover of a call from one app to another takes place, there are two devices which are involved in the handover; the initiating and receiving devices. The initiating device is where the request to handover the call was started, and the receiving device is where the handover request is confirmed by the other party.
  ///
  /// This permission protects access to the TelecomManager.acceptHandover(Uri, int, PhoneAccountHandle) which the receiving side of the handover uses to accept a handover.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.ACCEPT_HANDOVER"
  final String acceptHandover = 'android.permission.ACCEPT_HANDOVER';

  /// Allows an app to access location in the background. If you're requesting this permission, you must also request either ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION. Requesting this permission by itself doesn't give you location access.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.ACCESS_BACKGROUND_LOCATION"
  final String accessBackgroundLocation =
      'android.permission.ACCESS_BACKGROUND_LOCATION';

  /// Allows an application to access data blobs across users.
  ///
  /// Constant Value: "android.permission.ACCESS_BLOBS_ACROSS_USERS"
  final String accessBlobsAcrossUsers =
      'android.permission.ACCESS_BLOBS_ACROSS_USERS';

  /// Allows read/write access to the "properties" table in the checkin database, to change values that get uploaded.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.ACCESS_CHECKIN_PROPERTIES"
  final String accessCheckinProperties =
      'android.permission.ACCESS_CHECKIN_PROPERTIES';

  /// Allows an app to access approximate location. Alternatively, you might want ACCESS_FINE_LOCATION.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.ACCESS_COARSE_LOCATION"
  final String accessCoarseLocation =
      'android.permission.ACCESS_COARSE_LOCATION';

  /// Allows an app to access precise location. Alternatively, you might want ACCESS_COARSE_LOCATION.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.ACCESS_FINE_LOCATION"
  final String accessFineLocation = 'android.permission.ACCESS_FINE_LOCATION';

  /// Allows an application to access extra location provider commands.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"
  final String accessLocationExtraCommands =
      'android.permission.ACCESS_LOCATION_EXTRA_COMMANDS';

  /// Allows an application to access any geographic locations persisted in the user's shared collection.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.ACCESS_MEDIA_LOCATION"
  final String accessMediaLocation = 'android.permission.ACCESS_MEDIA_LOCATION';

  /// Allows applications to access information about networks.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.ACCESS_NETWORK_STATE"
  final String accessNetworkState = 'android.permission.ACCESS_NETWORK_STATE';

  /// Marker permission for applications that wish to access notification policy. This permission is not supported on managed profiles.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.ACCESS_NOTIFICATION_POLICY"
  final String accessNotificationPolicy =
      'android.permission.ACCESS_NOTIFICATION_POLICY';

  /// Allows applications to access information about Wi-Fi networks.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.ACCESS_WIFI_STATE"
  final String accessWifiState = 'android.permission.ACCESS_WIFI_STATE';

  /// Allows applications to call into AccountAuthenticators.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.ACCOUNT_MANAGER"
  final String accountManager = 'android.permission.ACCOUNT_MANAGER';

  /// Allows an application to recognize physical activity.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.ACTIVITY_RECOGNITION"
  final String activityRecognition = 'android.permission.ACTIVITY_RECOGNITION';

  /// Allows an application to add voicemails into the system.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "com.android.voicemail.permission.ADD_VOICEMAIL"
  final String addVoicemail = 'com.android.voicemail.permission.ADD_VOICEMAIL';

  /// Allows the app to answer an incoming phone call.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.ANSWER_PHONE_CALLS"
  final String answerPhoneCalls = 'android.permission.ANSWER_PHONE_CALLS';

  /// Allows an application to collect battery statistics
  ///
  /// Protection level: signature|privileged|development
  ///
  /// Constant Value: "android.permission.BATTERY_STATS"
  final String batteryStats = 'android.permission.BATTERY_STATS';

  /// Must be required by an AccessibilityService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_ACCESSIBILITY_SERVICE"
  final String bindAccessibilityService =
      'android.permission.BIND_ACCESSIBILITY_SERVICE';

  /// Allows an application to tell the AppWidget service which application can access AppWidget's data. The normal user flow is that a user picks an AppWidget to go into a particular host, thereby giving that host application access to the private data from the AppWidget app. An application that has this permission should honor that contract.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.BIND_APPWIDGET"
  final String bindAppwidget = 'android.permission.BIND_APPWIDGET';

  /// Must be required by a AutofillService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_AUTOFILL_SERVICE"
  final String bindAutofillService = 'android.permission.BIND_AUTOFILL_SERVICE';

  /// Must be required by a CallRedirectionService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_CALL_REDIRECTION_SERVICE"
  final String bindCallRedirectionService =
      'android.permission.BIND_CALL_REDIRECTION_SERVICE';

  /// A subclass of CarrierMessagingClientService must be protected with this permission.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_CARRIER_MESSAGING_CLIENT_SERVICE"
  final String bindCarrierMessagingClientService =
      'android.permission.BIND_CARRIER_MESSAGING_CLIENT_SERVICE';

  /// Constant Value: "android.permission.BIND_CARRIER_MESSAGING_SERVICE"
  @Deprecated(
      'This constant was deprecated in API level 23. Use BIND_CARRIER_SERVICES instead.')
  final String bindCarrierMessagingService =
      'android.permission.BIND_CARRIER_MESSAGING_SERVICE';

  /// The system process that is allowed to bind to services in carrier apps will have this permission. Carrier apps should use this permission to protect their services that only the system is allowed to bind to.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_CARRIER_SERVICES"
  final String bindCarrierServices = 'android.permission.BIND_CARRIER_SERVICES';

  /// Must be required by a ChooserTargetService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_CHOOSER_TARGET_SERVICE"
  @Deprecated(
      'This constant was deprecated in API level 30. For publishing direct share targets, please follow the instructions in https://developer.android.com/training/sharing/receive.html#providing-direct-share-targets instead.')
  final String bindChooserTargetService =
      'android.permission.BIND_CHOOSER_TARGET_SERVICE';

  /// Must be required by any CompanionDeviceServices to ensure that only the system can bind to it.
  ///
  /// Constant Value: "android.permission.BIND_COMPANION_DEVICE_SERVICE"
  final String bindCompanionDeviceService =
      'android.permission.BIND_COMPANION_DEVICE_SERVICE';

  /// Must be required by a ConditionProviderService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_CONDITION_PROVIDER_SERVICE"
  final String bindConditionProviderService =
      'android.permission.BIND_CONDITION_PROVIDER_SERVICE';

  /// Allows SystemUI to request third party controls.
  ///
  /// Should only be requested by the System and required by ControlsProviderService declarations.
  ///
  /// Constant Value: "android.permission.BIND_CONTROLS"
  final String bindControls = 'android.permission.BIND_CONTROLS';

  /// Must be required by a CredentialProviderService to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_CREDENTIAL_PROVIDER_SERVICE"
  final String bindCredentialProviderService =
      'android.permission.BIND_CREDENTIAL_PROVIDER_SERVICE';

  /// Must be required by device administration receiver, to ensure that only the system can interact with it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_DEVICE_ADMIN"
  final String bindDeviceAdmin = 'android.permission.BIND_DEVICE_ADMIN';

  /// Must be required by an DreamService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_DREAM_SERVICE"
  final String bindDreamService = 'android.permission.BIND_DREAM_SERVICE';

  /// Must be required by a InCallService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_INCALL_SERVICE"
  final String bindIncallService = 'android.permission.BIND_INCALL_SERVICE';

  /// Must be required by an InputMethodService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_INPUT_METHOD"
  final String bindInputMethod = 'android.permission.BIND_INPUT_METHOD';

  /// Must be required by an MidiDeviceService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_MIDI_DEVICE_SERVICE"
  final String bindMidiDeviceService =
      'android.permission.BIND_MIDI_DEVICE_SERVICE';

  /// Must be required by a HostApduService or OffHostApduService to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_NFC_SERVICE"
  final String bindNfcService = 'android.permission.BIND_NFC_SERVICE';

  /// Must be required by an NotificationListenerService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"
  final String bindNotificationListenerService =
      'android.permission.BIND_NOTIFICATION_LISTENER_SERVICE';

  /// Must be required by a PrintService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_PRINT_SERVICE"
  final String bindPrintService = 'android.permission.BIND_PRINT_SERVICE';

  /// Must be required by a QuickAccessWalletService to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_QUICK_ACCESS_WALLET_SERVICE"
  final String bindQuickAccessWalletService =
      'android.permission.BIND_QUICK_ACCESS_WALLET_SERVICE';

  /// Allows an application to bind to third party quick settings tiles.
  ///
  /// Should only be requested by the System, should be required by TileService declarations.
  ///
  /// Constant Value: "android.permission.BIND_QUICK_SETTINGS_TILE"
  final String bindQuickSettingsTile =
      'android.permission.BIND_QUICK_SETTINGS_TILE';

  /// Must be required by a RemoteViewsService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_REMOTEVIEWS"
  final String bindRemoteviews = 'android.permission.BIND_REMOTEVIEWS';

  /// Must be required by a CallScreeningService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_SCREENING_SERVICE"
  final String bindScreeningService =
      'android.permission.BIND_SCREENING_SERVICE';

  /// Must be required by a ConnectionService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_TELECOM_CONNECTION_SERVICE"
  final String bindTelecomConnectionService =
      'android.permission.BIND_TELECOM_CONNECTION_SERVICE';

  /// Must be required by a TextService (e.g. SpellCheckerService) to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_TEXT_SERVICE"
  final String bindTextService = 'android.permission.BIND_TEXT_SERVICE';

  /// Must be required by a TvInputService to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_TV_INPUT"
  final String bindTvInput = 'android.permission.BIND_TV_INPUT';

  /// Must be required by a TvInteractiveAppService to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_TV_INTERACTIVE_APP"
  final String bindTvInteractiveApp =
      'android.permission.BIND_TV_INTERACTIVE_APP';

  /// Must be required by a link VisualVoicemailService to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_VISUAL_VOICEMAIL_SERVICE"
  final String bindVisualVoicemailService =
      'android.permission.BIND_VISUAL_VOICEMAIL_SERVICE';

  /// Must be required by a VoiceInteractionService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_VOICE_INTERACTION"
  final String bindVoiceInteraction =
      'android.permission.BIND_VOICE_INTERACTION';

  /// Must be required by a VpnService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_VPN_SERVICE"
  final String bindVpnService = 'android.permission.BIND_VPN_SERVICE';

  /// Must be required by an VrListenerService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.BIND_VR_LISTENER_SERVICE"
  final String bindVrListenerService =
      'android.permission.BIND_VR_LISTENER_SERVICE';

  /// Must be required by a WallpaperService, to ensure that only the system can bind to it.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.BIND_WALLPAPER"
  final String bindWallpaper = 'android.permission.BIND_WALLPAPER';

  /// Allows applications to connect to paired bluetooth devices.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.BLUETOOTH"
  final String bluetooth = 'android.permission.BLUETOOTH';

  /// Allows applications to discover and pair bluetooth devices.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.BLUETOOTH_ADMIN"
  final String bluetoothAdmin = 'android.permission.BLUETOOTH_ADMIN';

  /// Required to be able to advertise to nearby Bluetooth devices.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.BLUETOOTH_ADVERTISE"
  final String bluetoothAdvertise = 'android.permission.BLUETOOTH_ADVERTISE';

  /// Required to be able to connect to paired Bluetooth devices.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.BLUETOOTH_CONNECT"
  final String bluetoothConnect = 'android.permission.BLUETOOTH_CONNECT';

  /// Allows applications to pair bluetooth devices without user interaction, and to allow or disallow phonebook access or message access.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.BLUETOOTH_PRIVILEGED"
  final String bluetoothPrivileged = 'android.permission.BLUETOOTH_PRIVILEGED';

  /// Required to be able to discover and pair nearby Bluetooth devices.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.BLUETOOTH_SCAN"
  final String bluetoothScan = 'android.permission.BLUETOOTH_SCAN';

  /// Allows an application to access data from sensors that the user uses to measure what is happening inside their body, such as heart rate.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.BODY_SENSORS"
  final String bodySensors = 'android.permission.BODY_SENSORS';

  /// Allows an application to access data from sensors that the user uses to measure what is happening inside their body, such as heart rate. If you're requesting this permission, you must also request BODY_SENSORS. Requesting this permission by itself doesn't give you Body sensors access.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.BODY_SENSORS_BACKGROUND"
  final String bodySensorsBackground =
      'android.permission.BODY_SENSORS_BACKGROUND';

  /// Allows an application to broadcast a notification that an application package has been removed.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.BROADCAST_PACKAGE_REMOVED"
  final String broadcastPackageRemoved =
      'android.permission.BROADCAST_PACKAGE_REMOVED';

  /// Allows an application to broadcast an SMS receipt notification.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.BROADCAST_SMS"
  final String broadcastSms = 'android.permission.BROADCAST_SMS';

  /// Allows an application to broadcast sticky intents. These are broadcasts whose data is held by the system after being finished, so that clients can quickly retrieve that data without having to wait for the next broadcast.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.BROADCAST_STICKY"
  final String broadcastSticky = 'android.permission.BROADCAST_STICKY';

  /// Allows an application to broadcast a WAP PUSH receipt notification.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.BROADCAST_WAP_PUSH"
  final String broadcastWapPush = 'android.permission.BROADCAST_WAP_PUSH';

  /// Allows an app which implements the InCallService API to be eligible to be enabled as a calling companion app. This means that the Telecom framework will bind to the app's InCallService implementation when there are calls active. The app can use the InCallService API to view information about calls on the system and control these calls.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CALL_COMPANION_APP"
  final String callCompanionApp = 'android.permission.CALL_COMPANION_APP';

  /// Allows an application to initiate a phone call without going through the Dialer user interface for the user to confirm the call.
  ///
  /// **Note**: An app holding this permission can also call carrier MMI codes to change settings such as call forwarding or call waiting preferences.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.CALL_PHONE"
  final String callPhone = 'android.permission.CALL_PHONE';

  /// Allows an application to call any phone number, including emergency numbers, without going through the Dialer user interface for the user to confirm the call being placed.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.CALL_PRIVILEGED"
  final String callPrivileged = 'android.permission.CALL_PRIVILEGED';

  /// Required to be able to access the camera device.
  ///
  /// This will automatically enforce the uses-feature manifest element for all camera features. If you do not require all camera features or can properly operate if a camera is not available, then you must modify your manifest as appropriate in order to install on devices that don't support all camera features.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.CAMERA"
  final String camera = 'android.permission.CAMERA';

  /// Allows an application to capture audio output. Use the CAPTURE_MEDIA_OUTPUT permission if only the USAGE_UNKNOWN), USAGE_MEDIA) or USAGE_GAME) usages are intended to be captured.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.CAPTURE_AUDIO_OUTPUT"
  final String captureAudioOutput = 'android.permission.CAPTURE_AUDIO_OUTPUT';

  /// Allows an application to change whether an application component (other than its own) is enabled or not.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.CHANGE_COMPONENT_ENABLED_STATE"
  final String changeComponentEnabledState =
      'android.permission.CHANGE_COMPONENT_ENABLED_STATE';

  /// Allows an application to modify the current configuration, such as locale.
  ///
  /// Protection level: signature|privileged|development
  ///
  /// Constant Value: "android.permission.CHANGE_CONFIGURATION"
  final String changeConfiguration = 'android.permission.CHANGE_CONFIGURATION';

  /// Allows applications to change network connectivity state.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CHANGE_NETWORK_STATE"
  final String changeNetworkState = 'android.permission.CHANGE_NETWORK_STATE';

  /// Allows applications to enter Wi-Fi Multicast mode.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CHANGE_WIFI_MULTICAST_STATE"
  final String changeWifiMulticastState =
      'android.permission.CHANGE_WIFI_MULTICAST_STATE';

  /// Allows applications to change Wi-Fi connectivity state.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CHANGE_WIFI_STATE"
  final String changeWifiState = 'android.permission.CHANGE_WIFI_STATE';

  /// Allows an application to clear the caches of all installed applications on the device.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.CLEAR_APP_CACHE"
  final String clearAppCache = 'android.permission.CLEAR_APP_CACHE';

  /// Allows an application to configure and connect to Wifi displays
  ///
  /// Constant Value: "android.permission.CONFIGURE_WIFI_DISPLAY"
  final String configureWifiDisplay =
      'android.permission.CONFIGURE_WIFI_DISPLAY';

  /// Allows enabling/disabling location update notifications from the radio.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.CONTROL_LOCATION_UPDATES"
  final String controlLocationUpdates =
      'android.permission.CONTROL_LOCATION_UPDATES';

  /// Allows a browser to invoke the set of query apis to get metadata about credential candidates prepared during the CredentialManager.prepareGetCredential API.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CREDENTIAL_MANAGER_QUERY_CANDIDATE_CREDENTIALS"
  final String credentialManagerQueryCandidateCredentials =
      'android.permission.CREDENTIAL_MANAGER_QUERY_CANDIDATE_CREDENTIALS';

  /// Allows specifying candidate credential providers to be queried in Credential Manager get flows, or to be preferred as a default in the Credential Manager create flows.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CREDENTIAL_MANAGER_SET_ALLOWED_PROVIDERS"
  final String credentialManagerSetAllowedProviders =
      'android.permission.CREDENTIAL_MANAGER_SET_ALLOWED_PROVIDERS';

  /// Allows a browser to invoke credential manager APIs on behalf of another RP.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.CREDENTIAL_MANAGER_SET_ORIGIN"
  final String credentialManagerSetOrigin =
      'android.permission.CREDENTIAL_MANAGER_SET_ORIGIN';

  /// Old permission for deleting an app's cache files, no longer used, but signals for us to quietly ignore calls instead of throwing an exception.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.DELETE_CACHE_FILES"
  final String deleteCacheFiles = 'android.permission.DELETE_CACHE_FILES';

  /// Allows an application to delete packages.
  ///
  /// Not for use by third-party applications.
  ///
  /// Starting in Build.VERSION_CODES.N, user confirmation is requested when the application deleting the package is not the same application that installed the package.
  ///
  /// Constant Value: "android.permission.DELETE_PACKAGES"
  final String deletePackages = 'android.permission.DELETE_PACKAGES';

  /// Allows an application to deliver companion messages to system
  ///
  /// Constant Value: "android.permission.DELIVER_COMPANION_MESSAGES"
  final String deliverCompanionMessages =
      'android.permission.DELIVER_COMPANION_MESSAGES';

  /// Allows an application to get notified when a screen capture of its windows is attempted.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.DETECT_SCREEN_CAPTURE"
  final String detectScreenCapture = 'android.permission.DETECT_SCREEN_CAPTURE';

  /// Allows applications to RW to diagnostic resources.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.DIAGNOSTIC"
  final String diagnostic = 'android.permission.DIAGNOSTIC';

  /// Allows applications to disable the keyguard if it is not secure.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.DISABLE_KEYGUARD"
  final String disableKeyguard = 'android.permission.DISABLE_KEYGUARD';

  /// Allows an application to retrieve state dump information from system services.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.DUMP"
  final String dump = 'android.permission.DUMP';

  /// Allows an application to indicate via PackageInstaller.SessionParams.setRequestUpdateOwnership(boolean) that it has the intention of becoming the update owner.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.ENFORCE_UPDATE_OWNERSHIP"
  final String enforceUpdateOwnership =
      'android.permission.ENFORCE_UPDATE_OWNERSHIP';

  /// Allows an assistive application to perform actions on behalf of users inside of applications.
  ///
  /// For now, this permission is only granted to the Assistant application selected by the user.
  ///
  /// Protection level: internal|role
  ///
  /// Constant Value: "android.permission.EXECUTE_APP_ACTION"
  final String executeAppAction = 'android.permission.EXECUTE_APP_ACTION';

  /// Allows an application to expand or collapse the status bar.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.EXPAND_STATUS_BAR"
  final String expandStatusBar = 'android.permission.EXPAND_STATUS_BAR';

  /// Run as a manufacturer test application, running as the root user. Only available when the device is running in manufacturer test mode.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.FACTORY_TEST"
  final String factoryTest = 'android.permission.FACTORY_TEST';

  /// Allows a regular application to use Service.startForeground.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE"
  final String foregroundService = 'android.permission.FOREGROUND_SERVICE';

  /// Allows a regular application to use Service.startForeground with the type "camera".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_CAMERA"
  final String foregroundServiceCamera =
      'android.permission.FOREGROUND_SERVICE_CAMERA';

  /// Allows a regular application to use Service.startForeground with the type "connectedDevice".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_CONNECTED_DEVICE"
  final String foregroundServiceConnectedDevice =
      'android.permission.FOREGROUND_SERVICE_CONNECTED_DEVICE';

  /// Allows a regular application to use Service.startForeground with the type "dataSync".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_DATA_SYNC"
  final String foregroundServiceDataSync =
      'android.permission.FOREGROUND_SERVICE_DATA_SYNC';

  /// Allows a regular application to use Service.startForeground with the type "health".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_HEALTH"
  final String foregroundServiceHealth =
      'android.permission.FOREGROUND_SERVICE_HEALTH';

  /// Allows a regular application to use Service.startForeground with the type "location".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_LOCATION"
  final String foregroundServiceLocation =
      'android.permission.FOREGROUND_SERVICE_LOCATION';

  /// Allows a regular application to use Service.startForeground with the type "mediaPlayback".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"
  final String foregroundServiceMediaPlayback =
      'android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK';

  /// Allows a regular application to use Service.startForeground with the type "mediaProjection".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION"
  final String foregroundServiceMediaProjection =
      'android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION';

  /// Allows a regular application to use Service.startForeground with the type "microphone".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_MICROPHONE"
  final String foregroundServiceMicrophone =
      'android.permission.FOREGROUND_SERVICE_MICROPHONE';

  /// Allows a regular application to use Service.startForeground with the type "phoneCall".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_PHONE_CALL"
  final String foregroundServicePhoneCall =
      'android.permission.FOREGROUND_SERVICE_PHONE_CALL';

  /// Allows a regular application to use Service.startForeground with the type "remoteMessaging".
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_REMOTE_MESSAGING"
  final String foregroundServiceRemoteMessaging =
      'android.permission.FOREGROUND_SERVICE_REMOTE_MESSAGING';

  /// Allows a regular application to use Service.startForeground with the type "specialUse".
  ///
  /// Protection level: normal|appop|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_SPECIAL_USE"
  final String foregroundServiceSpecialUse =
      'android.permission.FOREGROUND_SERVICE_SPECIAL_USE';

  /// Allows a regular application to use Service.startForeground with the type "systemExempted". Apps are allowed to use this type only in the use cases listed in ServiceInfo.FOREGROUND_SERVICE_TYPE_SYSTEM_EXEMPTED.
  ///
  /// Protection level: normal|instant
  ///
  /// Constant Value: "android.permission.FOREGROUND_SERVICE_SYSTEM_EXEMPTED"
  final String foregroundServiceSystemExempted =
      'android.permission.FOREGROUND_SERVICE_SYSTEM_EXEMPTED';

  /// Allows access to the list of accounts in the Accounts Service.
  ///
  /// **Note**: Beginning with Android 6.0 (API level 23), if an app shares the signature of the authenticator that manages an account, it does not need "GET_ACCOUNTS" permission to read information about that account. On Android 5.1 and lower, all apps need "GET_ACCOUNTS" permission to read information about any account.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.GET_ACCOUNTS"
  final String getAccounts = 'android.permission.GET_ACCOUNTS';

  /// Allows access to the list of accounts in the Accounts Service.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.GET_ACCOUNTS_PRIVILEGED"
  final String getAccountsPrivileged =
      'android.permission.GET_ACCOUNTS_PRIVILEGED';

  /// Allows an application to find out the space used by any package.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.GET_PACKAGE_SIZE"
  final String getPackageSize = 'android.permission.GET_PACKAGE_SIZE';

  /// Constant Value: "android.permission.GET_TASKS"
  @Deprecated(
      'This constant was deprecated in API level 21. No longer enforced.')
  final String getTasks = 'android.permission.GET_TASKS';

  /// This permission can be used on content providers to allow the global search system to access their data. Typically it used when the provider has some permissions protecting it (which global search would not be expected to hold), and added as a read-only permission to the path in the provider where global search queries are performed. This permission can not be held by regular applications; it is used by applications to protect themselves from everyone else besides global search.
  ///
  /// Protection level: signature|privileged
  ///
  /// Constant Value: "android.permission.GLOBAL_SEARCH"
  final String globalSearch = 'android.permission.GLOBAL_SEARCH';

  /// Allows an app to prevent non-system-overlay windows from being drawn on top of it
  ///
  /// Constant Value: "android.permission.HIDE_OVERLAY_WINDOWS"
  final String hideOverlayWindows = 'android.permission.HIDE_OVERLAY_WINDOWS';

  /// Allows an app to access sensor data with a sampling rate greater than 200 Hz.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.HIGH_SAMPLING_RATE_SENSORS"
  final String highSamplingRateSensors =
      'android.permission.HIGH_SAMPLING_RATE_SENSORS';

  /// Allows an application to install a location provider into the Location Manager.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.INSTALL_LOCATION_PROVIDER"
  final String installLocationProvider =
      'android.permission.INSTALL_LOCATION_PROVIDER';

  /// Allows an application to install packages.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.INSTALL_PACKAGES"
  final String installPackages = 'android.permission.INSTALL_PACKAGES';

  /// Allows an application to install a shortcut in Launcher.
  ///
  /// In Android O (API level 26) and higher, the INSTALL_SHORTCUT broadcast no longer has any effect on your app because it's a private, implicit broadcast. Instead, you should create an app shortcut by using the requestPinShortcut() method from the ShortcutManager class.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "com.android.launcher.permission.INSTALL_SHORTCUT"
  final String installShortcut =
      'com.android.launcher.permission.INSTALL_SHORTCUT';

  /// Allows an instant app to create foreground services.
  ///
  /// Protection level: signature|development|instant|appop
  ///
  /// Constant Value: "android.permission.INSTANT_APP_FOREGROUND_SERVICE"
  final String instantAppForegroundService =
      'android.permission.INSTANT_APP_FOREGROUND_SERVICE';

  /// Allows interaction across profiles in the same profile group.
  ///
  /// Constant Value: "android.permission.INTERACT_ACROSS_PROFILES"
  final String interactAcrossProfiles =
      'android.permission.INTERACT_ACROSS_PROFILES';

  /// Allows applications to open network sockets.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.INTERNET"
  final String internet = 'android.permission.INTERNET';

  /// Allows an application to call ActivityManager.killBackgroundProcesses(String).
  ///
  /// As of Android version Build.VERSION_CODES.UPSIDE_DOWN_CAKE, the ActivityManager.killBackgroundProcesses(String) is no longer available to third party applications. For backwards compatibility, the background processes of the caller's own package will still be killed when calling this API. If the caller has the system permission KILL_ALL_BACKGROUND_PROCESSES, other processes will be killed too.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.KILL_BACKGROUND_PROCESSES"
  final String killBackgroundProcesses =
      'android.permission.KILL_BACKGROUND_PROCESSES';

  /// Allows an application to capture screen content to perform a screenshot using the intent action Intent.ACTION_LAUNCH_CAPTURE_CONTENT_ACTIVITY_FOR_NOTE.
  ///
  /// Protection level: internal|role
  ///
  /// Intended for use by ROLE_NOTES only.
  ///
  /// Constant Value: "android.permission.LAUNCH_CAPTURE_CONTENT_ACTIVITY_FOR_NOTE"
  final String launchCaptureContentActivityForNote =
      'android.permission.LAUNCH_CAPTURE_CONTENT_ACTIVITY_FOR_NOTE';

  /// An application needs this permission for Settings.ACTION_SETTINGS_EMBED_DEEP_LINK_ACTIVITY to show its Activity embedded in Settings app.
  ///
  /// Constant Value: "android.permission.LAUNCH_MULTI_PANE_SETTINGS_DEEP_LINK"
  final String launchMultiPaneSettingsDeepLink =
      'android.permission.LAUNCH_MULTI_PANE_SETTINGS_DEEP_LINK';

  /// Allows a data loader to read a package's access logs. The access logs contain the set of pages referenced over time.
  ///
  /// Declaring the permission implies intention to use the API and the user of the device can grant permission through the Settings application.
  ///
  /// Protection level: signature|privileged|appop
  ///
  /// A data loader has to be the one which provides data to install an app.
  ///
  /// A data loader has to have both permission:LOADER_USAGE_STATS AND appop:LOADER_USAGE_STATS allowed to be able to access the read logs.
  ///
  /// Constant Value: "android.permission.LOADER_USAGE_STATS"
  final String loaderUsageStats = 'android.permission.LOADER_USAGE_STATS';

  /// Allows an application to use location features in hardware, such as the geofencing api.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.LOCATION_HARDWARE"
  final String locationHardware = 'android.permission.LOCATION_HARDWARE';

  /// Allows financed device kiosk apps to perform actions on the Device Lock service
  ///
  /// Protection level: internal|role
  ///
  /// Intended for use by the FINANCED_DEVICE_KIOSK role only.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_LOCK_STATE"
  final String manageDeviceLockState =
      'android.permission.MANAGE_DEVICE_LOCK_STATE';

  /// Allows an application to manage policy related to accessibility.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_ACCESSIBILITY"
  final String manageDevicePolicyAccessibility =
      'android.permission.MANAGE_DEVICE_POLICY_ACCESSIBILITY';

  /// Allows an application to set policy related to account management.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_ACCOUNT_MANAGEMENT"
  final String manageDevicePolicyAccountManagement =
      'android.permission.MANAGE_DEVICE_POLICY_ACCOUNT_MANAGEMENT';

  /// Allows an application to set device policies outside the current user that are required for securing device ownership without accessing user data.
  ///
  /// Holding this permission allows the use of other held MANAGE_DEVICE_POLICY_* permissions across all users on the device provided they do not grant access to user data.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_ACROSS_USERS"
  final String manageDevicePolicyAcrossUsers =
      'android.permission.MANAGE_DEVICE_POLICY_ACROSS_USERS';

  /// Allows an application to set device policies outside the current user.
  ///
  /// Fuller form of MANAGE_DEVICE_POLICY_ACROSS_USERS that removes the restriction on accessing user data.
  ///
  /// Holding this permission allows the use of any other held MANAGE_DEVICE_POLICY_* permissions across all users on the device.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL"
  final String manageDevicePolicyAcrossUsersFull =
      'android.permission.MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL';

  /// Allows an application to set device policies outside the current user that are critical for securing data within the current user.
  ///
  /// Holding this permission allows the use of other held MANAGE_DEVICE_POLICY_* permissions across all users on the device provided they are required for securing data within the current user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_ACROSS_USERS_SECURITY_CRITICAL"
  final String manageDevicePolicyAcrossUsersSecurityCritical =
      'android.permission.MANAGE_DEVICE_POLICY_ACROSS_USERS_SECURITY_CRITICAL';

  /// Allows an application to set policy related to airplane mode.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_AIRPLANE_MODE"
  final String manageDevicePolicyAirplaneMode =
      'android.permission.MANAGE_DEVICE_POLICY_AIRPLANE_MODE';

  /// Allows an application to manage policy regarding modifying applications.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_APPS_CONTROL"
  final String manageDevicePolicyAppsControl =
      'android.permission.MANAGE_DEVICE_POLICY_APPS_CONTROL';

  /// Allows an application to manage application restrictions.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_APP_RESTRICTIONS"
  final String manageDevicePolicyAppRestrictions =
      'android.permission.MANAGE_DEVICE_POLICY_APP_RESTRICTIONS';

  /// Allows an application to manage policy related to application user data.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_APP_USER_DATA"
  final String manageDevicePolicyAppUserData =
      'android.permission.MANAGE_DEVICE_POLICY_APP_USER_DATA';

  /// Allows an application to set policy related to audio output.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_AUDIO_OUTPUT"
  final String manageDevicePolicyAudioOutput =
      'android.permission.MANAGE_DEVICE_POLICY_AUDIO_OUTPUT';

  /// Allows an application to set policy related to autofill.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_AUTOFILL"
  final String manageDevicePolicyAutofill =
      'android.permission.MANAGE_DEVICE_POLICY_AUTOFILL';

  /// Allows an application to manage backup service policy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_BACKUP_SERVICE"
  final String manageDevicePolicyBackupService =
      'android.permission.MANAGE_DEVICE_POLICY_BACKUP_SERVICE';

  /// Allows an application to set policy related to bluetooth.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_BLUETOOTH"
  final String manageDevicePolicyBluetooth =
      'android.permission.MANAGE_DEVICE_POLICY_BLUETOOTH';

  /// Allows an application to request bugreports with user consent.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_BUGREPORT"
  final String manageDevicePolicyBugreport =
      'android.permission.MANAGE_DEVICE_POLICY_BUGREPORT';

  /// Allows an application to manage calling policy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_CALLS"
  final String manageDevicePolicyCalls =
      'android.permission.MANAGE_DEVICE_POLICY_CALLS';

  /// Allows an application to set policy related to restricting a user's ability to use or enable and disable the camera.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_CAMERA"
  final String manageDevicePolicyCamera =
      'android.permission.MANAGE_DEVICE_POLICY_CAMERA';

  /// Allows an application to set policy related to certificates.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_CERTIFICATES"
  final String manageDevicePolicyCertificates =
      'android.permission.MANAGE_DEVICE_POLICY_CERTIFICATES';

  /// Allows an application to manage policy related to common criteria mode.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_COMMON_CRITERIA_MODE"
  final String manageDevicePolicyCommonCriteriaMode =
      'android.permission.MANAGE_DEVICE_POLICY_COMMON_CRITERIA_MODE';

  /// Allows an application to manage debugging features policy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_DEBUGGING_FEATURES"
  final String manageDevicePolicyDebuggingFeatures =
      'android.permission.MANAGE_DEVICE_POLICY_DEBUGGING_FEATURES';

  /// Allows an application to set policy related to the default sms application.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_DEFAULT_SMS"
  final String manageDevicePolicyDefaultSms =
      'android.permission.MANAGE_DEVICE_POLICY_DEFAULT_SMS';

  /// Allows an application to manage policy related to device identifiers.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_DEVICE_IDENTIFIERS"
  final String manageDevicePolicyDeviceIdentifiers =
      'android.permission.MANAGE_DEVICE_POLICY_DEVICE_IDENTIFIERS';

  /// Allows an application to set policy related to the display.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_DISPLAY"
  final String manageDevicePolicyDisplay =
      'android.permission.MANAGE_DEVICE_POLICY_DISPLAY';

  /// Allows an application to set policy related to factory reset.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_FACTORY_RESET"
  final String manageDevicePolicyFactoryReset =
      'android.permission.MANAGE_DEVICE_POLICY_FACTORY_RESET';

  /// Allows an application to set policy related to fun.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_FUN"
  final String manageDevicePolicyFun =
      'android.permission.MANAGE_DEVICE_POLICY_FUN';

  /// Allows an application to set policy related to input methods.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_INPUT_METHODS"
  final String manageDevicePolicyInputMethods =
      'android.permission.MANAGE_DEVICE_POLICY_INPUT_METHODS';

  /// Allows an application to manage installing from unknown sources policy.
  ///
  /// MANAGE_SECURITY_CRITICAL_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_INSTALL_UNKNOWN_SOURCES"
  final String manageDevicePolicyInstallUnknownSources =
      'android.permission.MANAGE_DEVICE_POLICY_INSTALL_UNKNOWN_SOURCES';

  /// Allows an application to set policy related to keeping uninstalled packages.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_KEEP_UNINSTALLED_PACKAGES"
  final String manageDevicePolicyKeepUninstalledPackages =
      'android.permission.MANAGE_DEVICE_POLICY_KEEP_UNINSTALLED_PACKAGES';

  /// Allows an application to manage policy related to keyguard.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_SECURITY_CRITICAL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_KEYGUARD"
  final String manageDevicePolicyKeyguard =
      'android.permission.MANAGE_DEVICE_POLICY_KEYGUARD';

  /// Allows an application to set policy related to locale.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_LOCALE"
  final String manageDevicePolicyLocale =
      'android.permission.MANAGE_DEVICE_POLICY_LOCALE';

  /// Allows an application to set policy related to location.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_LOCATION"
  final String manageDevicePolicyLocation =
      'android.permission.MANAGE_DEVICE_POLICY_LOCATION';

  /// Allows an application to lock a profile or the device with the appropriate cross-user permission.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_LOCK"
  final String manageDevicePolicyLock =
      'android.permission.MANAGE_DEVICE_POLICY_LOCK';

  /// Allows an application to set policy related to lock credentials.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_SECURITY_CRITICAL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_LOCK_CREDENTIALS"
  final String manageDevicePolicyLockCredentials =
      'android.permission.MANAGE_DEVICE_POLICY_LOCK_CREDENTIALS';

  /// Allows an application to manage lock task policy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_LOCK_TASK"
  final String manageDevicePolicyLockTask =
      'android.permission.MANAGE_DEVICE_POLICY_LOCK_TASK';

  /// Allows an application to manage policy related to metered data.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_METERED_DATA"
  final String manageDevicePolicyMeteredData =
      'android.permission.MANAGE_DEVICE_POLICY_METERED_DATA';

  /// Allows an application to set policy related to restricting a user's ability to use or enable and disable the microphone.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_MICROPHONE"
  final String manageDevicePolicyMicrophone =
      'android.permission.MANAGE_DEVICE_POLICY_MICROPHONE';

  /// Allows an application to set policy related to mobile networks.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_MOBILE_NETWORK"
  final String manageDevicePolicyMobileNetwork =
      'android.permission.MANAGE_DEVICE_POLICY_MOBILE_NETWORK';

  /// Allows an application to manage policy preventing users from modifying users.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_MODIFY_USERS"
  final String manageDevicePolicyModifyUsers =
      'android.permission.MANAGE_DEVICE_POLICY_MODIFY_USERS';

  /// Allows an application to manage policy related to the Memory Tagging Extension (MTE).
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_MTE"
  final String manageDevicePolicyMte =
      'android.permission.MANAGE_DEVICE_POLICY_MTE';

  /// Allows an application to set policy related to nearby communications (e.g. Beam and nearby streaming).
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_NEARBY_COMMUNICATION"
  final String manageDevicePolicyNearbyCommunication =
      'android.permission.MANAGE_DEVICE_POLICY_NEARBY_COMMUNICATION';

  /// Allows an application to set policy related to network logging.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_NETWORK_LOGGING"
  final String manageDevicePolicyNetworkLogging =
      'android.permission.MANAGE_DEVICE_POLICY_NETWORK_LOGGING';

  /// Allows an application to manage the identity of the managing organization.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_ORGANIZATION_IDENTITY"
  final String manageDevicePolicyOrganizationIdentity =
      'android.permission.MANAGE_DEVICE_POLICY_ORGANIZATION_IDENTITY';

  /// Allows an application to set policy related to override APNs.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_OVERRIDE_APN"
  final String manageDevicePolicyOverrideApn =
      'android.permission.MANAGE_DEVICE_POLICY_OVERRIDE_APN';

  /// Allows an application to set policy related to hiding and suspending packages.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PACKAGE_STATE"
  final String manageDevicePolicyPackageState =
      'android.permission.MANAGE_DEVICE_POLICY_PACKAGE_STATE';

  /// Allows an application to set policy related to physical media.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PHYSICAL_MEDIA"
  final String manageDevicePolicyPhysicalMedia =
      'android.permission.MANAGE_DEVICE_POLICY_PHYSICAL_MEDIA';

  /// Allows an application to set policy related to printing.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PRINTING"
  final String manageDevicePolicyPrinting =
      'android.permission.MANAGE_DEVICE_POLICY_PRINTING';

  /// Allows an application to set policy related to private DNS.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PRIVATE_DNS"
  final String manageDevicePolicyPrivateDns =
      'android.permission.MANAGE_DEVICE_POLICY_PRIVATE_DNS';

  /// Allows an application to set policy related to profiles.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PROFILES"
  final String manageDevicePolicyProfiles =
      'android.permission.MANAGE_DEVICE_POLICY_PROFILES';

  /// Allows an application to set policy related to interacting with profiles (e.g. Disallowing cross-profile copy and paste).
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PROFILE_INTERACTION"
  final String manageDevicePolicyProfileInteraction =
      'android.permission.MANAGE_DEVICE_POLICY_PROFILE_INTERACTION';

  /// Allows an application to set a network-independent global HTTP proxy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_PROXY"
  final String manageDevicePolicyProxy =
      'android.permission.MANAGE_DEVICE_POLICY_PROXY';

  /// Allows an application query system updates.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_QUERY_SYSTEM_UPDATES"
  final String manageDevicePolicyQuerySystemUpdates =
      'android.permission.MANAGE_DEVICE_POLICY_QUERY_SYSTEM_UPDATES';

  /// Allows an application to force set a new device unlock password or a managed profile challenge on current user.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_RESET_PASSWORD"
  final String manageDevicePolicyResetPassword =
      'android.permission.MANAGE_DEVICE_POLICY_RESET_PASSWORD';

  /// Allows an application to set policy related to restricting the user from configuring private DNS.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_RESTRICT_PRIVATE_DNS"
  final String manageDevicePolicyRestrictPrivateDns =
      'android.permission.MANAGE_DEVICE_POLICY_RESTRICT_PRIVATE_DNS';

  /// Allows an application to set the grant state of runtime permissions on packages.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_RUNTIME_PERMISSIONS"
  final String manageDevicePolicyRuntimePermissions =
      'android.permission.MANAGE_DEVICE_POLICY_RUNTIME_PERMISSIONS';

  /// Allows an application to set policy related to users running in the background.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_RUN_IN_BACKGROUND"
  final String manageDevicePolicyRunInBackground =
      'android.permission.MANAGE_DEVICE_POLICY_RUN_IN_BACKGROUND';

  /// Allows an application to manage safe boot policy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SAFE_BOOT"
  final String manageDevicePolicySafeBoot =
      'android.permission.MANAGE_DEVICE_POLICY_SAFE_BOOT';

  /// Allows an application to set policy related to screen capture.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SCREEN_CAPTURE"
  final String manageDevicePolicyScreenCapture =
      'android.permission.MANAGE_DEVICE_POLICY_SCREEN_CAPTURE';

  /// Allows an application to set policy related to the usage of the contents of the screen.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SCREEN_CONTENT"
  final String manageDevicePolicyScreenContent =
      'android.permission.MANAGE_DEVICE_POLICY_SCREEN_CONTENT';

  /// Allows an application to set policy related to security logging.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SECURITY_LOGGING"
  final String manageDevicePolicySecurityLogging =
      'android.permission.MANAGE_DEVICE_POLICY_SECURITY_LOGGING';

  /// Allows an application to set policy related to settings.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SETTINGS"
  final String manageDevicePolicySettings =
      'android.permission.MANAGE_DEVICE_POLICY_SETTINGS';

  /// Allows an application to set policy related to sms.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SMS"
  final String manageDevicePolicySms =
      'android.permission.MANAGE_DEVICE_POLICY_SMS';

  /// Allows an application to set policy related to the status bar.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_STATUS_BAR"
  final String manageDevicePolicyStatusBar =
      'android.permission.MANAGE_DEVICE_POLICY_STATUS_BAR';

  /// Allows an application to set support messages for when a user action is affected by an active policy.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SUPPORT_MESSAGE"
  final String manageDevicePolicySupportMessage =
      'android.permission.MANAGE_DEVICE_POLICY_SUPPORT_MESSAGE';

  /// Allows an application to set policy related to suspending personal apps.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SUSPEND_PERSONAL_APPS"
  final String manageDevicePolicySuspendPersonalApps =
      'android.permission.MANAGE_DEVICE_POLICY_SUSPEND_PERSONAL_APPS';

  /// Allows an application to manage policy related to system apps.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SYSTEM_APPS"
  final String manageDevicePolicySystemApps =
      'android.permission.MANAGE_DEVICE_POLICY_SYSTEM_APPS';

  /// Allows an application to set policy related to system dialogs.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SYSTEM_DIALOGS"
  final String manageDevicePolicySystemDialogs =
      'android.permission.MANAGE_DEVICE_POLICY_SYSTEM_DIALOGS';

  /// Allows an application to set policy related to system updates.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_SYSTEM_UPDATES"
  final String manageDevicePolicySystemUpdates =
      'android.permission.MANAGE_DEVICE_POLICY_SYSTEM_UPDATES';

  /// Allows an application to manage device policy relating to time.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_TIME"
  final String manageDevicePolicyTime =
      'android.permission.MANAGE_DEVICE_POLICY_TIME';

  /// Allows an application to set policy related to usb data signalling.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_USB_DATA_SIGNALLING"
  final String manageDevicePolicyUsbDataSignalling =
      'android.permission.MANAGE_DEVICE_POLICY_USB_DATA_SIGNALLING';

  /// Allows an application to set policy related to usb file transfers.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_USB_FILE_TRANSFER"
  final String manageDevicePolicyUsbFileTransfer =
      'android.permission.MANAGE_DEVICE_POLICY_USB_FILE_TRANSFER';

  /// Allows an application to set policy related to users.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_USERS"
  final String manageDevicePolicyUsers =
      'android.permission.MANAGE_DEVICE_POLICY_USERS';

  /// Allows an application to set policy related to VPNs.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_VPN"
  final String manageDevicePolicyVpn =
      'android.permission.MANAGE_DEVICE_POLICY_VPN';

  /// Allows an application to set policy related to the wallpaper.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_WALLPAPER"
  final String manageDevicePolicyWallpaper =
      'android.permission.MANAGE_DEVICE_POLICY_WALLPAPER';

  /// Allows an application to set policy related to Wifi.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_WIFI"
  final String manageDevicePolicyWifi =
      'android.permission.MANAGE_DEVICE_POLICY_WIFI';

  /// Allows an application to set policy related to windows.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS_FULL is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_WINDOWS"
  final String manageDevicePolicyWindows =
      'android.permission.MANAGE_DEVICE_POLICY_WINDOWS';

  /// Allows an application to manage policy related to wiping data.
  ///
  /// Manifest.permission#MANAGE_DEVICE_POLICY_ACROSS_USERS is required to call APIs protected by this permission on users different to the calling user.
  ///
  /// Constant Value: "android.permission.MANAGE_DEVICE_POLICY_WIPE_DATA"
  final String manageDevicePolicyWipeData =
      'android.permission.MANAGE_DEVICE_POLICY_WIPE_DATA';

  /// Allows an application to manage access to documents, usually as part of a document picker.
  ///
  /// This permission should only be requested by the platform document management app. This permission cannot be granted to third-party apps.
  ///
  /// Constant Value: "android.permission.MANAGE_DOCUMENTS"
  final String manageDocuments = 'android.permission.MANAGE_DOCUMENTS';

  /// Allows an application a broad access to external storage in scoped storage. Intended to be used by few apps that need to manage files on behalf of the users.
  ///
  /// Protection level: signature|appop|preinstalled
  ///
  /// Constant Value: "android.permission.MANAGE_EXTERNAL_STORAGE"
  final String manageExternalStorage =
      'android.permission.MANAGE_EXTERNAL_STORAGE';

  /// Allows an application to modify and delete media files on this device or any connected storage device without user confirmation. Applications must already be granted the READ_EXTERNAL_STORAGE or MANAGE_EXTERNAL_STORAGE} permissions for this permission to take effect.
  ///
  /// Even if applications are granted this permission, if applications want to modify or delete media files, they also must get the access by calling MediaStore.createWriteRequest(ContentResolver, Collection), MediaStore.createDeleteRequest(ContentResolver, Collection), or MediaStore.createTrashRequest(ContentResolver, Collection, boolean).
  ///
  /// This permission doesn't give read or write access directly. It only prevents the user confirmation dialog for these requests.
  ///
  /// If applications are not granted ACCESS_MEDIA_LOCATION, the system also pops up the user confirmation dialog for the write request.
  ///
  /// Protection level: signature|appop|preinstalled
  ///
  /// Constant Value: "android.permission.MANAGE_MEDIA"
  final String manageMedia = 'android.permission.MANAGE_MEDIA';

  /// Allows to query ongoing call details and manage ongoing calls
  ///
  /// Protection level: signature|appop
  ///
  /// Constant Value: "android.permission.MANAGE_ONGOING_CALLS"
  final String manageOngoingCalls = 'android.permission.MANAGE_ONGOING_CALLS';

  /// Allows a calling application which manages its own calls through the self-managed ConnectionService APIs. See PhoneAccount.CAPABILITY_SELF_MANAGED for more information on the self-managed ConnectionService APIs.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.MANAGE_OWN_CALLS"
  final String manageOwnCalls = 'android.permission.MANAGE_OWN_CALLS';

  /// Allows applications to get notified when a Wi-Fi interface request cannot be satisfied without tearing down one or more other interfaces, and provide a decision whether to approve the request or reject it.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.MANAGE_WIFI_INTERFACES"
  final String manageWifiInterfaces =
      'android.permission.MANAGE_WIFI_INTERFACES';

  /// This permission is used to let OEMs grant their trusted app access to a subset of privileged wifi APIs to improve wifi performance. Allows applications to manage Wi-Fi network selection related features such as enable or disable global auto-join, modify connectivity scan intervals, and approve Wi-Fi Direct connections.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.MANAGE_WIFI_NETWORK_SELECTION"
  final String manageWifiNetworkSelection =
      'android.permission.MANAGE_WIFI_NETWORK_SELECTION';

  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.MASTER_CLEAR"
  final String masterClear = 'android.permission.MASTER_CLEAR';

  /// Allows an application to know what content is playing and control its playback.
  ///
  /// Not for use by third-party applications due to privacy of media consumption
  ///
  /// Constant Value: "android.permission.MEDIA_CONTENT_CONTROL"
  final String mediaContentControl = 'android.permission.MEDIA_CONTENT_CONTROL';

  /// Allows an application to modify global audio settings.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.MODIFY_AUDIO_SETTINGS"
  final String modifyAudioSettings = 'android.permission.MODIFY_AUDIO_SETTINGS';

  /// Allows modification of the telephony state - power on, mmi, etc. Does not include placing calls.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.MODIFY_PHONE_STATE"
  final String modifyPhoneState = 'android.permission.MODIFY_PHONE_STATE';

  /// Allows formatting file systems for removable storage.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.MOUNT_FORMAT_FILESYSTEMS"
  final String mountFormatFilesystems =
      'android.permission.MOUNT_FORMAT_FILESYSTEMS';

  /// Allows mounting and unmounting file systems for removable storage.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.MOUNT_UNMOUNT_FILESYSTEMS"
  final String mountUnmountFilesystems =
      'android.permission.MOUNT_UNMOUNT_FILESYSTEMS';

  /// Required to be able to advertise and connect to nearby devices via Wi-Fi.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.NEARBY_WIFI_DEVICES"
  final String nearbyWifiDevices = 'android.permission.NEARBY_WIFI_DEVICES';

  /// Allows applications to perform I/O operations over NFC.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.NFC"
  final String nfc = 'android.permission.NFC';

  /// Allows applications to receive NFC preferred payment service information.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.NFC_PREFERRED_PAYMENT_INFO"
  final String nfcPreferredPaymentInfo =
      'android.permission.NFC_PREFERRED_PAYMENT_INFO';

  /// Allows applications to receive NFC transaction events.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.NFC_TRANSACTION_EVENT"
  final String nfcTransactionEvent = 'android.permission.NFC_TRANSACTION_EVENT';

  /// Allows an application to modify any wifi configuration, even if created by another application. Once reconfigured the original creator cannot make any further modifications.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.OVERRIDE_WIFI_CONFIG"
  final String overrideWifiConfig = 'android.permission.OVERRIDE_WIFI_CONFIG';

  /// Allows an application to collect component usage statistics
  ///
  /// Declaring the permission implies intention to use the API and the user of the device can grant permission through the Settings application.
  ///
  /// Protection level: signature|privileged|development|appop|retailDemo
  ///
  /// Constant Value: "android.permission.PACKAGE_USAGE_STATS"
  final String packageUsageStats = 'android.permission.PACKAGE_USAGE_STATS';

  /// Constant Value: "android.permission.PERSISTENT_ACTIVITY"
  @Deprecated(
      'This constant was deprecated in API level 15. This functionality will be removed in the future; please do not use. Allow an application to make its activities persistent.')
  final String persistentActivity = 'android.permission.PERSISTENT_ACTIVITY';

  /// Allows an app to post notifications
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.POST_NOTIFICATIONS"
  final String postNotifications = 'android.permission.POST_NOTIFICATIONS';

  /// Allows an application to see the number being dialed during an outgoing call with the option to redirect the call to a different number or abort the call altogether.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.PROCESS_OUTGOING_CALLS"
  @Deprecated(
      'This constant was deprecated in API level 29. Applications should use CallRedirectionService instead of the Intent.ACTION_NEW_OUTGOING_CALL broadcast.')
  final String processOutgoingCalls =
      'android.permission.PROCESS_OUTGOING_CALLS';

  /// Allows an application to display its suggestions using the autofill framework.
  ///
  /// For now, this permission is only granted to the Browser application.
  ///
  /// Protection level: internal|role
  ///
  /// Constant Value: "android.permission.PROVIDE_OWN_AUTOFILL_SUGGESTIONS"
  final String provideOwnAutofillSuggestions =
      'android.permission.PROVIDE_OWN_AUTOFILL_SUGGESTIONS';

  /// Allows an application to be able to store and retrieve credentials from a remote device.
  ///
  /// Protection level: signature|privileged|role
  ///
  /// Constant Value: "android.permission.PROVIDE_REMOTE_CREDENTIALS"
  final String provideRemoteCredentials =
      'android.permission.PROVIDE_REMOTE_CREDENTIALS';

  /// Allows query of any normal app on the device, regardless of manifest declarations.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.QUERY_ALL_PACKAGES"
  final String queryAllPackages = 'android.permission.QUERY_ALL_PACKAGES';

  /// Allows an application to query over global data in AppSearch that's visible to the ASSISTANT role.
  ///
  /// Constant Value: "android.permission.READ_ASSISTANT_APP_SEARCH_DATA"
  final String readAssistantAppSearchData =
      'android.permission.READ_ASSISTANT_APP_SEARCH_DATA';

  /// Allows read only access to phone state with a non dangerous permission, including the information like cellular network type, software version.
  ///
  /// Constant Value: "android.permission.READ_BASIC_PHONE_STATE"
  final String readBasicPhoneState =
      'android.permission.READ_BASIC_PHONE_STATE';

  /// Allows an application to read the user's calendar data.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_CALENDAR"
  final String readCalendar = 'android.permission.READ_CALENDAR';

  /// Allows an application to read the user's call log.
  ///
  /// **Note**: If your app uses the READ_CONTACTS permission and both your minSdkVersion and targetSdkVersion values are set to 15 or lower, the system implicitly grants your app this permission. If you don't need this permission, be sure your targetSdkVersion is 16 or higher.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.READ_CALL_LOG"
  final String readCallLog = 'android.permission.READ_CALL_LOG';

  /// Allows an application to read the user's contacts data.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_CONTACTS"
  final String readContacts = 'android.permission.READ_CONTACTS';

  /// Allows an application to read from external storage.
  ///
  /// **Note**: Starting in API level 33, this permission has no effect. If your app accesses other apps' media files, request one or more of these permissions instead: READ_MEDIA_IMAGES, READ_MEDIA_VIDEO, READ_MEDIA_AUDIO. Learn more about the storage permissions that are associated with media files.
  ///
  /// This permission is enforced starting in API level 19. Before API level 19, this permission is not enforced and all apps still have access to read from external storage. You can test your app with the permission enforced by enabling Protect USB storage under Developer options in the Settings app on a device running Android 4.1 or higher.
  ///
  /// Also starting in API level 19, this permission is not required to read or write files in your application-specific directories returned by Context.getExternalFilesDir(String) and Context.getExternalCacheDir().
  ///
  /// Starting in API level 29, apps don't need to request this permission to access files in their app-specific directory on external storage, or their own files in the MediaStore. Apps shouldn't request this permission unless they need to access other apps' files in the MediaStore. Read more about these changes in the scoped storage section of the developer documentation.
  ///
  /// If both your minSdkVersion and targetSdkVersion values are set to 3 or lower, the system implicitly grants your app this permission. If you don't need this permission, be sure your targetSdkVersion is 4 or higher.
  ///
  /// This is a soft restricted permission which cannot be held by an app it its full form until the installer on record allowlists the permission. Specifically, if the permission is allowlisted the holder app can access external storage and the visual and aural media collections while if the permission is not allowlisted the holder app can only access to the visual and aural medial collections. Also the permission is immutably restricted meaning that the allowlist state can be specified only at install time and cannot change until the app is installed. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_EXTERNAL_STORAGE"
  final String readExternalStorage = 'android.permission.READ_EXTERNAL_STORAGE';

  /// Allows an application to query over global data in AppSearch that's visible to the HOME role.
  ///
  /// Constant Value: "android.permission.READ_HOME_APP_SEARCH_DATA"
  final String readHomeAppSearchData =
      'android.permission.READ_HOME_APP_SEARCH_DATA';

  /// Allows an application to retrieve the current state of keys and switches.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.READ_INPUT_STATE"
  @Deprecated(
      'This constant was deprecated in API level 16. The API that used this permission has been removed.')
  final String readInputState = 'android.permission.READ_INPUT_STATE';

  /// Allows an application to read the low-level system log files.
  ///
  /// Not for use by third-party applications, because Log entries can contain the user's private information.
  ///
  /// Constant Value: "android.permission.READ_LOGS"
  final String readLogs = 'android.permission.READ_LOGS';

  /// Allows an application to read audio files from external storage.
  ///
  /// This permission is enforced starting in API level Build.VERSION_CODES.TIRAMISU. An app which targets Build.VERSION_CODES.TIRAMISU or higher and needs to read audio files from external storage must hold this permission; READ_EXTERNAL_STORAGE is not required. For apps with a targetSdkVersion of Build.VERSION_CODES.S_V2 or lower, the READ_EXTERNAL_STORAGE permission is required, instead, to read audio files.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_MEDIA_AUDIO"
  final String readMediaAudio = 'android.permission.READ_MEDIA_AUDIO';

  /// Allows an application to read image files from external storage.
  ///
  /// This permission is enforced starting in API level Build.VERSION_CODES.TIRAMISU. An app which targets Build.VERSION_CODES.TIRAMISU or higher and needs to read image files from external storage must hold this permission; READ_EXTERNAL_STORAGE is not required. For apps with a targetSdkVersion of Build.VERSION_CODES.S_V2 or lower, the READ_EXTERNAL_STORAGE permission is required, instead, to read image files.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_MEDIA_IMAGES"
  final String readMediaImages = 'android.permission.READ_MEDIA_IMAGES';

  /// Allows an application to read video files from external storage.
  ///
  /// This permission is enforced starting in API level Build.VERSION_CODES.TIRAMISU. An app which targets Build.VERSION_CODES.TIRAMISU or higher and needs to read video files from external storage must hold this permission; READ_EXTERNAL_STORAGE is not required. For apps with a targetSdkVersion of Build.VERSION_CODES.S_V2 or lower, the READ_EXTERNAL_STORAGE permission is required, instead, to read video files.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_MEDIA_VIDEO"
  final String readMediaVideo = 'android.permission.READ_MEDIA_VIDEO';

  /// Allows an application to read image or video files from external storage that a user has selected via the permission prompt photo picker. Apps can check this permission to verify that a user has decided to use the photo picker, instead of granting access to READ_MEDIA_IMAGES or READ_MEDIA_VIDEO. It does not prevent apps from accessing the standard photo picker manually. This permission should be requested alongside READ_MEDIA_IMAGES and/or READ_MEDIA_VIDEO, depending on which type of media is desired.
  ///
  /// This permission will be automatically added to an app's manifest if the app requests READ_MEDIA_IMAGES, READ_MEDIA_VIDEO, or ACCESS_MEDIA_LOCATION regardless of target SDK. If an app does not request this permission, then the grant dialog will return `PERMISSION_GRANTED` for READ_MEDIA_IMAGES and/or READ_MEDIA_VIDEO, but the app will only have access to the media selected by the user. This false grant state will persist until the app goes into the background.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_MEDIA_VISUAL_USER_SELECTED"
  final String readMediaVisualUserSelected =
      'android.permission.READ_MEDIA_VISUAL_USER_SELECTED';

  /// Allows an application to read nearby streaming policy. The policy controls whether to allow the device to stream its notifications and apps to nearby devices. Applications that are not the device owner will need this permission to call DevicePolicyManager.getNearbyNotificationStreamingPolicy() or DevicePolicyManager.getNearbyAppStreamingPolicy().
  ///
  /// Constant Value: "android.permission.READ_NEARBY_STREAMING_POLICY"
  final String readNearbyStreamingPolicy =
      'android.permission.READ_NEARBY_STREAMING_POLICY';

  /// Allows read access to the device's phone number(s). This is a subset of the capabilities granted by READ_PHONE_STATE but is exposed to instant applications.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_PHONE_NUMBERS"
  final String readPhoneNumbers = 'android.permission.READ_PHONE_NUMBERS';

  /// Allows read only access to phone state, including the current cellular network information, the status of any ongoing calls, and a list of any PhoneAccounts registered on the device.
  ///
  /// **Note**: If both your minSdkVersion and targetSdkVersion values are set to 3 or lower, the system implicitly grants your app this permission. If you don't need this permission, be sure your targetSdkVersion is 4 or higher.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.READ_PHONE_STATE"
  final String readPhoneState = 'android.permission.READ_PHONE_STATE';

  /// Allows read only access to precise phone state. Allows reading of detailed information about phone state for special-use applications such as dialers, carrier applications, or ims applications.
  ///
  /// Constant Value: "android.permission.READ_PRECISE_PHONE_STATE"
  final String readPrecisePhoneState =
      'android.permission.READ_PRECISE_PHONE_STATE';

  /// Allows an application to read SMS messages.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.READ_SMS"
  final String readSms = 'android.permission.READ_SMS';

  /// Allows applications to read the sync settings.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.READ_SYNC_SETTINGS"
  final String readSyncSettings = 'android.permission.READ_SYNC_SETTINGS';

  /// Allows applications to read the sync stats.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.READ_SYNC_STATS"
  final String readSyncStats = 'android.permission.READ_SYNC_STATS';

  /// Allows an application to read voicemails in the system.
  ///
  /// Protection level: signature|privileged|role
  ///
  /// Constant Value: "com.android.voicemail.permission.READ_VOICEMAIL"
  final String readVoicemail =
      'com.android.voicemail.permission.READ_VOICEMAIL';

  /// Required to be able to reboot the device.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.REBOOT"
  final String reboot = 'android.permission.REBOOT';

  /// Allows an application to receive the Intent.ACTION_BOOT_COMPLETED that is broadcast after the system finishes booting. If you don't request this permission, you will not receive the broadcast at that time. Though holding this permission does not have any security implications, it can have a negative impact on the user experience by increasing the amount of time it takes the system to start and allowing applications to have themselves running without the user being aware of them. As such, you must explicitly declare your use of this facility to make that visible to the user.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.RECEIVE_BOOT_COMPLETED"
  final String receiveBootCompleted =
      'android.permission.RECEIVE_BOOT_COMPLETED';

  /// Allows an application to monitor incoming MMS messages.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.RECEIVE_MMS"
  final String receiveMms = 'android.permission.RECEIVE_MMS';

  /// Allows an application to receive SMS messages.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.RECEIVE_SMS"
  final String receiveSms = 'android.permission.RECEIVE_SMS';

  /// Allows an application to receive WAP push messages.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.RECEIVE_WAP_PUSH"
  final String receiveWapPush = 'android.permission.RECEIVE_WAP_PUSH';

  /// Allows an application to record audio.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.RECORD_AUDIO"
  final String recordAudio = 'android.permission.RECORD_AUDIO';

  /// Allows an application to change the Z-order of tasks.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REORDER_TASKS"
  final String reorderTasks = 'android.permission.REORDER_TASKS';

  /// Allows application to request to be associated with a virtual display capable of streaming Android applications (AssociationRequest.DEVICE_PROFILE_APP_STREAMING) by CompanionDeviceManager.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_PROFILE_APP_STREAMING"
  final String requestCompanionProfileAppStreaming =
      'android.permission.REQUEST_COMPANION_PROFILE_APP_STREAMING';

  /// Allows application to request to be associated with a vehicle head unit capable of automotive projection (AssociationRequest.DEVICE_PROFILE_AUTOMOTIVE_PROJECTION) by CompanionDeviceManager.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_PROFILE_AUTOMOTIVE_PROJECTION"
  final String requestCompanionProfileAutomotiveProjection =
      'android.permission.REQUEST_COMPANION_PROFILE_AUTOMOTIVE_PROJECTION';

  /// Allows application to request to be associated with a computer to share functionality and/or data with other devices, such as notifications, photos and media (AssociationRequest.DEVICE_PROFILE_COMPUTER) by CompanionDeviceManager.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_PROFILE_COMPUTER"
  final String requestCompanionProfileComputer =
      'android.permission.REQUEST_COMPANION_PROFILE_COMPUTER';

  /// Allows app to request to be associated with a device via CompanionDeviceManager as "glasses"
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_PROFILE_GLASSES"
  final String requestCompanionProfileGlasses =
      'android.permission.REQUEST_COMPANION_PROFILE_GLASSES';

  /// Allows application to request to stream content from an Android host to a nearby device (AssociationRequest.DEVICE_PROFILE_NEARBY_DEVICE_STREAMING) by CompanionDeviceManager.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_PROFILE_NEARBY_DEVICE_STREAMING"
  final String requestCompanionProfileNearbyDeviceStreaming =
      'android.permission.REQUEST_COMPANION_PROFILE_NEARBY_DEVICE_STREAMING';

  /// Allows app to request to be associated with a device via CompanionDeviceManager as a "watch"
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_PROFILE_WATCH"
  final String requestCompanionProfileWatch =
      'android.permission.REQUEST_COMPANION_PROFILE_WATCH';

  /// Allows a companion app to run in the background. This permission implies REQUEST_COMPANION_START_FOREGROUND_SERVICES_FROM_BACKGROUND, and allows to start a foreground service from the background. If an app does not have to run in the background, but only needs to start a foreground service from the background, consider using REQUEST_COMPANION_START_FOREGROUND_SERVICES_FROM_BACKGROUND, which is less powerful.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_RUN_IN_BACKGROUND"
  final String requestCompanionRunInBackground =
      'android.permission.REQUEST_COMPANION_RUN_IN_BACKGROUND';

  /// Allows an application to create a "self-managed" association.
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_SELF_MANAGED"
  final String requestCompanionSelfManaged =
      'android.permission.REQUEST_COMPANION_SELF_MANAGED';

  /// Allows a companion app to start a foreground service from the background.
  ///
  /// Protection level: normal
  ///
  /// See also:
  ///
  /// REQUEST_COMPANION_RUN_IN_BACKGROUND
  /// Constant Value: "android.permission.REQUEST_COMPANION_START_FOREGROUND_SERVICES_FROM_BACKGROUND"
  final String requestCompanionStartForegroundServicesFromBackground =
      'android.permission.REQUEST_COMPANION_START_FOREGROUND_SERVICES_FROM_BACKGROUND';

  /// Allows a companion app to use data in the background.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_COMPANION_USE_DATA_IN_BACKGROUND"
  final String requestCompanionUseDataInBackground =
      'android.permission.REQUEST_COMPANION_USE_DATA_IN_BACKGROUND';

  /// Allows an application to request deleting packages. Apps targeting APIs Build.VERSION_CODES.P or greater must hold this permission in order to use Intent.ACTION_UNINSTALL_PACKAGE or PackageInstaller.uninstall(VersionedPackage, IntentSender).
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_DELETE_PACKAGES"
  final String requestDeletePackages =
      'android.permission.REQUEST_DELETE_PACKAGES';

  /// Permission an application must hold in order to use Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"
  final String requestIgnoreBatteryOptimizations =
      'android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS';

  /// Allows an application to request installing packages. Apps targeting APIs greater than 25 must hold this permission in order to use Intent.ACTION_INSTALL_PACKAGE.
  ///
  /// Protection level: signature
  ///
  /// Constant Value: "android.permission.REQUEST_INSTALL_PACKAGES"
  final String requestInstallPackages =
      'android.permission.REQUEST_INSTALL_PACKAGES';

  /// Allows an application to subscribe to notifications about the presence status change of their associated companion device
  ///
  /// Constant Value: "android.permission.REQUEST_OBSERVE_COMPANION_DEVICE_PRESENCE"
  final String requestObserveCompanionDevicePresence =
      'android.permission.REQUEST_OBSERVE_COMPANION_DEVICE_PRESENCE';

  /// Allows an application to request the screen lock complexity and prompt users to update the screen lock to a certain complexity level.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.REQUEST_PASSWORD_COMPLEXITY"
  final String requestPasswordComplexity =
      'android.permission.REQUEST_PASSWORD_COMPLEXITY';

  /// Constant Value: "android.permission.RESTART_PACKAGES"
  @Deprecated(
      'This constant was deprecated in API level 15. The ActivityManager.restartPackage(String) API is no longer supported.')
  final String restartPackages = 'android.permission.RESTART_PACKAGES';

  /// Allows applications to use the user-initiated jobs API. For more details see JobInfo.Builder.setUserInitiated(boolean).
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.RUN_USER_INITIATED_JOBS"
  final String runUserInitiatedJobs =
      'android.permission.RUN_USER_INITIATED_JOBS';

  /// Allows applications to use exact alarm APIs.
  ///
  /// This is a special access permission that can be revoked by the system or the user. It should only be used to enable user-facing features that require exact alarms. For more details, please go through the associated developer docs.
  ///
  /// Apps need to target API Build.VERSION_CODES.S or above to be able to request this permission. Note that apps targeting lower API levels do not need this permission to use exact alarm APIs.
  ///
  /// Apps that hold this permission and target API Build.VERSION_CODES.TIRAMISU and below always stay in the WORKING_SET or lower standby bucket.
  ///
  /// If your app relies on exact alarms for core functionality, it can instead request USE_EXACT_ALARM once it targets API Build.VERSION_CODES.TIRAMISU. All apps using exact alarms for secondary features (which should still be user facing) should continue using this permission.
  ///
  /// Protection level: signature|privileged|appop
  ///
  /// Constant Value: "android.permission.SCHEDULE_EXACT_ALARM"
  final String scheduleExactAlarm = 'android.permission.SCHEDULE_EXACT_ALARM';

  /// Allows an application (Phone) to send a request to other applications to handle the respond-via-message action during incoming calls.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SEND_RESPOND_VIA_MESSAGE"
  final String sendRespondViaMessage =
      'android.permission.SEND_RESPOND_VIA_MESSAGE';

  /// Allows an application to send SMS messages.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.SEND_SMS"
  final String sendSms = 'android.permission.SEND_SMS';

  /// Allows an application to broadcast an Intent to set an alarm for the user.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "com.android.alarm.permission.SET_ALARM"
  final String setAlarm = 'com.android.alarm.permission.SET_ALARM';

  /// Allows an application to control whether activities are immediately finished when put in the background.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SET_ALWAYS_FINISH"
  final String setAlwaysFinish = 'android.permission.SET_ALWAYS_FINISH';

  /// Modify the global animation scaling factor.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SET_ANIMATION_SCALE"
  final String setAnimationScale = 'android.permission.SET_ANIMATION_SCALE';

  /// Configure an application for debugging.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SET_DEBUG_APP"
  final String setDebugApp = 'android.permission.SET_DEBUG_APP';

  /// Constant Value: "android.permission.SET_PREFERRED_APPLICATIONS"
  @Deprecated(
      'This constant was deprecated in API level 15. No longer useful, see PackageManager.addPackageToPreferred(String) for details.')
  final String setPreferredApplications =
      'android.permission.SET_PREFERRED_APPLICATIONS';

  /// Allows an application to set the maximum number of (not needed) application processes that can be running.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SET_PROCESS_LIMIT"
  final String setProcessLimit = 'android.permission.SET_PROCESS_LIMIT';

  /// Allows applications to set the system time directly.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SET_TIME"
  final String setTime = 'android.permission.SET_TIME';

  /// Allows applications to set the system time zone directly.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SET_TIME_ZONE"
  final String setTimeZone = 'android.permission.SET_TIME_ZONE';

  /// Allows applications to set the wallpaper.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.SET_WALLPAPER"
  final String setWallpaper = 'android.permission.SET_WALLPAPER';

  /// Allows applications to set the wallpaper hints.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.SET_WALLPAPER_HINTS"
  final String setWallpaperHints = 'android.permission.SET_WALLPAPER_HINTS';

  /// Allow an application to request that a signal be sent to all persistent processes.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.SIGNAL_PERSISTENT_PROCESSES"
  final String signalPersistentProcesses =
      'android.permission.SIGNAL_PERSISTENT_PROCESSES';

  /// Allows financial apps to read filtered sms messages. Protection level: signature|appop
  ///
  /// Constant Value: "android.permission.SMS_FINANCIAL_TRANSACTIONS"
  @Deprecated(
      'This constant was deprecated in API level 31. The API that used this permission is no longer functional.')
  final String smsFinancialTransactions =
      'android.permission.SMS_FINANCIAL_TRANSACTIONS';

  /// Allows an application to start foreground services from the background at any time. This permission is not for use by third-party applications, with the only exception being if the app is the default SMS app. Otherwise, it's only usable by privileged apps, app verifier app, and apps with any of the EMERGENCY or SYSTEM GALLERY roles.
  ///
  /// Constant Value: "android.permission.START_FOREGROUND_SERVICES_FROM_BACKGROUND"
  final String startForegroundServicesFromBackground =
      'android.permission.START_FOREGROUND_SERVICES_FROM_BACKGROUND';

  /// Allows the holder to start the screen with a list of app features.
  ///
  /// Protection level: signature|installer
  ///
  /// Constant Value: "android.permission.START_VIEW_APP_FEATURES"
  final String startViewAppFeatures =
      'android.permission.START_VIEW_APP_FEATURES';

  /// Allows the holder to start the permission usage screen for an app.
  ///
  /// Protection level: signature|installer
  ///
  /// Constant Value: "android.permission.START_VIEW_PERMISSION_USAGE"
  final String startViewPermissionUsage =
      'android.permission.START_VIEW_PERMISSION_USAGE';

  /// Allows an application to open, close, or disable the status bar and its icons.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.STATUS_BAR"
  final String statusBar = 'android.permission.STATUS_BAR';

  /// Allows an application to subscribe to keyguard locked (i.e., showing) state.
  ///
  /// Protection level: signature|role
  ///
  /// Intended for use by ROLE_ASSISTANT and signature apps only.
  ///
  /// Constant Value: "android.permission.SUBSCRIBE_TO_KEYGUARD_LOCKED_STATE"
  final String subscribeToKeyguardLockedState =
      'android.permission.SUBSCRIBE_TO_KEYGUARD_LOCKED_STATE';

  /// Allows an app to create windows using the type WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY, shown on top of all other apps. Very few apps should use this permission; these windows are intended for system-level interaction with the user.
  ///
  /// **Note**: If the app targets API level 23 or higher, the app user must explicitly grant this permission to the app through a permission management screen. The app requests the user's approval by sending an intent with action Settings.ACTION_MANAGE_OVERLAY_PERMISSION. The app can check whether it has this authorization by calling Settings.canDrawOverlays().
  ///
  /// Protection level: signature|setup|appop|installer|pre23|development
  ///
  /// Constant Value: "android.permission.SYSTEM_ALERT_WINDOW"
  final String systemAlertWindow = 'android.permission.SYSTEM_ALERT_WINDOW';

  /// Allows using the device's IR transmitter, if available.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.TRANSMIT_IR"
  final String transmitIr = 'android.permission.TRANSMIT_IR';

  /// Allows an app to turn on the screen on, e.g. with PowerManager.ACQUIRE_CAUSES_WAKEUP.
  ///
  /// Intended to only be used by home automation apps.
  ///
  /// Constant Value: "android.permission.TURN_SCREEN_ON"
  final String turnScreenOn = 'android.permission.TURN_SCREEN_ON';

  /// Constant Value: "com.android.launcher.permission.UNINSTALL_SHORTCUT"
  @Deprecated(
      'Don\'t use this permission in your app. This permission is no longer supported.')
  final String uninstallShortcut =
      'com.android.launcher.permission.UNINSTALL_SHORTCUT';

  /// Allows an application to update device statistics.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.UPDATE_DEVICE_STATS"
  final String updateDeviceStats = 'android.permission.UPDATE_DEVICE_STATS';

  /// Allows an application to indicate via PackageInstaller.SessionParams.setRequireUserAction(int) that user action should not be required for an app update.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.UPDATE_PACKAGES_WITHOUT_USER_ACTION"
  final String updatePackagesWithoutUserAction =
      'android.permission.UPDATE_PACKAGES_WITHOUT_USER_ACTION';

  /// Allows an app to use device supported biometric modalities.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.USE_BIOMETRIC"
  final String useBiometric = 'android.permission.USE_BIOMETRIC';

  /// Allows apps to use exact alarms just like with SCHEDULE_EXACT_ALARM but without needing to request this permission from the user.
  ///
  /// This is only intended for use by apps that rely on exact alarms for their core functionality. You should continue using SCHEDULE_EXACT_ALARM if your app needs exact alarms for a secondary feature that users may or may not use within your app.
  ///
  /// Keep in mind that this is a powerful permission and app stores may enforce policies to audit and review the use of this permission. Such audits may involve removal from the app store if the app is found to be misusing this permission.
  ///
  /// Apps need to target API Build.VERSION_CODES.TIRAMISU or above to be able to request this permission. Note that only one of USE_EXACT_ALARM or SCHEDULE_EXACT_ALARM should be requested on a device. If your app is already using SCHEDULE_EXACT_ALARM on older SDKs but needs USE_EXACT_ALARM on SDK 33 and above, then SCHEDULE_EXACT_ALARM should be declared with a max-sdk attribute, like:
  ///
  /// ```
  ///  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"
  ///  	 android:maxSdkVersion="32" />
  /// ```
  ///
  /// Apps that hold this permission, always stay in the WORKING_SET or lower standby bucket.
  ///
  /// Constant Value: "android.permission.USE_EXACT_ALARM"
  final String useExactAlarm = 'android.permission.USE_EXACT_ALARM';

  /// Allows an app to use fingerprint hardware.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.USE_FINGERPRINT"
  @Deprecated(
      'This constant was deprecated in API level 28. Applications should request USE_BIOMETRIC instead')
  final String useFingerprint = 'android.permission.USE_FINGERPRINT';

  /// Required for apps targeting Build.VERSION_CODES.Q that want to use notification full screen intents.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.USE_FULL_SCREEN_INTENT"
  final String useFullScreenIntent =
      'android.permission.USE_FULL_SCREEN_INTENT';

  /// Allows to read device identifiers and use ICC based authentication like EAP-AKA. Often required in authentication to access the carrier's server and manage services of the subscriber.
  ///
  /// Protection level: signature|appop
  ///
  /// Constant Value: "android.permission.USE_ICC_AUTH_WITH_DEVICE_IDENTIFIER"
  final String useIccAuthWithDeviceIdentifier =
      'android.permission.USE_ICC_AUTH_WITH_DEVICE_IDENTIFIER';

  /// Allows an application to use SIP service.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.USE_SIP"
  final String useSip = 'android.permission.USE_SIP';

  /// Required to be able to range to devices using ultra-wideband.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.UWB_RANGING"
  final String uwbRanging = 'android.permission.UWB_RANGING';

  /// Allows access to the vibrator.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.VIBRATE"
  final String vibrate = 'android.permission.VIBRATE';

  /// Allows using PowerManager WakeLocks to keep processor from sleeping or screen from dimming.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.WAKE_LOCK"
  final String wakeLock = 'android.permission.WAKE_LOCK';

  /// Allows applications to write the apn settings and read sensitive fields of an existing apn settings like user and password.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.WRITE_APN_SETTINGS"
  final String writeApnSettings = 'android.permission.WRITE_APN_SETTINGS';

  /// Allows an application to write the user's calendar data.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.WRITE_CALENDAR"
  final String writeCalendar = 'android.permission.WRITE_CALENDAR';

  /// Allows an application to write and read the user's call log data.
  ///
  /// **Note**: If your app uses the WRITE_CONTACTS permission and both your minSdkVersion and targetSdkVersion values are set to 15 or lower, the system implicitly grants your app this permission. If you don't need this permission, be sure your targetSdkVersion is 16 or higher.
  ///
  /// Protection level: dangerous
  ///
  /// This is a hard restricted permission which cannot be held by an app until the installer on record allowlists the permission. For more details see PackageInstaller.SessionParams.setWhitelistedRestrictedPermissions(Set).
  ///
  /// Constant Value: "android.permission.WRITE_CALL_LOG"
  final String writeCallLog = 'android.permission.WRITE_CALL_LOG';

  /// Allows an application to write the user's contacts data.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.WRITE_CONTACTS"
  final String writeContacts = 'android.permission.WRITE_CONTACTS';

  /// Allows an application to write to external storage.
  ///
  /// **Note**: If your app targets Build.VERSION_CODES.R or higher, this permission has no effect.
  ///
  /// If your app is on a device that runs API level 19 or higher, you don't need to declare this permission to read and write files in your application-specific directories returned by Context.getExternalFilesDir(String) and Context.getExternalCacheDir().
  ///
  /// Learn more about how to modify media files that your app doesn't own, and how to modify non-media files that your app doesn't own.
  ///
  /// If your app is a file manager and needs broad access to external storage files, then the system must place your app on an allowlist so that you can successfully request the MANAGE_EXTERNAL_STORAGE permission. Learn more about the appropriate use cases for minSdkVersion and targetSdkVersion values are set to 3 or lower, the system implicitly grants your app this permission. If you don't need this permission, be sure your targetSdkVersion is 4 or higher.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission.WRITE_EXTERNAL_STORAGE"
  final String writeExternalStorage =
      'android.permission.WRITE_EXTERNAL_STORAGE';

  /// Allows an application to modify the Google service map.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.WRITE_GSERVICES"
  final String writeGservices = 'android.permission.WRITE_GSERVICES';

  /// Allows an application to read or write the secure system settings.
  ///
  /// Not for use by third-party applications.
  ///
  /// Constant Value: "android.permission.WRITE_SECURE_SETTINGS"
  final String writeSecureSettings = 'android.permission.WRITE_SECURE_SETTINGS';

  /// Allows an application to read or write the system settings.
  ///
  /// **Note**: If the app targets API level 23 or higher, the app user must explicitly grant this permission to the app through a permission management screen. The app requests the user's approval by sending an intent with action Settings.ACTION_MANAGE_WRITE_SETTINGS. The app can check whether it has this authorization by calling Settings.System.canWrite().
  ///
  /// Protection level: signature|preinstalled|appop|pre23
  ///
  /// Constant Value: "android.permission.WRITE_SETTINGS"
  final String writeSettings = 'android.permission.WRITE_SETTINGS';

  /// Allows applications to write the sync settings.
  ///
  /// Protection level: normal
  ///
  /// Constant Value: "android.permission.WRITE_SYNC_SETTINGS"
  final String writeSyncSettings = 'android.permission.WRITE_SYNC_SETTINGS';

  /// Allows an application to modify and remove existing voicemails in the system.
  ///
  /// Protection level: signature|privileged|role
  ///
  /// Constant Value: "com.android.voicemail.permission.WRITE_VOICEMAIL"
  final String writeVoicemail =
      'com.android.voicemail.permission.WRITE_VOICEMAIL';
}

/// See https://developer.android.com/reference/android/Manifest.permission_group.
class _ManifestPermissionGroup {
  const _ManifestPermissionGroup();

  /// Used for permissions that are associated with activity recognition.
  ///
  /// Constant Value: "android.permission-group.ACTIVITY_RECOGNITION"
  final String activityRecognition =
      'android.permission-group.ACTIVITY_RECOGNITION';

  /// Used for runtime permissions related to user's calendar.
  ///
  /// Constant Value: "android.permission-group.CALENDAR"
  final String calendar = 'android.permission-group.CALENDAR';

  /// Used for permissions that are associated telephony features.
  ///
  /// Constant Value: "android.permission-group.CALL_LOG"
  final String callLog = 'android.permission-group.CALL_LOG';

  /// Used for permissions that are associated with accessing camera or capturing images/video from the device.
  ///
  /// Constant Value: "android.permission-group.CAMERA"
  final String camera = 'android.permission-group.CAMERA';

  /// Used for runtime permissions related to contacts and profiles on this device.
  ///
  /// Constant Value: "android.permission-group.CONTACTS"
  final String contacts = 'android.permission-group.CONTACTS';

  /// Used for permissions that allow accessing the device location.
  ///
  /// Constant Value: "android.permission-group.LOCATION"
  final String location = 'android.permission-group.LOCATION';

  /// Used for permissions that are associated with accessing microphone audio from the device. Note that phone calls also capture audio but are in a separate (more visible) permission group.
  ///
  /// Constant Value: "android.permission-group.MICROPHONE"
  final String microphone = 'android.permission-group.MICROPHONE';

  /// Required to be able to discover and connect to nearby Bluetooth devices.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission-group.NEARBY_DEVICES"
  final String nearbyDevices = 'android.permission-group.NEARBY_DEVICES';

  /// Used for permissions that are associated with posting notifications
  ///
  /// Constant Value: "android.permission-group.NOTIFICATIONS"
  final String notifications = 'android.permission-group.NOTIFICATIONS';

  /// Used for permissions that are associated telephony features.
  ///
  /// Constant Value: "android.permission-group.PHONE"
  final String phone = 'android.permission-group.PHONE';

  /// Required to be able to read audio files from shared storage.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission-group.READ_MEDIA_AURAL"
  final String readMediaAural = 'android.permission-group.READ_MEDIA_AURAL';

  /// Required to be able to read image and video files from shared storage.
  ///
  /// Protection level: dangerous
  ///
  /// Constant Value: "android.permission-group.READ_MEDIA_VISUAL"
  final String readMediaVisual = 'android.permission-group.READ_MEDIA_VISUAL';

  /// Used for permissions that are associated with accessing body or environmental sensors.
  ///
  /// Constant Value: "android.permission-group.SENSORS"
  final String sensors = 'android.permission-group.SENSORS';

  /// Used for runtime permissions related to user's SMS messages.
  ///
  /// Constant Value: "android.permission-group.SMS"
  final String sms = 'android.permission-group.SMS';

  /// Used for runtime permissions related to the shared external storage.
  ///
  /// Constant Value: "android.permission-group.STORAGE"
  final String storage = 'android.permission-group.STORAGE';
}
