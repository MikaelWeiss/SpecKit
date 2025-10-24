---
description: Execute implementation tasks from tasks.md
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Purpose

Execute the implementation plan by processing and completing all tasks defined in tasks.md, working phase by phase and marking tasks as complete.

## Execution Flow

1. **Find current tasks file**:
   - Locate tasks.md in current worktree or working directory
   - Path patterns: `Specs/<branch>/tasks.md` or `.worktrees/*/Specs/*/tasks.md`
   - ERROR if not found: "Run /tasks first to generate implementation tasks"

2. **Load implementation context**:
   - **Required**: Read tasks.md for complete task list
   - **Required**: Read spec.md for feature context and acceptance criteria
   - **Optional**: Read constitution.md for project principles
   - Parse task phases and dependencies
   - Identify task IDs, descriptions, file paths, parallel markers [P], story markers [US#]

3. **Verify project setup**:
   - Check for necessary project files (Package.swift, .xcodeproj, package.json, etc.)
   - Verify ignore files exist (.gitignore for .worktrees/, temp files, etc.)
   - If missing critical setup, create it before proceeding

4. **Execute tasks phase by phase**:

   **Phase execution rules**:
   - Complete each phase fully before moving to next
   - Within a phase:
     - Sequential tasks: Execute in order, wait for completion
     - Parallel tasks [P]: Can execute together (different files)
     - Stop immediately if non-parallel task fails
     - For parallel tasks, continue with successful ones, report failures

   **After each task completion**:
   - Mark task as complete in tasks.md: `- [x] T###`
   - Report progress: "✓ T### - [description]"
   - Commit if appropriate (user preference)

5. **Phase-by-phase execution**:

   **Phase 1: Setup**
   - Initialize project structure
   - Install dependencies
   - Setup configuration

   **Phase 2: Foundational**
   - Build shared infrastructure
   - Create base models and services
   - Setup error handling, logging
   - **Critical**: Must complete before any user story work

   **Phase 3+: User Story Phases**
   - Execute one user story phase at a time (or in parallel if resourced)
   - For each story:
     - Implement data models
     - Implement services/business logic
     - Implement UI/endpoints
     - Verify Independent Test criteria from spec
   - After completing a story phase, user can test that story independently

   **Final Phase: Polish**
   - Documentation updates
   - Performance optimization
   - Cross-cutting concerns

6. **Task execution guidelines**:
   - Read the file first if editing (never edit without reading)
   - Use appropriate tools (Edit for changes, Write for new files)
   - Follow file paths exactly as specified in task
   - Respect project structure and patterns
   - Apply constitution principles (from constitution.md)
   - Write code following project conventions

7. **Progress tracking**:
   - Update tasks.md after each completed task
   - Report status after each phase:
     - "Phase N complete: [summary]"
     - "Next phase: [name]"
   - If error occurs:
     - Report error with context
     - Keep task unchecked in tasks.md
     - Suggest fix or ask for guidance
     - Do not proceed to next phase

8. **Validation checkpoints** (after each user story phase):
   - Verify Independent Test criteria from spec can be met
   - Ensure story works standalone
   - Confirm no breaking changes to previously completed stories
   - Report: "User Story N complete and independently testable"

9. **Completion validation**:
   - All tasks marked [x]
   - All user stories implemented
   - Features match original spec
   - Constitution principles followed
   - No critical errors or warnings

10. **Final report**:
    - Total tasks completed
    - User stories implemented (list with P1, P2, P3)
    - MVP status (P1 complete = MVP complete)
    - Path to implemented code
    - Suggested next steps:
      - Test the implementation
      - Review against spec
      - Commit and push to origin
      - Create pull request

## Error Handling

**If task fails**:
- Report error clearly with context
- Keep task unchecked
- Suggest potential fix
- Ask if should retry or skip
- Do not proceed automatically

**If prerequisite missing**:
- Identify what's missing
- Suggest running earlier command (e.g., /setup-specs)
- Do not guess or create unexpected files

**If spec unclear during implementation**:
- Reference spec.md for context
- Make reasonable assumption based on context
- Document assumption in code comment
- Continue execution
- Report assumption to user

## Notes

- Work incrementally: complete one task before moving to next
- Update tasks.md frequently (after each task)
- Respect dependencies: don't skip required sequential tasks
- Parallel tasks [P] can run simultaneously
- Each user story should be independently testable
- Stop and validate after each story phase
- Final goal: working, tested features matching the spec
