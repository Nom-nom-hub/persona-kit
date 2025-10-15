---
description: Define and manage structured development workflows that guide persona-driven development processes.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-personas
  ps: scripts/check-prerequisites.ps1 -Json -RequirePersonas
agent_scripts:
  sh: scripts/update-agent-context.sh --workflows
  ps: scripts/update-agent-context.ps1 -Workflows
---

## Command Overview

The `/personakit.workflows` command creates, manages, and executes structured development workflows that guide persona-driven development processes. This command helps establish repeatable patterns for different types of development work using specialized personas.

## User Input

```text>
$ARGUMENTS
```

**Input Requirements**:
- Workflow name and description
- Workflow steps and stages
- Associated personas for each step
- Optional: Workflow configuration parameters

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare workflow context
   - Verify project constitution and personas exist
   - Check for existing workflow definitions
   - Parse workflow creation/management parameters
   - Initialize workflow management system

2. **Core Execution**: Create, update, or manage workflows
   - Define workflow structure based on input
   - Map appropriate personas to workflow steps
   - Configure workflow-specific behaviors and transitions
   - Integrate workflow with project constitution
   - Store workflow definition in appropriate directory

3. **Output Generation**: Complete workflow registration and validation
   - Generate workflow documentation and execution guidelines
   - Update agent context with available workflows
   - Create workflow execution tracking mechanisms
   - Log workflow creation for project tracking

## Expected Outputs

**Primary Outputs**:
- Workflow definition file in `/workflows/[name].md`
- Updated agent context with new workflow capabilities
- Workflow-specific execution guidelines
- Integration with available personas

**Side Effects**:
- Agent follows structured workflow patterns
- Consistent development approach across similar tasks
- Clear progression through development phases

## Error Handling

**Common Error Conditions**:
- Missing project constitution or personas
- Invalid workflow specification
- Conflicting workflow definitions
- Insufficient information for workflow creation

**Error Recovery**:
- Preserve existing workflows on creation failure
- Provide detailed workflow validation feedback
- Suggest workflow specification improvements
- Offer workflow template guidance

## Integration Points

**Dependencies**:
- Requires project constitution file
- Requires defined personas
- Project must be initialized with Persona Kit
- Access to workflows directory needed

**Triggers**:
- Enables structured development approaches
- Activates workflow-specific behaviors
- Guides persona usage throughout development
- Ensures consistent delivery patterns

## Usage Examples

### Basic Usage
```bash
/personakit.workflows
```

### Advanced Usage
```bash
/personakit.workflows Create a feature-development workflow that involves architecture review by senior-developer persona, implementation by junior-developer persona, and code review by reviewer persona
```

### Common Variations
- **New Workflow**: Define a completely new workflow with specific steps
- **Workflow Update**: Modify existing workflow characteristics
- **Workflow List**: Show all available workflows in current project

## Validation and Testing

**Success Criteria**:
- Workflow file created with proper structure
- Workflow aligns with project constitution
- Agent recognizes and can execute workflow
- Workflow definition clearly maps to personas

**Testing Approach**:
- Verify workflow file structure and content
- Test agent execution of new workflow
- Confirm alignment with constitutional principles
- Validate persona-workflow integration
</content>