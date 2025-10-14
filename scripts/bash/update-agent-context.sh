#!/usr/bin/env bash

# Update AI agent context files with persona-kit information
#
# This script maintains AI agent context files by parsing feature specifications
# and updating agent-specific configuration files with persona-driven project information.
#
# MAIN FUNCTIONS:
# 1. Environment Validation
#    - Verifies git repository structure and branch information
#    - Checks for required feature files and persona-kit structure
#    - Validates file permissions and accessibility
#
# 2. Feature Data Extraction
#    - Parses feature specification files to extract project metadata
#    - Identifies relevant personas, patterns, and workflows
#    - Handles missing or incomplete specification data gracefully
#
# 3. Agent File Management
#    - Creates new agent context files from templates when needed
#    - Updates existing agent files with new project information
#    - Preserves manual additions and custom configurations
#    - Supports multiple AI agent formats and directory structures
#
# 4. Persona Integration
#    - Incorporates active persona definitions into agent context
#    - Updates role-based decision-making guidance
#    - Maintains persona-specific communication patterns
#    - Integrates workflow and pattern information
#
# 5. Multi-Agent Support
#    - Handles agent-specific file paths and naming conventions
#    - Supports: Claude, Gemini, Copilot, Cursor, Qwen, opencode, Codex, Windsurf, Kilo Code, Auggie CLI, Amazon Q Developer CLI
#    - Can update single agents or all existing agent files
#    - Creates default Claude file if no agent files exist
#
# Usage: ./update-agent-context.sh [agent_type]
# Agent types: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|q
# Leave empty to update all existing agent files

set -e

# Enable strict error handling
set -u
set -o pipefail

#==============================================================================
# Configuration and Global Variables
#==============================================================================

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths and variables from common functions
eval $(get_feature_paths)

AGENT_TYPE="${1:-}"

# Agent-specific file paths
CLAUDE_FILE="$REPO_ROOT/CLAUDE.md"
GEMINI_FILE="$REPO_ROOT/GEMINI.md"
COPILOT_FILE="$REPO_ROOT/.github/copilot-instructions.md"
CURSOR_FILE="$REPO_ROOT/.cursor/rules/persona-kit-rules.mdc"
QWEN_FILE="$REPO_ROOT/QWEN.md"
AGENTS_FILE="$REPO_ROOT/AGENTS.md"
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/persona-kit-rules.md"
KILOCODE_FILE="$REPO_ROOT/.kilocode/rules/persona-kit-rules.md"
AUGGIE_FILE="$REPO_ROOT/.augment/rules/persona-kit-rules.md"
ROO_FILE="$REPO_ROOT/.roo/rules/persona-kit-rules.md"
CODEBUDDY_FILE="$REPO_ROOT/.codebuddy/rules/persona-kit-rules.md"
Q_FILE="$REPO_ROOT/AGENTS.md"

# Template file
TEMPLATE_FILE="$REPO_ROOT/persona-kit/templates/agent-file-template.md"

# Global variables for parsed feature data
FEATURE_DESCRIPTION=""
ACTIVE_PERSONAS=()
RELEVANT_PATTERNS=()
APPLICABLE_WORKFLOWS=()

#==============================================================================
# Utility Functions
#==============================================================================

log_info() {
    echo "INFO: $1"
}

log_success() {
    echo "✓ $1"
}

log_error() {
    echo "ERROR: $1" >&2
}

log_warning() {
    echo "WARNING: $1" >&2
}

# Cleanup function for temporary files
cleanup() {
    local exit_code=$?
    rm -f /tmp/agent_update_*_$$
    rm -f /tmp/manual_additions_$$
    exit $exit_code
}

# Set up cleanup trap
trap cleanup EXIT INT TERM

#==============================================================================
# Validation Functions
#==============================================================================

validate_environment() {
    # Check if we have a current branch/feature (git or non-git)
    if [[ -z "$CURRENT_BRANCH" ]]; then
        log_error "Unable to determine current feature"
        if [[ "$HAS_GIT" == "true" ]]; then
            log_info "Make sure you're on a feature branch"
        else
            log_info "Set PERSONA_FEATURE environment variable or create a feature first"
        fi
        exit 1
    fi

    # Check if feature directory exists
    if [[ ! -d "$FEATURE_DIR" ]]; then
        log_error "No feature directory found at $FEATURE_DIR"
        log_info "Make sure you're working on a feature with a corresponding .features directory"
        if [[ "$HAS_GIT" != "true" ]]; then
            log_info "Use: export PERSONA_FEATURE=your-feature-name or create a new feature first"
        fi
        exit 1
    fi

    # Check if spec.md exists
    if [[ ! -f "$FEATURE_SPEC" ]]; then
        log_error "No spec.md found at $FEATURE_SPEC"
        log_info "Create a feature specification file to provide context for AI agents"
        exit 1
    fi

    # Validate persona-kit structure
    if ! validate_persona_kit_structure "$REPO_ROOT"; then
        log_error "Invalid persona-kit structure"
        exit 1
    fi
}

