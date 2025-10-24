# Streamlined Specs

A simplified, practical spec-driven development system for Claude Code that reduces bloat while preserving the best parts of GitHub's SpecKit.

## Why This Exists

GitHub's [SpecKit](https://github.com/github/spec-kit) introduced a powerful concept: spec-driven development with AI coding agents. However, in practice, it has some issues:

### Problems with SpecKit

1. **Too Much Bloat**: SpecKit generates 8-12 files per feature:
   - `spec.md`, `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, `tasks.md`
   - `contracts/` directory with multiple API spec files
   - `checklists/` directory with multiple validation files
   - Result: Overwhelming amount of documentation to review and maintain

2. **Context Rot**: With so many files, the AI agent's context window fills up quickly with documentation instead of code. This makes the actual implementation less effective because there's less room for the codebase itself.

3. **Over-Engineering**: Multiple validation passes, extensive checklists, and complicated bash scripts add complexity without proportional value for most projects.

### What Streamlined Specs Fixes

This project keeps the **excellent** parts of SpecKit:

- ✅ Constitution-driven development (foundational project principles)
- ✅ Structured workflow (specify → clarify → tasks → implement)
- ✅ User story prioritization with independent testing (P1, P2, P3)
- ✅ Clear requirements and acceptance criteria
- ✅ TDD-compatible approach

And simplifies everything else:

- ✅ **2-3 files per feature** instead of 8-12 (60-70% reduction)
- ✅ **Consolidated spec.md** that includes tech approach, data model, and acceptance criteria
- ✅ **No separate plan/research/contracts** - only what you need
- ✅ **Shorter templates** (50-70% less content to review)
- ✅ **Git worktree integration** - each feature in its own isolated workspace
- ✅ **Bash scripts for deterministic operations** (branch numbering, path detection)
- ✅ **Automatic spec validation** with quality checklists
- ✅ **Auto-update CLAUDE.md** with tech stack from specs

## File Count Comparison

**SpecKit** per feature:
```
Specs/001-feature/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── tasks.md
├── contracts/
│   ├── api1.yaml
│   └── api2.yaml
└── checklists/
    ├── ux.md
    ├── security.md
    └── test.md
```
**Total: 8-12 files**

**Streamlined Specs** per feature:
```
.worktrees/001-feature/Specs/001-feature/
├── spec.md        # Consolidated (includes plan, research, data model)
├── tasks.md       # Executable implementation
└── checklist.md   # Quality validation (auto-generated)
```
**Total: 3 files** (plus 1 project-level constitution.md)

**Still 60-70% fewer files than SpecKit!**

## Installation

### Prerequisites

- [Claude Code](https://docs.claude.com/claude-code) installed
- Git repository (for worktree support)

### Quick Install (One-Liner)

```bash
git clone https://github.com/MikaelWeiss/SpecKit.git && cd SpecKit && chmod +x install.sh && ./install.sh
```

This will clone the repo and install automatically.

The installer will:
- Create `~/.claude/spec-templates/` and `~/.claude/commands/`
- Copy all templates and commands to the right locations
- Make commands available in Claude Code as slash commands

### Update

To update to a newer version:

```bash
cd SpecKit
git pull
./install.sh
```

It will replace existing files with the latest versions.

## Quick Start

### 1. Initialize Your Project

```bash
cd your-project/
/setup-specs
```

This creates:
- `Specs/` directory for all feature specs
- `Specs/constitution.md` template

### 2. Define Project Principles

```bash
/constitution
```

Answer interactive questions to define your project's:
- Core principles (e.g., "Test-First Development", "Radical Simplicity")
- Code quality rules
- Testing approach
- Documentation requirements

This only needs to be done **once per project**.

### 3. Create Your First Feature

```bash
/specify "Add user authentication with OAuth2"
```

This will:
- Generate a short name: `001-user-auth`
- Create a new branch: `001-user-auth`
- **Create a worktree**: `.worktrees/001-user-auth` (isolated workspace!)
- Create spec: `.worktrees/001-user-auth/Specs/001-user-auth/spec.md`
- Fill the spec with:
  - User stories (P1, P2, P3) - prioritized and independently testable
  - Technical approach
  - Data model
  - Success criteria

### 4. Clarify if Needed (Optional)

```bash
cd .worktrees/001-user-auth/
/clarify
```

If the spec has ambiguities, this will ask up to 3 targeted questions and update the spec with your answers.

### 5. Generate Implementation Tasks

```bash
/tasks
```

Creates `Specs/001-user-auth/tasks.md` with:
- Tasks organized by user story
- Clear dependencies
- Exact file paths
- Parallel execution markers

### 6. Implement

```bash
/implement
```

Executes tasks phase-by-phase:
- Setup → Foundational → User Stories → Polish
- Marks completed tasks
- Reports progress
- Builds your feature

### 7. Push When Ready

```bash
# Work is already in the worktree
git add .
git commit -m "Add OAuth2 authentication"
git push -u origin 001-user-auth

