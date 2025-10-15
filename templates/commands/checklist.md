---
description: Generate custom quality checklists that validate requirements completeness, clarity, and consistency using persona expertise.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-specification
  ps: scripts/check-prerequisites.ps1 -Json -RequireSpecification
agent_scripts:
  sh: scripts/update-agent-context.sh --checklist
  ps: scripts/update-agent-context.ps1 -Checklist
---

## Command Overview

The `/personakit.checklist` command generates custom quality checklists that validate requirements completeness, clarity, and consistency using persona expertise. This command creates verification tools that act like "unit tests for English" to ensure specifications and plans meet quality standards before implementation.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Scope for checklist (specification, plan, tasks, or all)
- Specific quality aspects to check (optional)
- Persona perspectives to prioritize (optional)

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare checklist context
   - Verify project constitution exists
   - Check for specification document
   - Identify relevant artifacts for checklist creation
   - Determine scope of checklist based on input

2. **Core Execution**: Generate comprehensive quality checklists using personas
   - Apply tester persona knowledge for validation criteria
   - Use architect persona insight for structural checks
   - Integrate developer persona perspective for implementation feasibility
   - Consider UX persona for user experience considerations
   - Create checklist items based on constitutional principles
   - Generate verification questions for each quality aspect

3. **Output Generation**: Complete checklist and integrate with project
   - Write checklist to `/memory/checklist.md` or appropriate location
   - Update agent context with checklist availability
   - Generate checklist usage guidelines
   - Create checklist completion tracking

## Expected Outputs

**Primary Outputs**:
- Quality checklist with specific verification items
- Context-specific validation criteria
- Persona-perspective quality checks
- Clear pass/fail criteria for verification

**Side Effects**:
- Enables systematic quality validation
- Guides specification and plan refinement
- Provides objective quality measures
- Facilitates consistent validation across projects

## Error Handling

**Common Error Conditions**:
- Missing project constitution or specification
- Invalid checklist scope specification
- Conflicting quality requirements
- Checklist items that violate constitutional principles

**Error Recovery**:
- Provide alternative checklist scope options
- Highlight alignment issues with constitution
- Suggest checklist refinement strategies
- Offer basic quality validation if detailed checklist fails

## Integration Points

**Dependencies**:
- Requires project constitution file
- Needs specification document
- Access to quality standards and guidelines
- Project initialized with Persona Kit

**Triggers**:
- Enables systematic quality validation process
- Guides specification refinement
- Activates quality-focused persona behaviors
- Initiates quality tracking and reporting

## Usage Examples

### Basic Usage
```bash
/personakit.checklist
```

### Advanced Usage
```bash
/personakit.checklist Generate a checklist focused on security requirements and validation criteria
```

### Common Variations
- **Specification Focus**: Checklist specifically for specification quality
- **Implementation Focus**: Checklist for plan and task quality
- **Security Focus**: Checklist emphasizing security requirements
- **Performance Focus**: Checklist emphasizing performance requirements

## Validation and Testing

**Success Criteria**:
- Checklist items are specific and measurable
- Checklist aligns with constitutional principles
- Checklist covers critical quality aspects
- Checklist is actionable and clear

**Testing Approach**:
- Verify checklist completeness against quality standards
- Check alignment with project constitution
- Confirm clarity and actionability of items
- Validate effectiveness in identifying issues
</content>