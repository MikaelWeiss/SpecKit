#!/usr/bin/env bash
# Common functions and variables for all scripts

# Get repository root
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        # Fall back to searching for Specs/ directory
        local dir="$PWD"
        while [ "$dir" != "/" ]; do
            if [ -d "$dir/Specs" ]; then
                echo "$dir"
                return 0
            fi
            dir="$(dirname "$dir")"
        done
        echo "$PWD"
    fi
}

# Check if we have git available
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

# Find feature directory in Specs
# Looks for a feature directory in Specs/ based on current context
find_feature_dir() {
    local repo_root="$1"
    local specs_dir="$repo_root/Specs"

    # If we're currently in a Specs subdirectory, use that
    local current_dir="$PWD"
    while [ "$current_dir" != "/" ] && [ "$current_dir" != "$repo_root" ]; do
        if [[ "$(dirname "$current_dir")" == "$specs_dir" ]]; then
            # We're directly inside a feature directory
            echo "$current_dir"
            return 0
        fi
        if [[ "$current_dir" == "$specs_dir" ]]; then
            # We're in Specs/ itself, can't determine feature
            break
        fi
        current_dir="$(dirname "$current_dir")"
    done

    # Otherwise, look for the most recently modified feature directory
    if [[ -d "$specs_dir" ]]; then
        local latest_dir=$(find "$specs_dir" -maxdepth 1 -type d ! -name "Specs" ! -name ".*" 2>/dev/null | grep -v "^$specs_dir$" | sort -t/ -k2 | tail -1)
        if [[ -n "$latest_dir" ]]; then
            echo "$latest_dir"
            return 0
        fi
    fi

    # No feature directory found
    echo ""
    return 1
}

# Get all feature paths (outputs bash variables)
get_feature_paths() {
    local repo_root=$(get_repo_root)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    local feature_dir=$(find_feature_dir "$repo_root")

    if [[ -z "$feature_dir" ]]; then
        echo "ERROR: Could not find feature directory. Are you in a Specs directory?" >&2
        return 1
    fi

    cat <<EOF
REPO_ROOT='$repo_root'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
SPEC_FILE='$feature_dir/spec.md'
TASKS_FILE='$feature_dir/tasks.md'
CHECKLIST_FILE='$feature_dir/checklist.md'
EOF
}

# Check if file exists and is not empty
file_exists() {
    [[ -f "$1" && -s "$1" ]]
}

# Check if directory exists and is not empty
dir_exists() {
    [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]]
}