# Create PR, merge, done!
```

## Worktree Workflow

One of the best features is **git worktree integration**. Each feature gets its own isolated workspace:

```bash
# Main repo stays clean
your-project/
├── .git/
├── Strive/                    # Your main code
└── Specs/
    └── constitution.md        # Project principles

# Each feature in its own worktree
.worktrees/
├── 001-user-auth/             # Feature 1 workspace
│   ├── Strive/                # Code for feature 1
│   └── Specs/001-user-auth/
│       ├── spec.md
│       └── tasks.md
└── 002-notifications/         # Feature 2 workspace (parallel!)
    ├── Strive/                # Code for feature 2
    └── Specs/002-notifications/
        ├── spec.md
        └── tasks.md
```

Benefits:
- Work on multiple features simultaneously without branch switching
- No conflicts between features in development
- Easy context switching: `cd .worktrees/001-user-auth/`
- Clean separation of concerns

## Quality Features

### Automatic Spec Validation

When you run `/specify`, the system automatically validates your spec against a quality checklist:

```
✓ No implementation details (languages, frameworks, APIs)
✓ Requirements are testable and unambiguous
✓ Success criteria are measurable and technology-agnostic
✓ All acceptance scenarios defined with Given/When/Then
✓ User stories are independently testable
✓ P1 defines a viable MVP
```

**What happens:**
1. Spec is generated from your description
2. Checklist is created automatically
3. Spec is validated against checklist
4. If issues found: spec is auto-fixed (up to 3 iterations)
5. Final checklist saved at `Specs/NNN-feature/checklist.md`

**Benefits:**
- Catches incomplete requirements before implementation
- Ensures specs are testable and measurable
- Saves time fixing issues later
- You still review the final spec, but quality is pre-validated

### Automatic CLAUDE.md Updates

When you run `/tasks`, your `CLAUDE.md` is automatically updated with the tech stack:

```markdown
## Active Technologies
<!-- SPEC_TECH_START -->
- 001-user-auth: Swift 6.2 + SwiftUI, Clean Architecture (added 2025-10-24)
- 002-notifications: EventKit, UserNotifications (added 2025-10-25)
<!-- SPEC_TECH_END -->
```

**Benefits:**
- Always know what tech is used in each feature
- Claude has current context for new conversations
- Manual additions preserved (use markers)
- No need to update CLAUDE.md manually

### Bash Scripts for Reliability

Deterministic operations use bash scripts instead of Claude executing commands inline:

**Scripts** (in `~/.claude/spec-scripts/`):
- `create-feature.sh` - Branch naming, number detection, worktree creation
- `find-spec.sh` - Locates current spec/tasks files reliably
- `update-context.sh` - Parses spec and updates CLAUDE.md

**Benefits:**
- Consistent branch numbering (no duplicates)
- Reliable path detection (no hallucination)
- Deterministic behavior (testable, debuggable)
- SpecKit-style bash variable output (`eval $(script)`)

## Available Commands

### `/setup-specs`
Initialize project for spec-driven development. Creates `Specs/` directory and constitution template.

**Usage**: Run once per project
```bash
cd your-project/
/setup-specs
```

### `/constitution`
Create or update project constitution with core principles and governance.

**Usage**: Run once per project (update as needed)
```bash
/constitution
```

### `/specify "feature description"`
Create a new feature specification with worktree.

**Usage**: Start each new feature
```bash
/specify "Add user authentication"
/specify "Implement payment processing"
/specify "Create admin dashboard"
```

### `/clarify`
Optional clarification of ambiguous requirements (max 3 questions).

**Usage**: Run if spec needs clarification
```bash
cd .worktrees/001-feature/
/clarify
```

### `/tasks`
Generate executable task breakdown organized by user story.

**Usage**: After spec is complete
```bash
/tasks
```

### `/implement`
Execute the implementation plan, marking tasks complete.

**Usage**: When ready to build
```bash
/implement
```

## Workflow Example

```bash
# === Setup (once per project) ===
cd ~/code/TaskTracker
/setup-specs
/constitution
# Define: "User Privacy First", "Test-First Development", "Radical Simplicity"

