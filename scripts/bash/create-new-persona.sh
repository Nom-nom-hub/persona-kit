#!/bin/bash

# --- PERSONA KIT CREATE NEW PERSONA SESSION ---
# Creates a new persona guidance session structure for a specific feature/branch

set -euo pipefail

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh" || { echo "Failed to source common.sh"; exit 1; }

create_persona_session() {
    local feature_name="${1:-}"
    
    if [ -z "$feature_name" ]; then
        log_error "Feature name is required"
        log_info "Usage: $0 <feature-name>"
        return 1
    fi
    
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Not in a Persona Kit project directory (no .personakit folder found)"
        return 1
    }
    
    local session_dir="$personakit_root/personas/$feature_name"
    
    if [ -d "$session_dir" ]; then
        log_warn "Persona session directory already exists: $session_dir"
        read -p "Do you want to continue and potentially overwrite existing files? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Operation cancelled"
            return 0
        fi
    fi
    
    ensure_directory "$session_dir"
    
    log_info "Creating persona guidance files for feature: $feature_name"
    
    # Create persona guidance files with initial content
    cat > "$session_dir/ceo-perspective.md" << EOF
# CEO Perspective for $feature_name

## Business Value Assessment
- 

## Strategic Priorities
- 

## Market Considerations
- 

## Resource Allocation
- 

## Risk Assessment
- 
EOF

    cat > "$session_dir/engineering-perspective.md" << EOF
# Engineering Manager Perspective for $feature_name

## Team Considerations
- 

## Timeline Impact
- 

## Technical Debt Assessment
- 

## Risk Management
- 

## Resource Requirements
- 
EOF

    cat > "$session_dir/architecture-notes.md" << EOF
# Architecture Notes for $feature_name

## System Design
- 

## Technology Decisions
- 

## Scalability Considerations
- 

## Security Implications
- 

## Integration Points
- 
EOF

    cat > "$session_dir/development-plan.md" << EOF
# Development Plan for $feature_name

## Implementation Approach
- 

## Code Structure
- 

## Dependencies
- 

## Testing Strategy
- 

## Performance Considerations
- 
EOF

    cat > "$session_dir/qa-assessment.md" << EOF
# QA Assessment for $feature_name

## Testing Strategy
- 

## Quality Standards
- 

## Risk Areas
- 

## Test Cases
- 

## Success Criteria
- 
EOF

    cat > "$session_dir/security-review.md" << EOF
# Security Review for $feature_name

## Security Considerations
- 

## Vulnerability Assessment
- 

## Best Practices
- 

## Compliance Requirements
- 

## Mitigation Strategies
- 
EOF

    cat > "$session_dir/devops-considerations.md" << EOF
# DevOps Considerations for $feature_name

## Deployment Strategy
- 

## Infrastructure Needs
- 

## Monitoring Requirements
- 

## CI/CD Pipeline
- 

## Operational Impact
- 
EOF

    cat > "$session_dir/multi-perspective-summary.md" << EOF
# Multi-Perspective Summary for $feature_name

## Key Recommendations
- 

## Consensus Areas
- 

## Conflicting Views
- 

## Implementation Priority
- 

## Success Metrics
- 
EOF

    log_info "Created persona session structure in: $session_dir"
    log_info "You can now fill in the guidance files with persona-specific insights"
}

main() {
    if [ $# -eq 0 ]; then
        log_error "Feature name is required"
        log_info "Usage: $0 <feature-name>"
        log_info "Example: $0 user-authentication"
        exit 1
    fi
    
    create_persona_session "$1"
}

main "$@"