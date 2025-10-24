---
description: Optional clarification of ambiguous requirements in the spec (max 3 questions)
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Identify and resolve critical ambiguities in the feature spec through targeted clarification questions. This is OPTIONAL - only run if spec has unclear requirements that significantly impact implementation.

## Execution Flow

1. **Find current spec**:
   - Run `~/.claude/spec-scripts/find-spec.sh`
   - Script outputs bash variables: REPO_ROOT, FEATURE_DIR, SPEC_FILE, etc.
   - Eval the output to set variables: `eval $(~/.claude/spec-scripts/find-spec.sh)`
   - Script validates that spec.md exists
   - If validation fails: ERROR with helpful message

2. **Scan for clarification needs**:
   - Search for `[NEEDS CLARIFICATION: ...]` markers in spec
   - Analyze spec for critical ambiguities in:
     - Feature scope boundaries
     - User permissions/roles (if multiple interpretations)
     - Security/compliance requirements
     - Data model (only if significantly unclear)
     - User workflows (only if multiple valid approaches)

3. **Prioritize questions** (max 3):
   - **ONLY ask if**:
     - Answer significantly impacts architecture/scope/security/UX
     - Multiple reasonable interpretations exist
     - No reasonable default exists
   - **DO NOT ask about**:
     - Minor implementation details
     - Questions better suited for planning phase
     - Stylistic preferences
     - Anything with an obvious industry-standard answer

4. **Ask questions one at a time**:
   - Present ONE question at a time
   - For each question, provide:
     - **Context**: Quote relevant spec section
     - **Question**: Specific thing needing clarification
     - **Suggested Answer**: Your recommendation based on best practices
     - **Alternatives**: 2-3 other valid options (if applicable)
   - User can accept suggestion ("yes"/"suggested") or provide custom answer
   - Record answer before moving to next question
   - Stop early if user says "done" or if remaining questions become unnecessary

5. **Update spec after EACH answer**:
   - Add entry to Clarifications section: `- Q: [question] → A: [answer]`
   - Apply answer to appropriate section:
     - Functional scope → User Stories or Acceptance Criteria
     - Data model → Data Model section
     - Technical approach → Technical Approach section
     - Edge cases → Edge Cases section
   - Remove any `[NEEDS CLARIFICATION: ...]` markers that were resolved
   - Save spec after each update (incremental)

6. **Report completion**:
   - Number of questions asked and answered
   - Sections updated in spec
   - Path to updated spec
   - Next step: "Run /tasks to generate implementation plan"

## Behavior Rules

- **If no critical ambiguities found**: Report "No critical clarifications needed. Spec is ready for /tasks." and exit
- **Max 3 questions total** across entire session
- **Short answers preferred**: Encourage ≤5 word answers or multiple choice
- **One question at a time**: Never show all questions upfront
- **Early termination**: Respect "done", "stop", "skip" from user
- **No multi-pass validation**: Ask questions once, update spec, done

## Example Interaction

**User**: /clarify

**Assistant**: I found 2 areas in the spec that need clarification.

**Question 1/2**: User Authentication Method

**Context**: From spec - "Users must be able to authenticate"

**What we need to know**: Which authentication method should we use?

**Suggested Answer**: Email/password (standard, simple, works offline)
**Alternatives**:
- Email/password (suggested)
- OAuth2 (Google/GitHub)
- Magic link (passwordless)
- Custom answer

You can accept the suggestion by saying "yes", or choose an alternative, or provide your own answer.

**User**: OAuth2

**Assistant**: [Updates spec with OAuth2 decision, saves file]

**Question 2/2**: Data Retention

**Context**: From spec - "System must store user habits"

**What we need to know**: How long should habit history be retained?

**Suggested Answer**: Indefinitely (users expect full history)
**Alternatives**:
- Indefinitely (suggested)
- 1 year
- 6 months
- Custom period

**User**: yes

**Assistant**: [Updates spec with "indefinitely" decision, saves file]

All clarifications complete! Updated spec at: .worktrees/001-habit-tracking/Specs/001-habit-tracking/spec.md

Sections updated:
- Technical Approach (authentication method)
- Data Model (retention policy)

Next step: Run /tasks to generate implementation tasks
