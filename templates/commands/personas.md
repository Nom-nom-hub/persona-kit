---
description: Create, manage, and utilize specialized AI personas to enhance software development workflows and decision-making processes.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-constitution
  ps: scripts/check-prerequisites.ps1 -Json -RequireConstitution
agent_scripts:
  sh: scripts/update-agent-context.sh --personas
  ps: scripts/update-agent-context.ps1 -Personas
---

## Command Overview

The `/personakit.personas` command creates, manages, and utilizes specialized AI personas with defined expertise, behaviors, and interaction patterns. This enables consistent role-based development approaches throughout the project lifecycle.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Persona name and role definition
- Expertise areas and knowledge domains
- Behavioral characteristics and interaction patterns
- Optional: Persona configuration parameters

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare persona context
   - Verify project constitution is available
   - Check for existing persona definitions
   - Parse persona creation/management parameters
   - Initialize persona management system

2. **Core Execution**: Create, update, or manage personas
   - Define persona characteristics based on input
   - Configure persona-specific behaviors and knowledge
   - Integrate persona with project context and constitution
   - Store persona definition in appropriate directory
   - Register persona with agent system

3. **Output Generation**: Complete persona registration and validation
   - Generate persona documentation and guidelines
   - Update agent context with available personas
   - Create persona utilization guidelines
   - Log persona creation for project tracking

## Expected Outputs

**Primary Outputs**:
- Persona definition file in `/personas/[name].md`
- Updated agent context with new persona capabilities
- Persona-specific configuration and guidelines
- Integration with project constitution

**Side Effects**:
- Agent behavior changes based on persona selection
- Influence on development approach and decision-making
- Consistency in role-specific interactions

## Error Handling

**Common Error Conditions**:
- Missing project constitution
- Invalid persona specification
- Conflicting persona definitions
- Insufficient information for persona creation

**Error Recovery**:
- Preserve existing personas on creation failure
- Provide detailed persona validation feedback
- Suggest persona specification improvements
- Offer persona template guidance

## Integration Points

**Dependencies**:
- Requires project constitution file
- Project must be initialized with Persona Kit
- Access to personas directory needed

**Triggers**:
- Enables role-based development approaches
- Influences decision-making patterns
- Activates persona-specific behaviors
- Guides consistent interaction patterns

## Usage Examples

### Basic Usage
```bash
/personakit.personas
```

### Advanced Usage
```bash
/personakit.personas Create a senior Python developer persona with expertise in architecture, testing, and performance optimization
```

### Common Variations
- **New Persona**: Define a completely new persona with specific expertise
- **Persona Update**: Modify existing persona characteristics
- **Persona List**: Show all available personas in current project

## Validation and Testing

**Success Criteria**:
- Persona file created with proper structure
- Persona aligns with project constitution
- Agent recognizes and can utilize persona
- Persona definition is clear and actionable

**Testing Approach**:
- Verify persona file structure and content
- Test agent interaction with new persona
- Confirm alignment with constitutional principles
- Validate persona-specific behaviors and knowledge
</content>