---
description: Create or update the project constitution defining core principles and governance
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Fill out the project constitution template with concrete values, establishing the foundational principles and governance for all development work.

## Execution Flow

1. **Load existing constitution**:
   - Read `Specs/constitution.md`
   - If file doesn't exist: ERROR "Run /setup-specs first to initialize the project"
   - Identify all placeholder tokens `[ALL_CAPS_IDENTIFIER]`

2. **Gather values for placeholders**:
   - **[PROJECT_NAME]**: Infer from repo name, package.json, or ask user
   - **[PRINCIPLE_N_NAME]**: Ask user or use provided input for each principle
   - **[PRINCIPLE_N_DESCRIPTION]**: Get from user input or ask interactively
   - **[PRINCIPLE_N_RATIONALE]**: Get from user input or ask interactively
   - **[CODE_QUALITY_RULE_N]**: Infer from existing codebase or ask
   - **[TESTING_RULE_N]**: Infer from project type or ask
   - **[DOCUMENTATION_RULE_N]**: Standard practices or ask
   - **[CONSTITUTION_VERSION]**: Default to "1.0.0" for new constitution
   - **[RATIFICATION_DATE]**: Today's date (YYYY-MM-DD)
   - **[LAST_AMENDED_DATE]**: Today's date (YYYY-MM-DD)

3. **Interactive mode** (if user input is empty or incomplete):
   - Ask for project name
   - Ask how many principles (default: 3)
   - For each principle:
     - Ask for principle name (e.g., "Test-First Development")
     - Ask for description (what it is)
     - Ask for rationale (why it matters)
   - Ask for key code quality rules (3-5)
   - Ask for testing approach
   - Ask for documentation requirements

4. **Batch mode** (if user provided comprehensive input):
   - Parse the input for principle names, descriptions, rationales
   - Fill template directly without additional questions
   - Use reasonable defaults for missing values

5. **Fill template**:
   - Replace all `[PLACEHOLDER]` tokens with concrete values
   - Ensure no bracketed placeholders remain
   - Adjust number of principle sections to match user's needs (can be more or less than 3)
   - Preserve markdown formatting and structure

6. **Write updated constitution**:
   - Overwrite `Specs/constitution.md` with filled template
   - Validate: no remaining `[...]` placeholders except in examples

7. **Report completion**:
   - Confirm constitution version
   - List principles defined
   - Path to constitution file
   - Next step: use `/specify "feature description"` to create your first feature spec

## Guidelines

- Be concise: principles should be clear and actionable
- Be specific: avoid vague language like "robust" or "high quality"
- Be testable: each principle should be verifiable
- Focus on what matters: 3-5 core principles is usually sufficient
- Rationales explain *why* each principle exists

## Example Interaction

**User**: /constitution

**Assistant**: I'll help you create the project constitution. First, what is your project name?

**User**: TaskTracker

**Assistant**: How many core principles should guide this project? (3-5 recommended)

**User**: 3

**Assistant**:
**Principle 1 Name**: (e.g., "Test-First Development", "User Privacy First", "Radical Simplicity")

**User**: User Privacy First

**Assistant**:
**Principle 1 Description**: What does this principle require?

**User**: All user data must be encrypted at rest and in transit. Users must have full control over their data with easy export and deletion.

**Assistant**:
**Principle 1 Rationale**: Why is this principle important for TaskTracker?

[... continues for all principles and rules ...]
