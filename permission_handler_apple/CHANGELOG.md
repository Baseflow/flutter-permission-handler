## 9.6.1

- Fixes small mistakes in the README.md documentation.

## 9.6.0

- Adds opt-in per-flavor permissions for Swift Package Manager builds. An app can declare a
  `permission_handler.yaml` next to its `pubspec.yaml` mapping each flavor to the `Info.plist` that
  defines it, and only the selected flavor's permissions are compiled in — a permission declared by
  `dev` can no longer reach a `prod` binary. Without this file the previous behaviour is unchanged.
  This is a Swift Package Manager feature: CocoaPods builds set the `PERMISSION_*` macros from the
  `Podfile` and are unaffected, including by the build phase below.
- Adds `dart run permission_handler_apple:select <flavor>`, which records the active flavor and
  clears the caches that would otherwise keep serving the previously resolved permissions. Xcode
  does not re-evaluate a package manifest when an environment variable or the selection changes, so
  this step is required when switching flavors. `select` is also the only YAML reader: a Swift
  package manifest cannot parse YAML, so the command translates the config into a generated
  `ios/Flutter/permission_handler.resolved.json` (gitignore it) that the manifest and the build
  phase read with their native JSON parsers. A translation older than the YAML fails the build
  instead of shipping stale permissions.
- Adds `tool/verify_flavor_selection.sh`, a build phase for the app target that fails the build when
  the selected flavor does not match the configuration being built. A package manifest is evaluated
  once and cannot detect that its own result went stale, so this is what catches a forgotten
  `select`. It is a no-op without a `permission_handler.yaml` and on CocoaPods builds.
- Adds the `PERMISSION_HANDLER_FLAVOR` and `PERMISSION_HANDLER_CONFIG` environment variables to set
  the active flavor and the configuration file location explicitly.
- `select` validates the configuration up front and refuses anything ambiguous: a build
  configuration claimed by more than one flavor, a `configurations` that is not a list, a
  non-string flavor name, or a `strict` that is not a boolean. Being the only reader of the YAML,
  it is the only place where these can be reported at all.

## 9.5.1

