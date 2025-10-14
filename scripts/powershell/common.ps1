# Common functions and variables for persona-kit PowerShell scripts

# Get repository root, with fallback for non-git repositories
function Get-RepoRoot {
    try {
        # Try git first
        $gitRoot = git rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $gitRoot
        }
    }
    catch {
        # Git not available or not in git repo
    }

    # Fall back to script location for non-git repos
    $scriptDir = Split-Path -Parent $PSCommandPath
    $repoRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
    return $repoRoot
}

# Get current branch, with fallback for non-git repositories
function Get-CurrentBranch {
    # First check if PERSONA_FEATURE environment variable is set
    $personaFeature = $env:PERSONA_FEATURE
    if ($personaFeature) {
        return $personaFeature
    }

    try {
        # Then check git if available
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $branch
        }
    }
    catch {
        # Git not available
    }

    # For non-git repos, try to find the latest feature directory
    $repoRoot = Get-RepoRoot
    $featuresDir = Join-Path $repoRoot ".features"

    if (Test-Path $featuresDir) {
        $latestFeature = ""
        $highest = 0

        Get-ChildItem $featuresDir -Directory | ForEach-Object {
            $dirName = $_.Name
            if ($dirName -match '^(\d{3})-') {
                $number = [int]$matches[1]
                if ($number -gt $highest) {
                    $highest = $number
                    $latestFeature = $dirName
                }
            }
        }

        if ($latestFeature) {
            return $latestFeature
        }
    }

    return "main"  # Final fallback
}

