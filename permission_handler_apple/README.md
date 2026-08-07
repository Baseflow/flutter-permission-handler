# permission_handler_apple

[![pub package](https://img.shields.io/pub/v/permission_handler_apple.svg)](https://pub.dartlang.org/packages/permission_handler_apple) ![Build status](https://github.com/Baseflow/flutter-permission-handler/workflows/permission_handler_apple/badge.svg?branch=master) [![style: flutter lints](https://img.shields.io/badge/style-flutter_lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)

The official iOS implementation of the [permission_handler](https://pub.dev/packages/permission_handler) plugin by [Baseflow](https://baseflow.com).

## Usage

Since version 9.1.0 of the [permission_handler](https://pub.dev/packages/permission_handler) plugin this is the endorsed iOS implementation. This means it will automatically be added to your dependencies when you depend on `permission_handler: ^9.1.0` in your applications pubspec.yaml.

More detailed instructions on using the API can be found in the [README.md](../permission_handler/README.md) of the [permission_handler](https://pub.dev/packages/permission_handler) package.

## Swift Package Manager

Only the permissions your app actually uses are compiled into the binary. Referencing an iOS
permission API you have no usage description for is grounds for App Store rejection
(`ITMS-90683`), so each permission is guarded by a `PERMISSION_*` macro.

Under CocoaPods you set those macros yourself, in the `GCC_PREPROCESSOR_DEFINITIONS` block of your
`Podfile`. Under Swift Package Manager the package manifest derives them instead: it locates your
app's `Info.plist` files and enables a permission when the matching `NS*UsageDescription` key is
present. `INFOPLIST_FILE` is read from your Xcode project and `.xcconfig` files, so
build-configuration and flavor specific plists (`Info-Debug.plist`, `Info-dev.plist`,
`Runner/Info-$(CONFIGURATION).plist`, …) are all picked up.

**Keys are merged across every configuration.** A package manifest is evaluated once and cannot
vary its settings per build configuration, so a permission declared only in `Info-dev.plist` is
compiled into your release binary too. Use the per-permission variables below where that matters.

**Changes are cached.** The manifest is not re-evaluated when an `Info.plist` or an environment
variable changes. Clear DerivedData once afterwards:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Environment variables

Xcode.app does not inherit your shell's environment, so set these with `launchctl setenv` rather
than exporting them, then restart Xcode.

| Variable | Effect |
| --- | --- |
| `PERMISSION_<NAME>` | Forces a single permission on (`1`) or off (`0`), overriding everything else. For example `launchctl setenv PERMISSION_CAMERA 0`. |
| `PERMISSION_HANDLER_INFO_PLIST` | A `:`-separated list of `Info.plist` paths. When set, replaces automatic discovery entirely. |
| `PERMISSION_HANDLER_VERBOSE` | Set to `1` to log the detected app root, the `Info.plist` files used, and the resolved macros. |

### Builds started from Xcode.app

Automatic discovery finds your app through the build's working directory, which points at the
Flutter project for `flutter run`, `flutter build ios` and a direct `xcodebuild` invocation. Builds
started from Xcode.app run with `/` as their working directory, and the manifest is given none of
Xcode's build settings, so there is nothing to find the app by. Point it at the plist explicitly:

```bash
launchctl setenv PERMISSION_HANDLER_INFO_PLIST /absolute/path/to/ios/Runner/Info.plist
rm -rf ~/Library/Developer/Xcode/DerivedData
```

If no `Info.plist` is found, every permission is compiled out and permission checks report
`denied`. The manifest warns about this, but Xcode discards Swift package manifest output, so the
warning only reaches you through the command line:

```bash
cd your_app
PERMISSION_HANDLER_VERBOSE=1 swift package --manifest-cache none \
  --package-path ios/Flutter/ephemeral/Packages/.packages/permission_handler_apple \
  dump-package > /dev/null
```

That prints the app root, the `Info.plist` files used and the resolved macros, and is the quickest
way to check what your app will actually be built with.

## Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-permission-handler/issues) page. Commercial support is available, you can contact us at <hello@baseflow.com>.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-permission-handler/pulls).

## Author

This permission_handler plugin for Flutter is developed by [Baseflow](https://baseflow.com).
