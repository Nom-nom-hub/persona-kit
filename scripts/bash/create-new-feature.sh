#!/usr/bin/env bash

set -e

JSON_MODE=false
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json] [--personas persona1,persona2] [--patterns pattern1,pattern2] [--workflows workflow1,workflow2] <feature_description>"; exit 0 ;;
        *) ARGS+=("$arg") ;;
    esac
done

FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] [--personas persona1,persona2] [--patterns pattern1,pattern2] [--workflows workflow1,workflow2] <feature_description>" >&2
    exit 1
fi

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

# Function to find the repository root by searching for existing project markers
find_repo_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ] || [ -d "$dir/persona-kit" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Resolve repository root. Prefer git information when available, but fall back
# to searching for repository markers so the workflow still functions in repositories that
# were initialised with --no-git.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
    HAS_GIT=true
else
    REPO_ROOT="$(find_repo_root "$SCRIPT_DIR")"
    if [ -z "$REPO_ROOT" ]; then
        echo "Error: Could not determine repository root. Please run this script from within the repository." >&2
        exit 1
    fi
    HAS_GIT=false
fi

cd "$REPO_ROOT"

# Load common functions
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

FEATURES_DIR="$REPO_ROOT/.features"
mkdir -p "$FEATURES_DIR"

HIGHEST=0
if [ -d "$FEATURES_DIR" ]; then
    for dir in "$FEATURES_DIR"/*; do
        [ -d "$dir" ] || continue
        dirname=$(basename "$dir")
        number=$(echo "$dirname" | grep -o '^[0-9]\+' || echo "0")
        number=$((10#$number))
        if [ "$number" -gt "$HIGHEST" ]; then HIGHEST=$number; fi
    done
fi

NEXT=$((HIGHEST + 1))
FEATURE_NUM=$(printf "%03d" "$NEXT")

BRANCH_NAME=$(echo "$FEATURE_DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
WORDS=$(echo "$BRANCH_NAME" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//')
BRANCH_NAME="${FEATURE_NUM}-${WORDS}"

if [ "$HAS_GIT" = true ]; then
    git checkout -b "$BRANCH_NAME"
else
    >&2 echo "[persona-kit] Warning: Git repository not detected; skipped branch creation for $BRANCH_NAME"
fi

FEATURE_DIR="$FEATURES_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

# Set the PERSONA_FEATURE environment variable for the current session
export PERSONA_FEATURE="$BRANCH_NAME"

# Create feature structure
create_feature_structure "$FEATURE_DIR"

# Copy selected personas if specified
if [[ -n "$PERSONAS" ]]; then
    echo "Copying selected personas: $(echo $PERSONAS | tr ',' ' ')"
    copy_persona_files "$FEATURE_DIR" "$PERSONAS_DIR" "$(echo $PERSONAS | tr ',' ' ')"
fi

# Copy selected patterns if specified
if [[ -n "$PATTERNS" ]]; then
    echo "Copying selected patterns: $(echo $PATTERNS | tr ',' ' ')"
    copy_pattern_files "$FEATURE_DIR" "$PATTERNS_DIR" "$(echo $PATTERNS | tr ',' ' ')"
fi

# Copy selected workflows if specified
if [[ -n "$WORKFLOWS" ]]; then
    echo "Copying selected workflows: $(echo $WORKFLOWS | tr ',' ' ')"
    copy_workflow_files "$FEATURE_DIR" "$WORKFLOWS_DIR" "$(echo $WORKFLOWS | tr ',' ' ')"
fi

# Generate feature summary
generate_feature_summary "$FEATURE_DIR" "$BRANCH_NAME"

# Create a basic spec template if none exists
SPEC_FILE="$FEATURE_DIR/spec.md"
if [ ! -s "$SPEC_FILE" ]; then
    cat > "$SPEC_FILE" << EOF
# Feature Specification: $FEATURE_DESCRIPTION

## Overview
[Brief description of the feature]

## User Stories
- As a [user type], I want [functionality] so that [benefit]

## Requirements
- [Technical requirements]
- [Functional requirements]
- [Non-functional requirements]

## Acceptance Criteria
- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] [Criteria 3]

## Technical Notes
- [Technical considerations]
- [Dependencies]
- [Architecture impact]

## Related Personas
$(if [[ -n "$PERSONAS" ]]; then echo "$(echo $PERSONAS | tr ',' '\n' | sed 's/^/- /')"; else echo "- [Relevant personas will be added here]"; fi)

## Related Patterns
$(if [[ -n "$PATTERNS" ]]; then echo "$(echo $PATTERNS | tr ',' '\n' | sed 's/^/- /')"; else echo "- [Relevant patterns will be added here]"; fi)

## Related Workflows
$(if [[ -n "$WORKFLOWS" ]]; then echo "$(echo $WORKFLOWS | tr ',' '\n' | sed 's/^/- /')"; else echo "- [Relevant workflows will be added here]"; fi)
EOF
fi

echo
echo "=== Feature Created Successfully ==="
echo "BRANCH_NAME: $BRANCH_NAME"
echo "FEATURE_DIR: $FEATURE_DIR"
echo "FEATURE_NUM: $FEATURE_NUM"
echo "SPEC_FILE: $SPEC_FILE"
echo "PERSONA_FEATURE environment variable set to: $BRANCH_NAME"

if [[ -n "$PERSONAS" ]]; then
    echo "PERSONAS: $(echo $PERSONAS | tr ',' ' ')"
fi

if [[ -n "$PATTERNS" ]]; then
    echo "PATTERNS: $(echo $PATTERNS | tr ',' ' ')"
fi

if [[ -n "$WORKFLOWS" ]]; then
    echo "WORKFLOWS: $(echo $WORKFLOWS | tr ',' ' ')"
fi

echo
echo "Next steps:"
echo "1. Edit $SPEC_FILE to define your feature requirements"
echo "2. Update $FEATURE_DIR/plan.md with implementation details"
echo "3. Use the copied personas, patterns, and workflows as needed"
echo "4. Follow the tasks in $FEATURE_DIR/tasks.md"

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","FEATURE_DIR":"%s","FEATURE_NUM":"%s","SPEC_FILE":"%s","PERSONAS":"%s","PATTERNS":"%s","WORKFLOWS":"%s"}\n' \
        "$BRANCH_NAME" "$FEATURE_DIR" "$FEATURE_NUM" "$SPEC_FILE" "$PERSONAS" "$PATTERNS" "$WORKFLOWS"
fi