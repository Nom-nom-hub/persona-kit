# --- PERSONA KIT SETUP PERSONA ENVIRONMENT ---
# Sets up the persona environment and initializes necessary files/directories

param(
    [switch]$DebugMode = $false
)

# Enable strict mode
Set-StrictMode -Version Latest

# Set debug mode based on parameter
$global:PERSONAKIT_DEBUG = if ($DebugMode) { 1 } else { 0 }

# Dot-source common functions
$scriptDir = Split-Path $PSScriptRoot -Parent
$commonScript = Join-Path $scriptDir "powershell" "common.ps1"
if (Test-Path $commonScript -PathType Leaf) {
    . $commonScript
} else {
    Write-Host "Error: Could not find common.ps1 at path $commonScript" -ForegroundColor Red
    exit 1
}

function Setup-PersonasMemory {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Not in a Persona Kit project directory (no .personakit folder found)"
        return $false
    }
    
    $memoryDir = Join-Path $personakitRoot ".personakit" "memory"
    Ensure-Directory -Dir $memoryDir
    
    # Create or update personas definition file
    $personasFile = Join-Path $memoryDir "personas.md"
    if (-not (Test-Path $personasFile -PathType Leaf)) {
        Log-Info "Creating personas definition file: $personasFile"
        
        $personasContent = @"
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
"@
        Set-Content -Path $personasFile -Value $personasContent -Encoding UTF8
    } else {
        Log-Info "Personas definition file already exists: $personasFile"
    }
    
    # Create or update persona templates
    $templatesDir = Join-Path $personakitRoot ".personakit" "templates"
    Ensure-Directory -Dir $templatesDir
    
    # Create guidance templates
    $guidanceDir = Join-Path $templatesDir "persona-guidance"
    Ensure-Directory -Dir $guidanceDir
    
    # Create general persona guidance template
    $guidanceTemplate = Join-Path $guidanceDir "guidance-template.md"
    if (-not (Test-Path $guidanceTemplate -PathType Leaf)) {
        Log-Info "Creating persona guidance template: $guidanceTemplate"
        
        $templateContent = @"
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
"@
        Set-Content -Path $guidanceTemplate -Value $templateContent -Encoding UTF8
    }
    
    Log-Info "Persona memory and templates initialized"
    return $true
}

function Setup-PersonasTracking {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Not in a Persona Kit project directory (no .personakit folder found)"
        return $false
    }
    
    # Create personas directory if it doesn't exist
    $personasDir = Join-Path $personakitRoot "personas"
    Ensure-Directory -Dir $personasDir
    
    Log-Info "Created personas tracking directory: $personasDir"
    return $true
}

function Setup-PersonasConfig {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Not in a Persona Kit project directory (no .personakit folder found)"
        return $false
    }
    
    # Create configuration file
    $configFile = Join-Path $personakitRoot ".personakit" "config.json"
    if (-not (Test-Path $configFile -PathType Leaf)) {
        Log-Info "Creating Persona Kit configuration: $configFile"
        
        $configContent = @{
            version = "1.0"
            personas = @{
                active = @(
                    "ceo",
                    "engineering-manager", 
                    "architect",
                    "developer",
                    "qa",
                    "security",
                    "devops"
                )
                default_sequence = @(
                    "ceo",
                    "engineering-manager",
                    "architect", 
                    "developer",
                    "qa",
                    "security",
                    "devops"
                )
            }
            guidance = @{
                max_length = 1000
                format = "markdown"
                sections = @(
                    "problem-understanding",
                    "recommendations", 
                    "justification",
                    "validation"
                )
            }
        } | ConvertTo-Json -Depth 3
        
        Set-Content -Path $configFile -Value $configContent -Encoding UTF8
    } else {
        Log-Info "Configuration file already exists: $configFile"
    }
    
    return $true
}

function Main {
    Log-Info "Setting up Persona Kit environment..."
    
    $setupSuccess = $true
    
    if (-not (Setup-PersonasMemory)) {
        $setupSuccess = $false
    }
    
    if (-not (Setup-PersonasTracking)) {
        $setupSuccess = $false
    }
    
    if (-not (Setup-PersonasConfig)) {
        $setupSuccess = $false
    }
    
    if ($setupSuccess) {
        Log-Info "Persona Kit environment setup complete!"
        Log-Info "You can now use persona commands like /personakit.personas"
        exit 0
    } else {
        Log-Error "Failed to complete Persona Kit environment setup"
        exit 1
    }
}

Main