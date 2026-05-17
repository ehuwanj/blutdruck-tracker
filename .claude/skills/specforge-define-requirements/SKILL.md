# specforge-define-requirements — Requirements Engineering

## Purpose

Run Phase 3 as a **Requirements Analyst**, transforming product vision into precise, testable specifications. This phase produces three key artifacts: a PRD, user stories, and use cases.

## Prerequisites

- `output/01-product-brief.md` (Phase 1 complete, 7/10+ gate)
- `output/02-market-analysis.md` and `output/03-competitive-analysis.md` (Phase 2 complete, 7/10+ gate)

## Workflow Steps

### Step 1: Review Prior Artifacts

Load all Phase 1–2 artifacts. Extract:
- Confirmed personas and their needs
- In-scope capabilities (from Product Brief)
- Competitive gaps to address
- Constraints (technical, regulatory, resource)
- Non-negotiable requirements implied by context

### Step 2: Elicit Functional Requirements

Decompose each in-scope capability into atomic functional requirements using the format:

```
ID: FR-XXX
Statement: The system shall [action] [subject] [condition]
Rationale: [why this requirement exists]
Priority: Must Have / Should Have / Could Have / Won't Have (MoSCoW)
Acceptance Criteria: [measurable, testable criteria]
```

Reject vague terms. Replace "fast" with "responds within 200ms under normal load." Replace "intuitive" with "users complete task X without documentation within 2 minutes." Every requirement must be testable.

### Step 3: Define Non-Functional Requirements

Systematically address each category with measurable targets:

- **Performance**: response time, throughput, latency
- **Scalability**: concurrent users, data volume, growth projections
- **Security**: authentication, authorization, encryption, compliance
- **Reliability**: uptime SLA, error rate tolerance, recovery time
- **Usability**: accessibility standard (WCAG 2.1 level), task completion rates
- **Maintainability**: code coverage minimum, deployment frequency target
- **Compatibility**: browser versions, OS versions, device types

### Step 4: Develop User Stories

Convert functional requirements into user stories:

```
ID: US-XXX
Title: [short description]
Story: As a [persona], I want [action], so that [benefit]
Acceptance Criteria (Given/When/Then):
  Given [precondition]
  When [action]
  Then [expected outcome]
Complexity: XS / S / M / L / XL
Linked Requirements: [FR-XXX, FR-YYY]
```

Group stories into epics. Each epic should represent a coherent user-facing capability.

### Step 5: Create Use Cases

Develop detailed use cases for 5–10 primary workflows:

```
ID: UC-XXX
Title: [action + object]
Primary Actor: [persona]
Preconditions: [what must be true]
Main Success Scenario: [numbered steps]
Alternative Flows: [variations]
Exception Flows: [error conditions]
Postconditions: [system state after success]
```

### Step 6: Validate Requirements

Check for:
- **Completeness**: every in-scope feature has requirements
- **Consistency**: no contradictions between requirements
- **Feasibility**: all requirements are implementable within constraints
- **Traceability**: every requirement traces to a business goal
- **Testability**: every requirement has measurable acceptance criteria

### Steps 7–9: Synthesize Documents

Produce three output files:

**`output/04-prd.md`**: Full PRD with functional and non-functional requirements, organized by epic/feature area.

**`output/05-user-stories.md`**: All user stories grouped by epic, with acceptance criteria and complexity estimates.

**`output/06-use-cases.md`**: Detailed use case specifications for primary workflows.

### Step 10: Quality Gate Check

Score each item 0–10 (minimum 7/10 average required):

- [ ] All in-scope capabilities have functional requirements
- [ ] All requirements use "The system shall..." format with measurable criteria
- [ ] Non-functional requirements cover all 7 categories with targets
- [ ] User stories follow Given/When/Then format
- [ ] Every story traces to at least one functional requirement
- [ ] Use cases cover all primary workflows
- [ ] No vague language remains (no "fast," "intuitive," "user-friendly" without quantification)
- [ ] Requirements are free of implementation decisions

## Output

- `output/04-prd.md`
- `output/05-user-stories.md`
- `output/06-use-cases.md`

## Key Principles

Requirements describe WHAT the system must do, not HOW to build it. Implementation decisions belong in Phase 5 (Architecture). Kill ambiguity with numbers. Every stated requirement must be testable — if you can't write a test for it, it's not a requirement.