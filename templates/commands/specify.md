---
description: Define what you want to build using persona-driven approach with requirements and user stories that align with project principles.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-constitution
  ps: scripts/check-prerequisites.ps1 -Json -RequireConstitution
agent_scripts:
  sh: scripts/update-agent-context.sh --specification
  ps: scripts/update-agent-context.ps1 -Specification
---

## Command Overview

The `/personakit.specify` command defines what you want to build using a persona-driven approach with requirements and user stories that align with project principles. This command helps formalize your vision into structured specifications that personas can work with effectively.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Description of what you want to build
- Functional requirements or user stories
- Non-functional requirements (optional but recommended)
- Constraints or special considerations

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare specification context
   - Verify project constitution is available
   - Check for existing specifications
   - Parse user input for requirements
   - Initialize specification creation process

2. **Core Execution**: Create structured specification using personas
   - Apply project constitution principles to requirements
   - Generate user stories from high-level description
   - Identify functional and non-functional requirements
   - Structure specification according to template
   - Consider persona perspectives during creation
   - Validate alignment with project principles

3. **Output Generation**: Complete specification and integrate with project
   - Write specification to `/memory/specification.md` or feature-specific location
   - Update agent context with new specification
   - Generate next-step recommendations
   - Create traceability links to constitution

## Expected Outputs

**Primary Outputs**:
- Structured specification document with requirements and user stories
- Aligned with project constitution principles
- Ready for persona-driven implementation approach
- Clear acceptance criteria defined

**Side Effects**:
- Guides subsequent planning and implementation phases
- Influences persona selection for implementation
- Establishes baseline for quality validation

## Error Handling

**Common Error Conditions**:
- Missing project constitution
- Insufficient input to create meaningful specification
- Contradictory requirements
- Requirements that violate constitutional principles

**Error Recovery**:
- Provide clarification prompts for insufficient input
- Highlight conflicts with constitutional principles
- Suggest requirement refinements
- Preserve partial work if creation fails

## Integration Points

**Dependencies**:
- Requires project constitution file
- Project must be initialized with Persona Kit
- Access to memory directory needed

**Triggers**:
- Enables persona-driven planning phase
- Guides feature development approach
- Activates requirement validation processes
- Influences workflow selection

## Usage Examples

### Basic Usage
```bash
/personakit.specify
```

### Advanced Usage
```bash
/personakit.specify Build a task management application that allows users to create projects, add tasks, assign priorities, and track progress with notifications
```

### Common Variations
- **Feature Specification**: Define a specific feature in detail
- **Requirements Gathering**: Focus on gathering and organizing requirements
- **User Story Creation**: Emphasize user stories and acceptance criteria

## Validation and Testing

**Success Criteria**:
- Specification addresses user needs clearly
- Requirements align with constitutional principles
- User stories have clear acceptance criteria
- Specification is actionable for personas

**Testing Approach**:
- Verify completeness of functional requirements
- Check alignment with project constitution
- Confirm clarity of user stories and acceptance criteria
- Validate that personas can effectively work with the specification
</content>