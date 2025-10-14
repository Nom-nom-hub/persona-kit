#!/usr/bin/env bash
# Common functions and variables for persona-kit scripts

# Get repository root, with fallback for non-git repositories
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        # Fall back to script location for non-git repos
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# Get current branch, with fallback for non-git repositories
get_current_branch() {
    # First check if PERSONA_FEATURE environment variable is set
    if [[ -n "${PERSONA_FEATURE:-}" ]]; then
        echo "$PERSONA_FEATURE"
        return
    fi

    # Then check git if available
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    # For non-git repos, try to find the latest feature directory
    local repo_root=$(get_repo_root)
    local features_dir="$repo_root/.features"

    if [[ -d "$features_dir" ]]; then
        local latest_feature=""
        local highest=0

        for dir in "$features_dir"/*; do
            if [[ -d "$dir" ]]; then
                local dirname=$(basename "$dir")
                if [[ "$dirname" =~ ^([0-9]{3})- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                fi
            fi
        done

        if [[ -n "$latest_feature" ]]; then
            echo "$latest_feature"
            return
        fi
    fi

    echo "main"  # Final fallback
}

# Check if we have git available
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    # For non-git repos, we can't enforce branch naming but still provide output
    if [[ "$has_git_repo" != "true" ]]; then
        echo "[persona-kit] Warning: Git repository not detected; skipped branch validation" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch" >&2
        echo "Feature branches should be named like: 001-feature-name" >&2
        return 1
    fi

    return 0
}

get_feature_dir() { echo "$1/.features/$2"; }

get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    local feature_dir=$(get_feature_dir "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
PERSONA_KIT_DIR='$repo_root/persona-kit'
PERSONAS_DIR='$repo_root/persona-kit/personas'
PATTERNS_DIR='$repo_root/persona-kit/patterns'
WORKFLOWS_DIR='$repo_root/persona-kit/workflows'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

# Check if file exists and is not empty
check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

# Check if directory exists and is not empty
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

# Get available personas from the personas directory
get_available_personas() {
    local personas_dir="$1/personas"
    local personas=()

    if [[ -d "$personas_dir" ]]; then
        for dir in "$personas_dir"/*; do
            if [[ -d "$dir" ]] && [[ -f "$dir/persona.md" ]]; then
                personas+=($(basename "$dir"))
            fi
        done
    fi

    echo "${personas[@]}"
}

# Get available patterns from the patterns directory
get_available_patterns() {
    local patterns_dir="$1/patterns"
    local patterns=()

    if [[ -d "$patterns_dir" ]]; then
        for dir in "$patterns_dir"/*; do
            if [[ -d "$dir" ]]; then
                patterns+=($(basename "$dir"))
            fi
        done
    fi

    echo "${patterns[@]}"
}

# Get available workflows from the workflows directory
get_available_workflows() {
    local workflows_dir="$1/workflows"
    local workflows=()

    if [[ -d "$workflows_dir" ]]; then
        for dir in "$workflows_dir"/*; do
            if [[ -d "$dir" ]] && [[ -f "$dir/workflow.md" ]]; then
                workflows+=($(basename "$dir"))
            fi
        done
    fi

    echo "${workflows[@]}"
}

# Validate that required persona-kit structure exists
validate_persona_kit_structure() {
    local repo_root="$1"
    local required_dirs=("$repo_root/persona-kit" "$repo_root/persona-kit/personas" "$repo_root/persona-kit/patterns" "$repo_root/persona-kit/workflows")

    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            echo "ERROR: Required directory not found: $dir" >&2
            return 1
        fi
    done

    return 0
}

# Create feature directory structure
create_feature_structure() {
    local feature_dir="$1"
    mkdir -p "$feature_dir"

    # Create standard feature files
    touch "$feature_dir/spec.md"
    touch "$feature_dir/plan.md"
    touch "$feature_dir/tasks.md"
    touch "$feature_dir/research.md"
    mkdir -p "$feature_dir/contracts"
}

# Copy persona files to feature directory
copy_persona_files() {
    local feature_dir="$1"
    local personas_dir="$2"
    local selected_personas="$3"

    for persona in $selected_personas; do
        local persona_source="$personas_dir/$persona/persona.md"
        local persona_dest="$feature_dir/personas/$persona.md"

        if [[ -f "$persona_source" ]]; then
            mkdir -p "$(dirname "$persona_dest")"
            cp "$persona_source" "$persona_dest"
            echo "  ✓ Copied $persona persona"
        else
            echo "  ⚠ Persona $persona not found at $persona_source"
        fi
    done
}

# Copy pattern files to feature directory
copy_pattern_files() {
    local feature_dir="$1"
    local patterns_dir="$2"
    local selected_patterns="$3"

    for pattern in $selected_patterns; do
        # Find pattern files in the pattern directory
        for pattern_file in "$patterns_dir/$pattern"/*.md; do
            if [[ -f "$pattern_file" ]]; then
                local pattern_name=$(basename "$pattern_file" .md)
                local pattern_dest="$feature_dir/patterns/$pattern/$pattern_name.md"

                mkdir -p "$(dirname "$pattern_dest")"
                cp "$pattern_file" "$pattern_dest"
                echo "  ✓ Copied $pattern/$pattern_name pattern"
            fi
        done
    done
}

# Copy workflow files to feature directory
copy_workflow_files() {
    local feature_dir="$1"
    local workflows_dir="$2"
    local selected_workflows="$3"

    for workflow in $selected_workflows; do
        local workflow_source="$workflows_dir/$workflow/workflow.md"
        local workflow_dest="$feature_dir/workflows/$workflow.md"

        if [[ -f "$workflow_source" ]]; then
            mkdir -p "$(dirname "$workflow_dest")"
            cp "$workflow_source" "$workflow_dest"
            echo "  ✓ Copied $workflow workflow"
        else
            echo "  ⚠ Workflow $workflow not found at $workflow_source"
        fi
    done
}

# Generate feature summary
generate_feature_summary() {
    local feature_dir="$1"
    local branch="$2"

    cat > "$feature_dir/README.md" << EOF
# Feature: $branch

This directory contains all persona-kit artifacts for feature development.

## Structure

- \`spec.md\` - Feature specification and requirements
- \`plan.md\` - Implementation plan and technical details
- \`tasks.md\` - Development tasks and checklist
- \`research.md\` - Research notes and references
- \`personas/\` - Persona definitions for this feature
- \`patterns/\` - Relevant patterns for this feature
- \`workflows/\` - Applicable workflows for this feature
- \`contracts/\` - API contracts and data models

## Getting Started

1. Review the feature specification in \`spec.md\`
2. Check the implementation plan in \`plan.md\`
3. Follow the tasks in \`tasks.md\`
4. Use the provided personas, patterns, and workflows as needed

## Branch Information

- **Branch**: \`$branch\`
- **Created**: \`\`date +%Y-%m-%d\` \`\`
- **Status**: Active development

EOF
}