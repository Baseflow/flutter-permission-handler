# Adopting the Android "permanently denied" fix in an app

This guide tells an app exactly what to change to pick up the fix on branch
`fix/android-ask-every-time-permanently-denied` of this fork
(`permission_handler_android` 14.1.0), and how to write permission code that
stays correct with it.

## 1. What changed, in one paragraph

On Android, `Permission.x.status` can no longer return `permanentlyDenied`.
It returns `denied` for every denied runtime permission. Only the result of
`Permission.x.request()` can be `permanentlyDenied`. Android gives apps no way
to tell a permanently denied permission apart from one that was never requested
or one that the user reset to **Ask every time** in the app settings, and the
old heuristic guessed wrong in the last case. Requesting a permanently denied
permission is cheap: the OS resolves it immediately, without showing a dialog.

iOS is unchanged: `status` still returns `permanentlyDenied` there. The
request-driven pattern below works on both platforms.

## 2. Behavior on Android after the fix

| Situation on the device | `status` returns | `request()` returns |
|---|---|---|
| Never asked | `denied` | dialog shown. `granted`, or `denied` after "Don't allow" or a dismissal |
| Denied once | `denied` | dialog shown. `granted`, or `permanentlyDenied` after a second "Don't allow" |
| Permanently denied | `denied` | `permanentlyDenied` immediately, no dialog |
| Settings: **Ask every time** | `denied` | dialog shown. `granted`, or `denied` after "Don't allow" |
| Settings: **Don't allow** (from granted or Ask every time) | `denied` | dialog shown, Android treats this as "denied once" |
| Settings: **Allow** or dialog "While using the app" | `granted` | `granted` |
| "Only this time" grant that expired | `denied` | dialog shown |

Known leftover: while the permission is in the **Ask every time** state, a user
who dismisses the dialog with Back gets `permanentlyDenied` for that single
request. The OS cannot tell that apart from an auto-denied request. The next
`status` is `denied` and the next `request()` shows the dialog again, so never
cache that verdict.

## 3. Depend on the fixed package

### 3.1 Publish the branch (once, in this fork)

The branch exists locally and is not pushed yet.

```bash
cd flutter-permission-handler
git push -u origin fix/android-ask-every-time-permanently-denied
```

### 3.2 Point the app at the fork

Only `permission_handler_android` contains the fix. Overriding just that
package is the smallest change and works with the app's current
`permission_handler` version, because `dependency_overrides` bypass the
umbrella package's version constraint.

Add to the app's `pubspec.yaml`, at top level:

```yaml
dependency_overrides:
  permission_handler_android:
    git:
      url: https://github.com/TetrixGauss/flutter-permission-handler.git
      ref: fix/android-ask-every-time-permanently-denied
      path: permission_handler_android
```

For local testing before the branch is pushed, use a path override instead
(adjust the relative path to where the fork is checked out):

```yaml
dependency_overrides:
  permission_handler_android:
    path: ../flutter-permission-handler/permission_handler_android
```

Optional: to also take the updated README and docs, move `permission_handler`
itself to the fork. Then both overrides are needed, because the fork's umbrella
requires `permission_handler_android` 14.1.0, which is not on pub.dev:

```yaml
dependency_overrides:
  permission_handler:
    git:
      url: https://github.com/TetrixGauss/flutter-permission-handler.git
      ref: fix/android-ask-every-time-permanently-denied
      path: permission_handler
  permission_handler_android:
    git:
      url: https://github.com/TetrixGauss/flutter-permission-handler.git
      ref: fix/android-ask-every-time-permanently-denied
      path: permission_handler_android
```

### 3.3 Raise `compileSdk` to 37

`permission_handler_android` 14.x compiles against API 37. In
`android/app/build.gradle.kts` set:

```kotlin
android {
    compileSdk = 37
```

Flutter's default (`flutter.targetSdkVersion`) is 36 and only produces a
warning, but the plugin's changelog requires 37. Platform `android-37.0` is
installed on this machine.

### 3.4 Resolve and verify the resolution

```bash
flutter pub get
grep -A 7 "^  permission_handler_android:" pubspec.lock
```

The lock entry must show `source: git` (or `path`) and `version: "14.1.0"`.
Commit `pubspec.lock` so CI and teammates build the same commit. To pick up
later commits on the branch run `flutter pub upgrade permission_handler_android`.

