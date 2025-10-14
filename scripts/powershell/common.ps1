# --- PERSONA KIT POWERSHELL SCRIPTS COMMON FUNCTIONS ---
# This file contains common utility functions for Persona Kit PowerShell scripts
# All other PowerShell scripts in the Persona Kit system dot-source this file

# Enable strict mode
Set-StrictMode -Version Latest

# --- DEFAULT VALUES ---
# Default values for configuration, may be overridden by environment variables
if (-not (Test-Path variable:global:PERSONAKIT_DEBUG)) { $global:PERSONAKIT_DEBUG = 0 }
if (-not (Test-Path variable:global:PERSONAKIT_FEATURE)) { $global:PERSONAKIT_FEATURE = "" }

# --- LOGGING FUNCTIONS ---
function Log-Debug {
    param([string]$Message)
    if ($global:PERSONAKIT_DEBUG -ge 1) {
        Write-Host "[DEBUG] $Message" -ForegroundColor Gray
    }
}

function Log-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Log-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Log-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# --- VALIDATION FUNCTIONS ---
function Test-GitRepo {
    try {
        $null = git rev-parse --git-dir 2>$null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Get-GitRoot {
    try {
        return (git rev-parse --show-toplevel 2>$null)
    } catch {
        return $null
    }
}

# --- PERSONA KIT SPECIFIC FUNCTIONS ---
function Get-PersonaKitRoot {
    param(
        [string]$CurrentDir = $(Get-Location)
    )
    
    $searchDir = $CurrentDir
    $rootDir = [System.IO.Path]::GetPathRoot($searchDir)
    
    while ($searchDir -ne $rootDir) {
        $personakitDir = Join-Path $searchDir ".personakit"
        if (Test-Path $personakitDir -PathType Container) {
            return $searchDir
        }
        
        $parentDir = Split-Path $searchDir -Parent
        if ($parentDir -eq $searchDir) { 
            # We've reached the root
            break
        }
        $searchDir = $parentDir
    }
    
    return $null
}

function Get-ActiveFeature {
    # If PERSONAKIT_FEATURE is set, use it
    if ($global:PERSONAKIT_FEATURE -and $global:PERSONAKIT_FEATURE -ne "") {
        return $global:PERSONAKIT_FEATURE
    }
    
    # Otherwise, get from git branch name
    if (Test-GitRepo) {
        try {
            $branchName = git branch --show-current 2>$null
            if ($branchName -and $branchName -ne "") {
                return $branchName
            }
        } catch {
            # Git command failed, continue
        }
    }
    
    Log-Error "Could not determine active feature. Either set PERSONAKIT_FEATURE environment variable or use git branches."
    return $null
}

# --- DIRECTORY MANAGEMENT ---
function Ensure-Directory {
    param([string]$Dir)
    
    if (-not (Test-Path $Dir -PathType Container)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        Log-Info "Created directory: $Dir"
    }
}

# --- FILE MANAGEMENT ---
function Ensure-File {
    param(
        [string]$File,
        [string]$TemplateDir = ""
    )
    
    if (-not (Test-Path $File -PathType Leaf)) {
        $fileDir = Split-Path $File -Parent
        Ensure-Directory -Dir $fileDir
        
        if ($TemplateDir -and (Test-Path (Join-Path $TemplateDir (Split-Path $File -Leaf)) -PathType Leaf)) {
            $templateFile = Join-Path $TemplateDir (Split-Path $File -Leaf)
            Copy-Item -Path $templateFile -Destination $File
            Log-Info "Created file from template: $File"
        } else {
            # Create an empty file
            '' | Out-File -FilePath $File -Encoding UTF8
            Log-Info "Created empty file: $File"
        }
    }
}

# --- PERSONA SPECIFIC FUNCTIONS ---
function Get-PersonaGuidanceDir {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Could not find .personakit directory"
        return $null
    }
    
    $feature = Get-ActiveFeature
    if (-not $feature) {
        return $null
    }
    
    return Join-Path $personakitRoot "personas" $feature
}

function Ensure-PersonaGuidanceStructure {
    $guidanceDir = Get-PersonaGuidanceDir
    if (-not $guidanceDir) {
        return $false
    }
    
    Ensure-Directory -Dir $guidanceDir
    
    # Create standard persona guidance files
    $guidanceFiles = @(
        "ceo-perspective.md",
        "engineering-perspective.md",
        "architecture-notes.md",
        "development-plan.md",
        "qa-assessment.md",
        "security-review.md",
        "devops-considerations.md",
        "multi-perspective-summary.md"
    )
    
    foreach ($file in $guidanceFiles) {
        $filePath = Join-Path $guidanceDir $file
        Ensure-File -File $filePath
    }
    
    return $true
}

# --- PATH RESOLUTION ---
function Get-PersonaKitTemplatesDir {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        return $null
    }
    
    return Join-Path $personakitRoot ".personakit" "templates"
}

