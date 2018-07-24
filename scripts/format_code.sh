#!/bin/bash

set -e
cd ..

# Format Dart code
printf 'Formatting Dart code\n'
flutter format .
printf '\n'

# Format Objective-C code
printf 'Formatting Objective-C code\n'
find . \( -name '*.h' -o -name '*.m' \) -exec clang-format -i -style=Google '{}' \;
printf '\n'

# Format Java code
printf 'Formatting JAVA code\n'
find . \( -name '*.java' \) -exec java -jar ./scripts/utils/google-java-format-1.3-all-deps.jar --replace '{}' \;
printf '\n'

modified_files=$(git ls-files --modified)
if [[ $modified_files ]]; then
    printf 'These files are not formatted correctly:\n'
    printf '\n'
    echo $modified_files | tr ' ' '\n'
    exit 1
else
    printf "All files are formatted correctly"
    exit 0
fi
