---
description: Create technical implementation plans with your chosen tech stack using persona expertise and project constraints.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-specification
  ps: scripts/check-prerequisites.ps1 -Json -RequireSpecification
agent_scripts:
  sh: scripts/update-agent-context.sh --planning
  ps: scripts/update-agent-context.ps1 -Planning
---

## Command Overview

The `/personakit.plan` command creates technical implementation plans with your chosen tech stack using persona expertise and project constraints. This command translates specifications into actionable implementation strategies that leverage specialized personas for different aspects of development.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Technology stack preferences (optional)
- Architecture constraints or requirements
- Performance or scalability requirements
- Deployment environment considerations

## Execution Workflow

1. **Setup**: Validate prerequisites and prepare planning context
   - Verify specification document exists
   - Check for project constitution
   - Identify available personas for planning
   - Analyze specification to understand requirements

2. **Core Execution**: Create comprehensive implementation plan using personas
   - Apply architecture persona expertise to design system structure
   - Consider security persona input for security aspects
   - Integrate performance requirements into planning
   - Map implementation phases with appropriate persona involvement
   - Define technology stack based on project needs
   - Validate plan against constitutional principles
   - Create detailed implementation guidelines

3. **Output Generation**: Complete implementation plan and prepare for execution
   - Write plan to `/memory/implementation-plan.md` or feature-specific location
   - Update agent context with planning details
   - Generate persona-specific action items
   - Create implementation phase checkpoints

## Expected Outputs

**Primary Outputs**:
- Comprehensive implementation plan with architecture and tech stack
- Phase-by-phase breakdown with persona assignments
- Technical constraints and considerations documented
- Integration strategies with existing systems

**Side Effects**:
- Guides implementation approach and technology decisions
- Assigns responsibilities to specific personas
- Establishes development milestones and phases
- Influences tool and infrastructure choices

## Error Handling

**Common Error Conditions**:
- Missing specification document
- Conflicting technical requirements
- Technology constraints that prevent implementation
- Architectural decisions that violate constitutional principles

**Error Recovery**:
- Suggest alternative architectural approaches
- Highlight conflicts with requirements
- Provide trade-off analysis for different options
- Recommend specification refinements if needed

## Integration Points

**Dependencies**:
- Requires existing specification document
- Needs project constitution file
- Access to persona definitions
- Project initialized with Persona Kit

**Triggers**:
- Enables persona-driven implementation phase
- Activates architecture and design processes
- Guides technology selection and setup
- Initiates phase-by-phase development planning

## Usage Examples

### Basic Usage
```bash
/personakit.plan
```

### Advanced Usage
```bash
/personakit.plan The application uses React with Node.js backend, PostgreSQL database, and should be deployable to AWS with CI/CD pipeline
```

### Common Variations
- **Architecture Focus**: Emphasize system architecture and design patterns
- **Tech Stack**: Focus on specific technology choices and integration
- **Performance Planning**: Emphasize performance and scalability considerations

## Validation and Testing

**Success Criteria**:
- Plan addresses all specification requirements
- Architecture aligns with persona expertise
- Technology choices are appropriate and justified
- Plan is actionable and includes clear phases

**Testing Approach**:
- Verify plan completeness against specification
- Check architecture for viability and scalability
- Confirm technology stack feasibility
- Validate persona-appropriate task assignments
</content>