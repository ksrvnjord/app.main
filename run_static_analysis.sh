#!/bin/bash
# Run this in the root of the project to run the static analysis tools.
# Can't run the script? Try `chmod +x run_static_analysis.sh` to make it executable.

# Assumes that you have the following installed:
# - dart
# - flutter

# Function to search for the string in files recursively
search_recursively() {
    local dir="$1"
    local target="$2"
    
    # Use find to search for files in the directory and its subdirectories
    find "$dir" -type f -exec grep -Hn "$target" {} +
    
    # Check the exit status of find
    if [ $? -eq 0 ]; then
        echo "❌ Found occurence of '$target' in '$dir' or its subdirectories"
        echo "Consider using the adaptive version of the widget instead"
        echo "Example: CircularProgressIndicator.adaptive()"
        exit 1
    fi
    
    echo "✅ Found no occurences of '$target' in '$dir' or its subdirectories"
}

# These patterns should be replaced with their adaptive versions: https://docs.flutter.dev/platform-integration/platform-adaptations
forbidden_patterns=("CircularProgressIndicator(" "Switch(" "Slider(" "Radio(" "Checkbox(")

# Iterate through the array using a for loop
for item in "${forbidden_patterns[@]}"; do
    search_recursively "lib" "$item"
done



# create an array containing the commands
commands=(
    "dart format --set-exit-if-changed ."
    "dcm analyze lib --fatal-style --fatal-performance --fatal-warnings --reporter=console"
    "dcm check-unused-files --exclude=/**.graphql.dart lib"
    "dcm check-unnecessary-nullable lib"
    "dcm check-unused-code lib --fatal-unused --monorepo"
    "dart run dependency_validator"
    "flutter analyze"
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
