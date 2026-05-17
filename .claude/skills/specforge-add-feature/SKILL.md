# specforge-add-feature — Feature Engineering

## Purpose

Extend an existing SpecForge project by adding a new feature end-to-end. Operates as a **Feature Engineer** in the post-implementation phase, assuming all Phases 1-7 are complete and a working codebase exists.

## Prerequisites

- All Phase 1-7 artifacts exist in `output/`
- A working codebase exists
- Phase 7 implementation is complete or substantially complete

## Workflow (14 Steps)

### Step 1: Context Loading

Load all existing Phase 1-7 artifacts AND analyze the actual codebase:
- Read the actual source files, not just specs
- Note any divergences between specs and implemented code
- Identify existing patterns: naming conventions, file organization, error handling, testing approach
- Document the actual API surface and data model as implemented

### Step 2: Feature Elicitation (HALT)

Present your project understanding summary to the user. Then ask six structured questions:

1. What problem does this feature solve? (for whom, with what evidence)
2. Who are the users of this feature? (primary and secondary)
3. What is the minimum scope? What is explicitly out of scope?
4. What existing features does this touch or depend on?
5. Are there any constraints (performance, compatibility, regulatory, timeline)?
6. Can you give an example of the feature working end-to-end?

Wait for answers before proceeding.

### Step 3: Requirements Definition

Create feature-scoped requirements:
- Functional requirements: `FR-FEAT-XXX` format
- User stories: `US-FEAT-XXX` format with Given/When/Then acceptance criteria
- Use cases for primary workflows
- Non-functional requirements (any new performance, security, or compatibility constraints)
- Dependency map: which existing features are affected

### Step 4: Requirements Confirmation (HALT)

Present the full requirements list. Ask:
- "Does this accurately capture what you want to build?"
- "Is the story ordering correct given dependencies?"
- "Is there anything missing or over-specified?"

Wait for explicit confirmation before proceeding to impact analysis.

### Step 5: Impact Analysis

Assess changes required across all layers:
- **Architecture**: new components, modified components, new external integrations
- **API**: new endpoints, modified existing endpoints, breaking changes
- **Data model**: new tables/fields, migrations required, data backfill needed
- **File-level changes**: list every file expected to change
- **Tests**: existing tests that will be affected, new test files needed
- **Dependencies**: new packages required
- **Configuration**: new environment variables, feature flags

### Step 6: Impact Review (HALT)

Present the full impact analysis. Ask:
- "Does this match what you expected?"
- "Are there any impacted areas I've missed?"
- "Are there any systems or services I haven't considered?"

Wait for confirmation before generating the Feature Spec.

### Step 7: Generate Feature Spec

Produce `output/23-feature-spec-[NAME].md` — the single source of truth for this feature's implementation. Include: requirements, user stories, use cases, impact analysis, and implementation plan.

### Step 8: Approve Feature Spec (HALT)

Present the Feature Spec and ask for explicit approval:
- "This is the last gate before code changes begin."
- "Once approved, I will implement according to this spec. Any deviations will be flagged."

Wait for explicit "approved" before touching any code.

### Steps 9–11: Story-by-Story Implementation

Implement each story following the same rigor as `specforge-implement`:
- One story at a time, fully complete before moving to next
- For each story: plan → code → test → self-review → Story Gate
- After each story: run full regression suite (not just new tests)

**Story Gate** (all 12 must pass):
- [ ] All acceptance criteria have tests
- [ ] Coverage meets project minimum
- [ ] Zero lint errors, zero type errors
- [ ] No TODOs or hardcoded secrets
- [ ] Follows existing patterns exactly
- [ ] Migrations are reversible
- [ ] All error states handled
- [ ] Backward compatibility maintained (or deviation explicitly approved)

### Step 12: Feature Gate

Score the complete feature on 10 dimensions (0–10 each, average ≥ 7.0, no item < 4):

- [ ] All acceptance criteria are tested and passing
- [ ] All regression tests pass
- [ ] Performance within NFR bounds
- [ ] Security review passed
- [ ] Accessibility maintained
- [ ] Documentation updated
- [ ] API contracts honored
- [ ] Data migrations tested
- [ ] Integration points verified
- [ ] Spec compliance confirmed

### Step 13: Feature Gate Report (HALT)

Present Feature Gate results. Ask: "Do you accept this feature as complete?"

### Step 14: Feature Delivery Report

Produce `output/24-feature-delivery-[NAME].md` including:
- Feature summary
- Requirements traceability
- Test coverage metrics
- Known limitations
- Rollback instructions

## Output

- `output/23-feature-spec-[NAME].md`
- `output/24-feature-delivery-[NAME].md`
- Actual code changes integrated into the codebase