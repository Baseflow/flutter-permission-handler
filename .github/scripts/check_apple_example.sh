#!/usr/bin/env bash
# Checks run on the permission_handler_apple example after CI built it.
#
# Expects `dart run permission_handler_apple:select release` and
# `flutter build ios --no-codesign --release` to have run in the example first.
# Meant for CI: it enables Swift Package Manager in the global Flutter config,
# clears the Swift Package Manager manifest cache and leaves the example without
# a flavor selection, so it refuses to run anywhere else.
set -euo pipefail

if [[ "${CI:-}" != "true" ]]; then
  echo "This script changes global Flutter and Swift Package Manager state and is" >&2
  echo "meant for CI. Run it with CI=true to run it anyway." >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
example_dir="${repo_root}/permission_handler_apple/example"
tmp="${RUNNER_TEMP:-$(mktemp -d)}"
cd "${example_dir}"

# Guard the Swift Package Manager permission resolution.
#
# Package.swift turns the usage description keys of the host app's
# Info.plist into PERMISSION_* macros. When that breaks, every macro
# silently falls back to 0 and all permissions are compiled out, so assert
# on the resolved manifest rather than on the build succeeding.
#
# The example declares two flavors over two Info.plist files that differ by
# exactly one key: `debug` (Info-Debug.plist, the build-configuration
# specific layout reported in issue #1548) has no contacts entry,
# `release` (Info.plist) does. That single difference is what proves both
# that a flavor cannot inherit another flavor's permissions and, on the
# legacy path, that both plists were discovered and merged.
echo "::group::Verify SPM permission resolution"
flutter config --enable-swift-package-manager
flutter build ios --config-only --debug --no-codesign

# Resolve the manifest under a given environment, capturing the macros
# (stdout) and the PERMISSION_HANDLER_VERBOSE diagnostics (stderr).
resolve() { # <name> <VAR=value>...
  local name="$1"; shift
  rm -rf ~/Library/Caches/org.swift.swiftpm/manifests
  env PERMISSION_HANDLER_VERBOSE=1 "$@" swift package --manifest-cache none \
    --package-path ios/Flutter/ephemeral/Packages/.packages/permission_handler_apple \
    dump-package > "${tmp}/${name}.json" 2> "${tmp}/${name}.log"
  echo "--- ${name} ---"
  cat "${tmp}/${name}.log"
}

expect() { # <name> <macro=value>...
  local name="$1"; shift
  for macro in "$@"; do
    grep -qF "${macro}" "${tmp}/${name}.json" || {
      echo "::error::[${name}] expected ${macro} in the resolved manifest"
      grep -o 'PERMISSION_[A-Z_]*=[01]' "${tmp}/${name}.json" | sort -u
      exit 1
    }
  done
}

expect_log() { # <name> <fixed string> <message>
  grep -qF "$2" "${tmp}/$1.log" || { echo "::error::[$1] $3"; exit 1; }
}

# Without a permission_handler.yaml the pre-flavor behaviour has to be
# unchanged: discover every Info.plist and merge them. PERMISSION_CONTACTS
# can only be 1 if both plists were found, which is what makes this
# assert on the discovery rather than on the example's default plist.
resolve legacy PERMISSION_HANDLER_CONFIG=/nonexistent/permission_handler.yaml
expect_log legacy 'Runner/Info.plist' \
  'ios/Runner/Info.plist was not discovered'
expect_log legacy 'Runner/Info-Debug.plist' \
  'ios/Runner/Info-Debug.plist was not discovered — INFOPLIST_FILE parsing is broken'
expect_log legacy 'NSContactsUsageDescription' \
  'the divergence warning did not fire — the plists were not merged'
expect legacy PERMISSION_CONTACTS=1 PERMISSION_CAMERA=1 PERMISSION_MICROPHONE=1 \
  PERMISSION_PHOTOS=1 PERMISSION_LOCATION=1

# The debug flavor must not see the release flavor's contacts entry.
resolve debug PERMISSION_HANDLER_FLAVOR=debug
expect debug PERMISSION_CONTACTS=0 PERMISSION_CAMERA=1 PERMISSION_MICROPHONE=1

