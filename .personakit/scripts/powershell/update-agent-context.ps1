# --- PERSONA KIT UPDATE AGENT CONTEXT ---
# Updates the AI agent context with the latest persona guidance and project information

param(
    [Parameter(Mandatory=$true)]
    [string]$AgentFile
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

function Update-AgentContext {
    param([string]$AgentFile)
    
    if ([string]::IsNullOrEmpty($AgentFile)) {
        Log-Error "Agent file path is required"
        Log-Info "Usage: $PSCommandPath -AgentFile <agent-file-path>"
        return $false
    }
    
    if (-not (Test-Path $AgentFile -PathType Leaf)) {
        Log-Error "Agent file does not exist: $AgentFile"
        return $false
    }
    
    Log-Info "Updating agent context file: $AgentFile"
    
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Not in a Persona Kit project directory (no .personakit folder found)"
        return $false
    }
    
    # Get current feature
    $feature = Get-ActiveFeature
    if (-not $feature) {
        Log-Error "Could not determine active feature"
        return $false
    }
    
    # Get persona guidance directory
    $guidanceDir = Join-Path $personakitRoot "personas" $feature
    
    # Create backup of current agent file
    $backupFile = "$AgentFile.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -Path $AgentFile -Destination $backupFile
    Log-Info "Created backup: $backupFile"
    
    # Read the original content without persona guidance
    $originalContent = @()
    $lines = Get-Content -Path $AgentFile -Encoding UTF8
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^## PERSONA GUIDANCE") {
            # Found the start of persona guidance, keep only content before this line
            $originalContent = $lines[0..($i-1)]
            break
        }
    }
    
    if ($originalContent.Count -eq 0) {
        # No persona guidance section found, use entire file
        $originalContent = $lines
    }
    
    # Write the original content back to the file
    $originalContent | Set-Content -Path $AgentFile -Encoding UTF8
    
    # Add persona guidance to the agent file
    $contentToAdd = @()
    $contentToAdd += ""
    $contentToAdd += "## PERSONA GUIDANCE"
    $contentToAdd += "Current feature: $feature"
    $contentToAdd += "Generated on: $(Get-Date)"
    $contentToAdd += ""
    
    # Add CEO perspective if available
    $ceoFile = Join-Path $guidanceDir "ceo-perspective.md"
    if (Test-Path $ceoFile -PathType Leaf) {
        $contentToAdd += "### CEO Perspective"
        $contentToAdd += ""
        $contentToAdd += Get-Content $ceoFile -Raw
        $contentToAdd += ""
    }
    
    # Add Engineering Manager perspective if available
    $engFile = Join-Path $guidanceDir "engineering-perspective.md"
    if (Test-Path $engFile -PathType Leaf) {
        $contentToAdd += "### Engineering Manager Perspective"
        $contentToAdd += ""
        $contentToAdd += Get-Content $engFile -Raw
        $contentToAdd += ""
    }
    
    # Add Architecture notes if available
    $archFile = Join-Path $guidanceDir "architecture-notes.md"
    if (Test-Path $archFile -PathType Leaf) {
        $contentToAdd += "### Architecture Notes"
        $contentToAdd += ""
        $contentToAdd += Get-Content $archFile -Raw
        $contentToAdd += ""
    }
    
    # Add Development plan if available
    $devFile = Join-Path $guidanceDir "development-plan.md"
    if (Test-Path $devFile -PathType Leaf) {
        $contentToAdd += "### Development Plan"
        $contentToAdd += ""
        $contentToAdd += Get-Content $devFile -Raw
        $contentToAdd += ""
    }
    
    # Add QA assessment if available
    $qaFile = Join-Path $guidanceDir "qa-assessment.md"
    if (Test-Path $qaFile -PathType Leaf) {
        $contentToAdd += "### QA Assessment"
        $contentToAdd += ""
        $contentToAdd += Get-Content $qaFile -Raw
        $contentToAdd += ""
    }
    
    # Add Security review if available
    $secFile = Join-Path $guidanceDir "security-review.md"
    if (Test-Path $secFile -PathType Leaf) {
        $contentToAdd += "### Security Review"
        $contentToAdd += ""
        $contentToAdd += Get-Content $secFile -Raw
        $contentToAdd += ""
    }
    
    # Add DevOps considerations if available
    $devopsFile = Join-Path $guidanceDir "devops-considerations.md"
    if (Test-Path $devopsFile -PathType Leaf) {
        $contentToAdd += "### DevOps Considerations"
        $contentToAdd += ""
        $contentToAdd += Get-Content $devopsFile -Raw
        $contentToAdd += ""
    }
    
    # Add Multi-perspective summary if available
    $summaryFile = Join-Path $guidanceDir "multi-perspective-summary.md"
    if (Test-Path $summaryFile -PathType Leaf) {
        $contentToAdd += "### Multi-Perspective Summary"
        $contentToAdd += ""
        $contentToAdd += Get-Content $summaryFile -Raw
        $contentToAdd += ""
    }
    
    # Add project constitution for context
    $constitutionFile = Join-Path $personakitRoot ".personakit" "memory" "constitution.md"
    if (Test-Path $constitutionFile -PathType Leaf) {
        $contentToAdd += "### Project Constitution"
        $contentToAdd += ""
        $contentToAdd += "Project principles and guidelines:"
        $contentToAdd += ""
        $contentToAdd += Get-Content $constitutionFile -Raw
        $contentToAdd += ""
    }
    
    # Add current vision for context
    $visionFile = Join-Path $personakitRoot ".personakit" "vision.md"
    if (Test-Path $visionFile -PathType Leaf) {
        $contentToAdd += "### Project Vision"
        $contentToAdd += ""
        $contentToAdd += "Project vision and success metrics:"
        $contentToAdd += ""
        # Just the first 20 lines to avoid overly long context
        $visionLines = Get-Content $visionFile
        $contentToAdd += $visionLines[0..([Math]::Min(19, $visionLines.Count - 1))]
        $contentToAdd += ""
    }
    
    # Add to the agent file
    $contentToAdd | Add-Content -Path $AgentFile -Encoding UTF8
    
    Log-Info "Updated agent context with latest persona guidance"
    Log-Info "Feature: $feature"
    Log-Info "Agent file: $AgentFile"
    
    return $true
}

function Main {
    if ([string]::IsNullOrEmpty($AgentFile)) {
        Log-Error "Agent file path is required"
        Log-Info "Usage: $PSCommandPath -AgentFile <agent-file-path>"
        Log-Info "Example: $PSCommandPath -AgentFile .claude/CLAUDE.md"
        exit 1
    }
    
    if (Update-AgentContext -AgentFile $AgentFile) {
        exit 0
    } else {
        exit 1
    }
}

Main