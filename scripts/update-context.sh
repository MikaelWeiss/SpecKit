#!/usr/bin/env bash

set -e

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get feature paths
eval $(get_feature_paths)

# Validate spec file exists
if ! file_exists "$SPEC_FILE"; then
    echo "ERROR: Spec file not found: $SPEC_FILE" >&2
    exit 1
fi

# Define CLAUDE.md path
CLAUDE_FILE="$REPO_ROOT/CLAUDE.md"

# Check if CLAUDE.md exists
if [ ! -f "$CLAUDE_FILE" ]; then
    echo "Note: CLAUDE.md not found. Skipping context update." >&2
    echo "Create CLAUDE.md in your repository root if you want automatic updates." >&2
    exit 0
fi

# Extract Technical Approach section from spec.md
extract_tech_stack() {
    local spec_file="$1"

    # Look for ## Technical Approach section
    # Extract content between "## Technical Approach" and next "##" heading
    awk '
        /^## Technical Approach/ { capture=1; next }
        /^##/ && capture { exit }
        capture { print }
    ' "$spec_file" | sed '/^$/d' | head -20  # Get first 20 non-empty lines
}

# Update CLAUDE.md with tech stack
update_claude_md() {
    local tech_stack="$1"
    local claude_file="$2"
    local feature_name=$(basename "$FEATURE_DIR")
    local timestamp=$(date +"%Y-%m-%d")

    # Check if Active Technologies section exists
    if ! grep -q "## Active Technologies" "$claude_file"; then
        # Add section at the end before any other sections that should come last
        cat >> "$claude_file" <<EOF

## Active Technologies
<!-- SPEC_TECH_START -->
<!-- This section is auto-updated from feature specs -->
<!-- Manual additions should go above or below the markers -->
- $feature_name: $tech_stack (added $timestamp)
<!-- SPEC_TECH_END -->
EOF
        echo "Added Active Technologies section to CLAUDE.md"
    else
        # Update existing section between markers
        if grep -q "<!-- SPEC_TECH_START -->" "$claude_file"; then
            # Replace content between markers
            awk -v tech="- $feature_name: $tech_stack (added $timestamp)" '
                /<!-- SPEC_TECH_START -->/ { print; print "<!-- This section is auto-updated from feature specs -->"; print "<!-- Manual additions should go above or below the markers -->"; print tech; skip=1; next }
                /<!-- SPEC_TECH_END -->/ { skip=0 }
                !skip { print }
            ' "$claude_file" > "$claude_file.tmp" && mv "$claude_file.tmp" "$claude_file"
            echo "Updated Active Technologies in CLAUDE.md"
        else
            # Add markers and content to existing section
            awk -v tech="- $feature_name: $tech_stack (added $timestamp)" '
                /^## Active Technologies/ {
                    print
                    print "<!-- SPEC_TECH_START -->"
                    print "<!-- This section is auto-updated from feature specs -->"
                    print "<!-- Manual additions should go above or below the markers -->"
                    print tech
                    print "<!-- SPEC_TECH_END -->"
                    next
                }
                { print }
            ' "$claude_file" > "$claude_file.tmp" && mv "$claude_file.tmp" "$claude_file"
            echo "Added markers to Active Technologies in CLAUDE.md"
        fi
    fi
}

# Extract tech stack from spec
TECH_STACK=$(extract_tech_stack "$SPEC_FILE")

if [ -z "$TECH_STACK" ]; then
    echo "Note: No Technical Approach section found in spec. Skipping context update." >&2
    exit 0
fi

# Format tech stack as single line (first line only for summary)
TECH_SUMMARY=$(echo "$TECH_STACK" | head -1 | sed 's/^[*-] *//' | sed 's/\*\*//g' | tr -d '\n')

if [ -z "$TECH_SUMMARY" ]; then
    echo "Note: Could not extract tech stack summary. Skipping context update." >&2
    exit 0
fi

# Update CLAUDE.md
update_claude_md "$TECH_SUMMARY" "$CLAUDE_FILE"

echo "Context updated successfully"