# Check if we have git available
function Test-Git {
    try {
        git rev-parse --show-toplevel 2>$null | Out-Null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

function Test-FeatureBranch {
    param(
        [string]$Branch,
        [bool]$HasGitRepo
    )

    # For non-git repos, we can't enforce branch naming but still provide output
    if (-not $HasGitRepo) {
        Write-Host "[persona-kit] Warning: Git repository not detected; skipped branch validation" -ForegroundColor Yellow
        return $true
    }

    if ($Branch -notmatch '^\d{3}-') {
        Write-Host "ERROR: Not on a feature branch. Current branch: $Branch" -ForegroundColor Red
        Write-Host "Feature branches should be named like: 001-feature-name" -ForegroundColor Red
        return $false
    }

    return $true
}

function Get-FeatureDir {
    param([string]$RepoRoot, [string]$Branch)
    return Join-Path $RepoRoot ".features" $Branch
}

function Get-FeaturePaths {
    $repoRoot = Get-RepoRoot
    $currentBranch = Get-CurrentBranch
    $hasGitRepo = Test-Git

    $featureDir = Get-FeatureDir $repoRoot $currentBranch
    $personaKitDir = Join-Path $repoRoot "persona-kit"

    return @{
        REPO_ROOT = $repoRoot
        CURRENT_BRANCH = $currentBranch
        HAS_GIT = $hasGitRepo
        FEATURE_DIR = $featureDir
        PERSONA_KIT_DIR = $personaKitDir
        PERSONAS_DIR = Join-Path $personaKitDir "personas"
        PATTERNS_DIR = Join-Path $personaKitDir "patterns"
        WORKFLOWS_DIR = Join-Path $personaKitDir "workflows"
        FEATURE_SPEC = Join-Path $featureDir "spec.md"
        IMPL_PLAN = Join-Path $featureDir "plan.md"
        TASKS = Join-Path $featureDir "tasks.md"
        RESEARCH = Join-Path $featureDir "research.md"
        DATA_MODEL = Join-Path $featureDir "data-model.md"
        QUICKSTART = Join-Path $featureDir "quickstart.md"
        CONTRACTS_DIR = Join-Path $featureDir "contracts"
    }
}

# Check if file exists and is not empty
function Test-File {
    param([string]$Path, [string]$Description)
    if (Test-Path $Path) {
        Write-Host "  ✓ $Description" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $Description" -ForegroundColor Red
    }
}

# Check if directory exists and is not empty
function Test-Directory {
    param([string]$Path, [string]$Description)
    if (Test-Path $Path) {
        $items = Get-ChildItem $Path -ErrorAction SilentlyContinue
        if ($items.Count -gt 0) {
            Write-Host "  ✓ $Description" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $Description" -ForegroundColor Red
        }
    } else {
        Write-Host "  ✗ $Description" -ForegroundColor Red
    }
}

# Get available personas from the personas directory
function Get-AvailablePersonas {
    param([string]$PersonaKitDir)

    $personasDir = Join-Path $PersonaKitDir "personas"
    $personas = @()

    if (Test-Path $personasDir) {
        Get-ChildItem $personasDir -Directory | ForEach-Object {
            $personaDir = $_.FullName
            $personaFile = Join-Path $personaDir "persona.md"
            if (Test-Path $personaFile) {
                $personas += $_.Name
            }
        }
    }

    return $personas
}

# Get available patterns from the patterns directory
function Get-AvailablePatterns {
    param([string]$PersonaKitDir)

    $patternsDir = Join-Path $PersonaKitDir "patterns"
    $patterns = @()

    if (Test-Path $patternsDir) {
        Get-ChildItem $patternsDir -Directory | ForEach-Object {
            $patterns += $_.Name
        }
    }

    return $patterns
}

# Get available workflows from the workflows directory
function Get-AvailableWorkflows {
    param([string]$PersonaKitDir)

    $workflowsDir = Join-Path $PersonaKitDir "workflows"
    $workflows = @()

    if (Test-Path $workflowsDir) {
        Get-ChildItem $workflowsDir -Directory | ForEach-Object {
            $workflowDir = $_.FullName
            $workflowFile = Join-Path $workflowDir "workflow.md"
            if (Test-Path $workflowFile) {
                $workflows += $_.Name
            }
        }
    }

    return $workflows
}

# Validate that required persona-kit structure exists
function Test-PersonaKitStructure {
    param([string]$RepoRoot)

    $requiredDirs = @(
        (Join-Path $RepoRoot "persona-kit"),
        (Join-Path $RepoRoot "persona-kit/personas"),
        (Join-Path $RepoRoot "persona-kit/patterns"),
        (Join-Path $RepoRoot "persona-kit/workflows")
    )

    foreach ($dir in $requiredDirs) {
        if (-not (Test-Path $dir)) {
            Write-Host "ERROR: Required directory not found: $dir" -ForegroundColor Red
            return $false
        }
    }

    return $true
}

# Create feature directory structure
function New-FeatureStructure {
    param([string]$FeatureDir)

    New-Item -ItemType Directory -Force -Path $FeatureDir | Out-Null

    # Create standard feature files
    New-Item -ItemType File -Force -Path (Join-Path $FeatureDir "spec.md") | Out-Null
    New-Item -ItemType File -Force -Path (Join-Path $FeatureDir "plan.md") | Out-Null
    New-Item -ItemType File -Force -Path (Join-Path $FeatureDir "tasks.md") | Out-Null
    New-Item -ItemType File -Force -Path (Join-Path $FeatureDir "research.md") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $FeatureDir "contracts") | Out-Null
}

# Copy persona files to feature directory
function Copy-PersonaFiles {
    param(
        [string]$FeatureDir,
        [string]$PersonasDir,
        [string[]]$SelectedPersonas
    )

    foreach ($persona in $SelectedPersonas) {
        $personaSource = Join-Path $PersonasDir "$persona/persona.md"
        $personaDest = Join-Path $FeatureDir "personas/$persona.md"

        if (Test-Path $personaSource) {
            New-Item -ItemType Directory -Force -Path (Split-Path $personaDest) | Out-Null
            Copy-Item $personaSource $personaDest -Force
            Write-Host "  ✓ Copied $persona persona" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ Persona $persona not found at $personaSource" -ForegroundColor Yellow
        }
    }
}

# Copy pattern files to feature directory
function Copy-PatternFiles {
    param(
        [string]$FeatureDir,
        [string]$PatternsDir,
        [string[]]$SelectedPatterns
    )

    foreach ($pattern in $SelectedPatterns) {
        # Find pattern files in the pattern directory
        $patternPath = Join-Path $PatternsDir $pattern
        if (Test-Path $patternPath) {
            Get-ChildItem $patternPath -File | ForEach-Object {
                $patternName = $_.BaseName
                $patternDest = Join-Path $FeatureDir "patterns/$pattern/$patternName.md"

                New-Item -ItemType Directory -Force -Path (Split-Path $patternDest) | Out-Null
                Copy-Item $_.FullName $patternDest -Force
                Write-Host "  ✓ Copied $pattern/$patternName pattern" -ForegroundColor Green
            }
        }
    }
}

# Copy workflow files to feature directory
function Copy-WorkflowFiles {
    param(
        [string]$FeatureDir,
        [string]$WorkflowsDir,
        [string[]]$SelectedWorkflows
    )

    foreach ($workflow in $SelectedWorkflows) {
        $workflowSource = Join-Path $WorkflowsDir "$workflow/workflow.md"
        $workflowDest = Join-Path $FeatureDir "workflows/$workflow.md"

        if (Test-Path $workflowSource) {
            New-Item -ItemType Directory -Force -Path (Split-Path $workflowDest) | Out-Null
            Copy-Item $workflowSource $workflowDest -Force
            Write-Host "  ✓ Copied $workflow workflow" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ Workflow $workflow not found at $workflowSource" -ForegroundColor Yellow
        }
    }
}

# Generate feature summary
function New-FeatureSummary {
    param(
        [string]$FeatureDir,
        [string]$Branch
    )

    $readmePath = Join-Path $FeatureDir "README.md"
    $currentDate = Get-Date -Format "yyyy-MM-dd"

    $content = @"
# Feature: $Branch

This directory contains all persona-kit artifacts for feature development.

## Structure

- `spec.md` - Feature specification and requirements
- `plan.md` - Implementation plan and technical details
- `tasks.md` - Development tasks and checklist
- `research.md` - Research notes and references
- `personas/` - Persona definitions for this feature
- `patterns/` - Relevant patterns for this feature
- `workflows/` - Applicable workflows for this feature
- `contracts/` - API contracts and data models

## Getting Started

1. Review the feature specification in `spec.md`
2. Check the implementation plan in `plan.md`
3. Follow the tasks in `tasks.md`
4. Use the provided personas, patterns, and workflows as needed

## Branch Information

- **Branch**: `$Branch`
- **Created**: `$currentDate`
- **Status**: Active development

"@

    $content | Out-File -FilePath $readmePath -Encoding UTF8
}