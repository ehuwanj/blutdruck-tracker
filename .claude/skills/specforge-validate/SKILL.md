# specforge-validate — Cross-Phase Quality Assessment

## Purpose

Run an independent quality evaluation of SpecForge artifacts against phase-specific checklists and cross-cutting consistency standards. Can run mid-phase, between phases, or on-demand at any point in the lifecycle.

## When to Use

- After completing any phase, before advancing to the next
- When you suspect inconsistencies between artifacts
- Before starting implementation (Phase 7)
- When a stakeholder asks "are the specs ready?"

## Workflow Steps

### Step 1: Artifact Inventory

Scan the `output/` directory. For each of the 15 expected artifacts, note:
- Present or missing
- Last modified date
- File size (suspiciously small files may be incomplete)

Expected artifacts:
1. `01-product-brief.md`
2. `02-market-analysis.md`
3. `03-competitive-analysis.md`
4. `04-prd.md`
5. `05-user-stories.md`
6. `06-use-cases.md`
7. `07-ux-spec.md`
8. `08-architecture.md`
9. `09-api-spec.md`
10. `10-data-model.md`
11. `11-tech-decisions.md`
12. `12-epic-breakdown.md`
13. `13-sprint-plan.md`
14. `14-roadmap.md`
15. `15-traceability-matrix.md`

### Step 2: Individual Quality Assessment

For each present artifact, score each item 0–10:

**Phase 1 — Product Brief**:
- Problem statement is backed by evidence
- Primary persona defined with specificity
- Value proposition differentiates from alternatives
- All objectives meet SMART criteria
- Scope has explicit in-scope AND out-of-scope
- Assumptions identified with validation plans
- Top 5 risks documented with mitigations
- Stakeholders identified with roles

**Phase 2 — Market Analysis & Competitive Analysis**:
- Market size estimated at TAM/SAM/SOM with cited sources
- At least 5 competitors profiled
- Feature matrix is complete
- All data points have citations
- Product Brief claims tested against data

**Phase 3 — PRD, User Stories, Use Cases**:
- Requirements use "The system shall..." format
- No vague terms without quantification
- Every requirement has measurable acceptance criteria
- User stories follow Given/When/Then format
- Use cases cover all primary workflows

**Phase 4 — UX Spec**:
- All screens in inventory have wireframe specs
- Every screen has empty state and error state
- No placeholder copy
- Accessibility requirements specified
- Design system covers all visual decisions

**Phase 5 — Architecture, API, Data Model, Tech Decisions**:
- All functional requirements map to components
- Every technology choice has an ADR
- API spec covers all user stories requiring data
- Security architecture addresses all domains

**Phase 6 — Epic Breakdown, Sprint Plan, Roadmap, Traceability Matrix**:
- Every story has an estimate and sprint assignment
- Sprint 0 covers all foundation work
- Buffer is allocated
- Traceability matrix links business goals to sprints

Placeholder text in any artifact scores zero. Shallow sections (fewer than 3 competitors profiled, only 2 NFRs) score no higher than 4.

### Step 3: Cross-Phase Consistency Validation

Check for inconsistencies across artifacts:

- **Persona consistency**: Do the same personas appear across Product Brief, Requirements, UX Spec, and Sprint Plan? Any divergences?
- **Scope consistency**: Does the in-scope from Phase 1 match the requirements in Phase 3 and the epics in Phase 6?
- **Requirements coverage**: Does every functional requirement appear in at least one user story?
- **API coverage**: Does the API spec cover endpoints needed by all user stories that require data?
- **Data model coverage**: Does every entity referenced in use cases appear in the data model?
- **Sprint coverage**: Does every user story have a sprint assignment in the sprint plan?
- **Traceability completeness**: Can every business goal be traced forward to at least one sprint? Can every sprint story be traced back to a business goal?

Connection quality between artifacts matters more than individual artifact quality. A perfect Product Brief connected to a misaligned Requirements document is worse than two imperfect but consistent documents.

### Step 4: Gap Analysis

Identify and categorize issues found:

**Critical (blocking — must fix before development starts)**:
- Missing required artifacts
- Traceability breaks (stories with no business goal)
- Scope gaps (business goal with no sprint coverage)
- Unresolved contradictions between phases

**Important (should fix — will cause rework if not addressed)**:
- Shallow or incomplete sections
- Inconsistent terminology across phases
- Estimated stories with no acceptance criteria
- Non-functional requirements without architectural provisions

**Optional (improve if time allows)**:
- Style inconsistencies
- Section depth improvements
- Additional examples or context

### Step 5: Report Generation

Produce `output/validation-report.md` with:
- Artifact inventory table (present/missing for all 15)
- Phase-by-phase quality scores
- Cross-phase consistency assessment
- Prioritized issues (Critical / Important / Optional)
- Final verdict: **READY FOR DEVELOPMENT** or **NOT READY** with specific conditions

### Step 6: Actionable Recommendations

For each Critical issue, provide:
- Exactly which artifact needs updating
- What specifically is missing or incorrect
- Suggested content to add or change

## Output

- `output/validation-report.md`

## Execution Philosophy

Be objective, not kind. The validator's job is to catch problems before development starts — catching a specification gap now is far cheaper than discovering a fundamental misalignment after three sprints of implementation. The traceability matrix is the ultimate verification tool: if a business goal cannot be traced through requirements to sprint-assigned stories, the gap exists regardless of how polished the individual documents look.