#==============================================================================
# Feature Data Extraction Functions
#==============================================================================

extract_feature_field() {
    local field_pattern="$1"
    local feature_file="$2"

    grep "^\*\*$field_pattern\*\*: " "$feature_file" 2>/dev/null | \
        head -1 | \
        sed "s|^\*\*$field_pattern\*\*: ||" | \
        sed 's/^[ \t]*//;s/[ \t]*$//' | \
        grep -v "NEEDS CLARIFICATION" | \
        grep -v "^N/A$" || echo ""
}

parse_feature_data() {
    local spec_file="$1"

    if [[ ! -f "$spec_file" ]]; then
        log_error "Feature spec file not found: $spec_file"
        return 1
    fi

    if [[ ! -r "$spec_file" ]]; then
        log_error "Feature spec file is not readable: $spec_file"
        return 1
    fi

    log_info "Parsing feature data from $spec_file"

    FEATURE_DESCRIPTION=$(extract_feature_field "Overview" "$spec_file")

    # Extract personas, patterns, and workflows from feature directory
    if [[ -d "$FEATURE_DIR/personas" ]]; then
        for persona_file in "$FEATURE_DIR/personas"/*.md; do
            if [[ -f "$persona_file" ]]; then
                ACTIVE_PERSONAS+=($(basename "$persona_file" .md))
            fi
        done
    fi

    if [[ -d "$FEATURE_DIR/patterns" ]]; then
        for pattern_dir in "$FEATURE_DIR/patterns"/*; do
            if [[ -d "$pattern_dir" ]]; then
                RELEVANT_PATTERNS+=($(basename "$pattern_dir"))
            fi
        done
    fi

    if [[ -d "$FEATURE_DIR/workflows" ]]; then
        for workflow_file in "$FEATURE_DIR/workflows"/*.md; do
            if [[ -f "$workflow_file" ]]; then
                APPLICABLE_WORKFLOWS+=($(basename "$workflow_file" .md))
            fi
        done
    fi

    # Log what we found
    if [[ -n "$FEATURE_DESCRIPTION" ]]; then
        log_info "Found feature description"
    else
        log_warning "No feature description found in spec"
    fi

    if [[ ${#ACTIVE_PERSONAS[@]} -gt 0 ]]; then
        log_info "Found active personas: ${ACTIVE_PERSONAS[*]}"
    else
        log_warning "No active personas found"
    fi

    if [[ ${#RELEVANT_PATTERNS[@]} -gt 0 ]]; then
        log_info "Found relevant patterns: ${RELEVANT_PATTERNS[*]}"
    fi

    if [[ ${#APPLICABLE_WORKFLOWS[@]} -gt 0 ]]; then
        log_info "Found applicable workflows: ${APPLICABLE_WORKFLOWS[*]}"
    fi
}

#==============================================================================
# Persona and Pattern Integration Functions
#==============================================================================

generate_persona_context() {
    local personas=("$@")
    local context=""

    for persona in "${personas[@]}"; do
        local persona_file="$FEATURE_DIR/personas/$persona.md"
        if [[ -f "$persona_file" ]]; then
            context+="
**$persona Persona**:"
            context+=$(grep "^## " "$persona_file" | head -5 | sed 's/^## /- /' | head -3)
            context+="- See personas/$persona.md for complete role definition"
        fi
    done

    echo "$context"
}

generate_pattern_context() {
    local patterns=("$@")
    local context=""

    for pattern in "${patterns[@]}"; do
        local pattern_files=("$FEATURE_DIR/patterns/$pattern"/*.md)
        if [[ -f "${pattern_files[0]}" ]]; then
            context+="
**$pattern Pattern**:"
            context+=$(grep "^## " "${pattern_files[0]}" | head -3 | sed 's/^## /- /' | head -2)
            context+="- See patterns/$pattern/ for detailed pattern guidance"
        fi
    done

    echo "$context"
}

generate_workflow_context() {
    local workflows=("$@")
    local context=""

    for workflow in "${workflows[@]}"; do
        local workflow_file="$FEATURE_DIR/workflows/$workflow.md"
        if [[ -f "$workflow_file" ]]; then
            context+="
**$workflow Workflow**:"
            context+=$(grep "^## " "$workflow_file" | head -3 | sed 's/^## /- /' | head -2)
            context+="- See workflows/$workflow.md for complete workflow steps"
        fi
    done

    echo "$context"
}

#==============================================================================
# Template and Content Generation Functions
#==============================================================================

create_new_agent_file() {
    local target_file="$1"
    local temp_file="$2"
    local project_name="$3"
    local current_date="$4"

    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_warning "Template not found at $TEMPLATE_FILE, creating basic agent file"
        # Create a basic template
        cat > "$TEMPLATE_FILE" << 'EOF'
# AI Agent Context: [PROJECT NAME]

**Last updated**: [DATE]

## Project Overview
[EXTRACTED FROM ALL PLAN.MD FILES]

## Active Technologies
[ACTUAL STRUCTURE FROM PLANS]

## Development Commands
[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES]

## Coding Standards
[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE]

## Recent Changes
[LAST 3 FEATURES AND WHAT THEY ADDED]

## Active Personas
[PERSONA CONTEXT INFORMATION]

## Relevant Patterns
[PATTERN CONTEXT INFORMATION]

## Applicable Workflows
[WORKFLOW CONTEXT INFORMATION]

## Development Guidelines
- Follow the active persona definitions for role-specific guidance
- Apply relevant patterns when dealing with complex situations
- Follow established workflows for consistent development processes
- Maintain clear separation of concerns between different personas
- Use pattern-driven approaches for decision-making and problem-solving
EOF
    fi

    if [[ ! -r "$TEMPLATE_FILE" ]]; then
        log_error "Template file is not readable: $TEMPLATE_FILE"
        return 1
    fi

    log_info "Creating new agent context file from template..."

    if ! cp "$TEMPLATE_FILE" "$temp_file"; then
        log_error "Failed to copy template file"
        return 1
    fi

    # Generate context information
    local persona_context=$(generate_persona_context "${ACTIVE_PERSONAS[@]}")
    local pattern_context=$(generate_pattern_context "${RELEVANT_PATTERNS[@]}")
    local workflow_context=$(generate_workflow_context "${APPLICABLE_WORKFLOWS[@]}")

    # Replace template placeholders
    local project_structure="persona-kit/\\n.features/$CURRENT_BRANCH/"
    local commands="# Use persona-kit scripts for development workflow"
    local language_conventions="Follow persona-driven development practices"
    local tech_stack="Persona-Kit Framework ($CURRENT_BRANCH)"
    local recent_change="- $CURRENT_BRANCH: Persona-driven feature development"

    # Perform substitutions with error checking
    local escaped_branch=$(printf '%s\n' "$CURRENT_BRANCH" | sed 's/[\[\.*^$()+{}|]/\\&/g')

    local substitutions=(
        "s|\[PROJECT NAME\]|$project_name|"
        "s|\[DATE\]|$current_date|"
        "s|\[EXTRACTED FROM ALL PLAN.MD FILES\]|$tech_stack|"
        "s|\[ACTUAL STRUCTURE FROM PLANS\]|$project_structure|g"
        "s|\[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES\]|$commands|"
        "s|\[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE\]|$language_conventions|"
        "s|\[LAST 3 FEATURES AND WHAT THEY ADDED\]|$recent_change|"
        "s|\[PERSONA CONTEXT INFORMATION\]|$persona_context|"
        "s|\[PATTERN CONTEXT INFORMATION\]|$pattern_context|"
        "s|\[WORKFLOW CONTEXT INFORMATION\]|$workflow_context|"
    )

    for substitution in "${substitutions[@]}"; do
        if ! sed -i.bak -e "$substitution" "$temp_file"; then
            log_error "Failed to perform substitution: $substitution"
            rm -f "$temp_file" "$temp_file.bak"
            return 1
        fi
    done

    # Convert \n sequences to actual newlines
    newline=$(printf '\n')
    sed -i.bak2 "s/\\\\n/${newline}/g" "$temp_file"

    # Clean up backup files
    rm -f "$temp_file.bak" "$temp_file.bak2"

    return 0
}

#==============================================================================
# Agent File Update Function
#==============================================================================

update_agent_file() {
    local target_file="$1"
    local agent_name="$2"

    if [[ -z "$target_file" ]] || [[ -z "$agent_name" ]]; then
        log_error "update_agent_file requires target_file and agent_name parameters"
        return 1
    fi

    log_info "Updating $agent_name context file: $target_file"

    local project_name
    project_name=$(basename "$REPO_ROOT")
    local current_date
    current_date=$(date +%Y-%m-%d)

    # Create directory if it doesn't exist
    local target_dir
    target_dir=$(dirname "$target_file")
    if [[ ! -d "$target_dir" ]]; then
        if ! mkdir -p "$target_dir"; then
            log_error "Failed to create directory: $target_dir"
            return 1
        fi
    fi

    if [[ ! -f "$target_file" ]]; then
        # Create new file from template
        local temp_file
        temp_file=$(mktemp) || {
            log_error "Failed to create temporary file"
            return 1
        }

        if create_new_agent_file "$target_file" "$temp_file" "$project_name" "$current_date"; then
            if mv "$temp_file" "$target_file"; then
                log_success "Created new $agent_name context file"
            else
                log_error "Failed to move temporary file to $target_file"
                rm -f "$temp_file"
                return 1
            fi
        else
            log_error "Failed to create new agent file"
            rm -f "$temp_file"
            return 1
        fi
    else
        # Update existing file with persona information
        if [[ ! -r "$target_file" ]]; then
            log_error "Cannot read existing file: $target_file"
            return 1
        fi

        if [[ ! -w "$target_file" ]]; then
            log_error "Cannot write to existing file: $target_file"
            return 1
        fi

        # Generate context and update existing file
        local persona_context=$(generate_persona_context "${ACTIVE_PERSONAS[@]}")
        local pattern_context=$(generate_pattern_context "${RELEVANT_PATTERNS[@]}")
        local workflow_context=$(generate_workflow_context "${APPLICABLE_WORKFLOWS[@]}")

        # Use a temporary file for atomic update
        local temp_file
        temp_file=$(mktemp) || {
            log_error "Failed to create temporary file"
            return 1
        }

        # Copy original file and update sections
        cp "$target_file" "$temp_file"

        # Update persona section if it exists
        if grep -q "Active Personas" "$temp_file"; then
            # Remove existing persona section and add new one
            sed -i '/## Active Personas/,/## /{//!d; /## Active Personas/d; }' "$temp_file"
            sed -i '/## Recent Changes/a\
\
## Active Personas\
'"$persona_context"'\
' "$temp_file"
        fi

        # Update patterns section if it exists
        if grep -q "Relevant Patterns" "$temp_file"; then
            sed -i '/## Relevant Patterns/,/## /{//!d; /## Relevant Patterns/d; }' "$temp_file"
            sed -i '/## Active Personas/a\
\
## Relevant Patterns\
'"$pattern_context"'\
' "$temp_file"
        fi

        # Update workflows section if it exists
        if grep -q "Applicable Workflows" "$temp_file"; then
            sed -i '/## Applicable Workflows/,/## /{//!d; /## Applicable Workflows/d; }' "$temp_file"
            sed -i '/## Relevant Patterns/a\
\
## Applicable Workflows\
'"$workflow_context"'\
' "$temp_file"
        fi

        # Update timestamp
        if grep -q "Last updated.*[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" "$temp_file"; then
            sed -i "s/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/$current_date/" "$temp_file"
        fi

        # Move temp file to target atomically
        if ! mv "$temp_file" "$target_file"; then
            log_error "Failed to update target file"
            rm -f "$temp_file"
            return 1
        fi

        log_success "Updated existing $agent_name context file"
    fi

    return 0
}

#==============================================================================
# Agent Selection and Processing
#==============================================================================

update_specific_agent() {
    local agent_type="$1"

    case "$agent_type" in
        claude)
            update_agent_file "$CLAUDE_FILE" "Claude Code"
            ;;
        gemini)
            update_agent_file "$GEMINI_FILE" "Gemini CLI"
            ;;
        copilot)
            update_agent_file "$COPILOT_FILE" "GitHub Copilot"
            ;;
        cursor-agent)
            update_agent_file "$CURSOR_FILE" "Cursor IDE"
            ;;
        qwen)
            update_agent_file "$QWEN_FILE" "Qwen Code"
            ;;
        opencode)
            update_agent_file "$AGENTS_FILE" "opencode"
            ;;
        codex)
            update_agent_file "$AGENTS_FILE" "Codex CLI"
            ;;
        windsurf)
            update_agent_file "$WINDSURF_FILE" "Windsurf"
            ;;
        kilocode)
            update_agent_file "$KILOCODE_FILE" "Kilo Code"
            ;;
        auggie)
            update_agent_file "$AUGGIE_FILE" "Auggie CLI"
            ;;
        roo)
            update_agent_file "$ROO_FILE" "Roo Code"
            ;;
        codebuddy)
            update_agent_file "$CODEBUDDY_FILE" "CodeBuddy"
            ;;
        q)
            update_agent_file "$Q_FILE" "Amazon Q Developer CLI"
            ;;
        *)
            log_error "Unknown agent type '$agent_type'"
            log_error "Expected: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|q"
            exit 1
            ;;
    esac
}

update_all_existing_agents() {
    local found_agent=false

    # Check each possible agent file and update if it exists
    if [[ -f "$CLAUDE_FILE" ]]; then
        update_agent_file "$CLAUDE_FILE" "Claude Code"
        found_agent=true
    fi

    if [[ -f "$GEMINI_FILE" ]]; then
        update_agent_file "$GEMINI_FILE" "Gemini CLI"
        found_agent=true
    fi

    if [[ -f "$COPILOT_FILE" ]]; then
        update_agent_file "$COPILOT_FILE" "GitHub Copilot"
        found_agent=true
    fi

    if [[ -f "$CURSOR_FILE" ]]; then
        update_agent_file "$CURSOR_FILE" "Cursor IDE"
        found_agent=true
    fi

    if [[ -f "$QWEN_FILE" ]]; then
        update_agent_file "$QWEN_FILE" "Qwen Code"
        found_agent=true
    fi

    if [[ -f "$AGENTS_FILE" ]]; then
        update_agent_file "$AGENTS_FILE" "Codex/opencode"
        found_agent=true
    fi

    if [[ -f "$WINDSURF_FILE" ]]; then
        update_agent_file "$WINDSURF_FILE" "Windsurf"
        found_agent=true
    fi

    if [[ -f "$KILOCODE_FILE" ]]; then
        update_agent_file "$KILOCODE_FILE" "Kilo Code"
        found_agent=true
    fi

    if [[ -f "$AUGGIE_FILE" ]]; then
        update_agent_file "$AUGGIE_FILE" "Auggie CLI"
        found_agent=true
    fi

    if [[ -f "$ROO_FILE" ]]; then
        update_agent_file "$ROO_FILE" "Roo Code"
        found_agent=true
    fi

    if [[ -f "$CODEBUDDY_FILE" ]]; then
        update_agent_file "$CODEBUDDY_FILE" "CodeBuddy"
        found_agent=true
    fi

    if [[ -f "$Q_FILE" ]]; then
        update_agent_file "$Q_FILE" "Amazon Q Developer CLI"
        found_agent=true
    fi

    # If no agent files exist, create a default Claude file
    if [[ "$found_agent" == false ]]; then
        log_info "No existing agent files found, creating default Claude file..."
        update_agent_file "$CLAUDE_FILE" "Claude Code"
    fi
}

print_summary() {
    echo
    log_info "Summary of persona-kit integration:"

    if [[ ${#ACTIVE_PERSONAS[@]} -gt 0 ]]; then
        echo "  - Active Personas: ${ACTIVE_PERSONAS[*]}"
    fi

    if [[ ${#RELEVANT_PATTERNS[@]} -gt 0 ]]; then
        echo "  - Relevant Patterns: ${RELEVANT_PATTERNS[*]}"
    fi

    if [[ ${#APPLICABLE_WORKFLOWS[@]} -gt 0 ]]; then
        echo "  - Applicable Workflows: ${APPLICABLE_WORKFLOWS[*]}"
    fi

    echo

    log_info "Usage: $0 [claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|codebuddy|q]"
}

#==============================================================================
# Main Execution
#==============================================================================

main() {
    # Validate environment before proceeding
    validate_environment

    log_info "=== Updating agent context files for feature $CURRENT_BRANCH ==="

    # Parse the feature files to extract project information
    if ! parse_feature_data "$FEATURE_SPEC"; then
        log_error "Failed to parse feature data"
        exit 1
    fi

    # Process based on agent type argument
    local success=true

    if [[ -z "$AGENT_TYPE" ]]; then
        # No specific agent provided - update all existing agent files
        log_info "No agent specified, updating all existing agent files..."
        if ! update_all_existing_agents; then
            success=false
        fi
    else
        # Specific agent provided - update only that agent
        log_info "Updating specific agent: $AGENT_TYPE"
        if ! update_specific_agent "$AGENT_TYPE"; then
            success=false
        fi
    fi

    # Print summary
    print_summary

    if [[ "$success" == true ]]; then
        log_success "Agent context update completed successfully"
        exit 0
    else
        log_error "Agent context update completed with errors"
        exit 1
    fi
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi