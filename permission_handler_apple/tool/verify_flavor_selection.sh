#!/bin/sh
#
# Fails the build when the permissions compiled into the Swift package do not
# belong to the configuration being built.
#
# A Swift package manifest is evaluated once, is cached, and is given none of
# Xcode's build settings, so it cannot tell which configuration is running and
# cannot notice that its answer went stale. This script runs as a build phase of
# the app target, where CONFIGURATION *is* available, and compares it against the
# flavor recorded by `dart run permission_handler_apple:select`.
#
# Add it as a "Run Script" build phase on the Runner target, as early in the
# phase list as possible so a mismatch fails before the app is compiled. It is a
# no-op for projects without a permission_handler.json and for CocoaPods builds.

set -eu

APP_ROOT="${SRCROOT}/.."
CONFIG="${APP_ROOT}/permission_handler.json"
SELECTION="${APP_ROOT}/ios/Flutter/permission_handler.selected"
SPM_PACKAGE="${SRCROOT}/Flutter/ephemeral/Packages/.packages/permission_handler_apple"

# Per-flavor permissions are opt-in; nothing to check without a config.
[ -f "${CONFIG}" ] || exit 0

# Only Swift Package Manager builds resolve permissions from Package.swift.
# Under CocoaPods the PERMISSION_* macros come from the Podfile's
# GCC_PREPROCESSOR_DEFINITIONS, which this script has no say over, so a flavor
# selection means nothing and must not fail the build.
[ -d "${SPM_PACKAGE}" ] || exit 0

if [ ! -x /usr/bin/python3 ]; then
  echo "warning: [permission_handler_apple] /usr/bin/python3 not found, skipping flavor verification."
  exit 0
fi

EXPECTED=$(/usr/bin/python3 - "${CONFIG}" "${CONFIGURATION}" <<'PY'
import json, sys

config_path, configuration = sys.argv[1], sys.argv[2]
try:
    with open(config_path) as handle:
        flavors = json.load(handle).get("flavors", {})
except (OSError, ValueError) as error:
    print(f"!invalid:{error}")
    sys.exit(0)

for name, entry in flavors.items():
    if configuration in (entry or {}).get("configurations", []):
        print(name)
        break
PY
)

case "${EXPECTED}" in
  '!invalid:'*)
    echo "error: [permission_handler_apple] ${CONFIG} could not be read: ${EXPECTED#!invalid:}"
    exit 1
    ;;
  '')
    echo "warning: [permission_handler_apple] no flavor in ${CONFIG} lists the \"${CONFIGURATION}\" configuration, so the compiled permissions cannot be verified. Add it to the flavor's \"configurations\" array."
    exit 0
    ;;
esac

if [ ! -f "${SELECTION}" ]; then
  echo "error: [permission_handler_apple] building \"${CONFIGURATION}\" needs the \"${EXPECTED}\" permission flavor, but no flavor has been selected. Run: dart run permission_handler_apple:select ${EXPECTED}"
  exit 1
fi

SELECTED=$(tr -d '[:space:]' < "${SELECTION}")

if [ "${SELECTED}" != "${EXPECTED}" ]; then
  echo "error: [permission_handler_apple] building \"${CONFIGURATION}\" needs the \"${EXPECTED}\" permission flavor, but \"${SELECTED}\" is selected, so this build would ship ${SELECTED}'s permissions. Run: dart run permission_handler_apple:select ${EXPECTED}"
  exit 1
fi
