#!/usr/bin/env bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Streamlined Specs Installer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directories
CLAUDE_DIR="$HOME/.claude"
TEMPLATES_DIR="$CLAUDE_DIR/spec-templates"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SCRIPTS_DIR="$CLAUDE_DIR/spec-scripts"

# Source directories
SOURCE_TEMPLATES="$SCRIPT_DIR/templates"
SOURCE_COMMANDS="$SCRIPT_DIR/commands"
SOURCE_SCRIPTS="$SCRIPT_DIR/scripts"

# Create target directories if they don't exist
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$TEMPLATES_DIR"
mkdir -p "$COMMANDS_DIR"
mkdir -p "$SCRIPTS_DIR"
echo -e "${GREEN}✓${NC} Directories ready"
echo ""

# Install templates
echo -e "${YELLOW}Installing templates...${NC}"
template_count=0
for template in "$SOURCE_TEMPLATES"/*.md; do
    if [ -f "$template" ]; then
        filename=$(basename "$template")
        target="$TEMPLATES_DIR/$filename"

        if [ -f "$target" ]; then
            echo -e "  ${BLUE}↻${NC} Updating $filename"
        else
            echo -e "  ${GREEN}+${NC} Installing $filename"
        fi

        cp "$template" "$target"
        ((template_count++))
    fi
done
echo -e "${GREEN}✓${NC} Installed $template_count templates"
echo ""

# Install scripts
echo -e "${YELLOW}Installing scripts...${NC}"
script_count=0
for script in "$SOURCE_SCRIPTS"/*.sh; do
    if [ -f "$script" ]; then
        filename=$(basename "$script")
        target="$SCRIPTS_DIR/$filename"

        if [ -f "$target" ]; then
            echo -e "  ${BLUE}↻${NC} Updating $filename"
        else
            echo -e "  ${GREEN}+${NC} Installing $filename"
        fi

        cp "$script" "$target"
        chmod +x "$target"  # Make executable
        ((script_count++))
    fi
done
echo -e "${GREEN}✓${NC} Installed $script_count scripts"
echo ""

# Install commands
echo -e "${YELLOW}Installing commands...${NC}"
command_count=0
for command in "$SOURCE_COMMANDS"/*.md; do
    if [ -f "$command" ]; then
        filename=$(basename "$command")
        target="$COMMANDS_DIR/$filename"

        if [ -f "$target" ]; then
            echo -e "  ${BLUE}↻${NC} Updating /$filename"
        else
            echo -e "  ${GREEN}+${NC} Installing /$filename"
        fi

        cp "$command" "$target"
        ((command_count++))
    fi
done
echo -e "${GREEN}✓${NC} Installed $command_count commands"
echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Installed:"
echo "  • $template_count templates → $TEMPLATES_DIR/"
echo "  • $script_count scripts → $SCRIPTS_DIR/"
echo "  • $command_count commands → $COMMANDS_DIR/"
echo ""
echo "Available commands:"
echo "  • /setup-specs    - Initialize project for spec-driven development"
echo "  • /constitution   - Define project principles"
echo "  • /specify        - Create feature spec (with worktree!)"
echo "  • /clarify        - Optional clarification (max 3 questions)"
echo "  • /tasks          - Generate task breakdown"
echo "  • /implement      - Execute implementation"
echo ""
echo "Next steps:"
echo "  1. cd to your project directory"
echo "  2. Run: /setup-specs"
echo "  3. Run: /constitution"
echo "  4. Start building: /specify \"your feature description\""
echo ""
echo -e "${BLUE}For full documentation, see README.md${NC}"
echo ""
