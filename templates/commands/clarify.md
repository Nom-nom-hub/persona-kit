---
description: Clarify underspecified areas in specifications and plans using persona expertise before implementation.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-specification --require-plan
  ps: scripts/check-prerequisites.ps1 -Json -RequireSpecification -RequirePlan
agent_scripts:
  sh: scripts/update-agent-context.sh --clarification
  ps: scripts/update-agent-context.ps1 -Clarification
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Goal

Identify and resolve underspecified areas in specifications and plans using persona expertise before implementation begins. This command SHOULD run after `/personakit.specify` and `/personakit.plan` but before `/personakit.tasks` or `/personakit.implement` to ensure clarity before task execution.

## Operating Constraints

**STRICTLY CLARIFICATION FOCUSED**: Do **not** change specifications or plans, only identify and clarify ambiguities. Output structured clarification recommendations and questions. Use persona perspectives to identify blind spots.

**Constitution Authority**: All clarifications must align with project constitution (`/memory/constitution.md`). Constitution violations should be flagged and require explicit resolution before proceeding.

## Execution Steps

### 1. Initialize Clarification Context

Run `{SCRIPT}` once from repo root and parse JSON for available documents. Derive absolute paths:

- SPECIFICATION = `/memory/specification.md` or feature-specific spec
- PLAN = `/memory/implementation-plan.md` or feature-specific plan
- CONSTITUTION = `/memory/constitution.md`

Abort with an error message if any required file is missing (instruct the user to run missing prerequisite command).

### 2. Load Artifacts (Progressive Disclosure)

Load and analyze only the minimal necessary context from each artifact:

**From specification:**

- Functional Requirements
- Non-Functional Requirements
- User Stories
- Acceptance Criteria
- Edge Cases (if present)

**From implementation plan:**

- Architecture/stack choices
- Data Model references
- Implementation Phases
- Technical constraints
- Security considerations

**From constitution:**

- Load `/memory/constitution.md` for principle validation

### 3. Apply Persona Perspectives

Engage different persona perspectives to identify clarification needs:

**Developer Persona Perspective:**
- Identify underspecified technical details
- Flag unclear implementation requirements
- Question ambiguous data structures

**Architect Persona Perspective:**
- Identify scalability and performance gaps
- Question integration points
- Highlight infrastructure assumptions

**Tester Persona Perspective:**
- Identify unclear acceptance criteria
- Flag untestable requirements
- Question edge cases and error handling

### 4. Detection Passes (Token-Efficient Analysis)

Focus on high-signal clarification needs. Limit to 50 findings total; aggregate remainder in overflow summary.

#### A. Ambiguity Detection

- Flag vague adjectives (fast, scalable, secure, intuitive, robust) lacking measurable criteria
- Flag unresolved placeholders (TODO, TKTK, ???, `<placeholder>`, etc.)
- Identify requirements without measurable outcomes
- Find user stories without clear acceptance criteria

#### B. Technical Under-specification

- Requirements with verbs but missing technical objects or outcomes
- User stories missing technical constraints or considerations
- Implementation steps referencing undefined components
- Integration points without specification

#### C. Persona-Specific Blind Spots

- Areas where specific persona expertise could provide clarity
- Missing considerations from particular persona perspectives
- Assumptions that need validation from specific persona viewpoints

#### D. Constitution Alignment

- Any specification or plan elements potentially conflicting with constitutional principles
- Missing mandated considerations from constitution

#### E. Implementation Readiness

- Areas that would cause problems during task generation
- Missing information that would delay implementation
- Dependencies that aren't clearly specified

### 5. Severity Assignment

Use this heuristic to prioritize findings:

- **CRITICAL**: Violates constitution MUST, missing core specification element, or requirement that makes implementation impossible
- **HIGH**: Ambiguous security/performance requirement, unclear acceptance criteria, missing critical technical detail
- **MEDIUM**: Vague technical specification, underspecified integration point, unclear data format
- **LOW**: Minor clarification opportunities, style/wording improvements

### 6. Produce Compact Clarification Report

Output a Markdown report (no file writes) with the following structure:

## Specification and Plan Clarification Report

| ID | Category | Severity | Location(s) | Summary | Persona Perspective | Recommendation |
|----|----------|----------|-------------|---------|-------------------|----------------|
| A1 | Ambiguity | HIGH | spec.md:L120-134 | Requirement lacks measurable criteria | Tester | Define specific performance metrics |

(Add one row per finding; generate stable IDs prefixed by category initial.)

**Constitution Alignment Issues:** (if any)

**Missing Information by Persona:**
- **Developer Perspective:** [Items needing technical clarification]
- **Architect Perspective:** [Items needing design clarification]  
- **Tester Perspective:** [Items needing validation clarification]

**Metrics:**
- Total Clarification Needs
- Critical/High Issues Count
- Specification Clarity Score
- Plan Completeness Score

### 7. Provide Next Actions

At end of report, output a concise Next Actions block:

- If CRITICAL issues exist: Recommend addressing before `/tasks` or `/implement`
- If only LOW/MEDIUM: Process may proceed, but suggest priority clarifications
- Provide explicit input suggestions: e.g., "Clarify performance metrics for user authentication", "Define acceptable response times for API endpoints"

### 8. Offer Clarification Assistance

Ask the user: "Would you like me to help clarify the top N issues now?" and provide detailed prompts for each critical issue.

## Operating Principles

### Context Efficiency

- **Minimal high-signal tokens**: Focus on actionable clarifications, not exhaustive documentation
- **Progressive disclosure**: Load artifacts incrementally; don't dump all content into analysis
- **Token-efficient output**: Limit findings table to 50 rows; summarize overflow
- **Deterministic results**: Rerunning without changes should produce consistent IDs and counts

### Analysis Guidelines

- **NEVER modify files** (this is clarification analysis only)
- **NEVER hallucinate missing specifications** (if absent, report them accurately)
- **Prioritize constitution alignment** (these are always CRITICAL)
- **Use persona perspectives** (different personas identify different issues)
- **Report zero issues gracefully** (emit success report with clarity metrics)
</content>