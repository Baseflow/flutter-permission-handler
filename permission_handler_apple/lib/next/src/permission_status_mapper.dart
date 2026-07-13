import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'pigeon/apple_permissions.g.dart';

/// Maps [AVAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapAVAuthorizationStatus(AVAuthorizationStatus status) {
  switch (status) {
    case AVAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case AVAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case AVAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case AVAuthorizationStatus.authorized:
      return PermissionStatus.granted;
  }
}

/// Maps [PHAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapPHAuthorizationStatus(PHAuthorizationStatus status) {
  switch (status) {
    case PHAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case PHAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case PHAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case PHAuthorizationStatus.authorized:
      return PermissionStatus.granted;
    case PHAuthorizationStatus.limited:
      return PermissionStatus.limited;
  }
}

/// Maps [EKAuthorizationStatus] to [PermissionStatus].
///
/// [isWriteOnlyRequest] controls how [EKAuthorizationStatus.writeOnly] is
/// interpreted.
PermissionStatus mapEKAuthorizationStatus(
  EKAuthorizationStatus status, {
  required bool isWriteOnlyRequest,
}) {
  switch (status) {
    case EKAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case EKAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case EKAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case EKAuthorizationStatus.authorized:
    case EKAuthorizationStatus.fullAccess:
      return PermissionStatus.granted;
    case EKAuthorizationStatus.writeOnly:
      return isWriteOnlyRequest
          ? PermissionStatus.granted
          : PermissionStatus.denied;
  }
}

/// Maps [CNAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapCNAuthorizationStatus(CNAuthorizationStatus status) {
  switch (status) {
    case CNAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case CNAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case CNAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case CNAuthorizationStatus.authorized:
      return PermissionStatus.granted;
    case CNAuthorizationStatus.limited:
      return PermissionStatus.limited;
  }
}

/// Maps [UNAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapUNAuthorizationStatus(UNAuthorizationStatus status) {
  switch (status) {
    case UNAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case UNAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case UNAuthorizationStatus.authorized:
      return PermissionStatus.granted;
    case UNAuthorizationStatus.provisional:
      return PermissionStatus.provisional;
    case UNAuthorizationStatus.ephemeral:
      return PermissionStatus.granted;
  }
}

/// Maps [CBManagerAuthorization] to [PermissionStatus].
PermissionStatus mapCBManagerAuthorization(CBManagerAuthorization status) {
  switch (status) {
    case CBManagerAuthorization.notDetermined:
      return PermissionStatus.denied;
    case CBManagerAuthorization.restricted:
      return PermissionStatus.restricted;
    case CBManagerAuthorization.denied:
      return PermissionStatus.permanentlyDenied;
    case CBManagerAuthorization.allowedAlways:
      return PermissionStatus.granted;
  }
}

/// Maps [CMAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapCMAuthorizationStatus(CMAuthorizationStatus status) {
  switch (status) {
    case CMAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case CMAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case CMAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case CMAuthorizationStatus.authorized:
      return PermissionStatus.granted;
  }
}

/// Maps [SFSpeechRecognizerAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapSFSpeechAuthorizationStatus(
  SFSpeechRecognizerAuthorizationStatus status,
) {
  switch (status) {
    case SFSpeechRecognizerAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case SFSpeechRecognizerAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case SFSpeechRecognizerAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case SFSpeechRecognizerAuthorizationStatus.authorized:
      return PermissionStatus.granted;
  }
}

/// Maps [MPMediaLibraryAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapMPMediaAuthorizationStatus(
  MPMediaLibraryAuthorizationStatus status,
) {
  switch (status) {
    case MPMediaLibraryAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case MPMediaLibraryAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case MPMediaLibraryAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case MPMediaLibraryAuthorizationStatus.authorized:
      return PermissionStatus.granted;
  }
}

/// Maps [ATTrackingManagerAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapATTAuthorizationStatus(
  ATTrackingManagerAuthorizationStatus status,
) {
  switch (status) {
    case ATTrackingManagerAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case ATTrackingManagerAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case ATTrackingManagerAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case ATTrackingManagerAuthorizationStatus.authorized:
      return PermissionStatus.granted;
  }
}

/// Maps [INSiriAuthorizationStatus] to [PermissionStatus].
PermissionStatus mapINSiriAuthorizationStatus(
    INSiriAuthorizationStatus status) {
  switch (status) {
    case INSiriAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case INSiriAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case INSiriAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case INSiriAuthorizationStatus.authorized:
      return PermissionStatus.granted;
  }
}

/// Maps [CLAuthorizationStatus] to [PermissionStatus].
///
/// [isAlwaysRequest] is `true` when checking [Permission.locationAlways].
PermissionStatus mapCLAuthorizationStatus(
  CLAuthorizationStatus status, {
  required bool isAlwaysRequest,
}) {
  if (isAlwaysRequest) {
    switch (status) {
      case CLAuthorizationStatus.notDetermined:
        return PermissionStatus.denied;
      case CLAuthorizationStatus.restricted:
        return PermissionStatus.restricted;
      case CLAuthorizationStatus.authorizedWhenInUse:
      case CLAuthorizationStatus.denied:
        return PermissionStatus.permanentlyDenied;
      case CLAuthorizationStatus.authorizedAlways:
        return PermissionStatus.granted;
    }
  }

  switch (status) {
    case CLAuthorizationStatus.notDetermined:
      return PermissionStatus.denied;
    case CLAuthorizationStatus.restricted:
      return PermissionStatus.restricted;
    case CLAuthorizationStatus.denied:
      return PermissionStatus.permanentlyDenied;
    case CLAuthorizationStatus.authorizedWhenInUse:
    case CLAuthorizationStatus.authorizedAlways:
      return PermissionStatus.granted;
  }
}

/// Maps [UIBackgroundRefreshStatus] to [PermissionStatus].
PermissionStatus mapUIBackgroundRefreshStatus(
    UIBackgroundRefreshStatus status) {
  switch (status) {
    case UIBackgroundRefreshStatus.denied:
      return PermissionStatus.denied;
    case UIBackgroundRefreshStatus.restricted:
      return PermissionStatus.restricted;
    case UIBackgroundRefreshStatus.available:
      return PermissionStatus.granted;
  }
}
