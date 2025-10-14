#!/bin/bash

# --- PERSONA KIT PREREQUISITES CHECK ---
# Validates that all required tools are available before starting persona sessions

set -euo pipefail

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh" || { echo "Failed to source common.sh"; exit 1; }

check_git() {
    if ! command -v git &> /dev/null; then
        log_error "git is not installed or not in PATH"
        log_info "Please install git from https://git-scm.com/"
        return 1
    else
        log_info "git $(git --version) found"
        return 0
    fi
}

check_python() {
    if ! command -v python3 &> /dev/null; then
        log_error "python3 is not installed or not in PATH"
        log_info "Please install Python 3.11 or higher from https://www.python.org/"
        return 1
    else
        local python_version
        python_version=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")')
        log_info "Python $python_version found"
        
        # Check if version is at least 3.11
        local major_version
        major_version=$(python3 -c 'import sys; print(sys.version_info.major)')
        local minor_version
        minor_version=$(python3 -c 'import sys; print(sys.version_info.minor)')
        
        if [ "$major_version" -lt 3 ] || { [ "$major_version" -eq 3 ] && [ "$minor_version" -lt 11 ]; }; then
            log_error "Python 3.11 or higher is required, but found $major_version.$minor_version"
            return 1
        else
            return 0
        fi
    fi
}

check_project_structure() {
    local personakit_root
    personakit_root=$(get_personakit_root) || {
        log_error "Not in a Persona Kit project directory (no .personakit folder found)"
        log_info "Run 'personakit init' to create a new Persona Kit project"
        return 1
    }
    
    log_info "Persona Kit project found at: $personakit_root"
    
    # Check required directories
    local required_dirs=(".personakit/memory" ".personakit/templates" "personas")
    local all_good=true
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$personakit_root/$dir" ]; then
            log_error "Missing required directory: $personakit_root/$dir"
            all_good=false
        else
            log_debug "Found required directory: $personakit_root/$dir"
        fi
    done
    
    if [ "$all_good" = false ]; then
        return 1
    fi
    
    # Check required files
    local required_files=(".personakit/memory/constitution.md" ".personakit/memory/personas.md")
    for file in "${required_files[@]}"; do
        if [ ! -f "$personakit_root/$file" ]; then
            log_warn "Missing recommended file: $personakit_root/$file"
        else
            log_debug "Found recommended file: $personakit_root/$file"
        fi
    done
    
    return 0
}

check_ai_tools() {
    log_info "Checking for AI assistant tools..."
    
    # Check for common AI tools
    local tools=("claude" "gemini" "code" "cursor" "qwen" "opencode" "codex" "windsurf" "kilocode" "auggie" "codebuddy")
    local found_tools=()
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            found_tools+=("$tool")
            log_info "Found AI tool: $tool"
        else
            log_debug "AI tool not found: $tool"
        fi
    done
    
    if [ ${#found_tools[@]} -eq 0 ]; then
        log_warn "No AI assistant tools found. This is OK if you're using an IDE-based assistant."
    else
        log_info "Found ${#found_tools[@]} AI assistant tools: ${found_tools[*]}"
    fi
}

main() {
    log_info "Checking prerequisites for Persona Kit..."
    
    local errors=0
    
    log_info "1. Checking git..."
    if ! check_git; then
        ((errors++))
    fi
    
    log_info "2. Checking Python..."
    if ! check_python; then
        ((errors++))
    fi
    
    log_info "3. Checking project structure..."
    if ! check_project_structure; then
        ((errors++))
    fi
    
    log_info "4. Checking AI tools..."
    check_ai_tools  # This is non-fatal
    
    if [ $errors -gt 0 ]; then
        log_error "Found $errors error(s) in prerequisites"
        exit 1
    else
        log_info "All prerequisites check passed!"
        exit 0
    fi
}

main "$@"