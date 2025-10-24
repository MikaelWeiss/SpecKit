#!/usr/bin/env bash

set -e

# Parse arguments
FEATURE_DESCRIPTION=""
SHORT_NAME=""
BRANCH_NUMBER=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --short-name)
            SHORT_NAME="$2"
            shift 2
            ;;
        --number)
            BRANCH_NUMBER="$2"
            shift 2
            ;;
        --help|-h)
            cat <<EOF
Usage: $0 [--short-name <name>] [--number N] <feature_description>

Creates a new feature branch with worktree and Specs directory.

Options:
  --short-name <name>  Custom short name (2-4 words) for the branch
  --number N           Specify branch number manually (overrides auto-detection)
  --help, -h           Show this help message

Examples:
  $0 "Add user authentication system"
  $0 --short-name "user-auth" "Add user authentication"
  $0 --number 5 "Implement OAuth2 integration"
EOF
            exit 0
            ;;
        *)
            FEATURE_DESCRIPTION="$FEATURE_DESCRIPTION $1"
            shift
            ;;
    esac
done

FEATURE_DESCRIPTION=$(echo "$FEATURE_DESCRIPTION" | xargs)

if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "ERROR: Feature description required" >&2
    echo "Usage: $0 [OPTIONS] <feature_description>" >&2
    exit 1
fi

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Navigate to main repo root if inside a worktree
navigate_to_repo_root

# Get repository root
REPO_ROOT=$(get_repo_root)
cd "$REPO_ROOT"

# Ensure Specs directory exists
mkdir -p "$REPO_ROOT/Specs"

# Function to generate short-name from description
generate_short_name() {
    local description="$1"

    # Common stop words to filter out
    local stop_words="^(i|a|an|the|to|for|of|in|on|at|by|with|from|is|are|was|were|be|been|being|have|has|had|do|does|did|will|would|should|could|can|may|might|must|shall|this|that|these|those|my|your|our|their|want|need|add|get|set)$"

    # Convert to lowercase and split into words
    local clean_name=$(echo "$description" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/ /g')

    # Filter words: remove stop words and short words (unless uppercase acronyms in original)
    local meaningful_words=()
    for word in $clean_name; do
        [ -z "$word" ] && continue

        # Keep words that are NOT stop words AND length >= 3
        if ! echo "$word" | grep -qiE "$stop_words"; then
            if [ ${#word} -ge 3 ]; then
                meaningful_words+=("$word")
            elif echo "$description" | grep -q "\b${word^^}\b"; then
                # Keep short words if they appear as uppercase in original (likely acronyms)
                meaningful_words+=("$word")
            fi
        fi
    done

    # Use first 2-4 meaningful words
    if [ ${#meaningful_words[@]} -gt 0 ]; then
        local max_words=3
        if [ ${#meaningful_words[@]} -eq 2 ]; then max_words=2; fi
        if [ ${#meaningful_words[@]} -ge 4 ]; then max_words=4; fi

        local result=""
        local count=0
        for word in "${meaningful_words[@]}"; do
            if [ $count -ge $max_words ]; then break; fi
            if [ -n "$result" ]; then result="$result-"; fi
            result="$result$word"
            count=$((count + 1))
        done
        echo "$result"
    else
        # Fallback to simple approach
        echo "$description" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//' | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//'
    fi
}

# Function to find next available branch number
find_next_number() {
    local short_name="$1"

    # Check remote branches
    git fetch --all --prune 2>/dev/null || true
    local remote_branches=$(git ls-remote --heads origin 2>/dev/null | grep -E "refs/heads/[0-9]+-${short_name}$" | sed 's/.*\/\([0-9]*\)-.*/\1/' | sort -n || echo "")

    # Check local branches
    local local_branches=$(git branch 2>/dev/null | grep -E "^[* ]*[0-9]+-${short_name}$" | sed 's/^[* ]*//' | sed 's/-.*//' | sort -n || echo "")

    # Check Specs directories
    local spec_dirs=""
    if [ -d "$REPO_ROOT/Specs" ]; then
        spec_dirs=$(find "$REPO_ROOT/Specs" -maxdepth 1 -type d -name "[0-9]*-${short_name}" 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/-.*//' | sort -n || echo "")
    fi

    # Find highest number across all sources
    local max_num=0
    for num in $remote_branches $local_branches $spec_dirs; do
        if [ "$num" -gt "$max_num" ]; then
            max_num=$num
        fi
    done

    # Return next number (formatted as 3 digits)
    printf "%03d" $((max_num + 1))
}

# Generate short-name
if [ -n "$SHORT_NAME" ]; then
    # Use provided short name, just clean it up
    BRANCH_SUFFIX=$(echo "$SHORT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
else
    # Generate from description
    BRANCH_SUFFIX=$(generate_short_name "$FEATURE_DESCRIPTION")
fi

# Determine branch number
if [ -z "$BRANCH_NUMBER" ]; then
    if has_git; then
        BRANCH_NUMBER=$(find_next_number "$BRANCH_SUFFIX")
    else
        # Fall back to checking Specs/ only
        HIGHEST=0
        if [ -d "$REPO_ROOT/Specs" ]; then
            for dir in "$REPO_ROOT/Specs"/*-"$BRANCH_SUFFIX"; do
                if [ -d "$dir" ]; then
                    NUM=$(basename "$dir" | sed 's/-.*//')
                    if [ "$NUM" -gt "$HIGHEST" ]; then
                        HIGHEST=$NUM
                    fi
                fi
            done
        fi
        BRANCH_NUMBER=$(printf "%03d" $((HIGHEST + 1)))
    fi
else
    # Format provided number as 3 digits
    BRANCH_NUMBER=$(printf "%03d" "$BRANCH_NUMBER")
fi

# Create branch name
BRANCH_NAME="${BRANCH_NUMBER}-${BRANCH_SUFFIX}"
WORKTREE_PATH=".worktrees/$BRANCH_NAME"
SPEC_DIR="$WORKTREE_PATH/Specs/$BRANCH_NAME"
SPEC_FILE="$SPEC_DIR/spec.md"

# Create worktree if using git
if has_git; then
    # Create branch and worktree
    git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" 2>&1 || {
        echo "ERROR: Failed to create worktree at $WORKTREE_PATH" >&2
        echo "This usually means the branch already exists or the path is occupied." >&2
        exit 1
    }

    # Create Specs directory inside worktree
    mkdir -p "$SPEC_DIR"
else
    # Without git, just create directories
    mkdir -p "$SPEC_DIR"
    echo "Warning: Git not detected. Created directories without worktree." >&2
fi

# Output variables for use by calling script
cat <<EOF
BRANCH_NAME='$BRANCH_NAME'
BRANCH_NUMBER='$BRANCH_NUMBER'
SHORT_NAME='$BRANCH_SUFFIX'
WORKTREE_PATH='$WORKTREE_PATH'
SPEC_DIR='$SPEC_DIR'
SPEC_FILE='$SPEC_FILE'
EOF
