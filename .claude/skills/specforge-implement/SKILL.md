# specforge-implement — Implementation

## Purpose

Run Phase 7 as an **Implementation Lead** who reads all Phase 1-6 specification artifacts and executes the sprint plan story-by-story, delivering working, tested, production-ready code with verification reports at three levels of granularity (story, sprint, release).

## Prerequisites

All 15 Phase 1-6 artifacts must exist in `output/` before execution begins. Phase 6 quality gate must have achieved an average score of 7.0 or higher.

## Workflow Steps

### Step 1: Context Loading

Absorb all 15 artifacts to identify:
- Technology stack and key architectural decisions
- Epic/story/sprint counts and sequencing
- Critical path and dependencies
- Known risks from the risk register

> **HALT POINT**: Confirm understanding with the user. Present a summary of: tech stack, total sprints, critical path stories, and top 3 risks. Ask: "Does this match your understanding? Any corrections before we begin?"

### Step 2: Sprint 0 — Foundation

Before writing feature code:
1. Create project structure per architecture spec
2. Install all dependencies
3. Configure linting, formatting, and type-checking
4. Establish CI/CD pipeline (even a basic one)
5. Initialize database schema and migration tooling
6. Set up test framework with a passing smoke test
7. Document contribution standards (branching, commit format, PR process)

> **HALT POINT**: Verify scaffold completeness. Ask: "Can you run the empty project locally? Does CI pass?" Confirm before proceeding to feature sprints.

### Steps 3–N: Per-Sprint Cycle

For each sprint:
1. Load sprint goal and assigned stories
2. Confirm scope with user
3. Implement stories one at a time (never start the next until the current passes its gate)

For each story:
1. **Plan**: Re-read acceptance criteria, identify files to change, check for edge cases
2. **Code**: Implement the feature following project patterns exactly
3. **Test**: Write tests covering happy path, alternatives, and error conditions
4. **Self-review**: Check the 12-item Story Gate before declaring done

### Story Gate (all 12 must pass)

- [ ] All acceptance criteria have corresponding tests
- [ ] Code coverage meets project minimum
- [ ] Zero lint errors
- [ ] Zero type errors
- [ ] No TODO or FIXME comments
- [ ] No hardcoded secrets or credentials
- [ ] All public APIs are documented
- [ ] Implementation follows existing architectural patterns
- [ ] No debug logging left in production paths
- [ ] Database migrations are reversible
- [ ] Error states are handled (no unhandled exceptions)
- [ ] Spec compliance verified (behavior matches use case)

Produce `output/17-story-report-[STORY-ID].md` for each story.

### Sprint Gate (score 0–10 each, average ≥ 7.0)

After all stories in a sprint are complete:

- [ ] All stories in sprint passed their Story Gate
- [ ] Sprint goal is demonstrably achieved
- [ ] Integration tests pass (stories work together)
- [ ] CI/CD pipeline passes
- [ ] No regression in previously completed features
- [ ] Performance is within NFR bounds
- [ ] Security review passed (no new vulnerabilities introduced)
- [ ] Documentation updated
- [ ] Migration scripts tested
- [ ] Demo prepared

Produce `output/18-sprint-report-[N].md`.

> **HALT POINT**: Present sprint report. Ask: "Review the sprint demo. Are you ready to proceed to Sprint N+1?" Wait for explicit confirmation.

### Release Gate (score 0–10 each, average ≥ 8.0, no item < 5)

After all sprints complete:

- [ ] All user stories pass gates
- [ ] End-to-end tests pass for all primary use cases
- [ ] Performance tests meet NFR targets
- [ ] Security audit complete (no critical or high vulnerabilities)
- [ ] Accessibility audit complete
- [ ] All requirements have at least one passing test
- [ ] Code coverage meets threshold
- [ ] CI/CD pipeline fully operational
- [ ] Staging deployment successful
- [ ] Monitoring and alerting operational

Produce `output/19-release-report.md`.

> **HALT POINT**: Present final release gate with GO/NO-GO recommendation. List any outstanding issues. Ask for explicit user approval before declaring the release ready.

## Outputs

- `output/16-project-scaffold.md`
- `output/17-story-report-[STORY-ID].md` (one per story)
- `output/18-sprint-report-[N].md` (one per sprint)
- `output/19-release-report.md`
- `output/20-progress-tracker.md`
- `output/21-dependency-manifest.md`
- `output/22-cicd-spec.md`

## Critical Principles

- One story at a time, fully complete — never start the next story while the current one is failing its gate.
- Self-review before handoff — catch issues before they compound.
- Regression is the primary risk — run existing tests after every story.
- Follow existing patterns exactly — introducing new conventions mid-project creates inconsistency debt.
- All database migrations must be reversible.
- Backward compatibility is mandatory unless explicitly approved otherwise.