# SpecForge Command to Skill Migration

This project now treats skills as the canonical workflow definition, while preserving command entrypoints.

## Mapping

- `/specforge:generate-all` -> `specforge` (`.claude/skills/specforge/SKILL.md`)
- `/specforge:discover` -> `specforge-discover` (`.claude/skills/specforge-discover/SKILL.md`)
- `/specforge:analyze-market` -> `specforge-analyze-market` (`.claude/skills/specforge-analyze-market/SKILL.md`)
- `/specforge:define-requirements` -> `specforge-define-requirements` (`.claude/skills/specforge-define-requirements/SKILL.md`)
- `/specforge:design-ux` -> `specforge-design-ux` (`.claude/skills/specforge-design-ux/SKILL.md`)
- `/specforge:design-architecture` -> `specforge-design-architecture` (`.claude/skills/specforge-design-architecture/SKILL.md`)
- `/specforge:plan-implementation` -> `specforge-plan-implementation` (`.claude/skills/specforge-plan-implementation/SKILL.md`)
- `/specforge:validate` -> `specforge-validate` (`.claude/skills/specforge-validate/SKILL.md`)
- `/specforge:implement` -> `specforge-implement` (`.claude/skills/specforge-implement/SKILL.md`)
- `/specforge:add-feature` -> `specforge-add-feature` (`.claude/skills/specforge-add-feature/SKILL.md`)
- `/specforge:test-coverage` -> `specforge-test-coverage` (`.claude/skills/specforge-test-coverage/SKILL.md`)

## Rationale

- Keeps lifecycle guidance modular and reusable.
- Preserves existing command muscle memory.
- Makes maintenance easier by separating orchestration from execution details.

## Maintenance Rule

When behavior changes, update the corresponding skill first. Commands should remain lightweight entrypoints that reference skill definitions.