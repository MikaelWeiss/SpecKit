# Specification Quality Checklist: [FEATURE_NAME]

**Purpose**: Validate specification completeness and quality before proceeding to tasks
**Created**: [DATE]
**Feature**: [spec.md](./spec.md)

## Content Quality

- [ ] No implementation details (languages, frameworks, APIs, databases)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] All mandatory sections completed

## Requirement Completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
- [ ] Success criteria are technology-agnostic (no implementation details)
- [ ] All acceptance scenarios are defined with Given/When/Then
- [ ] Edge cases are identified
- [ ] Scope is clearly bounded
- [ ] Dependencies and assumptions identified

## User Story Quality

- [ ] Each user story is independently testable
- [ ] User stories are prioritized (P1, P2, P3, etc.)
- [ ] P1 defines a viable MVP
- [ ] Each story has clear acceptance criteria
- [ ] User stories describe outcomes, not implementation

## Notes

- Items marked incomplete require spec updates before `/tasks`
- Run `/clarify` to resolve [NEEDS CLARIFICATION] markers
- This checklist is generated and validated automatically
