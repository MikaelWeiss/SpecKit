# Tasks: [FEATURE_NAME]

**Input**: Specs/[BRANCH_NAME]/spec.md
**Format**: `- [ ] T### [P?] [US#?] Description with file path`
- **[P]**: Parallelizable (different files, no dependencies)
- **[US#]**: User story number (US1, US2, etc.)

## Phase 1: Setup

**Purpose**: Project initialization

- [ ] T001 [Task description with file path]
- [ ] T002 [P] [Task description with file path]

## Phase 2: Foundational

**Purpose**: Blocking prerequisites for all user stories

- [ ] T003 [Task description with file path]
- [ ] T004 [P] [Task description with file path]

## Phase 3: User Story 1 - [Title] (P1) 🎯 MVP

**Goal**: [What this story delivers]
**Independent Test**: [How to verify]

- [ ] T005 [P] [US1] [Task with file path]
- [ ] T006 [US1] [Task with file path]

## Phase 4: User Story 2 - [Title] (P2)

**Goal**: [What this story delivers]
**Independent Test**: [How to verify]

- [ ] T007 [P] [US2] [Task with file path]
- [ ] T008 [US2] [Task with file path]

## Phase N: Polish

**Purpose**: Cross-cutting improvements

- [ ] TXXX [P] [Task description]

## Dependencies

- Setup (Phase 1) → Foundational (Phase 2)
- Foundational → All User Stories (can run in parallel)
- All User Stories → Polish

## Notes

- MVP = User Story 1 only
- Each story should be independently deployable
- Mark completed: `- [x] T###`
