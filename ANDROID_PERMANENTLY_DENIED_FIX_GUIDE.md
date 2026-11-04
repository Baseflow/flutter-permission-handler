# Adopting the Android "permanently denied" fix in an app

`permission_handler_android` 14.1.0 changes what a status check reports for a
denied permission on Android. This guide explains the change, tells you how to
write permission code that stays correct with it, and how to audit an existing
app for the pattern that the old behavior encouraged.

## 1. What changed, in one paragraph

On Android, `Permission.x.status` can no longer return `permanentlyDenied`.
It returns `denied` for every denied runtime permission. Only the result of
`Permission.x.request()` can be `permanentlyDenied`. Android gives apps no way
to tell a permanently denied permission apart from one that was never requested
or one that the user reset to **Ask every time** in the app settings, and the
old heuristic guessed wrong in the last case: an app could get stuck sending
the user to the app settings even though the OS was ready to show the request
dialog again ([#1206](https://github.com/Baseflow/flutter-permission-handler/issues/1206)).
Requesting a permanently denied permission is cheap: the OS resolves it
immediately, without showing a dialog.

iOS is unchanged: `status` still returns `permanentlyDenied` there. The
request-driven pattern below works on both platforms.

## 2. Behavior on Android after the fix

| Situation on the device | `status` returns | `request()` returns |
|---|---|---|
| Never asked | `denied` | dialog shown. `granted`, or `denied` after "Don't allow" or a dismissal |
| Denied once | `denied` | dialog shown. `granted`, or `permanentlyDenied` after a second "Don't allow" |
| Denied twice (permanently denied) | `denied` | `permanentlyDenied`, immediately, no dialog |
| Reset to "Ask every time" in settings | `denied` | dialog shown. `granted`, or `denied` after "Don't allow" |
| Granted | `granted` | `granted`, immediately, no dialog |

The row that used to be wrong is the fourth one: `status` reported
`permanentlyDenied` and `request()` showed the dialog anyway.

## 3. Upgrade

Take `permission_handler` 13.0.2 or later, which depends on
`permission_handler_android` 14.1.0:

```yaml
dependencies:
  permission_handler: ^13.0.2
```

`permission_handler_android` 14.x compiles against API 37, a requirement
introduced in 14.0.0. If you are coming from 13.x, set `compileSdk` in
`android/app/build.gradle(.kts)`:

```kotlin
android {
    compileSdk = 37
```

Then run `flutter pub get` and confirm the resolved version:

```bash
flutter pub get
grep -A 3 "^  permission_handler_android:" pubspec.lock
```

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
   `permanentlyDenied`.** That is exactly the pattern that keeps users stuck in
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

## 5. Auditing an existing app

Search the app for `isPermanentlyDenied` and `permanentlyDenied`. Keep every
usage that is fed by the result of a `request()` call, and rewrite the ones fed
by a `status` read. These are the three shapes that show up most:

**A "can request" helper that excludes permanently denied.** This is the one
that keeps a feature from ever asking again:

```dart
// Before: a permanently denied permission — and, before the fix, one reset to
// "Ask every time" — is never requested again.
bool get canRequest =>
    this == PermissionStatus.denied || this == PermissionStatus.restricted;

// After: requesting is always safe when the permission is not granted.
bool get canRequest =>
    this != PermissionStatus.granted && this != PermissionStatus.limited;
```

**An early return on a status read.** Code that refreshes statuses and bails
out to a "go to settings" screen when one of them is `permanentlyDenied` is
dead code on Android now. Drop the early return and let the following
`request()` decide; it resolves immediately for a permanently denied permission
and yields the same outcome.

**A "already asked" guard that survives a trip to Settings.** A flag like
`_permissionsRequested`, set once per screen visit, stops the second request.
When the user returns from Settings after choosing **Ask every time**, the
screen re-initializes, sees `denied`, skips the request and shows the settings
prompt again instead of the system dialog. Reset the flag before calling
`openAppSettings()`, or when the app resumes:

```dart
/// Allow the next request to show the system dialog again, for example after
/// the user returns from the app settings.
void allowPermissionRePrompt() => _permissionsRequested = false;
```

Cached status values are fine as long as they are refreshed. On Android a
refresh never yields `permanentlyDenied`, so a stored `permanentlyDenied` is
only true right after a request stored its result and drops back to `denied` on
the next refresh. That is intended: the user may have changed the permission in
Settings in the meantime.

## 6. Verify on a device or emulator

Use a debug build of the app. `<pkg>` is the application id.

1. Fresh install. Trigger the feature, tap **Don't allow**. The app must
   behave as "denied" (no settings prompt).
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

## 7. If an app cannot upgrade yet

The unfixed plugin is wrong only about `status`. Apps on an older version can
avoid the stuck state by following the rules in section 4 today: ignore
`status.isPermanentlyDenied` on Android, always call `request()` and act on its
result. With the old plugin a request after **Ask every time** shows the
dialog and reports `granted` or `denied` correctly; only the pre-check was
lying.

## 8. Background

- Root cause: choosing **Ask every time** revokes the permission as a one-time
  permission, which clears `FLAG_PERMISSION_USER_SET`.
  `shouldShowRequestPermissionRationale()` returns exactly that flag, so it is
  `false`, and the old plugin combined that with a never-cleared
  "was denied before" flag in `SharedPreferences`.
- A second denial is now detected from the change of
  `shouldShowRequestPermissionRationale()` across the request (`true` ->
  `false`), so it is reported as `permanentlyDenied` even when the first denial
  happened in the app settings.
- Upstream issue: [#1206](https://github.com/Baseflow/flutter-permission-handler/issues/1206).
- See the `permission_handler_android` 14.1.0 entry in its
  [CHANGELOG](https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler_android/CHANGELOG.md).
