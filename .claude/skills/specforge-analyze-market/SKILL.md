# specforge-analyze-market — Market & Competitive Analysis

## Purpose

Run Phase 2 as a **Market Analyst** who replaces assumptions with evidence. The core mission: test every claim in the Product Brief about market need, competitive gaps, and opportunity size through systematic research.

## Prerequisites

- `output/01-product-brief.md` must exist and have passed the Phase 1 quality gate (7/10 average minimum).

## Workflow Steps

### Step 1: Extract and Review Assumptions

Load `output/01-product-brief.md`. Extract every market-related claim and assumption. List them explicitly before beginning research — these are your hypotheses to test.

### Step 2: Define the Market

Establish precise market boundaries:

1. Define the **market category** — what is the product competing in?
2. Estimate **TAM** (Total Addressable Market) using top-down (industry reports) and bottom-up (unit economics) approaches.
3. Estimate **SAM** (Serviceable Addressable Market) — the segment you can realistically reach.
4. Estimate **SOM** (Serviceable Obtainable Market) — realistic first-year capture.

All estimates must cite sources. If data is unavailable, state: "Data unavailable — recommend primary research."

### Step 3: Research Market Trends

Document:
- Market growth rate and trajectory (cite source and year)
- Key growth drivers
- Key barriers to adoption
- Emerging shifts (technology, regulation, behavior)
- Signals of market timing (too early, right timing, saturated)

### Step 4: Map the Competitive Landscape

Identify competitors across three tiers:
- **Direct competitors** — solving the same problem for the same audience
- **Indirect competitors** — solving a related problem or adjacent need
- **Substitute solutions** — how users solve the problem without dedicated software (spreadsheets, manual processes, workarounds)

For each competitor, document: name, positioning, pricing, key features, strengths, weaknesses, customer sentiment (use G2, Capterra, TrustRadius reviews).

> **HALT POINT**: Present the competitive landscape. Ask: "Are there any competitors or substitutes I've missed?" Wait for confirmation before proceeding.

### Step 5: Build Feature Matrix and Positioning Map

Create a feature comparison matrix: rows are competitors + your product, columns are key capabilities. Mark presence, partial, or absence.

Identify **competitive gaps**: features missing from all or most competitors that your target users need.

Build a **positioning map** using two axes that matter most to your target user segment.

### Step 6: Validate Product Brief Claims

For each assumption extracted in Step 1:
- What does the market data say?
- Confirmed, contradicted, or insufficient data?
- If contradicted, what does this mean for the product strategy?

Test willingness to pay: what do comparable products charge? What pricing models are common?

Assess market entry feasibility: what are realistic barriers to acquisition, distribution, or sales?

### Step 7: Assess Market-Level Risks

Document risks specific to market dynamics:
- Entrenched competitors with high switching costs
- Market consolidation trends
- Regulatory changes
- Technology disruption
- Economic sensitivity

### Steps 8–9: Synthesize Documents

> **HALT POINT**: Before generating final documents, present a summary of key findings. Ask: "Do these findings align with your understanding, or do we need to investigate anything further?"

Produce two output documents:

**`output/02-market-analysis.md`**: Market sizing (TAM/SAM/SOM with sources), trends, opportunity validation, risks.

**`output/03-competitive-analysis.md`**: Competitor profiles, feature matrix, positioning map, differentiation gaps.

### Step 10: Quality Gate Check

Score each item 0–10 (minimum 7/10 average required to advance):

- [ ] Market size is estimated with cited sources at all three levels (TAM/SAM/SOM)
- [ ] At least 5 competitors profiled across direct and indirect categories
- [ ] Feature matrix covers all key capabilities
- [ ] Competitive gaps are clearly identified
- [ ] Product Brief claims are tested against real data
- [ ] Pricing landscape is documented
- [ ] Market risks are assessed
- [ ] No unsupported data claims

> **HALT POINT**: Present scores. If any item is below 6, recommend addressing it before advancing to Phase 3.

## Output

- `output/02-market-analysis.md`
- `output/03-competitive-analysis.md`

## Critical Standards

All data points require source citations (URLs, report names, or research references). Real user feedback from review sites often reveals competitive weaknesses better than marketing copy. Never fabricate market data — uncertainty is preferable to invented numbers.