- Fixes the Swift Package Manager permission auto-detection, which failed to find the host app's
  `Info.plist` and silently compiled out every permission. Apps hit this in two ways: the manifest
  only ever looked at `ios/Runner/Info.plist`, so build-configuration or flavor specific plists such
  as `Info-Debug.plist` were never seen ([#1548](https://github.com/Baseflow/flutter-permission-handler/issues/1548)),
  and the app-root lookup could walk past the app entirely. `Info.plist` locations are now resolved
  from `INFOPLIST_FILE` in the Xcode project and any `.xcconfig` files, with a scan of `ios/` as a
  fallback, and the usage description keys found across them are merged.
- Adds the `PERMISSION_HANDLER_INFO_PLIST` environment variable, which points the manifest at one or
  more `Info.plist` files and replaces automatic discovery. This is required for builds started from
  Xcode.app, which run with `/` as their working directory and cannot be detected automatically.
- Adds the `PERMISSION_HANDLER_VERBOSE` environment variable, which logs the app root, the
  `Info.plist` files used, and the resolved `PERMISSION_*` macros.
- Emits a warning when no `Info.plist` can be located, instead of silently disabling every
  permission. Note that Xcode discards Swift package manifest output, so this warning is only
  visible through the `swift package` command line.

## 9.5.0

- Adds support for the new Android 17 permission `ACCESS_LOCAL_NETWORK`.

## 9.4.10

- Fixed Info.plist lookup in Package.swift to auto-apply permissions.
- You may see build log "Plugin permission_handler_apple has a Package.swift for ios but is missing a dependency on FlutterFramework". FlutterFramework hasn't been added intentionally because it requires to bump flutter constraint to >=3.41.0.

## 9.4.9

- Rewrites copyleft code from stackoverflow to fix compliance issue.

## 9.4.8

- Adds Swift Package Manager (SPM) support for Flutter 3.24+. Permissions are
  enabled automatically based on usage description keys present in `Info.plist`
  — no additional configuration required beyond clearing DerivedData once after
  changes: `rm -rf ~/Library/Developer/Xcode/DerivedData`.
- Moves ObjC sources to SPM-compatible layout (`Sources/permission_handler_apple/`).
  CocoaPods continues to work unchanged.
- Bumps minimum iOS deployment target to 12.0.

## 9.4.7

- Increases minimum supported Flutter version to 3.3.0, and removes code only
  required for iOS versions prior to iOS 11.

## 9.4.6

- Adds the ability to handle `CNAuthorizationStatusLimited` introduced in ios18

## 9.4.5

- Fixes issue #1002, Xcode warning of the unresponsive of main thread when checking isLocationEnabled.
  
## 9.4.4

- Fixes potentially-nil return type of EventPermissionStrategy#getEntityType.
- - Fixes typo in comment for full calendar access.

## 9.4.3

- Adds the `PERMISSION_LOCATION_WHENINUSE` macro, which can be used instead of
the `PERMISSION_LOCATION` macro, and exclusively enables the `requestWhenInUseAuthorization`
and remove the `requestAlwaysAuthorization` when requesting location permission.
- Improves error handling when `Info.plist` doesn't contain the correct declarations.
- Adds support for the `NSLocationAlwaysAndWhenInUseUsageDescription` property list
key.

## 9.4.2

- Updates the privacy manifest to include the use of the `NSUserDefaults` API. 
The permission_handler stores a boolean value to track if permission to always 
access the device location has been requested.

## 9.4.1

- Adds empty privacy manifest.

## 9.4.0

- Adds a new permission `Permission.backgroundRefresh` to check the background refresh permission status.

## 9.3.1

- Updates plist key from `NSPhotoLibraryUsageDescription` to `NSPhotoLibraryAddUsageDescription`.

## 9.3.0

- Adds support to request authorization to access SiriKit via the `Permission.assistant` permission.

## 9.2.0

- Adds the support for `Permission.calendarWriteOnly` and `Permission.calendarFullAccess` permissions which are introduced in iOS 17+.

## 9.1.4

- Adds checking whether Bluetooth service is enabled through `Permission.bluetooth.serviceStatus`.

## 9.1.3

- Fixes an issue where the `Permission.location.request()`, `Permission.locationWhenInUse.request()` and `Permission.locationAlways.request()` calls returned `PermissionStatus.denied` regardless of the actual permission status.

## 9.1.2

- Fixes an issue where the `Permission.locationAlways.request()` call hangs when the application was granted "Allow once" permissions for fetching location coordinates.

## 9.1.1

- Adds the new Android 13 permission "BODY_SENSORS_BACKGROUND" to PermissionHandlerEnums.h.

## 9.1.0

- Adds the "Provisional" permission status which is introduced in iOS 12+.

## 9.0.8

- Adds missing return statement causing the permission_handler to freeze when already requesting permissions.

## 9.0.7

- Adds new Android 13 permissions "SCHEDULE_EXACT_ALARM, READ_MEDIA_IMAGES, READ_MEDIA_VIDEO and READ_MEDIA_AUDIO" to PermissionHandlerEnums.h

## 9.0.6

- Prevents appearing popup that asks to turn on Bluetooth on iOS

## 9.0.5

- Adds new Android 13 NEARBY_WIFI_DEVICES permission to PermissionHandlerEnums.h

## 9.0.4

- Adds flag inside `UserDefaults` to save whether `locationAlways` has already been requested and prevent further requests, which would be left unanswered by the system.

## 9.0.3

- Ensures a request for `locationAlways` permission returns a result unblocking the permission request and preventing the `ERROR_ALREADY_REQUESTING_PERMISSIONS` error for subsequent permission requests.

## 9.0.2

- Moves Apple implementation into its own package.
