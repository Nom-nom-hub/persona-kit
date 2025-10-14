#!/bin/bash

# --- PERSONA KIT BASH SCRIPTS COMMON FUNCTIONS ---
# This file contains common utility functions for Persona Kit bash scripts
# All other bash scripts in the Persona Kit system source this file

set -euo pipefail

# --- DEFAULT VALUES ---
# Default values for configuration, may be overridden by environment variables
: "${PERSONAKIT_DEBUG:=0}"
: "${PERSONAKIT_FEATURE:=}"

# --- LOGGING FUNCTIONS ---
log_debug() {
    if [ "${PERSONAKIT_DEBUG}" -ge 1 ]; then
        echo "[DEBUG] $*" >&2
    fi
}

log_info() {
    echo "[INFO] $*" >&2
}

log_warn() {
    echo "[WARN] $*" >&2
}

log_error() {
    echo "[ERROR] $*" >&2
}

# --- VALIDATION FUNCTIONS ---
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

get_git_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

# --- PERSONA KIT SPECIFIC FUNCTIONS ---
get_personakit_root() {
    local current_dir="${1:-$(pwd)}"
    local search_dir="$current_dir"
    
    while [ "$search_dir" != "/" ]; do
        if [ -d "$search_dir/.personakit" ]; then
            echo "$search_dir"
            return 0
        fi
        search_dir=$(dirname "$search_dir")
    done
    
    return 1
}

get_active_feature() {
    # If PERSONAKIT_FEATURE is set, use it
    if [ -n "${PERSONAKIT_FEATURE:-}" ]; then
        echo "${PERSONAKIT_FEATURE}"
        return 0
    fi
    
    # Otherwise, get from git branch name
    if is_git_repo; then
        local branch_name
        branch_name=$(git branch --show-current 2>/dev/null || echo "")
        if [ -n "$branch_name" ]; then
            echo "$branch_name"
            return 0
        fi
    fi
    
    log_error "Could not determine active feature. Either set PERSONAKIT_FEATURE environment variable or use git branches."
    return 1
}

# --- DIRECTORY MANAGEMENT ---
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log_info "Created directory: $dir"
    fi
}

# --- FILE MANAGEMENT ---
ensure_file() {
    local file="$1"
    local template_dir="${2:-}"
    
    if [ ! -f "$file" ]; then
        ensure_directory "$(dirname "$file")"
        
        if [ -n "$template_dir" ] && [ -f "$template_dir/$(basename "$file")" ]; then
            cp "$template_dir/$(basename "$file")" "$file"
            log_info "Created file from template: $file"
        else
            touch "$file"
            log_info "Created empty file: $file"
        fi
    fi
}

# --- PERSONA SPECIFIC FUNCTIONS ---
get_persona_guidance_dir() {
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Could not find .personakit directory"
        return 1
    }
    
    local feature
    feature=$(get_active_feature) || return 1
    
    echo "$personakit_root/personas/$feature"
}

ensure_persona_guidance_structure() {
    local guidance_dir
    guidance_dir=$(get_persona_guidance_dir) || return 1
    
    ensure_directory "$guidance_dir"
    
    # Create standard persona guidance files
    ensure_file "$guidance_dir/ceo-perspective.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/engineering-perspective.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/architecture-notes.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/development-plan.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/qa-assessment.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/security-review.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/devops-considerations.md" "$TEMPLATES_DIR/persona-guidance"
    ensure_file "$guidance_dir/multi-perspective-summary.md" "$TEMPLATES_DIR/persona-guidance"
}

# --- PATH RESOLUTION ---
get_personakit_templates_dir() {
    local personakit_root
    personakit_root=$(get_personakit_root) || return 1
    echo "$personakit_root/.personakit/templates"
}

get_personakit_scripts_dir() {
    local personakit_root
    personakit_root=$(get_personakit_root) || return 1
    echo "$personakit_root/.personakit/scripts"
}

get_personakit_memory_dir() {
    local personakit_root
    personakit_root=$(get_personakit_root) || return 1
    echo "$personakit_root/.personakit/memory"
}

# --- UTILITY FUNCTIONS ---
update_claude_context() {
    local claude_file="${1:-}"
    
    if [ -n "$claude_file" ] && [ -f "$claude_file" ]; then
        log_info "Updating Claude context file: $claude_file"
        
        # Add current persona guidance to Claude context
        local guidance_dir
        guidance_dir=$(get_persona_guidance_dir) || return 1
        
        {
            echo "## PERSONA GUIDANCE"
            echo ""
            echo "Current feature: $(get_active_feature)"
            echo ""
            
            if [ -f "$guidance_dir/ceo-perspective.md" ]; then
                echo "### CEO Perspective"
                echo ""
                cat "$guidance_dir/ceo-perspective.md"
                echo ""
            fi
            
            if [ -f "$guidance_dir/engineering-perspective.md" ]; then
                echo "### Engineering Perspective"
                echo ""
                cat "$guidance_dir/engineering-perspective.md"
                echo ""
            fi
            
            if [ -f "$guidance_dir/architecture-notes.md" ]; then
                echo "### Architecture Notes"
                echo ""
                cat "$guidance_dir/architecture-notes.md"
                echo ""
            fi
            
            if [ -f "$guidance_dir/development-plan.md" ]; then
                echo "### Development Plan"
                echo ""
                cat "$guidance_dir/development-plan.md"
                echo ""
            fi
            
            if [ -f "$guidance_dir/qa-assessment.md" ]; then
                echo "### QA Assessment"
                echo ""
                cat "$guidance_dir/qa-assessment.md"
                echo ""
            fi
            
            if [ -f "$guidance_dir/security-review.md" ]; then
                echo "### Security Review"
                echo ""
                cat "$guidance_dir/security-review.md"
                echo ""
            fi
            
            if [ -f "$guidance_dir/devops-considerations.md" ]; then
                echo "### DevOps Considerations"
                echo ""
                cat "$guidance_dir/devops-considerations.md"
                echo ""
            fi
            
        } >> "$claude_file"
        
        log_info "Updated Claude context with persona guidance"
    fi
}