#!/bin/bash

# --- PERSONA KIT SETUP PERSONA ENVIRONMENT ---
# Sets up the persona environment and initializes necessary files/directories

set -euo pipefail

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh" || { echo "Failed to source common.sh"; exit 1; }

setup_personas_memory() {
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Not in a Persona Kit project directory (no .personakit folder found)"
        return 1
    }
    
    local memory_dir="$personakit_root/.personakit/memory"
    ensure_directory "$memory_dir"
    
    # Create or update personas definition file
    local personas_file="$memory_dir/personas.md"
    if [ ! -f "$personas_file" ]; then
        log_info "Creating personas definition file: $personas_file"
        
        cat > "$personas_file" << EOF
# Persona Definitions

This document defines the personas available in this Persona Kit project.

## CEO Persona
- Focus: Strategic business guidance
- Expertise: Market positioning, feature prioritization, resource allocation
- Decision Style: High-level, ROI-focused

## Engineering Manager Persona
- Focus: Team dynamics and project management
- Expertise: Timeline management, technical debt, team workflow
- Decision Style: Balanced approach considering delivery and quality

## Architect Persona
- Focus: System design and scalability
- Expertise: Technology selection, architecture patterns, security
- Decision Style: Long-term thinking with system implications

## Developer Persona
- Focus: Implementation details and coding
- Expertise: Specific technologies, debugging, best practices
- Decision Style: Practical and implementation-focused

## QA Persona
- Focus: Quality assurance and testing
- Expertise: Testing strategies, quality metrics, bug prevention
- Decision Style: Risk-conscious with thorough validation

## Security Persona
- Focus: Security best practices and threat mitigation
- Expertise: Security implementations, vulnerability assessment
- Decision Style: Risk-averse with security-first approach

## DevOps Persona
- Focus: Deployment and operational excellence
- Expertise: Infrastructure, CI/CD, monitoring, observability
- Decision Style: Reliability-focused with operational awareness
EOF
    else
        log_info "Personas definition file already exists: $personas_file"
    fi
    
    # Create or update persona templates
    local templates_dir="$personakit_root/.personakit/templates"
    ensure_directory "$templates_dir"
    
    # Create guidance templates
    local guidance_dir="$templates_dir/persona-guidance"
    ensure_directory "$guidance_dir"
    
    # Create general persona guidance template
    local guidance_template="$guidance_dir/guidance-template.md"
    if [ ! -f "$guidance_template" ]; then
        log_info "Creating persona guidance template: $guidance_template"
        
        cat > "$guidance_template" << EOF
# Guidance Template

## Problem Understanding
- Context: 
- Requirements: 
- Goal: 

## Persona Analysis
- Key Considerations: 
- Potential Risks: 

## Recommendations
- Primary Recommendation: 
- Alternative Approaches: 
- Implementation Steps: 

## Justification
- Rationale: 
- Benefits: 
- Trade-offs: 

## Validation Points
- Success Criteria: 
- Quality Indicators: 
EOF
    fi
    
    log_info "Persona memory and templates initialized"
}

setup_personas_tracking() {
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Not in a Persona Kit project directory (no .personakit folder found)"
        return 1
    }
    
    # Create personas directory if it doesn't exist
    local personas_dir="$personakit_root/personas"
    ensure_directory "$personas_dir"
    
    log_info "Created personas tracking directory: $personas_dir"
}

setup_personas_config() {
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Not in a Persona Kit project directory (no .personakit folder found)"
        return 1
    }
    
    # Create configuration file
    local config_file="$personakit_root/.personakit/config.json"
    if [ ! -f "$config_file" ]; then
        log_info "Creating Persona Kit configuration: $config_file"
        
        cat > "$config_file" << EOF
{
  "version": "1.0",
  "personas": {
    "active": [
      "ceo",
      "engineering-manager", 
      "architect",
      "developer",
      "qa",
      "security",
      "devops"
    ],
    "default_sequence": [
      "ceo",
      "engineering-manager",
      "architect", 
      "developer",
      "qa",
      "security",
      "devops"
    ]
  },
  "guidance": {
    "max_length": 1000,
    "format": "markdown",
    "sections": [
      "problem-understanding",
      "recommendations", 
      "justification",
      "validation"
    ]
  }
}
EOF
    else
        log_info "Configuration file already exists: $config_file"
    fi
}

main() {
    log_info "Setting up Persona Kit environment..."
    
    setup_personas_memory
    setup_personas_tracking
    setup_personas_config
    
    log_info "Persona Kit environment setup complete!"
    log_info "You can now use persona commands like /personakit.personas"
}

main "$@"