# flutter-permission-handler agent instructions

Technical reference for AI agents and contributors developing in this repository.

Process and conduct live in their own files: contribution workflow in
[CONTRIBUTING.md](CONTRIBUTING.md), the [Contributor Covenant Code of
Conduct](CODE_OF_CONDUCT.md) (report unacceptable behavior to
[hello@baseflow.com](mailto:hello@baseflow.com)).

## Scope and stack

- This repo is the **permission_handler federated plugin** monorepo maintained by
  [Baseflow](https://baseflow.com).
- It contains six published packages: an app-facing package, a platform
  interface and four platform implementations. Work inside the **specific
  package** you are changing.
- The repository root is a **pub workspace** (`pubspec.yaml`, name
  `permission_handler_monorepo`, `publish_to: none`). Every package and every
  example is a member, so one `flutter pub get` anywhere in the tree resolves all
  of them against each other's local sources. There is no Melos and none should
  be added unless the team decides to.
- Run Flutter and Dart commands with the same tooling CI uses (`flutter`, `dart`).
  Nothing in this repo requires anything else. If you happen to manage SDK
  versions locally with [fvm](https://fvm.app), prefix commands with `fvm`; that
  is a personal setup choice and is never checked in.

### Prerequisites

- Basic Dart and Flutter knowledge, and some familiarity with the platform you
  are changing
- A working Flutter SDK installation, stable channel. **No workflow pins a
  version.** Every workflow installs Flutter with `subosito/flutter-action` at
  `channel: "stable"`, so CI runs whatever stable resolves to on the day. The
  committed floor is the pubspec constraint: `sdk: ^3.6.0` (`^3.5.0` for
  `permission_handler_html`) and `flutter: ">=3.24.0"`.
- For `permission_handler_apple` and the app-facing iOS build, access to a Mac
- Android builds require JDK 17
- Windows builds need Windows

### Reference documentation

- [Developing packages & plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages),
  in particular the [federated plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins) section
- [Writing platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels)
- [Platform interface breaking changes](https://flutter.dev/go/platform-interface-breaking-changes)
- [Pub workspaces](https://dart.dev/tools/pub/workspaces)
- [Effective Dart](https://dart.dev/effective-dart)
- [pub versioning philosophy](https://dart.dev/tools/pub/versioning)

## Packages in this repo

| Package | Role | Native code |
|---|---|---|
| `permission_handler` | App-facing API: the `Permission` extensions and `openAppSettings` | none |
| `permission_handler_platform_interface` | Shared contract (`Permission`, `PermissionStatus`, `ServiceStatus`) and the default `MethodChannelPermissionHandler` | none |
| `permission_handler_android` | Android implementation | Java |
| `permission_handler_apple` | iOS implementation, with a `select` command for per-flavor permissions under Swift Package Manager | Objective-C |
| `permission_handler_html` | Web implementation, `WebPermissionHandler` | none |
| `permission_handler_windows` | Windows implementation | C++ |

## Architecture overview

This is an **endorsed federated plugin**. Apps depend only on
`permission_handler`; its `pubspec.yaml` depends on every implementation and
names it as the `default_package` for its platform.

```
App → Permission.request() / .status / ...
    → PermissionHandlerPlatform.instance
    → MethodChannelPermissionHandler (Android, iOS, Windows) or WebPermissionHandler (web)
    → MethodChannel('flutter.baseflow.com/permissions/methods')
    → native handler (Java, Objective-C, C++)
```

- Android, Apple and Windows have **no Dart code**. Each registers only a native
  `pluginClass`, and all three answer the same channel through the default
  `MethodChannelPermissionHandler` in the platform interface. A change to that
  class changes what all three native sides receive.
- The web package registers `WebPermissionHandler` as the instance and talks to
  browser APIs through `WebDelegate`. It does not use the channel.
- `PermissionHandlerPlatform` extends `PlatformInterface` and verifies its
  instance token, so a Dart implementation must **extend** it, never
  `implement` it.

### The channel and the permission codes

One `MethodChannel`, `flutter.baseflow.com/permissions/methods`, with the
methods `checkPermissionStatus`, `checkServiceStatus`, `requestPermissions`,
`shouldShowRequestPermissionRationale` and `openAppSettings`.

Permissions and statuses cross the channel as integers. The Dart side encodes
and decodes them in
`permission_handler_platform_interface/lib/src/method_channel/utils/codec.dart`.
The integer values are defined four times and must stay identical:

| Side | Definition |
|---|---|
| Dart | `permission_handler_platform_interface/lib/src/permissions.dart` |
| Android | `permission_handler_android/android/src/main/java/com/baseflow/permissionhandler/PermissionConstants.java` |
| iOS | `permission_handler_apple/ios/permission_handler_apple/Sources/permission_handler_apple/PermissionHandlerEnums.h` |
| Windows | `permission_handler_windows/windows/permission_constants.h` |

### iOS permission macros

Every iOS permission is compiled only when its `PERMISSION_*` macro is set, so an
app is not rejected for referencing an API it has no usage description for.
Under CocoaPods the app sets the macros in its `Podfile`. Under Swift Package
Manager, `Package.swift` derives them from the app's `Info.plist` keys, and
`dart run permission_handler_apple:select <flavor>` (`bin/select.dart`) picks a
per-flavor set from `permission_handler.yaml`. The
[`permission_handler_apple` README](permission_handler_apple/README.md) is the
reference.

## Authoritative project structure

- Root overview: `README.md`
- Contribution workflow: `CONTRIBUTING.md`
- Android "permanently denied" behavior: `ANDROID_PERMANENTLY_DENIED_FIX_GUIDE.md`
- Workspace: `pubspec.yaml`, with shared lints in `analysis_options.yaml`
  (`flutter_lints` plus `public_member_api_docs`).
  `permission_handler_platform_interface` has its own `analysis_options.yaml`.
- App-facing API: `permission_handler/lib/permission_handler.dart`
- Platform contract: `permission_handler_platform_interface/lib/src/permission_handler_platform_interface.dart`
- Channel client: `permission_handler_platform_interface/lib/src/method_channel/method_channel_permission_handler.dart`
- Native entry points:
  - Android: `permission_handler_android/android/src/main/java/com/baseflow/permissionhandler/PermissionHandlerPlugin.java`,
    with the logic in `PermissionManager.java`, `ServiceManager.java` and `AppSettingsManager.java`
  - iOS: `permission_handler_apple/ios/permission_handler_apple/Sources/permission_handler_apple/PermissionHandlerPlugin.m`,
    with one strategy class per permission group under `strategies/`
  - Windows: `permission_handler_windows/windows/permission_handler_windows_plugin.cpp`
- Web: `permission_handler_html/lib/`
- Swift Package Manager manifest: `permission_handler_apple/ios/permission_handler_apple/Package.swift`
- Example apps: `<package>/example/`, in every package except the platform interface
- CI: `.github/workflows/<package>.yaml`

### CI map

Every workflow runs on pushes and pull requests to `main`, filtered to its own
package directory and its own workflow file. A change to root files such as this
one, the workspace `pubspec.yaml` or the root `analysis_options.yaml` starts no
workflow.

| Workflow | Runner | Format, analyze | Example build | Unit tests |
|---|---|---|---|---|
| `permission_handler.yaml` | macOS | yes | apk, iOS | `flutter test --coverage` |
| `permission_handler_platform_interface.yaml` | Ubuntu | yes | none | `flutter test --coverage` |
| `permission_handler_android.yaml` | Ubuntu | yes | apk | none exist |
| `permission_handler_apple.yaml` | macOS | yes | iOS, plus a Swift Package Manager check that the `PERMISSION_*` macros resolve as expected | none exist |

`permission_handler_html` and `permission_handler_windows` have **no workflow**.
Nothing checks them on a pull request, so run format, analyze and the example
build yourself. No workflow publishes.

## Where to make changes

- **Public API and docs for app developers** → `permission_handler/lib/` and its
  README. The README also documents the `AndroidManifest.xml`, `Info.plist` and
  `Podfile` setup each permission needs.
- **Cross-platform contract** → `permission_handler_platform_interface/lib/`.
  Prefer additive changes: add methods, do not change signatures.
- **Platform behavior** → the matching native sources in that platform's package
- **Never** put platform-specific logic in `permission_handler` beyond thin
  delegation.

**Adding a permission** touches every package. Add the constant in
`permissions.dart` with the next free integer, mirror that integer in the three
native constant files above, implement it on each platform that supports it
(Android `PermissionManager`, an iOS strategy class plus its `PERMISSION_*`
macro, its `Info.plist` key mapping in `Package.swift` and the README, the
Windows handler, `WebDelegate`), and document the manifest or plist entries in
`permission_handler/README.md`. Each package is its own pull request and its own
release, platform interface first.

Traps:

- **The integers are wire protocol.** Never renumber or reuse a value, even for a
  removed permission. An app built against one version of a native package and
  another of the interface would silently map to the wrong permission.
- **The channel name is wire protocol too.** Do not change it without a major
  version and a migration plan.
- **Android cannot report `permanentlyDenied` from `status`.** Only the result of
  `request()` can be. See `ANDROID_PERMANENTLY_DENIED_FIX_GUIDE.md` before
  changing anything about denial handling.
- **iOS code behind a macro is not compiled by default.** The example enables the
  macros it needs; a permission your change touches may need enabling there
  before the build exercises it.
- **Web is limited.** `openAppSettings` and
  `shouldShowRequestPermissionRationale` always return `false`.

## Development setup

Per [CONTRIBUTING.md](CONTRIBUTING.md) and Baseflow's open-source forking workflow:

1. Fork `https://github.com/Baseflow/flutter-permission-handler` on GitHub.
2. Clone your fork: `git clone git@github.com:<your_name>/flutter-permission-handler.git`
3. Add upstream (the official repo you fetch from, not your fork):

```bash
git remote add upstream git@github.com:Baseflow/flutter-permission-handler.git
```

4. Branch from the latest `main`:

```bash
git fetch upstream
git checkout upstream/main -b <name_of_your_branch>
```

Expected remotes after setup:

```
origin    git@github.com:<your_name>/flutter-permission-handler.git   # your fork (push here)
upstream  git@github.com:Baseflow/flutter-permission-handler.git      # official repo (fetch here)
```

Repository admins skip the fork: clone `Baseflow/flutter-permission-handler`
directly and branch from `origin/main`.

## Commands

Run from the package you are editing:

```bash
cd permission_handler_platform_interface   # or any other package
flutter pub get                            # resolves the whole workspace
dart format .
flutter analyze
flutter test                               # where tests exist
```

CI runs the same commands with stricter flags:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
```

Build or run an example from `<package>/example/`:

```bash
cd permission_handler/example
flutter run
```

The Apple example builds after a flavor selection, as CI does:

```bash
cd permission_handler_apple/example
dart run permission_handler_apple:select release
flutter build ios --no-codesign --release
```

Before finishing work, run what CI runs for the package you changed, including
its example build where your platform allows it.

## Testing expectations

| Package | Tests |
|---|---|
| `permission_handler` | Dart unit tests, mocking `PermissionHandlerPlatform` with mockito |
| `permission_handler_platform_interface` | Dart unit tests under `test/src/`, with a channel mock in `test/src/method_channel/` |
| `permission_handler_html` | A placeholder test only. Verify through the example. |
| `permission_handler_android`, `permission_handler_apple`, `permission_handler_windows` | No tests. Verify through the example build, on a device for anything behavioral. |

Because the workspace resolves siblings from local sources, a test run here uses
your local copy of every other package, not the published one. Before relying on
a change in one package from another, remember that pub.dev users get the
published version until it is released.

## Platform notes

- **Android**: `PermissionManager` requests permissions, `ServiceManager`
  answers service status and `AppSettingsManager` opens settings.
  `shouldShowRequestPermissionRationale` is meaningful only here.
- **iOS**: one strategy class per permission group, each compiled behind its
  `PERMISSION_*` macro. Both CocoaPods and Swift Package Manager are supported,
  and they configure the macros differently.
- **Windows**: a small permission surface compared to mobile.
- **All platforms**: requesting a permission at runtime does not replace
  declaring it in `AndroidManifest.xml`, `Info.plist` or the equivalent. The
  example apps are the reference.

## Pull request workflow

**`main` is the branch of record.** Branch from the latest `main`, open every
pull request against `main`, and rebase onto `main` before submitting. Every
workflow builds `main` only, so a pull request against anything else gets no CI.
`next` and `macos_support` are old long-lived branches that are not maintained:
do not branch from them or target them. Pull requests are squash merged, so each
one becomes a single commit on `main`.

This repo uses the **forking workflow** for everyone who is not a repository
admin: contributors work on their own fork and open pull requests to the main
repository, and must not push branches to `Baseflow/flutter-permission-handler`.
Repository admins push their branches straight to
`Baseflow/flutter-permission-handler` and open pull requests from there. Either
way, every change reaches `main` through a reviewed pull request; nobody pushes
to `main` directly.

1. Apply changes on a branch based on `main`, scoped to one package.
2. Bump that package's `version:` in `pubspec.yaml` following semver, and add a
   matching `CHANGELOG.md` entry (format: see [Releases](#releases)).
3. Verify locally, from the package you changed: `dart format .`,
   `flutter analyze`, `flutter test` where tests exist, and the example build.
4. Push the branch and open a pull request against `main` on
   `Baseflow/flutter-permission-handler`, filling out the full
   [PR template](.github/PULL_REQUEST_TEMPLATE.md).

Docs-only and CI-only pull requests, such as changes to this file,
`CONTRIBUTING.md` or `.github/`, do not bump a version and add no changelog
entry.

Keep public API changes additive and non-breaking where possible. A breaking
change needs a major version and a README and changelog callout. For the
platform interface, follow the Flutter guidance on
[platform interface breaking changes](https://flutter.dev/go/platform-interface-breaking-changes).

### PR description style

The [PR template](.github/PULL_REQUEST_TEMPLATE.md) has no headings: it opens
with a free-text description of the change and the issue it fixes, followed by
`## Pre-launch Checklist`. Keep that structure.

- State what changed and why. Don't narrate your own editing process, and don't
  explain why one obvious, in-scope edit was made alongside another.
- Don't repeat file paths in prose; the diff already shows them.
- Link at least one fixed issue, as the template asks.
- Tick only what you actually did. If something was left to CI, say so in the
  description and leave the box unticked.

### PR checklist

The template's Pre-launch Checklist, verbatim:

- [ ] I made sure the project builds.
- [ ] I read the Contributor Guide and followed the process outlined there for submitting PRs.
- [ ] I updated `pubspec.yaml` with an appropriate new version according to the pub versioning philosophy, or this PR is does not need version changes.
- [ ] I updated `CHANGELOG.md` to add a description of the change.
- [ ] I updated/added relevant documentation (doc comments with `///`).
- [ ] I rebased onto `main`.
- [ ] I added new tests to check the change I am making, or this PR does not need tests.
- [ ] I made sure all existing and new tests are passing.
- [ ] I ran `dart format .` and committed any changes.
- [ ] I ran `flutter analyze` and fixed any errors.

And for this repo specifically:

- [ ] This PR changes exactly one package
- [ ] No permission integer was renumbered or reused, and the channel name is unchanged
- [ ] For `permission_handler_html` or `permission_handler_windows`, format,
      analyze and the example build were run locally, since no workflow runs them

## Releases

Each package is versioned and released independently. Only maintainers cut
releases.

**No workflow publishes.** A release is published to pub.dev by a maintainer, and
the release commit on `main` is tagged `<package>_v<version>`, for example
`permission_handler_v13.0.2` or `permission_handler_apple_v9.6.4`. Every merged
pull request already bumped its own package's version and added its changelog
entry, so there is no separate release-prep pull request.

When a release depends on a sibling's new version (an implementation handling a
new permission, or the app-facing package using a new interface method), publish
the dependency first and raise the constraint in a pull request before releasing
the dependent package. The workspace hides a missing constraint bump locally,
because it resolves siblings from source.

`CHANGELOG.md` uses `## x.y.z` headings with no date and a flat list of `-`
bullets, newest first, with no `## [Unreleased]` section. Match that format.
Introducing a different one is a separate decision, not part of an unrelated
change.

Published versions are immutable, so keep branch names out of URLs in
`pubspec.yaml` and in docs: a branch-specific link becomes a permanent dead link
once that branch is gone.