function Get-PersonaKitScriptsDir {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        return $null
    }
    
    return Join-Path $personakitRoot ".personakit" "scripts"
}

function Get-PersonaKitMemoryDir {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        return $null
    }
    
    return Join-Path $personakitRoot ".personakit" "memory"
}

# --- UTILITY FUNCTIONS ---
function Update-ClaudeContext {
    param([string]$ClaudeFile = "")
    
    if ($ClaudeFile -and (Test-Path $ClaudeFile -PathType Leaf)) {
        Log-Info "Updating Claude context file: $ClaudeFile"
        
        # Add current persona guidance to Claude context
        $guidanceDir = Get-PersonaGuidanceDir
        if (-not $guidanceDir) {
            return $false
        }
        
        $contentToAdd = @()
        $contentToAdd += "## PERSONA GUIDANCE"
        $contentToAdd += ""
        $contentToAdd += "Current feature: $(Get-ActiveFeature)"
        $contentToAdd += ""
        
        # Add CEO perspective if available
        $ceoFile = Join-Path $guidanceDir "ceo-perspective.md"
        if (Test-Path $ceoFile -PathType Leaf) {
            $contentToAdd += "### CEO Perspective"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $ceoFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add Engineering perspective if available
        $engFile = Join-Path $guidanceDir "engineering-perspective.md"
        if (Test-Path $engFile -PathType Leaf) {
            $contentToAdd += "### Engineering Perspective"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $engFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add Architecture notes if available
        $archFile = Join-Path $guidanceDir "architecture-notes.md"
        if (Test-Path $archFile -PathType Leaf) {
            $contentToAdd += "### Architecture Notes"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $archFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add Development plan if available
        $devFile = Join-Path $guidanceDir "development-plan.md"
        if (Test-Path $devFile -PathType Leaf) {
            $contentToAdd += "### Development Plan"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $devFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add QA assessment if available
        $qaFile = Join-Path $guidanceDir "qa-assessment.md"
        if (Test-Path $qaFile -PathType Leaf) {
            $contentToAdd += "### QA Assessment"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $qaFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add Security review if available
        $secFile = Join-Path $guidanceDir "security-review.md"
        if (Test-Path $secFile -PathType Leaf) {
            $contentToAdd += "### Security Review"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $secFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add DevOps considerations if available
        $devopsFile = Join-Path $guidanceDir "devops-considerations.md"
        if (Test-Path $devopsFile -PathType Leaf) {
            $contentToAdd += "### DevOps Considerations"
            $contentToAdd += ""
            $contentToAdd += (Get-Content $devopsFile -Raw) -split "`n"
            $contentToAdd += ""
        }
        
        # Add to the Claude file
        $contentToAdd | Out-File -FilePath $ClaudeFile -Append -Encoding UTF8
        
        Log-Info "Updated Claude context with persona guidance"
        return $true
    }
    
    return $false
}