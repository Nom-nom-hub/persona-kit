#!/usr/bin/env bash

set -e

# Parse command line arguments
JSON_MODE=false
FORCE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --force)
            FORCE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--force] [--personas persona1,persona2] [--patterns pattern1,pattern2] [--workflows workflow1,workflow2]"
            echo "  --json      Output results in JSON format"
            echo "  --force     Overwrite existing files"
            echo "  --personas  Comma-separated list of personas to include"
            echo "  --patterns  Comma-separated list of patterns to include"
            echo "  --workflows Comma-separated list of workflows to include"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *) ARGS+=("$arg") ;;
    esac
done

# Parse optional arguments
PERSONAS=""
PATTERNS=""
WORKFLOWS=""

# Simple argument parsing for personas, patterns, workflows
for arg in "$@"; do
    case "$arg" in
        --personas=*)
            PERSONAS="${arg#*=}"
            ;;
        --patterns=*)
            PATTERNS="${arg#*=}"
            ;;
        --workflows=*)
            WORKFLOWS="${arg#*=}"
            ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths and variables from common functions
eval $(get_feature_paths)

# Validate persona-kit structure
if ! validate_persona_kit_structure "$REPO_ROOT"; then
    echo "Error: Invalid persona-kit structure. Please ensure persona-kit is properly set up." >&2
    exit 1
fi

# Check if we're on a proper feature branch (only for git repos)
check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

# Ensure the feature directory exists
mkdir -p "$FEATURE_DIR"

echo "=== Setting up Persona Workflow for Feature: $CURRENT_BRANCH ==="
echo

# Set up personas
echo "Setting up personas..."
if [[ -n "$PERSONAS" ]]; then
    echo "Using specified personas: $(echo $PERSONAS | tr ',' ' ')"
    copy_persona_files "$FEATURE_DIR" "$PERSONAS_DIR" "$(echo $PERSONAS | tr ',' ' ')"
else
    echo "Copying all available personas..."
    available_personas=$(get_available_personas "$PERSONA_KIT_DIR")
    if [[ -n "$available_personas" ]]; then
        copy_persona_files "$FEATURE_DIR" "$PERSONAS_DIR" "$available_personas"
    else
        echo "  ⚠ No personas found in $PERSONAS_DIR"
    fi
fi

echo

# Set up patterns
echo "Setting up patterns..."
if [[ -n "$PATTERNS" ]]; then
    echo "Using specified patterns: $(echo $PATTERNS | tr ',' ' ')"
    copy_pattern_files "$FEATURE_DIR" "$PATTERNS_DIR" "$(echo $PATTERNS | tr ',' ' ')"
else
    echo "Copying all available patterns..."
    available_patterns=$(get_available_patterns "$PERSONA_KIT_DIR")
    if [[ -n "$available_patterns" ]]; then
        copy_pattern_files "$FEATURE_DIR" "$PATTERNS_DIR" "$available_patterns"
    else
        echo "  ⚠ No patterns found in $PATTERNS_DIR"
    fi
fi

echo

# Set up workflows
echo "Setting up workflows..."
if [[ -n "$WORKFLOWS" ]]; then
    echo "Using specified workflows: $(echo $WORKFLOWS | tr ',' ' ')"
    copy_workflow_files "$FEATURE_DIR" "$WORKFLOWS_DIR" "$(echo $WORKFLOWS | tr ',' ' ')"
else
    echo "Copying all available workflows..."
    available_workflows=$(get_available_workflows "$PERSONA_KIT_DIR")
    if [[ -n "$available_workflows" ]]; then
        copy_workflow_files "$FEATURE_DIR" "$WORKFLOWS_DIR" "$available_workflows"
    else
        echo "  ⚠ No workflows found in $WORKFLOWS_DIR"
    fi
fi

echo

# Create workflow integration file
WORKFLOW_INTEGRATION="$FEATURE_DIR/workflow-integration.md"
if [[ ! -f "$WORKFLOW_INTEGRATION" ]] || [[ "$FORCE" == "true" ]]; then
    cat > "$WORKFLOW_INTEGRATION" << EOF