## 4. Rules for the app's permission code

1. **Never derive "permanently denied" from `status`.** Use `status` only to
   skip the request when the permission is already `granted` or `limited`, and
   to decide whether to show your own explainer before asking.
2. **Always call `request()` when you need a permission that is not granted.**
   This is safe when it is permanently denied: no dialog appears and the result
   comes back immediately.
3. **Branch on the `request()` result.**
   - `granted` or `limited`: proceed.
   - `denied`: the user declined just now. Do not re-prompt immediately, offer
     the feature again on the next user action.
   - `permanentlyDenied`: offer an "Open settings" action via
     `openAppSettings()`.
4. **Never persist a `permanentlyDenied` verdict.** Not to disk, and not as a
   long-lived flag that blocks future requests. After the app resumes from
   Settings, read `status` again; if it is not `granted`, the next user action
   calls `request()` again.
5. **Do not use `shouldShowRequestRationale` to detect permanent denial.** It
   is `false` for "never asked", "Ask every time" and "permanently denied"
   alike.
6. **Do not gate `request()` on your own `canRequest` style flag that excludes
   `permanentlyDenied`.** That is exactly the pattern that kept users stuck in
   Settings.

Reference pattern:

```dart
Future<bool> ensureLocation() async {
  var status = await Permission.locationWhenInUse.status;
  if (status.isGranted || status.isLimited) return true;

  // Optionally show your own explainer here when status.isDenied.

  status = await Permission.locationWhenInUse.request();
  if (status.isGranted || status.isLimited) return true;

  if (status.isPermanentlyDenied) {
    // Offer "Open settings". Do not remember this decision.
    await showOpenSettingsPrompt();
    return false;
  }
  // Denied just now: stay quiet, let the user try again later.
  return false;
}
```

## 5. Exact changes for monnett-app

Files are relative to `monnett-app/`.

### 5.1 `pubspec.yaml`

`permission_handler: ^12.0.0+1` stays as is. Add the `dependency_overrides`
block from section 3.2 (git form once the branch is pushed, path form
`../flutter-permission-handler/permission_handler_android` until then). There
is no existing `dependency_overrides` section in this file.

### 5.2 `android/app/build.gradle.kts`

Line 19 currently reads `compileSdk = flutter.targetSdkVersion`. Change it to:

```kotlin
    compileSdk = 37
```

### 5.3 `lib/presentation/bloc/permission_cubit/permission_state.dart`

`canRequest` excludes `permanentlyDenied`, which is what keeps
`LocationCubit.pickCurrentLocation` from ever asking again. Replace it:

```dart
  /// Whether calling request() can still change the outcome.
  ///
  /// Requesting is always safe when the permission is not granted: on Android
  /// a status check never reports `permanentlyDenied`, and a permanently
  /// denied permission resolves immediately without a dialog on both
  /// platforms. Only the *result* of a request can tell the two apart.
  bool get canRequest => !isGranted && this != AppPermissionStatus.limited;
```

With this change `LocationCubit.pickCurrentLocation` needs no edit: it checks
the status, requests when `canRequest`, and already branches on the request
result (`isPermanentlyDenied` first, then `isGranted`). Both denied outcomes
land on the same `LocationBlockedWidget.permissionDenied` dialog, which has an
"Open settings" action.

### 5.4 `lib/presentation/bloc/camera/camera_cubit.dart`

In `initCamera`, the early return on `permissions.state.isCameraPermanentlyDenied`
right after `refreshStatuses()` is dead code on Android now, because a status
refresh never yields `permanentlyDenied`. It is safe to keep for iOS, or to
remove, since the following `requestPermissions` call returns immediately for
a permanently denied camera and the existing `!canUseCamera` check produces the
same `CameraStatus.permissionDenied`.

Recommended UX improvement: `_permissionsRequested` prevents a second request
per screen visit. When the user comes back from Settings after choosing
**Ask every time**, `initCamera` runs again from `didChangeAppLifecycleState`,
sees `denied`, skips the request and shows the settings screen again instead of
the system dialog. Add a method to `CameraCubit`:

