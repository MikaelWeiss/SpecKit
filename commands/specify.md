---
description: Create feature specification with worktree and consolidated spec document
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Create a new feature specification in a dedicated worktree with a consolidated spec.md that includes user stories, technical approach, data model, and success criteria. Includes automatic validation to ensure spec quality.

## Execution Flow

1. **Validate prerequisites**:
   - Check that `Specs/` directory exists (if not: ERROR "Run /setup-specs first")
   - Check that `Specs/constitution.md` exists and is filled out (no `[...]` placeholders)
   - Verify we're in a git repository

2. **Parse feature description**:
   - Feature description comes from $ARGUMENTS
   - If empty: ERROR "Provide a feature description, e.g., /specify 'Add user authentication'"

3. **Create feature branch and worktree**:
   - Run `~/.claude/spec-scripts/create-feature.sh "$ARGUMENTS"`
   - Script outputs bash variables: BRANCH_NAME, WORKTREE_PATH, SPEC_DIR, SPEC_FILE
   - Eval the output to set variables: `eval $(~/.claude/spec-scripts/create-feature.sh "$ARGUMENTS")`
   - Script handles:
     - **Detecting if inside a worktree**: If currently in `.worktrees/` folder, automatically navigates to main repo root
     - Generating short-name (2-4 words, stop-word filtering)
     - Finding next available number (checks remote/local branches + Specs/ dirs)
     - Creating branch: `git checkout -b NNN-short-name`
     - Creating worktree: `git worktree add -b "branch" ".worktrees/branch"`
     - Creating Specs directory: `.worktrees/branch/Specs/branch/`
   - **CRITICAL**: cd into the new worktree: `cd "$WORKTREE_PATH"`
   - **CRITICAL**: Only after changing to the worktree, proceed to reading files

4. **Load spec template**:
   - Read `~/.claude/spec-templates/spec-template.md`

5. **Analyze feature description and fill spec** (ONLY after cd into worktree):
   - **IMPORTANT**: Do NOT read any codebase files before this step
   - **IMPORTANT**: Only read codebase files from the clean worktree (prevents uncommitted changes from polluting spec)
   - Extract user goals and actions
   - Identify key concepts: actors, data, workflows
   - Generate 2-4 user stories with priorities (P1, P2, P3, P4)
   - Each story must be independently testable
   - P1 is the MVP (most critical functionality)
   - Fill Technical Approach based on project type (infer from codebase)
   - Identify data entities if applicable
   - Define measurable success criteria (technology-agnostic)
   - Mark Edge Cases
   - **Use reasonable defaults** - only add `[NEEDS CLARIFICATION: ...]` for critical decisions with multiple valid interpretations (max 3 total)

6. **Write spec file**:
   - Path: $SPEC_FILE (from script output)
   - Replace all template placeholders with concrete content
   - Fill [FEATURE_NAME], [BRANCH_NAME], [DATE], etc.
   - Ensure user stories are prioritized and independently testable

7. **Validation Loop** (automatic quality check):

   a. **Create checklist**:
      - Load `~/.claude/spec-templates/checklist-template.md`
      - Fill [FEATURE_NAME], [DATE]
      - Write to `$SPEC_DIR/checklist.md`

   b. **Validate spec against checklist**:
      - For each checklist item, review the spec
      - Document which items pass/fail
      - Track specific issues (quote relevant spec sections)

   c. **Handle validation results**:

      - **If all items pass**:
        - Mark all checklist items complete: `- [x]`
        - Write updated checklist
        - Proceed to step 8

      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the spec to address each issue
        3. Re-run validation (max 3 iterations total)
        4. If still failing after 3 iterations:
           - Mark failing items in checklist with notes
           - Warn user about remaining issues
           - Proceed anyway (user can fix manually)

      - **If [NEEDS CLARIFICATION] markers remain**:
        - This is OK - user will run /clarify to resolve them
        - Note in checklist: "Run /clarify to resolve NEEDS CLARIFICATION markers"
        - Proceed to step 8

8. **Report completion**:
   - Confirm worktree created at $WORKTREE_PATH
   - Confirm spec created at $SPEC_FILE
   - List user stories identified (with priorities)
   - Report validation status:
     - "✓ Spec validation passed" OR
     - "⚠ Spec validation completed with notes (see checklist.md)"
   - Suggest next steps:
     - "Review the spec in the worktree"
     - "Review checklist at $SPEC_DIR/checklist.md"
     - "If clarification needed, cd to worktree and run /clarify"
     - "When ready, run /tasks to generate implementation tasks"
     - "To push branch: `cd $WORKTREE_PATH && git push -u origin $BRANCH_NAME`"

## Quality Guidelines

**User Stories**:
- Must be independently testable (can implement just one and have a working feature)
- Prioritized by value (P1 = MVP, highest value)
- Written from user perspective (what they can do, not how it works)
- Each has clear acceptance criteria (Given/When/Then format)

**Technical Approach**:
- Identifies tech stack, architecture pattern, key dependencies
- Documents key technical decisions with rationales
- Includes storage approach if data is involved
- Specifies testing strategy

**Data Model**:
- Lists entities with fields and relationships
- Describes state management approach
- Keeps it high-level (no implementation details)

**Success Criteria**:
- Measurable outcomes (time, percentage, count)
- Technology-agnostic (user-facing, not implementation)
- Verifiable without knowing implementation
- Mix of quantitative and qualitative measures

**Clarifications**:
- Max 3 total `[NEEDS CLARIFICATION: ...]` markers
- Only for critical decisions that significantly impact scope/security/UX
- Must have multiple reasonable interpretations
- If reasonable default exists, use it (don't ask)

**Validation**:
- Automatic quality check ensures completeness
- Catches missing requirements early
- Forces testable, measurable specifications
- Max 3 validation iterations to avoid infinite loops

## Example

**User**: /specify "Add ability for users to track daily habits and see streak counts"

**Assistant**:
[Runs create-feature.sh, gets: BRANCH_NAME='001-habit-tracking', WORKTREE_PATH='.worktrees/001-habit-tracking', etc.]
[Generates spec with 3 user stories:
  - P1: Create and mark habits as complete
  - P2: View streak counts and history
  - P3: Get daily reminders for habits
]
[Writes spec to .worktrees/001-habit-tracking/Specs/001-habit-tracking/spec.md]
[Creates and validates checklist]
[If validation passes: marks all checklist items complete]
[Reports completion with validation status]
