---
description: Execute all tasks according to defined workflows and personas to build the feature according to the plan.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
agent_scripts:
  sh: scripts/update-agent-context.sh --implementation
  ps: scripts/update-agent-context.ps1 -Implementation
---

## Command Overview

The `/personakit.implement` command executes all tasks according to defined workflows and personas to build the feature according to the plan. This command orchestrates the actual implementation using specialized personas for different aspects of development.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Specific workflow to execute (optional, defaults to main workflow)
- Target persona for implementation (optional, defaults to configured persona)
- Feature scope or specific tasks to implement (optional)

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare implementation context
   - Verify required files exist (constitution.md, workflows, personas)
   - Check for complete task breakdown
   - Validate development environment
   - Select appropriate implementation persona based on task requirements

2. **Core Execution**: Execute implementation tasks using personas
   - Iterate through defined tasks in correct order
   - Switch personas as appropriate for each task
   - Execute persona-specific actions for each task
   - Monitor progress and handle dependencies
   - Apply workflow guidelines during implementation

3. **Output Generation**: Complete implementation and verify results
   - Generate implementation summary and metrics
   - Update agent context with implementation progress
   - Create verification tasks for completed features
   - Log implementation history and any issues encountered

## Expected Outputs

**Primary Outputs**:
- Implemented code files according to task specifications
- Updated project documentation
- Implementation progress tracking
- Quality verification results

**Side Effects**:
- Project files modified/created according to specifications
- Development history captured
- Integration with version control systems

## Error Handling

**Common Error Conditions**:
- Missing prerequisite files (constitution, workflows, personas)
- Invalid task specifications
- Environment setup issues
- Code generation conflicts

**Error Recovery**:
- Preserve existing code state on failure
- Provide detailed error context for each failed task
- Suggest remediation steps
- Enable resumption from failure point

## Integration Points

**Dependencies**:
- Requires completed workflows and personas setup
- Needs constitution guidelines
- Depends on properly formatted task breakdowns
- Requires development environment configuration

**Triggers**:
- Executes development workflows
- Activates specialized personas
- Initiates quality checks and verification
- Updates project progress tracking

## Usage Examples

### Basic Usage
```bash
/personakit.implement
```

### Advanced Usage
```bash
/personakit.implement --workflow feature-development --persona senior-developer
```

### Common Variations
- **Complete Feature**: Implement entire feature with all tasks
- **Specific Tasks**: Implement only certain tasks or components
- **Persona-Specific**: Use specific persona for implementation approach

## Validation and Testing

**Success Criteria**:
- All tasks completed successfully according to specifications
- Code compiles and meets quality standards
- Implementation aligns with original plan
- Personas used effectively during implementation

**Testing Approach**:
- Verify all task outputs are generated correctly
- Check code quality and adherence to standards
- Confirm proper persona usage during implementation
- Validate workflow execution consistency
</content>