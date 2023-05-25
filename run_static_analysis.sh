#!/bin/bash
# Run this in the root of the project to run the static analysis tools.
# Can't run the script? Try `chmod +x run_static_analysis.sh` to make it executable.

# Assumes that you have the following installed:
# - dart
# - flutter



# create an array containing the commands
commands=(
    "flutter analyze"
    "dart format --set-exit-if-changed ."
    "flutter pub run dart_code_metrics:metrics analyze lib --fatal-style --fatal-performance --fatal-warnings --reporter=console"
    "flutter pub run dart_code_metrics:metrics check-unused-files --exclude=/**.graphql.dart lib"
    "flutter pub run dart_code_metrics:metrics check-unnecessary-nullable lib"
    "flutter pub run dart_code_metrics:metrics check-unused-code lib --fatal-unused --monorepo"
    "flutter pub run dependency_validator"
)

# loop through the array and execute each command
for command in "${commands[@]}"; do
    echo ""
    echo "Running command: $command"
    $command # run the command
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then # exit if the command fails
        echo "❌ Static analysis failed for '$command'"
        exit $EXIT_CODE
    fi
    echo "✅ Static analysis passed for '$command'"
done

echo ""
echo "✅ Static analysis completed successfully, good job!"
