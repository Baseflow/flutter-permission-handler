# permission_handler_apple

[![pub package](https://img.shields.io/pub/v/permission_handler_apple.svg)](https://pub.dartlang.org/packages/permission_handler_apple) ![Build status](https://github.com/Baseflow/flutter-permission-handler/workflows/permission_handler_apple/badge.svg?branch=master) [![style: flutter lints](https://img.shields.io/badge/style-flutter_lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)

The official iOS implementation of the [permission_handler](https://pub.dev/packages/permission_handler) plugin by [Baseflow](https://baseflow.com).

## Usage

Since version 9.1.0 of the [permission_handler](https://pub.dev/packages/permission_handler) plugin this is the endorsed iOS implementation. This means it will automatically be added to your dependencies when you depend on `permission_handler: ^9.1.0` in your applications pubspec.yaml.

More detailed instructions on using the API can be found in the [README.md](../permission_handler/README.md) of the [permission_handler](https://pub.dev/packages/permission_handler) package.

## Architecture (9.5.0+)

Starting with version 9.5.0, iOS uses a **Pigeon ProxyApi** architecture:

| Directory | Role |
|-----------|------|
| `darwin/` | Active Swift plugin (`PermissionHandlerDarwinPlugin`) — registers Pigeon proxy bridges only |
| `lib/next/` | Dart permission orchestration (`PermissionHandlerApple`, handlers, `PermissionManager`) |
| `pigeon/` | Pigeon schema input (`apple_permissions.dart`) |
| `ios/` | Legacy Obj-C implementation (frozen; not compiled with `sharedDarwinSource: true`) |

Request flow:

```
App → PermissionHandlerApple (Dart)
    → PermissionManager + permission handlers
    → Pigeon ProxyApi classes (*.g.dart)
    ↔ PermissionHandlerDarwinPlugin (Swift)
    → Apple frameworks (CoreLocation, Photos, …)
```

Advanced consumers can import native proxy APIs directly:

```dart
import 'package:permission_handler_apple/next/exports/apple_permissions.dart';
```

## Pigeon code generation

Regenerate Dart and Swift artifacts after editing `pigeon/apple_permissions.dart`:

```bash
cd permission_handler_apple
./tool/pigeon_regenerate.sh
```

Or manually:

```bash
dart run pigeon --input pigeon/apple_permissions.dart
```

Commit both `lib/next/src/pigeon/apple_permissions.g.dart` and
`darwin/permission_handler_apple/Sources/permission_handler_apple/PermissionHandler/PermissionHandlerLibrary.g.swift`.

## iOS setup

### Minimum deployment target

The `darwin/` implementation requires **iOS 14.0** or higher.

### Configuring permissions

Permission compile-time flags (`PERMISSION_*`) still apply. Configure them in your app's
`ios/Podfile` `post_install` block (CocoaPods) or via environment variables / `Info.plist` keys
(Swift Package Manager). See the [permission_handler README](../permission_handler/README.md)
for the full list of macros and required usage-description keys.

Example Podfile snippet:

```ruby
config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
  '$(inherited)',
  'PERMISSION_CAMERA=1',
  'PERMISSION_PHOTOS=1',
  # …
]
```

For SPM, the `darwin/permission_handler_apple/Package.swift` resolves enabled permissions from
environment variables and `Info.plist` keys automatically (same logic as the legacy `ios/` package).

## Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-permission-handler/issues) page. Commercial support is available, you can contact us at <hello@baseflow.com>.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-permission-handler/pulls).

## Author

This permission_handler plugin for Flutter is developed by [Baseflow](https://baseflow.com).
