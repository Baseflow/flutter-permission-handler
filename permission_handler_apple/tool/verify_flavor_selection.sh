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
# The user-facing config is permission_handler.yaml, but this script reads the
# generated permission_handler.resolved.json that `select` derives from it —
# `yaml` is not in the Python standard library, and JSON is. The YAML file
# itself is consulted only for existence and modification time, to catch a
# translation that is missing or stale.
#
# Add it as a "Run Script" build phase on the Runner target, as early in the
# phase list as possible so a mismatch fails before the app is compiled. It is a
# no-op for projects without a permission_handler.yaml and for CocoaPods builds.

set -eu

APP_ROOT="${SRCROOT}/.."
CONFIG="${APP_ROOT}/permission_handler.yaml"
RESOLVED="${APP_ROOT}/ios/Flutter/permission_handler.resolved.json"
SELECTION="${APP_ROOT}/ios/Flutter/permission_handler.selected"
SPM_PACKAGE="${SRCROOT}/Flutter/ephemeral/Packages/.packages/permission_handler_apple"

# Per-flavor permissions are opt-in; nothing to check without a config.
[ -f "${CONFIG}" ] || exit 0

# Only Swift Package Manager builds resolve permissions from Package.swift.
# Under CocoaPods the PERMISSION_* macros come from the Podfile's
# GCC_PREPROCESSOR_DEFINITIONS, which this script has no say over, so a flavor
# selection means nothing and must not fail the build.
[ -d "${SPM_PACKAGE}" ] || exit 0

if [ ! -f "${RESOLVED}" ]; then
  echo "error: [permission_handler_apple] ${CONFIG} is present but its generated translation (${RESOLVED}) is not, so no permissions were compiled in. Run: dart run permission_handler_apple:select <flavor>"
  exit 1
fi

# `find -newer` instead of `[ -nt ]`: -nt is a bash extension and this script
# declares /bin/sh. Errors are not swallowed — a comparison that could not run
# is reported rather than read as "not stale", which would let a stale
# translation build silently.
if ! STALE=$(find "${CONFIG}" -newer "${RESOLVED}" 2>&1); then
  echo "error: [permission_handler_apple] could not compare ${CONFIG} against its generated translation: ${STALE}"
  exit 1
fi

if [ -n "${STALE}" ]; then
  echo "error: [permission_handler_apple] ${CONFIG} was modified after its generated translation, so this build would use a stale permission configuration. Run: dart run permission_handler_apple:select <flavor>"
  exit 1
fi

if [ ! -x /usr/bin/python3 ]; then
  echo "warning: [permission_handler_apple] /usr/bin/python3 not found, skipping flavor verification."
  exit 0
fi

EXPECTED=$(/usr/bin/python3 - "${RESOLVED}" "${CONFIGURATION}" <<'PY'
import json, sys

resolved_path, configuration = sys.argv[1], sys.argv[2]
try:
    with open(resolved_path) as handle:
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
    echo "error: [permission_handler_apple] ${RESOLVED} could not be read: ${EXPECTED#!invalid:}. Run: dart run permission_handler_apple:select <flavor>"
    exit 1
    ;;
  '')
    echo "warning: [permission_handler_apple] no flavor in ${CONFIG} lists the \"${CONFIGURATION}\" configuration, so the compiled permissions cannot be verified. Add it to the flavor's \"configurations\" list."
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
