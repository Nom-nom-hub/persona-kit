#!/bin/bash

# --- PERSONA KIT UPDATE AGENT CONTEXT ---
# Updates the AI agent context with the latest persona guidance and project information

set -euo pipefail

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh" || { echo "Failed to source common.sh"; exit 1; }

update_agent_context() {
    local agent_file="${1:-}"
    
    if [ -z "$agent_file" ]; then
        log_error "Agent file path is required"
        log_info "Usage: $0 <agent-file-path>"
        return 1
    fi
    
    if [ ! -f "$agent_file" ]; then
        log_error "Agent file does not exist: $agent_file"
        return 1
    fi
    
    log_info "Updating agent context file: $agent_file"
    
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Not in a Persona Kit project directory (no .personakit folder found)"
        return 1
    }
    
    # Get current feature
    local feature
    feature=$(get_active_feature) || {
        log_error "Could not determine active feature"
        return 1
    }
    
    # Get persona guidance directory
    local guidance_dir="$personakit_root/personas/$feature"
    
    # Create backup of current agent file
    local backup_file="${agent_file}.backup.$(date +%s)"
    cp "$agent_file" "$backup_file"
    log_info "Created backup: $backup_file"
    
    # Save the original content without persona guidance
    local original_content
    if grep -q "# PERSONA GUIDANCE" "$agent_file"; then
        # Extract content before persona guidance section
        original_content=$(awk '/# PERSONA GUIDANCE/{exit} {print}' "$agent_file")
    else
        # No persona guidance section found, use entire file
        original_content=$(cat "$agent_file")
    fi
    
    # Write the original content back to the file
    echo "$original_content" > "$agent_file"
    
    # Add persona guidance to the agent file
    {
        echo ""
        echo "## PERSONA GUIDANCE"
        echo "Current feature: $feature"
        echo "Generated on: $(date)"
        echo ""
        
        # Add CEO perspective if available
        if [ -f "$guidance_dir/ceo-perspective.md" ]; then
            echo "### CEO Perspective"
            echo ""
            cat "$guidance_dir/ceo-perspective.md"
            echo ""
        fi
        
        # Add Engineering Manager perspective if available
        if [ -f "$guidance_dir/engineering-perspective.md" ]; then
            echo "### Engineering Manager Perspective"
            echo ""
            cat "$guidance_dir/engineering-perspective.md"
            echo ""
        fi
        
        # Add Architecture notes if available
        if [ -f "$guidance_dir/architecture-notes.md" ]; then
            echo "### Architecture Notes"
            echo ""
            cat "$guidance_dir/architecture-notes.md"
            echo ""
        fi
        
        # Add Development plan if available
        if [ -f "$guidance_dir/development-plan.md" ]; then
            echo "### Development Plan"
            echo ""
            cat "$guidance_dir/development-plan.md"
            echo ""
        fi
        
        # Add QA assessment if available
        if [ -f "$guidance_dir/qa-assessment.md" ]; then
            echo "### QA Assessment"
            echo ""
            cat "$guidance_dir/qa-assessment.md"
            echo ""
        fi
        
        # Add Security review if available
        if [ -f "$guidance_dir/security-review.md" ]; then
            echo "### Security Review"
            echo ""
            cat "$guidance_dir/security-review.md"
            echo ""
        fi
        
        # Add DevOps considerations if available
        if [ -f "$guidance_dir/devops-considerations.md" ]; then
            echo "### DevOps Considerations"
            echo ""
            cat "$guidance_dir/devops-considerations.md"
            echo ""
        fi
        
        # Add Multi-perspective summary if available
        if [ -f "$guidance_dir/multi-perspective-summary.md" ]; then
            echo "### Multi-Perspective Summary"
            echo ""
            cat "$guidance_dir/multi-perspective-summary.md"
            echo ""
        fi
        
        # Add project constitution for context
        local constitution_file="$personakit_root/.personakit/memory/constitution.md"
        if [ -f "$constitution_file" ]; then
            echo "### Project Constitution"
            echo ""
            echo "Project principles and guidelines:"
            echo ""
            cat "$constitution_file"
            echo ""
        fi
        
        # Add current vision for context
        local vision_file="$personakit_root/.personakit/vision.md"
        if [ -f "$vision_file" ]; then
            echo "### Project Vision"
            echo ""
            echo "Project vision and success metrics:"
            echo ""
            head -20 "$vision_file"  # Just the first 20 lines to avoid overly long context
            echo ""
        fi
    } >> "$agent_file"
    
    log_info "Updated agent context with latest persona guidance"
    log_info "Feature: $feature"
    log_info "Agent file: $agent_file"
}

main() {
    if [ $# -eq 0 ]; then
        log_error "Agent file path is required"
        log_info "Usage: $0 <agent-file-path>"
        log_info "Example: $0 .claude/CLAUDE.md"
        exit 1
    fi
    
    update_agent_context "$1"
}

main "$@"