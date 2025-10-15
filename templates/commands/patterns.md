---
description: Access and apply development patterns to improve consistency, quality, and efficiency in project implementation.
scripts:
  sh: scripts/check-prerequisites.sh --json --require-config
  ps: scripts/check-prerequisites.ps1 -Json -RequireConfig
agent_scripts:
  sh: scripts/update-agent-context.sh --patterns
  ps: scripts/update-agent-context.ps1 -Patterns
---

## Command Overview

The `/personakit.patterns` command accesses and applies proven development patterns to improve consistency, quality, and efficiency in project implementation. This command helps identify and apply appropriate patterns based on current development context and project requirements.

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- Pattern category or specific pattern name (optional)
- Current development context or challenge
- Project-specific constraints or requirements

## Execution Workflow

1. **Setup**: Validate prerequisites and assess pattern context
   - Verify project initialization status
   - Check for existing pattern definitions
   - Analyze current development context
   - Identify applicable pattern categories

2. **Core Execution**: Identify, adapt, and apply development patterns
   - Search pattern repository for relevant solutions
   - Evaluate patterns against project constraints
   - Adapt patterns to project-specific requirements
   - Generate pattern application guidelines
   - Integrate pattern with current development context

3. **Output Generation**: Deliver pattern implementation guidance
   - Generate pattern application documentation
   - Update agent context with pattern considerations
   - Create pattern implementation checkpoints
   - Log pattern usage for project tracking

## Expected Outputs

**Primary Outputs**:
- Pattern application guidelines in `/patterns/[context].md`
- Updated agent context with pattern considerations
- Pattern-specific implementation steps
- Integration with current development artifacts

**Side Effects**:
- Influence on implementation approaches
- Consistency in applying proven solutions
- Improved development efficiency through reuse

## Error Handling

**Common Error Conditions**:
- Missing project initialization
- Invalid pattern specification
- No applicable patterns for context
- Pattern conflicts with project constraints

**Error Recovery**:
- Provide alternative pattern suggestions
- Offer custom approach recommendations
- Suggest pattern modification strategies
- Fallback to standard development practices

## Integration Points

**Dependencies**:
- Requires initialized project with Persona Kit
- Access to patterns directory and repository
- Project context and constraint information

**Triggers**:
- Influences implementation approaches
- Activates pattern-specific behaviors
- Guides consistency in development practices
- Enhances solution quality through proven patterns

## Usage Examples

### Basic Usage
```bash
/personakit.patterns
```

### Advanced Usage
```bash
/personakit.patterns Apply architectural patterns for a microservices project with high scalability requirements
```

### Common Variations
- **Pattern Discovery**: Identify relevant patterns for current challenge
- **Pattern Application**: Apply specific pattern to current context
- **Pattern Review**: Assess existing pattern usage in project

## Validation and Testing

**Success Criteria**:
- Pattern appropriately addresses development challenge
- Pattern aligns with project architecture and constraints
- Implementation guidance is clear and actionable
- Pattern application improves development efficiency

**Testing Approach**:
- Verify pattern relevance to current context
- Test pattern implementation guidance
- Confirm alignment with project architecture
- Validate pattern effectiveness post-implementation
</content>