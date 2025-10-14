# --- PERSONA KIT PREREQUISITES CHECK ---
# Validates that all required tools are available before starting persona sessions

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

function Test-Git {
    try {
        $gitVersion = git --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Log-Info "Git found: $gitVersion"
            return $true
        } else {
            Log-Error "git is not installed or not in PATH"
            Log-Info "Please install git from https://git-scm.com/"
            return $false
        }
    } catch {
        Log-Error "git is not installed or not in PATH"
        Log-Info "Please install git from https://git-scm.com/"
        return $false
    }
}

function Test-Python {
    try {
        $pythonVersion = python --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            # Extract version numbers
            if ($pythonVersion -match 'Python (\d+)\.(\d+)\.(\d+)') {
                $major = [int]$matches[1]
                $minor = [int]$matches[2]
                
                Log-Info "Python $pythonVersion found"
                
                if ($major -gt 3 -or ($major -eq 3 -and $minor -ge 11)) {
                    return $true
                } else {
                    Log-Error "Python 3.11 or higher is required, but found $major.$minor"
                    return $false
                }
            } else {
                Log-Error "Could not parse Python version: $pythonVersion"
                return $false
            }
        } else {
            Log-Error "python is not installed or not in PATH"
            Log-Info "Please install Python 3.11 or higher from https://www.python.org/"
            return $false
        }
    } catch {
        Log-Error "python is not installed or not in PATH"
        Log-Info "Please install Python 3.11 or higher from https://www.python.org/"
        return $false
    }
}

function Test-ProjectStructure {
    $personakitRoot = Get-PersonaKitRoot
    if (-not $personakitRoot) {
        Log-Error "Not in a Persona Kit project directory (no .personakit folder found)"
        Log-Info "Run 'personakit init' to create a new Persona Kit project"
        return $false
    }
    
    Log-Info "Persona Kit project found at: $personakitRoot"
    
    # Check required directories
    $requiredDirs = @(
        (Join-Path $personakitRoot ".personakit" "memory"),
        (Join-Path $personakitRoot ".personakit" "templates"),
        (Join-Path $personakitRoot "personas")
    )
    
    $allGood = $true
    
    foreach ($dir in $requiredDirs) {
        if (-not (Test-Path $dir -PathType Container)) {
            Log-Error "Missing required directory: $dir"
            $allGood = $false
        } else {
            Log-Debug "Found required directory: $dir"
        }
    }
    
    # Check required files
    $requiredFiles = @(
        (Join-Path $personakitRoot ".personakit" "memory" "constitution.md"),
        (Join-Path $personakitRoot ".personakit" "memory" "personas.md")
    )
    
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path $file -PathType Leaf)) {
            Log-Warn "Missing recommended file: $file"
        } else {
            Log-Debug "Found recommended file: $file"
        }
    }
    
    return $allGood
}

function Test-AITools {
    Log-Info "Checking for AI assistant tools..."
    
    # Check for common AI tools
    $tools = @("claude", "gemini", "code", "cursor", "qwen", "opencode", "codex", "windsurf", "kilocode", "auggie", "codebuddy")
    $foundTools = @()
    
    foreach ($tool in $tools) {
        try {
            $result = & $tool --version 2>$null
            if ($LASTEXITCODE -eq 0) {
                $foundTools += $tool
                Log-Info "Found AI tool: $tool"
            } else {
                Log-Debug "AI tool not found: $tool"
            }
        } catch {
            Log-Debug "AI tool not found: $tool"
        }
    }
    
    if ($foundTools.Count -eq 0) {
        Log-Warn "No AI assistant tools found. This is OK if you're using an IDE-based assistant."
    } else {
        Log-Info "Found $($foundTools.Count) AI assistant tools: $($foundTools -join ', ')"
    }
    
    return $true
}

function Main {
    Log-Info "Checking prerequisites for Persona Kit..."
    
    $errors = 0
    
    Log-Info "1. Checking git..."
    if (-not (Test-Git)) {
        $errors++
    }
    
    Log-Info "2. Checking Python..."
    if (-not (Test-Python)) {
        $errors++
    }
    
    Log-Info "3. Checking project structure..."
    if (-not (Test-ProjectStructure)) {
        $errors++
    }
    
    Log-Info "4. Checking AI tools..."
    Test-AITools  # This is non-fatal
    
    if ($errors -gt 0) {
        Log-Error "Found $errors error(s) in prerequisites"
        exit 1
    } else {
        Log-Info "All prerequisites check passed!"
        exit 0
    }
}

Main