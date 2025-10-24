---
description: Generate executable task breakdown from feature spec
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Generate a structured, dependency-ordered task list organized by user story, enabling incremental implementation and independent testing of each story.

## Execution Flow

1. **Find current spec**:
   - Run `~/.claude/spec-scripts/find-spec.sh`
   - Script outputs bash variables: REPO_ROOT, FEATURE_DIR, SPEC_FILE, TASKS_FILE, etc.
   - Eval the output to set variables: `eval $(~/.claude/spec-scripts/find-spec.sh)`
   - Script validates that spec.md exists
   - If validation fails: ERROR with helpful message

2. **Load and analyze spec**:
   - Extract user stories with priorities (P1, P2, P3, ...)
   - Extract technical approach (tech stack, architecture, dependencies)
   - Extract data model (entities, relationships)
   - Extract acceptance criteria for each story
   - Note project structure from codebase (infer file paths)

3. **Determine project structure**:
   - Inspect existing directories to determine pattern:
     - iOS: Strive/Domain/, Strive/Application/, Strive/Presentation/
     - Web: backend/src/, frontend/src/
     - Mobile: api/src/, ios/src/
     - Single: src/, lib/, cmd/
   - Use existing pattern for file paths in tasks

4. **Generate task phases**:

   **Phase 1: Setup** (project initialization)
   - Create directory structure if needed
   - Initialize dependencies
   - Setup configuration files

   **Phase 2: Foundational** (blocking prerequisites)
   - Core infrastructure ALL stories depend on
   - Authentication/authorization framework (if needed)
   - Database setup and migrations (if needed)
   - Base models/entities shared across stories
   - Error handling and logging infrastructure

   **Phase 3+: One phase per user story** (in priority order)
   - Start with P1 (MVP), then P2, P3, etc.
   - For each story:
     - Goal: What this story delivers
     - Independent Test: How to verify it works standalone
     - Tasks: Specific implementation steps with file paths
     - Use [US1], [US2], [US3] labels to mark story tasks
     - Mark parallelizable tasks with [P]

   **Final Phase: Polish**
   - Documentation updates
   - Performance optimization
   - Cross-cutting concerns

5. **Task format requirements**:
   - **Format**: `- [ ] T### [P?] [US#?] Description with file path`
   - **Sequential numbering**: T001, T002, T003, ...
   - **[P] marker**: Only if task can run in parallel (different files, no dependencies)
   - **[US#] marker**: User story label (US1, US2, US3) for user story phase tasks
   - **File paths**: Every task MUST include specific file path
   - Examples:
     - `- [ ] T001 Create project structure per spec`
     - `- [ ] T005 [P] [US1] Create User model in Domain/DataModels.swift`
     - `- [ ] T012 [US2] Implement authentication in Application/AuthManager.swift`

6. **Organize by user story** (critical):
   - Each user story gets its own phase
   - Map all components to the story that needs them:
     - Models needed for that story
     - Services needed for that story
     - UI/endpoints needed for that story
     - Tests for that story (if TDD specified)
   - Stories should be independent (can implement in any order after Foundation)
   - Within each story: data models → services → UI/endpoints → integration

7. **Dependencies section**:
   - Show phase dependencies:
     - Setup → Foundational → All User Stories (parallel) → Polish
   - Show user story dependencies (most should be independent)
   - Show parallel opportunities within each phase

8. **Load tasks template**:
   - Read `~/.claude/spec-templates/tasks-template.md`
   - Use structure as guide
   - Replace placeholder content with actual tasks

9. **Write tasks file**:
   - Path: $TASKS_FILE (from script output, same directory as spec.md)
   - Fill all template placeholders
   - Ensure every task has proper format and file path

10. **Update CLAUDE.md with tech stack**:
    - Run `~/.claude/spec-scripts/update-context.sh`
    - Script extracts tech stack from spec.md Technical Approach section
    - Updates CLAUDE.md's "Active Technologies" section
    - Preserves manual additions (uses markers)
    - If CLAUDE.md doesn't exist or has no tech section, script will note and skip

11. **Report completion**:
    - Path to tasks.md
    - Total task count
    - Task count per user story
    - MVP scope (typically just User Story 1 / P1 tasks)
    - Parallel opportunities identified
    - Note if CLAUDE.md was updated with tech stack
    - Next step: "Run /implement to execute tasks"

## Quality Rules

**Task Organization**:
- One phase per user story (enables independent implementation)
- Each story phase includes Goal and Independent Test criteria
- Clear dependencies (what blocks what)
- Parallel opportunities explicitly marked

**Task Specificity**:
- Every task has exact file path
- Action-oriented (Create, Implement, Add, Update, etc.)
- Specific enough for LLM to execute without additional context
- No vague tasks ("Set up models" → specific model files)

**User Story Independence**:
- Each story should be implementable without others
- Each story should be testable without others
- Each story should deliver value standalone
- Foundation phase contains only truly shared infrastructure

**MVP Focus**:
- User Story 1 (P1) is the MVP
- MVP should be minimal but functional and valuable
- Other stories add incremental value

## Example Output Structure

```markdown
# Tasks: Habit Tracking

## Phase 1: Setup
- [ ] T001 Create Specs directory structure
- [ ] T002 [P] Initialize dependencies in Package.swift

## Phase 2: Foundational
- [ ] T003 Create base app structure in Strive/Application/
- [ ] T004 [P] Setup storage manager in Strive/Application/Storage/

## Phase 3: User Story 1 - Create Habits (P1) 🎯 MVP
**Goal**: Users can create habits and mark them complete
**Independent Test**: Create a habit, mark it complete, verify it's saved

- [ ] T005 [P] [US1] Create Habit model in Strive/Domain/DataModels.swift
- [ ] T006 [US1] Create HabitManager in Strive/Application/HabitManager.swift
- [ ] T007 [US1] Create CreateHabitView in Strive/Presentation/Scenes/Habits/
- [ ] T008 [US1] Create HabitListView in Strive/Presentation/Scenes/Habits/

## Phase 4: User Story 2 - View Streaks (P2)
**Goal**: Users can see streak counts for their habits
**Independent Test**: Create habits, complete them, view streak counts

- [ ] T009 [P] [US2] Add streak calculation to HabitManager
- [ ] T010 [US2] Create StreakView in Strive/Presentation/Scenes/Habits/

## Phase 5: Polish
- [ ] T011 [P] Update CHANGELOG.md
- [ ] T012 Add accessibility labels to all views

## Dependencies
- Setup → Foundational → User Stories (can run in parallel) → Polish
- US1 and US2 are independent (can implement in any order)
```
