#!/usr/bin/env bash

set -e

# Parse arguments
REQUIRE_TASKS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --require-tasks)
            REQUIRE_TASKS=true
            shift
            ;;
        --help|-h)
            cat <<EOF
Usage: $0 [--require-tasks]

Finds the current feature spec and validates required files exist.

Options:
  --require-tasks  Require tasks.md to exist (for /implement)
  --help, -h       Show this help message

Examples:
  $0                    # For /clarify or /tasks
  $0 --require-tasks    # For /implement
EOF
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option: $1" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get feature paths
eval $(get_feature_paths)

# Validate spec file exists
if ! file_exists "$SPEC_FILE"; then
    echo "ERROR: Spec file not found: $SPEC_FILE" >&2
    echo "Run /specify first to create a feature specification" >&2
    exit 1
fi

# Validate tasks file if required
if [ "$REQUIRE_TASKS" = true ]; then
    if ! file_exists "$TASKS_FILE"; then
        echo "ERROR: Tasks file not found: $TASKS_FILE" >&2
        echo "Run /tasks first to generate implementation tasks" >&2
        exit 1
    fi
fi

# Output all paths (already done by get_feature_paths via eval)
get_feature_paths
