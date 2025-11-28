---
description: Initialize spec-driven development structure for the project
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Bootstrap a project for streamlined spec-driven development by creating the necessary directory structure and constitution file.

## Execution Steps

1. **Verify project root**: Find the git repository root or current working directory

2. **Create Specs directory**:
   - Create `Specs/` directory in project root if it doesn't exist
   - This will hold all feature specifications

3. **Check for existing constitution**:
   - Look for `Specs/constitution.md`
   - If exists: inform user and skip
   - If not exists: proceed to step 4

4. **Copy constitution template**:
   - Read the template from `~/.claude/spec-templates/constitution-template.md`
   - Copy it to `Specs/constitution.md`
   - Inform user that they should run `/constitution` to fill it out

5. **Create .gitignore entry** (if git repo):
   - Check if `.gitignore` exists
   - If not, create it
   - Add `Specs/**/*.swp` and `Specs/**/.*` to ignore temp files

6. **Report completion**:
   - Confirm Specs/ directory created
   - Confirm constitution.md template installed
   - Next step: run `/constitution` to define project principles

## Notes

- This command only needs to be run once per project
- If Specs/ already exists, this command is idempotent
- The constitution should be filled out before creating features with `/specify`