# ...and the release flavor must see it.
resolve release PERMISSION_HANDLER_FLAVOR=release
expect release PERMISSION_CONTACTS=1 PERMISSION_CAMERA=1 PERMISSION_MICROPHONE=1

# With `strict: true` an unresolved flavor compiles nothing in,
# rather than falling back to the union of every flavor. The earlier
# build step recorded a selection, so drop it first — otherwise the
# manifest resolves that flavor and this asserts nothing. The
# generated resolved.json stays; only the selection is missing.
rm -f ios/Flutter/permission_handler.selected
resolve strict
expect strict PERMISSION_CONTACTS=0 PERMISSION_CAMERA=0 PERMISSION_MICROPHONE=0

# Editing permission_handler.yaml without re-running `select` must not
# build with the stale translation: everything compiles out and the
# manifest says to re-run select.
touch permission_handler.yaml
resolve stale PERMISSION_HANDLER_FLAVOR=release
expect stale PERMISSION_CONTACTS=0 PERMISSION_CAMERA=0 PERMISSION_MICROPHONE=0
expect_log stale 'modified after its generated translation' \
  'the staleness guard did not fire'

resolve explicit PERMISSION_HANDLER_INFO_PLIST="${PWD}/ios/Runner/Info.plist"
expect_log explicit 'Runner/Info.plist' \
  'PERMISSION_HANDLER_INFO_PLIST was not used as the Info.plist'
expect explicit PERMISSION_CONTACTS=1 PERMISSION_CAMERA=1 PERMISSION_MICROPHONE=1
echo "::endgroup::"

# An app target whose INFOPLIST_FILE is built from a variable this manifest
# does not expand, next to an extension carrying Xcode's stock
# `GENERATE_INFOPLIST_FILE = YES`. Neither yields a usable path, so the
# scan of `ios/` has to take over; a settings hit that resolves to nothing
# must not suppress it. Built here rather than committed, because it is a
# project layout the example cannot also be.
echo "::group::Verify SPM detection falls back to scanning"
app="${tmp}/fallback-app"
rm -rf "${app}"
mkdir -p "${app}/ios/Extension.xcodeproj" "${app}/ios/Runner"
touch "${app}/pubspec.yaml"
cp "${example_dir}/ios/Runner/Info.plist" "${app}/ios/Runner/Info.plist"
printf 'GENERATE_INFOPLIST_FILE = YES;\nINFOPLIST_FILE = "$(TARGET_NAME)/Info.plist";\n' \
  > "${app}/ios/Extension.xcodeproj/project.pbxproj"

(
  cd "${app}"
  rm -rf ~/Library/Caches/org.swift.swiftpm/manifests
  PERMISSION_HANDLER_VERBOSE=1 swift package --manifest-cache none \
    --package-path "${repo_root}/permission_handler_apple/ios/permission_handler_apple" \
    dump-package > "${tmp}/fallback.json" 2> "${tmp}/fallback.log"
)
cat "${tmp}/fallback.log"

grep -qF 'PERMISSION_CAMERA=1' "${tmp}/fallback.json" || {
  echo "::error::the scan fallback did not run — an unresolvable INFOPLIST_FILE suppressed it"
  exit 1
}
echo "::endgroup::"

# The build phase that catches a stale selection is the only check that
# runs on every build, so make sure it actually fails.
echo "::group::Verify flavor mismatch fails the build"
dart run permission_handler_apple:select release
if xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner \
     -configuration Debug -sdk iphonesimulator \
     -derivedDataPath "${tmp}/dd" build > "${tmp}/mismatch.log" 2>&1; then
  echo "::error::a Debug build with the release flavor selected should have failed"
  exit 1
fi
grep -q 'needs the "debug" permission flavor' "${tmp}/mismatch.log" || {
  echo "::error::build failed, but not with the flavor mismatch error"
  tail -40 "${tmp}/mismatch.log"
  exit 1
}
echo "::endgroup::"
