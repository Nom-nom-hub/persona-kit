# --- PERSONA KIT CREATE NEW PERSONA SESSION ---
# Creates a new persona guidance session structure for a specific feature/branch

param(
    [Parameter(Mandatory=$true)]
    [string]$FeatureName,
    
    [switch]$Force = $false
)

# Enable strict mode
Set-StrictMode -Version Latest

# Dot-source common functions
$scriptDir = Split-Path $PSScriptRoot -Parent
$commonScript = Join-Path $scriptDir "powershell" "common.ps1"
if (Test-Path $commonScript -PathType Leaf) {
    . $commonScript
} else {
    Write-Host "Error: Could not find common.ps1 at path $commonScript" -ForegroundColor Red
    exit 1
}

function New-PersonaSession {
    param(
        [string]$FeatureName,
        [bool]$Force = $false
    )
    
    if ([string]::IsNullOrEmpty($FeatureName)) {
        Log-Error "Feature name is required"
        Log-Info "Usage: $PSCommandPath -FeatureName <feature-name>"
        return $false
    }
    
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Not in a Persona Kit project directory (no .personakit folder found)"
        return $false
    }
    
    $sessionDir = Join-Path $personakitRoot "personas" $FeatureName
    
    if (Test-Path $sessionDir -PathType Container) {
        Log-Warn "Persona session directory already exists: $sessionDir"
        if (-not $Force) {
            $response = Read-Host "Do you want to continue and potentially overwrite existing files? (y/N)"
            if ($response -notmatch '^[Yy]$') {
                Log-Info "Operation cancelled"
                return $true
            }
        }
    }
    
    Ensure-Directory -Dir $sessionDir
    
    Log-Info "Creating persona guidance files for feature: $FeatureName"
    
    # Create persona guidance files with initial content
    $ceoContent = @"
# CEO Perspective for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "ceo-perspective.md") -Value $ceoContent -Encoding UTF8


    $engContent = @"
# Engineering Manager Perspective for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "engineering-perspective.md") -Value $engContent -Encoding UTF8


    $archContent = @"
# Architecture Notes for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "architecture-notes.md") -Value $archContent -Encoding UTF8


    $devContent = @"
# Development Plan for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "development-plan.md") -Value $devContent -Encoding UTF8


    $qaContent = @"
# QA Assessment for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "qa-assessment.md") -Value $qaContent -Encoding UTF8


    $secContent = @"
# Security Review for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "security-review.md") -Value $secContent -Encoding UTF8


    $devopsContent = @"
# DevOps Considerations for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "devops-considerations.md") -Value $devopsContent -Encoding UTF8


    $summaryContent = @"
# Multi-Perspective Summary for $FeatureName

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
"@
    Set-Content -Path (Join-Path $sessionDir "multi-perspective-summary.md") -Value $summaryContent -Encoding UTF8


    Log-Info "Created persona session structure in: $sessionDir"
    Log-Info "You can now fill in the guidance files with persona-specific insights"
    
    return $true
}

function Main {
    if ([string]::IsNullOrEmpty($FeatureName)) {
        Log-Error "Feature name is required"
        Log-Info "Usage: $PSCommandPath -FeatureName <feature-name>"
        Log-Info "Example: $PSCommandPath -FeatureName user-authentication"
        exit 1
    }
    
    if (New-PersonaSession -FeatureName $FeatureName -Force $Force) {
        exit 0
    } else {
        exit 1
    }
}

Main