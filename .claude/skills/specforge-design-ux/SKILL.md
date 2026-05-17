# specforge-design-ux — UX & Design Specification

## Purpose

Run Phase 4 as a **UX Strategist (Advocate)**, translating requirements into user-centered design specifications. This phase bridges requirements documentation and technical architecture by ensuring implementation serves users effectively.

## Prerequisites

- `output/01-product-brief.md` through `output/06-use-cases.md` (Phases 1–3 complete, 7/10+ gates)

## Workflow Steps

### Step 1: Prior Artifact Review (UX Lens)

Load all prior artifacts. Focus on:
- Persona details: goals, frustrations, tech proficiency, device context
- Use case flows: primary paths, alternative flows, exception handling
- Non-functional requirements relevant to UX: usability, accessibility, performance
- Constraints affecting design: platform targets, technical limitations

### Step 2: Persona Deepening

Extend personas with UX-specific context:
- **Context of use**: where and when do they use this? (commuting, office, stressed, multitasking?)
- **Device and environment**: screen size, connection quality, noise, lighting
- **Mental models**: what existing systems shape their expectations?
- **Scenario narratives**: write a day-in-the-life story for each primary persona

### Step 3: Information Architecture

Define the structural foundation:
- **Screen inventory**: list every screen/view with its purpose
- **Navigation model**: tabs, hierarchy, drawer, or hybrid — justify the choice
- **URL/route structure** (if applicable)
- **Search and discovery mechanisms**
- **Content hierarchy** per screen: primary, secondary, tertiary information

### Step 4: User Flow Design

For each primary use case, map the complete user journey:
- Entry point(s)
- Step-by-step path with decision points
- Alternative paths (optional steps, shortcuts)
- Error states and recovery paths
- Exit points
- Emotional state at each step (frustrated? confident? uncertain?)

### Step 5: Wireframe Specifications

For each key screen, produce a detailed wireframe spec (text-based):

```
Screen: [Name]
Purpose: [one sentence]
Entry from: [screen(s)]
Exits to: [screen(s)]

Layout:
  [Describe the layout grid and major zones]

Components:
  [List each UI component with its content, behavior, and state variations]

Interactions:
  [Describe what happens on tap/click/swipe/focus]

Empty state:
  [What the user sees with no data]

Error state:
  [What the user sees when something goes wrong]

Loading state:
  [Skeleton screen? Spinner? Progressive loading?]

Copy:
  [Actual UI strings, not placeholders]
```

Design for the stressed user, not the demo user. Every screen must have an empty state and an error state defined.

### Step 6: Interaction Patterns

Define standard behaviors used across the app:

- **Form patterns**: validation timing (on blur? on submit?), error display, required field marking
- **Loading states**: when to show skeletons vs. spinners vs. progress bars
- **Success feedback**: toasts, inline confirmations, page transitions
- **Destructive actions**: confirmation dialogs, undo patterns
- **Navigation transitions**: what animation/transition signals hierarchy level?

### Step 7: Accessibility Specification

Establish WCAG 2.1 Level AA requirements:
- Color contrast ratios for all text/background combinations
- Touch target minimum sizes
- Keyboard navigation order
- Screen reader labels for all interactive elements
- Focus indicator visibility
- Error messages that don't rely on color alone

### Step 8: Design System Foundations

Specify the visual language:
- **Spacing scale**: base unit and multipliers
- **Typography**: typefaces, size scale, weight usage, line height
- **Color roles**: primary, secondary, surface, background, error, success, warning, on-* variants
- **Elevation/shadow system** (if applicable)
- **Border radius conventions**
- **Icon system**: library choice, size standards, usage rules
- **Component standards**: button variants, input states, card anatomy

### Step 9: Specification Synthesis

Consolidate all findings and verify:
- Every use case has a corresponding user flow
- Every screen in the inventory has a wireframe spec
- Interaction patterns cover all common behaviors
- No placeholder copy remains in wireframe specs

> **HALT POINT**: Present the complete UX specification outline. Ask: "Does this cover all the interactions your users will have? Are there any edge cases or workflows missing?" Wait for confirmation.

### Step 10: Quality Gate Check

Score each item 0–10 (minimum 7/10 average required):

- [ ] All personas have context-of-use narratives
- [ ] Screen inventory is complete (no implicit screens)
- [ ] User flows cover all primary and major alternative paths
- [ ] Every screen has an empty state and error state defined
- [ ] Wireframe specs use real copy, not placeholders
- [ ] Accessibility requirements are specified concretely
- [ ] Design system covers all visual decision categories
- [ ] Interaction patterns are consistent across the app
- [ ] All error handling paths are designed
- [ ] Navigation model is justified

## Output

- `output/07-ux-spec.md`

## Critical Philosophy

Design for the stressed user, not the demo user. A design that only works under ideal conditions will fail in production. Mandate real UI copy — placeholder text ("Lorem ipsum," "Enter text here") in wireframes leads to late-breaking copy problems. Define error states for every interaction: most UX failures happen in edge cases, not happy paths.