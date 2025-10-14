---
description: [Brief description of what this command does and its primary purpose]
scripts:
  sh: [Shell script path for this command]
  ps: [PowerShell script path for this command]
agent_scripts:
  sh: [Shell script for updating agent context]
  ps: [PowerShell script for updating agent context]
---

## Command Overview

[Describe the purpose and scope of this command, including what it accomplishes and why it's needed.]

## User Input

```text
$ARGUMENTS
```

**Input Requirements**:
- [Required parameters or arguments]
- [Optional parameters with defaults]
- [Input validation rules]

## Execution Workflow

1. **Setup**: [Initial setup and validation steps]
   - [Parse and validate input arguments]
   - [Set up environment and dependencies]
   - [Check prerequisites and permissions]

2. **Core Execution**: [Main command logic and processing]
   - [Primary operations and transformations]
   - [Data processing and file operations]
   - [Integration with other systems]

3. **Output Generation**: [Results and artifact creation]
   - [Files, reports, or data produced]
   - [Status reporting and logging]
   - [Cleanup and finalization]

## Expected Outputs

**Primary Outputs**:
- [Main deliverables or results]
- [File locations and naming conventions]
- [Data formats and structures]

**Side Effects**:
- [Files modified or created]
- [System state changes]
- [Notifications or triggers]

## Error Handling

**Common Error Conditions**:
- [Input validation failures]
- [File system errors]
- [Permission or access issues]
- [Dependency or prerequisite failures]

**Error Recovery**:
- [Retry mechanisms]
- [Fallback procedures]
- [User notification strategies]

## Integration Points

**Dependencies**:
- [Other commands or systems this depends on]
- [Required files or configurations]
- [External services or APIs]

**Triggers**:
- [What this command enables or triggers]
- [Follow-on processes or workflows]
- [Integration with other tools]

## Usage Examples

### Basic Usage
```bash
[command-name] [basic-arguments]
```

### Advanced Usage
```bash
[command-name] [advanced-arguments] [options]
```

### Common Variations
- **[Variation 1]**: [Description and example]
- **[Variation 2]**: [Description and example]
- **[Variation 3]**: [Description and example]

## Validation and Testing

**Success Criteria**:
- [How to verify the command worked correctly]
- [Expected file contents or system state]
- [Performance or quality benchmarks]

**Testing Approach**:
- [Manual testing procedures]
- [Automated test scenarios]
- [Edge cases and error conditions]