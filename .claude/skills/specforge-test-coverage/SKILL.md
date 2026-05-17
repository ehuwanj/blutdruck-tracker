# specforge-test-coverage — Test Coverage Analysis & Implementation

## Purpose

Analyze existing codebases for coverage gaps, create prioritized test plans, implement missing tests following project conventions, and configure CI/CD enforcement.

This skill does **not** require Phase 1-7 SpecForge artifacts — it can run on any codebase.

## Workflow (12 Steps)

### Step 1: Tech Stack Detection

Scan the codebase to identify:
- Programming language(s) and versions
- Test framework(s) in use
- Coverage tool and current configuration
- Test file naming conventions and directory structure
- Existing mocking patterns and test helper utilities
- Current coverage thresholds (if any configured)

> **HALT POINT**: Present findings. Confirm scope: "Should I analyze the entire codebase, or specific packages/modules?" Ask for target coverage percentage. Wait for explicit confirmation.

### Step 2: Baseline Measurement

Run coverage analysis and capture current state:
- Overall line/branch/function coverage percentage
- Coverage by file and by directory
- Identify files with 0% coverage vs. partially covered vs. fully covered
- Note any files explicitly excluded from coverage

Document the baseline clearly — this is the "before" state for the report.

### Step 3: Gap Analysis

Categorize all uncovered/undertested code by risk level:

**P0 — Critical (test immediately)**:
- Business logic with financial, security, or data-integrity implications
- Error handling and exception paths
- Authentication and authorization checks
- Data validation functions

**P1 — High (test in this session)**:
- Core user-facing workflows
- Integration points with external systems
- Database operations and migrations

**P2 — Medium (test if time allows)**:
- Secondary workflows
- Utility functions called frequently
- Configuration parsing

**P3 — Low (document and defer)**:
- Thin wrappers with no logic
- Generated code
- UI rendering without logic
- Explicitly excluded paths

> **HALT POINT**: Present gap analysis. Ask: "Do these priorities match your risk assessment? Any gaps I've misclassified?" Wait for confirmation before implementing tests.

### Step 4: Test Plan Creation

Produce `output/25-test-coverage-plan.md` with:
- Prioritized list of test files to create/expand
- For each: what to test, test type (unit/integration/E2E), estimated count
- Conventions guide derived from existing tests (naming, structure, mocking)
- Target coverage percentages by priority tier
- CI/CD enforcement configuration plan

### Steps 5–6: Test Implementation

Implement tests in priority order (P0 first):

For each test file:
1. Read existing tests in the same module for pattern reference
2. Write tests following detected conventions exactly (naming, structure, assertions, mocking)
3. Cover: happy path, boundary conditions, error paths
4. Verify test passes in isolation and as part of the suite
5. Check for flakiness (if a test passes inconsistently, fix it or remove it)

**Test quality standards**:
- Tests verify WHAT a function does, not HOW it does it
- Each test has a single clear assertion focus
- Error handling receives equal testing attention as success paths
- No test depends on ordering or shared mutable state
- Meaningful assertion messages that explain what went wrong

> **HALT POINT**: After implementing P0 tests, present results and coverage improvement. Ask: "Should I continue with P1 tests, or is this coverage level sufficient for now?"

### Step 7: Coverage Verification

Re-run coverage analysis after implementation:
- New overall coverage percentage
- Coverage improvement per file
- Confirm all P0 gaps are addressed
- Note any tests that were too difficult to write (document why)

### Step 8: CI/CD Integration

Configure automated coverage enforcement:
- Set minimum coverage thresholds in the test runner configuration
- Configure CI to fail on coverage regression
- Document the enforcement configuration
- Provide the exact configuration change needed

### Steps 9–12: Documentation and Reporting

Produce `output/26-test-coverage-report.md` with:
- Before/after coverage metrics
- Complete inventory of new tests added
- Remaining gaps and justification for deferral
- CI/CD configuration applied
- Recommendations for ongoing coverage maintenance

## Output

- `output/25-test-coverage-plan.md`
- `output/26-test-coverage-report.md`
- New test files integrated into the codebase
- Updated CI/CD configuration

## Critical Standards

- Follow existing naming patterns, file organization, and mocking strategies exactly
- Write behavior-focused tests with meaningful assertions
- Cover happy paths, edge cases, and error conditions
- No flaky tests — if it doesn't pass reliably, fix it or remove it
- Most production incidents come from untested error handling — treat it as a first-class concern
- Maintain the test pyramid: more unit tests than integration tests, more integration than E2E