# === Feature 1: Core Task Management (MVP) ===
/specify "Users can create, view, and complete daily tasks"
# → Creates .worktrees/001-task-management/
# → Spec has 3 user stories:
#    P1: Create and list tasks
#    P2: Mark tasks complete
#    P3: Delete tasks

cd .worktrees/001-task-management/
/tasks
# → Generates tasks organized by story

/implement
# → Builds feature, marks tasks complete

git add .
git commit -m "Implement core task management"
git push -u origin 001-task-management
# → Create PR, get review, merge

# === Feature 2: Reminders (parallel development!) ===
cd ~/code/TaskTracker
/specify "Add reminder notifications for upcoming tasks"
# → Creates .worktrees/002-reminders/
# → Can develop while Feature 1 is in code review!

cd .worktrees/002-reminders/
/tasks
/implement
# ... and so on
```

## Best Practices

### User Stories

- **P1 is MVP**: Most critical functionality that delivers value standalone
- **Independent**: Each story should work without others
- **Testable**: Clear acceptance criteria (Given/When/Then)
- **Incremental**: Implement P1, test, deploy, then add P2, etc.

### Worktrees

- One feature = one worktree
- Keep worktrees focused and short-lived
- Remove worktree after merging: `git worktree remove .worktrees/001-feature`
- Add `.worktrees/` to `.gitignore` (handled by `/setup-specs`)

### Constitution

- Keep it concise: 3-5 core principles is ideal
- Be specific and testable
- Update when truly needed (major version)
- Use it as a decision-making filter

## Comparison with SpecKit

| Aspect | SpecKit | Streamlined Specs |
|--------|---------|-------------------|
| Files per feature | 8-12 files | 3 files |
| Template length | Long, extensive | Short, focused |
| Spec validation | Multi-pass with checklists | Automatic with checklist |
| Context management | Manual | Auto-update CLAUDE.md |
| Bash scripts | 7 complex scripts | 4 simple scripts |
| Worktree support | No | Yes (built-in) |
| Context usage | High (many files) | Low (consolidated) |
| Setup complexity | Medium | Low |
| Maintenance | Higher | Lower |
| Constitution | ✅ Yes | ✅ Yes (same quality) |
| User stories | ✅ Yes | ✅ Yes (same quality) |
| TDD support | ✅ Yes | ✅ Yes (same quality) |

## File Structure

```
SpecKit/
├── install.sh                    # Installation script
├── README.md                     # This file
├── templates/
│   ├── constitution-template.md  # Project principles template
│   ├── spec-template.md          # Feature spec template (consolidated)
│   ├── tasks-template.md         # Task breakdown template
│   └── checklist-template.md     # Spec validation checklist
├── scripts/
│   ├── common.sh                 # Shared utilities
│   ├── create-feature.sh         # Branch/worktree creation
│   ├── find-spec.sh              # Spec file detection
│   └── update-context.sh         # CLAUDE.md updater
└── commands/
    ├── setup-specs.md            # Initialize project
    ├── constitution.md           # Define principles
    ├── specify.md                # Create feature spec + worktree + validation
    ├── clarify.md                # Optional clarification
    ├── tasks.md                  # Generate tasks + update context
    └── implement.md              # Execute implementation
```

## FAQ

**Q: Can I use this with existing SpecKit projects?**
A: Yes, but you'll need to consolidate your existing specs into the new format. The constitution can be reused as-is.

**Q: Do I have to use worktrees?**
A: No, but it's highly recommended. The `/specify` command creates worktrees by default, but you can work in regular branches if you prefer.

**Q: Can I customize the templates?**
A: Yes! Edit the templates in `~/.claude/spec-templates/` after installation.

**Q: What if I need more than 3 clarification questions?**
A: The 3-question limit keeps specs actionable. If you need more, run `/clarify` again after the first round, or add notes to the spec manually.

**Q: How do I update to new versions?**
A: Just run `./install.sh` again - it replaces existing files.

**Q: Where should I store the constitution?**
A: In `Specs/constitution.md` at your project root. It's project-specific and should be committed to version control.

**Q: Can I share my constitution across projects?**
A: You can use it as a template, but each project should have its own constitution tailored to its specific needs.

## Contributing

Found a bug or have an improvement? Please:
1. Open an issue describing the problem
2. Submit a PR with your fix
3. Update tests if applicable

## License

MIT License - feel free to use, modify, and share.

## Credits

Inspired by GitHub's [SpecKit](https://github.com/github/spec-kit), simplified for practical everyday use.

---

**Made for developers who want spec-driven development without the overhead.**