```dart
  /// Allow the next [initCamera] to show the system dialog again, for example
  /// after the user returns from the app settings.
  void allowPermissionRePrompt() => _permissionsRequested = false;
```

and call it at the start of `_handleGoToSettings` in
`lib/presentation/widgets/screens/camera/camera_preview_screen.dart`, before
`openSettings()`.

### 5.5 Already correct, no change

- `lib/core/util/helpers/media_selection_helper.dart` (gallery access): checks
  `status` only to skip when granted or limited, then requests and shows
  `NoGalleryAccessWidget` on a `permanentlyDenied` **result**.
- `PermissionCubit.refreshStatuses()`: reads fresh statuses. On Android these
  are never `permanentlyDenied`, so `hasPermanentlyDenied`,
  `isCameraPermanentlyDenied` and `isStoragePermanentlyDenied` are only true
  right after a `requestPermissions` call stored its result via `_emitAll`,
  and drop back to `denied` on the next refresh. That is the intended
  behavior: the user may have changed the permission in Settings.

### 5.6 Other apps in this workspace

The same rules apply to every app that depends on `permission_handler`:
`study_buddy`, `e_energy`, `e_energy_admin`, `clean_service`, `gleemsy`,
`e_delivery`, `dating_full_system/noGen` (all `^12`), and `bridge_chat`,
`leeloo_chat_app` (`^11.3.1`). Audit each `isPermanentlyDenied` /
`permanentlyDenied` usage: keep the ones fed by a `request()` result, rewrite
the ones fed by `status`.

## 6. Verify on a device or emulator

Use a debug build of the app. `<pkg>` is the application id, for example
`com.monnet.social.monnet.dev`.

1. Fresh install. Trigger the location feature, tap **Don't allow**. The app
   must behave as "denied" (no settings prompt).
2. Trigger it again, tap **Don't allow**. The request result is
   `permanentlyDenied`; the app shows its "Open settings" prompt.
   Check the flags:

   ```bash
   adb shell dumpsys package <pkg> | grep -A1 "ACCESS_FINE_LOCATION: granted"
   # expect: granted=false, flags=[ USER_SET|USER_FIXED|... ]
   ```

3. Open Settings > Apps > the app > Permissions > Location, choose
   **Ask every time**, return to the app.

   ```bash
   adb shell dumpsys package <pkg> | grep -A1 "ACCESS_FINE_LOCATION: granted"
   # expect: granted=false, flags=[ ...|ONE_TIME ]   (no USER_SET, no USER_FIXED)
   ```

   Trigger the feature: the system dialog must appear. Before the fix the app
   went straight to its "Open settings" prompt.
4. Tap **While using the app**: the feature works and `status` is `granted`.

To reset the permission between runs without reinstalling:

```bash
adb shell pm revoke <pkg> android.permission.ACCESS_FINE_LOCATION
adb shell pm revoke <pkg> android.permission.ACCESS_COARSE_LOCATION
adb shell pm clear-permission-flags <pkg> android.permission.ACCESS_FINE_LOCATION user-set user-fixed
adb shell pm clear-permission-flags <pkg> android.permission.ACCESS_COARSE_LOCATION user-set user-fixed
```

The `ONE_TIME` flag cannot be cleared from the shell; choose **Don't allow** in
Settings first, then run the commands above.

## 7. If an app cannot take the fork yet

The unfixed plugin is wrong only about `status`. Apps on the pub.dev version
can avoid the stuck state by following the rules in section 4 today: ignore
`status.isPermanentlyDenied` on Android, always call `request()` and act on its
result. With the old plugin a request after **Ask every time** shows the
dialog and reports `granted` or `denied` correctly; only the pre-check was
lying.

## 8. Background

- Root cause: choosing **Ask every time** revokes the permission as a one-time
  permission, which clears `FLAG_PERMISSION_USER_SET`.
  `shouldShowRequestPermissionRationale()` returns exactly that flag, so it is
  `false`, and the old plugin combined that with a never-cleared
  "was denied before" flag in SharedPreferences.
- Upstream issue: https://github.com/Baseflow/flutter-permission-handler/issues/1206
- The fix commit on this branch: "Fix Android status reporting
  permanentlyDenied after 'Ask every time'" (`permission_handler_android`
  14.1.0, see its CHANGELOG).
