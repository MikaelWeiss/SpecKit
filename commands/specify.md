---
description: Create feature specification with worktree and consolidated spec document
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Create a new feature specification in a dedicated worktree with a consolidated spec.md that includes user stories, technical approach, data model, and success criteria.

## Execution Flow

1. **Validate prerequisites**:
   - Check that `Specs/` directory exists (if not: ERROR "Run /setup-specs first")
   - Check that `Specs/constitution.md` exists and is filled out (no `[...]` placeholders)
   - Verify we're in a git repository

2. **Parse feature description**:
   - Feature description comes from $ARGUMENTS
   - If empty: ERROR "Provide a feature description, e.g., /specify 'Add user authentication'"

3. **Generate short-name** (2-4 words):
   - Extract meaningful keywords from description
   - Use action-noun format when possible
   - Keep technical terms intact
   - Examples:
     - "Add user authentication" → "user-auth"
     - "Implement OAuth2 integration" → "oauth2-integration"
     - "Fix payment timeout bug" → "fix-payment-timeout"

4. **Find next available number**:
   - Check remote branches: `git ls-remote --heads origin | grep -E 'refs/heads/[0-9]+-<short-name>$'`
   - Check local branches: `git branch | grep -E '^[* ]*[0-9]+-<short-name>$'`
   - Check Specs directories: `find Specs/ -maxdepth 1 -type d -name '[0-9]*-<short-name>'`
   - Find highest number N across all three sources
   - Use N+1 (or 001 if none found)

5. **Create worktree**:
   - Branch name: `<number>-<short-name>` (e.g., "001-user-auth")
   - Execute: `git worktree add -b "<branch-name>" ".worktrees/<branch-name>"`
   - If worktree creation fails: ERROR with helpful message
   - **Do NOT push to origin** (user will do this manually when ready)

6. **Create Specs directory in worktree**:
   - Within the worktree, create: `Specs/<branch-name>/`
   - This is where the spec.md will live

7. **Load spec template**:
   - Read `~/.claude/spec-templates/spec-template.md`

8. **Analyze feature description and fill spec**:
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

9. **Write spec file**:
   - Path: `.worktrees/<branch-name>/Specs/<branch-name>/spec.md`
   - Replace all template placeholders with concrete content
   - Fill [FEATURE_NAME], [BRANCH_NAME], [DATE], etc.
   - Ensure user stories are prioritized and independently testable

10. **Report completion**:
    - Confirm worktree created at `.worktrees/<branch-name>`
    - Confirm spec created at `.worktrees/<branch-name>/Specs/<branch-name>/spec.md`
    - List user stories identified (with priorities)
    - Suggest next steps:
      - "Review the spec in the worktree"
      - "If clarification needed, run /clarify"
      - "When ready, run /tasks to generate implementation tasks"
      - "To push branch: `cd .worktrees/<branch-name> && git push -u origin <branch-name>`"

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

## Example

**User**: /specify "Add ability for users to track daily habits and see streak counts"

**Assistant**:
[Analyzes description, generates short-name: "habit-tracking"]
[Finds next number: 001]
[Creates worktree at .worktrees/001-habit-tracking]
[Generates spec with 3 user stories:
  - P1: Create and mark habits as complete
  - P2: View streak counts and history
  - P3: Get daily reminders for habits
]
[Writes spec to .worktrees/001-habit-tracking/Specs/001-habit-tracking/spec.md]
[Reports completion with next steps]
