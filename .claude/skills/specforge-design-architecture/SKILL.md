# specforge-design-architecture — Architecture & Technical Design

## Purpose

Run Phase 5 as a **Solutions Architect**, translating product requirements into a complete technical architecture. It answers: "How will we build this?"

## Prerequisites

- All Phase 1–4 artifacts complete (7/10+ gates for each phase)

## Workflow Steps

### Step 1: Technical Review of Prior Artifacts

Load all prior artifacts with a technical lens:
- Extract all non-functional requirements (performance, scalability, security, reliability)
- Identify all integration points mentioned in use cases or UX specs
- Note constraints: team size, budget, timeline, existing infrastructure, team expertise
- Flag any UX requirements that have significant technical implications

### Step 2: Define System Boundaries

Map the system's external boundaries:
- Create a **Context Diagram**: your system as a box, all external systems/actors as surrounding elements, with labeled connections
- Identify all integration points: APIs consumed, services called, data imported/exported
- Document protocols, authentication methods, and failure handling for each integration
- Define what is inside vs. outside your system's responsibility

### Step 3: High-Level Design

Select and justify architectural style:
- Options: monolith, modular monolith, microservices, serverless, event-driven, or hybrid
- Justify with reference to team size, operational complexity, scalability needs, and delivery timeline
- Create a **Container Diagram**: major deployable units, their responsibilities, and connections
- Document key architectural decisions as Architecture Decision Records (ADRs):

```
ADR-XXX: [Title]
Status: Accepted
Context: [What situation prompted this decision]
Decision: [What was decided]
Alternatives considered: [What else was evaluated]
Consequences: [Trade-offs and implications]
```

### Step 4: Technology Selection

For each major technology choice, write a formal ADR:
- Programming language(s)
- Frameworks and major libraries
- Database(s): type, specific product, justification
- Caching strategy (if applicable)
- Message queue / event bus (if applicable)
- Search infrastructure (if applicable)
- Authentication system
- Hosting/deployment platform

Principle: choose proven technologies the team knows. Technology familiarity beats trendiness. New tech introduces risk — justify it explicitly.

### Step 5: API Design

Define the complete API surface:
- List all endpoints with method, path, and purpose
- Document request/response schemas (use OpenAPI-style notation)
- Define authentication and authorization approach per endpoint
- Specify error handling: status codes, error response format, retry guidance
- Address versioning strategy (how breaking changes will be managed)

Treat APIs as permanent contracts. Plan for backward compatibility from day one.

### Step 6: Data Modeling

Define the data layer:
- **Entity-relationship diagram**: all entities, attributes, and relationships
- **Data lifecycle**: how data is created, updated, archived, and deleted
- **Access patterns**: how each entity is queried (informs index and schema decisions)
- **Data ownership**: which service/component owns each entity
- **Migration strategy**: how schema changes will be deployed

### Step 7: Security Architecture

Address each security domain explicitly:
- **Authentication**: mechanism, session management, token lifecycle
- **Authorization**: model (RBAC, ABAC, ownership-based), enforcement points
- **Encryption**: at rest (which data stores?), in transit (TLS version minimum)
- **Input validation**: boundaries, sanitization approach
- **Secrets management**: no hardcoded credentials, key rotation strategy
- **Compliance**: relevant regulations (GDPR, HIPAA, SOC2) and how they're addressed
- **Threat model**: top 5 attack vectors and mitigations

Security is an integrated property, not a feature added later.

### Step 8: Infrastructure Planning

Define the operational model:
- **Deployment topology**: environments (dev, staging, production), cloud/on-premise
- **Scaling strategy**: horizontal or vertical, auto-scaling triggers
- **Disaster recovery**: backup frequency, RTO, RPO targets
- **Monitoring and observability**: logging, metrics, tracing, alerting
- **Cost model**: major cost drivers and estimates

### Step 9: Document Synthesis

Produce four output documents:

**`output/08-architecture.md`**: System context, high-level design, component structure, security posture, infrastructure approach, and all ADRs.

**`output/09-api-spec.md`**: Complete endpoint inventory, schemas, authentication requirements, error handling.

**`output/10-data-model.md`**: Entity-relationship descriptions, lifecycle definitions, access patterns, migration notes.

**`output/11-tech-decisions.md`**: All formal Architecture Decision Records.

### Step 10: Quality Gate Check

Score each item 0–10 (minimum 7/10 average required):

- [ ] All functional requirements map to system components
- [ ] Every data entity appears in the data model
- [ ] All NFRs have corresponding architectural provisions
- [ ] Every technology choice has a formal ADR
- [ ] API spec covers all user stories requiring data
- [ ] Security architecture addresses all 6 domains
- [ ] Architecture is explainable in under 15 minutes using the documentation alone
- [ ] No "we'll figure it out later" for critical technical decisions

## Output

- `output/08-architecture.md`
- `output/09-api-spec.md`
- `output/10-data-model.md`
- `output/11-tech-decisions.md`