---
description: Create or update project governing principles and development guidelines that will guide all subsequent development phases.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-config
  ps: scripts/check-prerequisites.ps1 -Json -RequireConfig
agent_scripts:
  sh: scripts/update-agent-context.sh --constitution
  ps: scripts/update-agent-context.ps1 -Constitution
---

## Command Overview

The `/personakit.constitution` command creates or updates your project's governing principles and development guidelines. This establishes foundational guidelines that the AI agent will reference during persona creation, workflow definition, and implementation phases.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Project-specific principles and guidelines (optional but recommended)
- Existing constitution content to update (if updating)

## Execution Workflow

1. **Setup**: Validate prerequisites and project context
   - Verify project initialization status
   - Check for existing constitution file
   - Parse and validate input arguments

2. **Core Execution**: Create or update constitutional principles
   - Load existing constitution if present
   - Integrate user input with established principles
   - Generate comprehensive governance document
   - Apply project-specific context and constraints

3. **Output Generation**: Save and register constitutional guidelines
   - Write constitution.md to /memory/constitution.md
   - Update agent context with new principles
   - Log constitutional updates for traceability
   - Verify proper integration with project context

## Expected Outputs

**Primary Outputs**:
- `/memory/constitution.md` with complete project principles
- Updated agent context reflecting new guidelines
- Validation log of constitutional elements

**Side Effects**:
- Agent behavior alignment with defined principles
- Influence on future persona and workflow decisions
- Establishes baseline for consistency checks

## Error Handling

**Common Error Conditions**:
- Missing project initialization
- Invalid constitutional syntax
- Conflicting principles with existing project
- Insufficient input for comprehensive constitution

**Error Recovery**:
- Preserve existing constitution on failure
- Provide detailed error context
- Suggest corrective inputs

## Integration Points

**Dependencies**:
- Project must be initialized with Persona Kit
- Requires access to memory directory
- Depends on agent context update scripts

**Triggers**:
- Enables consistent decision-making across all personas
- Guides future workflow and persona creation
- Influences implementation choices

## Usage Examples

### Basic Usage
```bash
/personakit.constitution
```

### Advanced Usage
```bash
/personakit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements
```

### Common Variations
- **Initial Setup**: Define foundational principles for new project
- **Updates**: Refine existing principles with new project insights
- **Specialization**: Add technology-specific guidelines (e.g., cloud, security)

## Validation and Testing

**Success Criteria**:
- Constitution file exists and is properly formatted
- All principles are clear and actionable
- Agent demonstrates understanding of principles
- Future decisions align with constitutional guidelines

**Testing Approach**:
- Review constitution content for clarity and completeness
- Verify agent alignment with principles
- Check consistency in applying principles to scenarios
</content>