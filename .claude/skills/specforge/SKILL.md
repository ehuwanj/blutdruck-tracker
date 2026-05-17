# specforge — Full Lifecycle Orchestration

## Purpose

Orchestrate the complete SpecForge specification process across six phases, delivering 15 artifacts plus validation documentation.

## Key Workflow Structure

The process unfolds sequentially with human review gates between phases:

1. **Discovery & Vision** — Produces Product Brief; run as Strategist
2. **Market & Competitive Analysis** — Produces market and competitive research; run as Market Analyst
3. **Requirements Engineering** — Produces PRD, user stories, use cases; run as Requirements Analyst
4. **UX & Design Specification** — Produces UX specification; run as UX Strategist
5. **Architecture & Technical Design** — Produces architecture, API, data model, tech decisions; run as Solutions Architect
6. **Implementation Planning** — Produces epics, sprints, roadmap, traceability; run as Delivery Manager

## Critical Implementation Points

Quality gates are not bureaucracy — they prevent cascading errors across phases. Each gate requires minimum 7/10 scores (8/10 for the final planning gate).

**Halt points** occur after every phase, allowing users to pause, revise, or proceed. The process expects 2-4 hours of active participation.

"It is cheaper to loop back than to push forward." Phase 1 quality is paramount, and Phase 2 (market analysis) should never be skipped despite common practice.

All outputs write to an `output/` directory with numbered filenames for clear sequencing.

## Execution Order

Invoke each skill in order, confirming quality gate before advancing:

1. `specforge-discover` → `output/01-product-brief.md`
2. `specforge-analyze-market` → `output/02-market-analysis.md`, `output/03-competitive-analysis.md`
3. `specforge-define-requirements` → `output/04-prd.md`, `output/05-user-stories.md`, `output/06-use-cases.md`
4. `specforge-design-ux` → `output/07-ux-spec.md`
5. `specforge-design-architecture` → `output/08-architecture.md`, `output/09-api-spec.md`, `output/10-data-model.md`, `output/11-tech-decisions.md`
6. `specforge-plan-implementation` → `output/12-epic-breakdown.md`, `output/13-sprint-plan.md`, `output/14-roadmap.md`, `output/15-traceability-matrix.md`
7. `specforge-validate` → `output/validation-report.md`
8. `specforge-implement` → code + `output/16-22-*.md`

Cross-cutting skills (invoke at any time):
- `specforge-test-coverage`
- `specforge-add-feature` (post-implementation)

## Deliverables

- `output/01-product-brief.md`
- `output/02-market-analysis.md`
- `output/03-competitive-analysis.md`
- `output/04-prd.md`
- `output/05-user-stories.md`
- `output/06-use-cases.md`
- `output/07-ux-spec.md`
- `output/08-architecture.md`
- `output/09-api-spec.md`
- `output/10-data-model.md`
- `output/11-tech-decisions.md`
- `output/12-epic-breakdown.md`
- `output/13-sprint-plan.md`
- `output/14-roadmap.md`
- `output/15-traceability-matrix.md`
- `output/validation-report.md`