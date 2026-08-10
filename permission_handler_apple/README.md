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
compiled into your release binary too. Declare flavors (below) when that matters.

**Changes are cached.** The manifest is not re-evaluated when an `Info.plist` or an environment
variable changes. Clear DerivedData once afterwards:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Per-flavor permissions

> Swift Package Manager only. Under CocoaPods the macros come from your `Podfile`, where you can
> already set them per configuration; `permission_handler.yaml` is ignored and the build phase
> below is a no-op.

If your flavors need different permissions — a `dev` build that scans QR codes, a `prod` build that
does not — merging is wrong: it compiles the camera code into `prod` too, which is what
`ITMS-90683` rejects. Declare a `permission_handler.yaml` next to your `pubspec.yaml`:

```yaml
strict: true
flavors:
  dev:
    info-plist: ios/Runner/Info-dev.plist
    configurations:
      - Debug-dev
      - Profile-dev
      - Release-dev
  prod:
    info-plist: ios/Runner/Info-prod.plist
    configurations:
      - Debug-prod
      - Profile-prod
      - Release-prod
```

Each flavor names the one `Info.plist` that defines it, and nothing is merged: a flavor can never
inherit another flavor's permissions. `configurations` lists the Xcode build configurations that
belong to the flavor, which is how the build phase below knows what to expect. Each configuration
must belong to exactly one flavor — `select` rejects a config where two flavors claim the same one,
since the build would have no way to tell which permissions it should ship.

Select a flavor before building:

```bash
dart run permission_handler_apple:select prod   # --list shows what is declared
flutter run --flavor prod
```

Selecting is a separate step because the package manifest is evaluated once, is cached, and is
given none of Xcode's build settings — it cannot tell which configuration is running, and Xcode
will not re-evaluate it just because an environment variable changed. `select` records the choice
*and* clears the caches that would otherwise keep serving the previous flavor's permissions.

`select` is also the only YAML reader in the pipeline. A Swift package manifest cannot parse YAML —
Foundation has no support for it and a manifest cannot import libraries — so `select` translates
your config into a generated `ios/Flutter/permission_handler.resolved.json` that the manifest and
the build phase read with their native JSON parsers. Never edit that file; if you change
`permission_handler.yaml`, re-run `select`. Building with a translation older than the YAML fails
rather than using stale permissions.

With `strict: true` (the default) a build whose flavor cannot be determined compiles no
permissions at all, rather than falling back to the union of every flavor.

#### Fail the build on a stale selection

Nothing inside the manifest can detect a stale selection, because a cached manifest is not
executed. Add a **Run Script** build phase to your Runner target, and drag it to the *top* of the
phase list so a mismatch fails before anything is compiled:

```sh
# Resolve the plugin, wherever this project gets it from.
PLUGIN="$SRCROOT/Flutter/ephemeral/Packages/.packages/permission_handler_apple/../.."
[ -d "$PLUGIN/tool" ] || PLUGIN="$SRCROOT/.symlinks/plugins/permission_handler_apple"
[ -f "$PLUGIN/tool/verify_flavor_selection.sh" ] || exit 0
/bin/sh "$PLUGIN/tool/verify_flavor_selection.sh"
```

It runs on every build, where `CONFIGURATION` is available, and fails with an actionable message
when the selected flavor does not match what is being built:

```
error: [permission_handler_apple] building "Release-prod" needs the "prod" permission flavor,
but "dev" is selected, so this build would ship dev's permissions.
Run: dart run permission_handler_apple:select prod
```

Add these to your `.gitignore` — one records a local choice, the other is generated:

```
ios/Flutter/permission_handler.selected
ios/Flutter/permission_handler.resolved.json
```

### Environment variables

Xcode.app does not inherit your shell's environment, so set these with `launchctl setenv` rather
than exporting them, then restart Xcode.

| Variable | Effect |
| --- | --- |
| `PERMISSION_<NAME>` | Forces a single permission on (`1`) or off (`0`), overriding everything else. For example `launchctl setenv PERMISSION_CAMERA 0`. |
| `PERMISSION_HANDLER_INFO_PLIST` | A `:`-separated list of `Info.plist` paths. When set, replaces automatic discovery entirely. |
| `PERMISSION_HANDLER_FLAVOR` | The active flavor, overriding the one recorded by `select`. Changing it still needs the caches cleared. |
| `PERMISSION_HANDLER_CONFIG` | Path to `permission_handler.yaml`, for builds that cannot locate the app automatically. |
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
