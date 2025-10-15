---
description: Define user stories, prioritize features, and make product decisions using product management expertise.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-constitution
  ps: scripts/check-prerequisites.ps1 -Json -RequireConstitution
agent_scripts:
  sh: scripts/update-agent-context.sh --product-manager
  ps: scripts/update-agent-context.ps1 -ProductManager
---

## Command Overview

The `/personakit.product-manager` command defines user stories, prioritizes features, and makes product decisions using product management expertise. This persona focuses on user needs, market requirements, and strategic feature prioritization.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Feature or product requirements to evaluate
- User stories or user needs to analyze
- Business objectives or strategic goals to consider
- Market or competitive context (optional)

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare product management context
   - Verify project constitution is available
   - Check for existing product specifications
   - Parse user input for requirements
   - Initialize product management perspective

2. **Core Execution**: Apply product management expertise to requirements
   - Evaluate features against business value and user needs
   - Prioritize features based on impact vs effort analysis
   - Refine user stories with clear acceptance criteria
   - Consider market positioning and competitive landscape
   - Assess technical feasibility from product perspective
   - Validate alignment with strategic goals

3. **Output Generation**: Complete product management recommendations
   - Generate prioritized feature list
   - Create detailed user stories with acceptance criteria
   - Provide market positioning recommendations
   - Update agent context with product priorities

## Expected Outputs

**Primary Outputs**:
- Prioritized feature list with business value assessments
- Refined user stories with clear acceptance criteria
- Product roadmap recommendations
- Market and competitive considerations

**Side Effects**:
- Influences feature implementation priorities
- Guides persona focus during development
- Shapes project timeline based on business value
- Directs user experience decisions

## Error Handling

**Common Error Conditions**:
- Missing project constitution
- Contradictory business requirements
- Market requirements that violate constitutional principles
- Features that aren't technically feasible

**Error Recovery**:
- Provide alternative feature suggestions with similar value
- Highlight trade-offs between different approaches
- Suggest requirement refinements
- Recommend additional stakeholder input for complex decisions

## Integration Points

**Dependencies**:
- Requires project constitution file
- Project must be initialized with Persona Kit
- Access to product specifications needed

**Triggers**:
- Enables feature prioritization decisions
- Guides user story creation process
- Influences development roadmap
- Activates business-value-focused behaviors

## Usage Examples

### Basic Usage
```bash
/personakit.product-manager
```

### Advanced Usage
```bash
/personakit.product-manager Prioritize the authentication features based on user security needs and business impact
```

### Common Variations
- **Feature Prioritization**: Focus on prioritizing existing features
- **User Story Refinement**: Emphasize refining user stories and acceptance criteria
- **Roadmap Planning**: Focus on strategic product planning and timeline

## Validation and Testing

**Success Criteria**:
- Feature priorities align with business objectives
- User stories are clear and actionable
- Product decisions consider user needs and market position
- Recommendations are feasible within technical constraints

**Testing Approach**:
- Verify priority alignment with business goals
- Check user story clarity and completeness
- Confirm technical feasibility of recommendations
- Validate market positioning considerations
</content>