# Workflow Integration Guide

This document outlines how to integrate the provided personas, patterns, and workflows for feature development.

## Available Personas
$(if [[ -d "$FEATURE_DIR/personas" ]]; then
    for persona_file in "$FEATURE_DIR/personas"/*.md; do
        if [[ -f "$persona_file" ]]; then
            persona_name=$(basename "$persona_file" .md)
            echo "- **$persona_name**: See personas/$persona_name.md for detailed role definition"
        fi
    done
else
    echo "- No personas have been set up for this feature"
fi)

## Available Patterns
$(if [[ -d "$FEATURE_DIR/patterns" ]]; then
    for pattern_dir in "$FEATURE_DIR/patterns"/*; do
        if [[ -d "$pattern_dir" ]]; then
            pattern_name=$(basename "$pattern_dir")
            echo "- **$pattern_name**: See patterns/$pattern_name/ for pattern documentation"
        fi
    done
else
    echo "- No patterns have been set up for this feature"
fi)

## Available Workflows
$(if [[ -d "$FEATURE_DIR/workflows" ]]; then
    for workflow_file in "$FEATURE_DIR/workflows"/*.md; do
        if [[ -f "$workflow_file" ]]; then
            workflow_name=$(basename "$workflow_file" .md)
            echo "- **$workflow_name**: See workflows/$workflow_name.md for workflow steps"
        fi
    done
else
    echo "- No workflows have been set up for this feature"
fi)

## Integration Guidelines

### 1. Role Assignment
- Review each persona and assign team members or AI agents to these roles
- Ensure clear responsibility boundaries between different personas

### 2. Pattern Selection
- Choose patterns that match your specific development scenario
- Combine multiple patterns when dealing with complex situations
- Adapt patterns to your team's context and constraints

### 3. Workflow Customization
- Modify workflows to fit your team's processes and tools
- Identify the most relevant phases for your feature development
- Create checkpoints for pattern and persona integration

### 4. Communication Strategy
- Use persona communication preferences for stakeholder updates
- Apply communication patterns for structured information sharing
- Establish regular check-ins aligned with workflow phases

## Next Steps

1. **Review Artifacts**: Examine all copied personas, patterns, and workflows
2. **Customize Content**: Adapt materials to your specific feature context
3. **Assign Roles**: Designate team members to different persona roles
4. **Plan Integration**: Schedule how and when to apply each pattern and workflow
5. **Track Progress**: Use the provided workflows to monitor development progress

## Support

If you need help integrating these materials:
- Refer to the original persona-kit documentation in persona-kit/
- Consult with team leads familiar with persona-driven development
- Use the patterns for guidance on complex situations
EOF

    echo "✓ Created workflow integration guide: $WORKFLOW_INTEGRATION"
else
    echo "✓ Workflow integration guide already exists (use --force to overwrite)"
fi

echo

# Output results
if $JSON_MODE; then
    printf '{"FEATURE_DIR":"%s","PERSONAS":"%s","PATTERNS":"%s","WORKFLOWS":"%s","WORKFLOW_INTEGRATION":"%s"}\n' \
        "$FEATURE_DIR" "$PERSONAS" "$PATTERNS" "$WORKFLOWS" "$WORKFLOW_INTEGRATION"
else
    echo "=== Setup Complete ==="
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "PERSONAS: ${PERSONAS:-All available}"
    echo "PATTERNS: ${PATTERNS:-All available}"
    echo "WORKFLOWS: ${WORKFLOWS:-All available}"
    echo "WORKFLOW_INTEGRATION: $WORKFLOW_INTEGRATION"
    echo
    echo "Next steps:"
    echo "1. Review the workflow integration guide"
    echo "2. Customize personas, patterns, and workflows for your feature"
    echo "3. Assign team roles based on persona definitions"
    echo "4. Follow the established workflows for development"
fi