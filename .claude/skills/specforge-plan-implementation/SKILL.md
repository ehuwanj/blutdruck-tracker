# specforge-plan-implementation — Implementation Planning

## Purpose

Run Phase 6 as a **Delivery Manager (Planner)**, transforming architectural and requirements artifacts into development-ready execution plans. Decompose the specified system into estimable, sequenced, development-ready work items.

## Prerequisites

- All Phase 1–5 artifacts complete (7/10+ gates for each phase)

## Workflow Steps

### Step 1: Artifact Review & Team Assessment

Load all Phase 1–5 artifacts. Before planning, gather:
- Team size and composition (frontend, backend, full-stack, etc.)
- Expected sprint length (1 or 2 weeks recommended)
- Team velocity baseline (if known) or assume standard for team size
- Hard deadlines or milestones imposed by business constraints
- Known risks from prior phases' risk registers

### Step 2: Epic Decomposition

Refine and finalize the epic list:
- User-facing epics: each representing a coherent capability
- Technical epics: infrastructure, auth scaffolding, monitoring, CI/CD, data migrations
- Each epic must have: title, goal, estimated effort range, key dependencies, definition of done

Decompose each epic into sprint-sized user stories (already defined in Phase 3). Verify that every story has acceptance criteria and a complexity estimate.

### Step 3: Story Point Estimation

Establish baseline estimates:
- If a velocity baseline exists, use it
- If not, estimate relative complexity: use reference stories to anchor the scale
- Apply a **15–25% buffer** on total estimate to absorb unknowns — this is not optional padding

### Step 4: Sprint Planning

Sequence work across sprints respecting:
- **Dependencies**: no story starts before its blockers complete
- **MoSCoW priority**: Must Have items fill early sprints; Could Haves fill later
- **Team capacity**: do not exceed realistic velocity per sprint
- **Sprint 0**: always includes environment setup, CI/CD pipeline, schema initialization, test framework, auth scaffolding, and standards documentation

Each sprint must have:
- A clear sprint goal (one sentence)
- A list of assigned stories with estimates
- Total points vs. capacity
- A demo-able outcome at sprint end

### Step 5: Roadmap Creation

Group sprints into business-aligned milestones:
- **Milestone 1**: MVP / first shippable version
- **Milestone 2**: Feature complete
- **Milestone 3**: Production ready
- Add decision gates: points where stakeholders review progress and confirm continuation

### Step 6: Traceability Matrix

Build an end-to-end traceability map:

```
Business Goal → Requirement(s) → User Story(ies) → Component(s) → Sprint
```

Every story must trace back to a business goal. If it doesn't, question whether it belongs in scope. Every business goal must trace forward to at least one sprint-assigned story.

The traceability matrix is your audit trail — it lets any stakeholder ask "why are we building this?" and get a data-backed answer.

### Step 7: Risk Register

Consolidate all risks from prior phases and add planning-specific risks:
- Technical risks (unknowns, integrations, performance)
- Delivery risks (scope creep, key person dependency, timeline pressure)
- Each risk: probability (H/M/L), impact (H/M/L), mitigation plan, contingency plan

### Step 8: Document Synthesis

Produce four output documents:

**`output/12-epic-breakdown.md`**: All epics with stories, estimates, dependencies, and definitions of done.

**`output/13-sprint-plan.md`**: Sprint-by-sprint assignments with goals, capacity, and demo outcomes.

**`output/14-roadmap.md`**: Milestone timeline with decision gates, buffer allocation, and business alignment.

**`output/15-traceability-matrix.md`**: Complete chains from business goals to sprint assignments.

### Step 9: Quality Gate Check

Score each item 0–10 (minimum **8/10** average required — highest bar in the framework):

- [ ] Every user story has an estimate and sprint assignment
- [ ] Sprint 0 covers all foundation work
- [ ] No sprint exceeds realistic team capacity
- [ ] Buffer is allocated (15–25% of total estimate)
- [ ] Every business goal traces to sprint-assigned stories
- [ ] Every story traces to a business goal
- [ ] Risk register is complete and current
- [ ] Milestones are realistic given team velocity
- [ ] All dependencies are resolved (no circular dependencies)
- [ ] Stakeholder review gates are defined

## Output

- `output/12-epic-breakdown.md`
- `output/13-sprint-plan.md`
- `output/14-roadmap.md`
- `output/15-traceability-matrix.md`

## Critical Principles

- Sprint 0 is not optional — foundation work done in Sprint 0 pays dividends every sprint after.
- Deliver vertical slices (complete features end-to-end) per sprint, not horizontal layers (all backend, then all frontend).
- 15–25% buffer absorbs unknowns; teams that skip it will slip their deadline.
- The traceability matrix is your audit trail — if you can't trace a story back to a business goal, question whether it belongs.