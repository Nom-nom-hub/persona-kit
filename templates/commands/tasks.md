---
description: Generate actionable task lists for implementation using persona insights and workflow knowledge.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-plan
  ps: scripts/check-prerequisites.ps1 -Json -RequirePlan
agent_scripts:
  sh: scripts/update-agent-context.sh --tasks
  ps: scripts/update-agent-context.ps1 -Tasks
---

## Command Overview

The `/personakit.tasks` command generates actionable task lists for implementation using persona insights and workflow knowledge. This command breaks down the implementation plan into specific, persona-appropriate tasks with clear dependencies and execution order.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Optional: Specific workflow to follow for task generation
- Optional: Specific persona perspective for task breakdown
- Optional: Task prioritization or grouping preferences

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare task generation context
   - Verify implementation plan exists
   - Check for project constitution
   - Identify available personas and their expertise
   - Analyze plan to understand implementation phases

2. **Core Execution**: Generate comprehensive task breakdown using personas
   - Apply developer persona knowledge to code tasks
   - Use architect persona insight for structural tasks
   - Integrate tester persona perspective for validation tasks
   - Consider persona-specific skills for task assignment
   - Establish task dependencies and execution order
   - Identify parallelizable tasks for efficiency
   - Create clear, actionable task descriptions

3. **Output Generation**: Complete task breakdown and prepare for execution
   - Write tasks to `/memory/tasks.md` or feature-specific location
   - Update agent context with task breakdown
   - Generate persona-specific task lists
   - Create task tracking and completion metrics

## Expected Outputs

**Primary Outputs**:
- Detailed task breakdown with clear descriptions
- Task dependencies and execution order defined
- Persona-appropriate task assignments
- Parallel tasks identified for efficiency

**Side Effects**:
- Enables systematic implementation approach
- Guides persona activities during development
- Establishes progress tracking framework
- Provides clear completion criteria

## Error Handling

**Common Error Conditions**:
- Missing implementation plan
- Contradictory task dependencies
- Tasks that require unavailable personas or skills
- Tasks that violate constitutional principles

**Error Recovery**:
- Suggest alternative task breakdown approaches
- Highlight dependency conflicts
- Recommend task consolidation or splitting
- Preserve valid portions of task breakdown

## Integration Points

**Dependencies**:
- Requires implementation plan document
- Needs project constitution file
- Requires defined personas
- Project initialized with Persona Kit

**Triggers**:
- Enables systematic implementation phase
- Activates task execution and tracking
- Guides persona activities during development
- Initiates progress monitoring processes

## Usage Examples

### Basic Usage
```bash
/personakit.tasks
```

### Advanced Usage
```bash
/personakit.tasks Generate tasks focusing on the senior developer persona perspective and organize by implementation phases
```

### Common Variations
- **Full Breakdown**: Complete task breakdown for entire implementation
- **Phase-Specific**: Focus on tasks for specific implementation phase
- **Persona-Focused**: Emphasize tasks appropriate for specific persona

## Validation and Testing

**Success Criteria**:
- All plan elements converted to actionable tasks
- Task dependencies properly defined
- Tasks are appropriately sized and clear
- Task assignments align with persona expertise

**Testing Approach**:
- Verify completeness of task breakdown
- Check dependency logic and execution order
- Confirm task clarity and actionability
- Validate persona-task alignment
</content>