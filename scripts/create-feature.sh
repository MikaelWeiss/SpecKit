#!/usr/bin/env bash

set -e

# Parse arguments
FEATURE_DESCRIPTION=""
SHORT_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --short-name)
            SHORT_NAME="$2"
            shift 2
            ;;
        --help|-h)
            cat <<EOF
Usage: $0 [--short-name <name>] <feature_description>

Creates a new feature spec directory.

Options:
  --short-name <name>  Custom short name (2-4 words) for the feature
  --help, -h           Show this help message

Examples:
  $0 "Add user authentication system"
  $0 --short-name "user-auth" "Add user authentication"
  $0 "Implement OAuth2 integration"
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

# Generate short-name
if [ -n "$SHORT_NAME" ]; then
    # Use provided short name, just clean it up
    FEATURE_NAME=$(echo "$SHORT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
else
    # Generate from description
    FEATURE_NAME=$(generate_short_name "$FEATURE_DESCRIPTION")
fi

# Define paths
SPEC_DIR="$REPO_ROOT/Specs/$FEATURE_NAME"
SPEC_FILE="$SPEC_DIR/spec.md"

# Check if feature already exists
if [ -d "$SPEC_DIR" ]; then
    echo "ERROR: Feature directory already exists: $SPEC_DIR" >&2
    echo "Choose a different name with --short-name or remove the existing directory" >&2
    exit 1
fi

# Create spec directory
mkdir -p "$SPEC_DIR"

# Output variables for use by calling script
cat <<EOF
FEATURE_NAME='$FEATURE_NAME'
SPEC_DIR='$SPEC_DIR'
SPEC_FILE='$SPEC_FILE'
EOF
