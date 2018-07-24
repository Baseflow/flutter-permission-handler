#!/bin/bash

set -e

cd ../example

if [[ $1 == 'apk' ]]; then
    flutter build apk
elif [[ $1 == 'ios' ]]; then
    flutter build ios --no-codesign
else
    echo "Neither 'apk' or 'ios' were specified, so not building"
fi
