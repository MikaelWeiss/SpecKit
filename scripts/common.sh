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

# Get current branch
get_current_branch() {
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
    else
        echo "main"
    fi
}

# Check if we have git available
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

# Check if current branch follows feature branch naming (NNN-name)
check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    if [[ "$has_git_repo" != "true" ]]; then
        echo "[Warning] Git repository not detected; skipped branch validation" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch" >&2
        echo "Feature branches should be named like: 001-feature-name" >&2
        return 1
    fi

    return 0
}

# Find feature directory by numeric prefix
# Supports multiple branches working on same spec (e.g., 004-fix, 004-feature both use Specs/004-main/)
find_feature_dir() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/Specs"

    # Extract numeric prefix from branch (e.g., "004" from "004-whatever")
    if [[ ! "$branch_name" =~ ^([0-9]{3})- ]]; then
        # If branch doesn't have numeric prefix, use branch name exactly
        echo "$specs_dir/$branch_name"
        return
    fi

    local prefix="${BASH_REMATCH[1]}"

    # Search for directory in Specs/ that starts with this prefix
    local matches=()
    if [[ -d "$specs_dir" ]]; then
        for dir in "$specs_dir"/"$prefix"-*; do
            if [[ -d "$dir" ]]; then
                matches+=("$(basename "$dir")")
            fi
        done
    fi

    # Handle results
    if [[ ${#matches[@]} -eq 0 ]]; then
        # No match found - return the branch name path
        echo "$specs_dir/$branch_name"
    elif [[ ${#matches[@]} -eq 1 ]]; then
        # Exactly one match - perfect!
        echo "$specs_dir/${matches[0]}"
    else
        # Multiple matches - use first one but warn
        echo "Warning: Multiple spec directories found with prefix '$prefix': ${matches[*]}" >&2
        echo "$specs_dir/${matches[0]}"
    fi
}

# Get all feature paths (outputs bash variables)
get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    local feature_dir=$(find_feature_dir "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
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
