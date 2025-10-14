#!/usr/bin/env pwsh

param(
    [switch]$Json,
    [switch]$Help,
    [string]$Personas,
    [string]$Patterns,
    [string]$Workflows,
    [string]$FeatureDescription
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Json] [-Personas persona1,persona2] [-Patterns pattern1,pattern2] [-Workflows workflow1,workflow2] <feature_description>"
    exit 0
}

# Get feature description from remaining arguments
if (-not $FeatureDescription) {
    $FeatureDescription = $args -join " "
}

if (-not $FeatureDescription) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Json] [-Personas persona1,persona2] [-Patterns pattern1,pattern2] [-Workflows workflow1,workflow2] <feature_description>" -ForegroundColor Red
    exit 1
}

# Function to find the repository root by searching for existing project markers
function Find-RepoRoot {
    param([string]$StartDir)

    $currentDir = $StartDir
    while ($currentDir -ne "") {
        if ((Test-Path (Join-Path $currentDir ".git")) -or (Test-Path (Join-Path $currentDir "persona-kit"))) {
            return $currentDir
        }
        $currentDir = Split-Path $currentDir -Parent
    }
    return $null
}

# Resolve repository root. Prefer git information when available, but fall back
# to searching for repository markers so the workflow still functions in repositories that
# were initialised with --no-git.
$scriptDir = Split-Path -Parent $PSCommandPath

try {
    $gitRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0) {
        $repoRoot = $gitRoot
        $hasGit = $true
    } else {
        throw "Not a git repository"
    }
}
catch {
    $repoRoot = Find-RepoRoot $scriptDir
    if (-not $repoRoot) {
        Write-Host "Error: Could not determine repository root. Please run this script from within the repository." -ForegroundColor Red
        exit 1
    }
    $hasGit = $false
}

Set-Location $repoRoot

# Load common functions
$commonScript = Join-Path (Split-Path -Parent $PSCommandPath) "common.ps1"
. $commonScript

# Get all paths and variables from common functions
$paths = Get-FeaturePaths

# Validate persona-kit structure
if (-not (Test-PersonaKitStructure $repoRoot)) {
    Write-Host "Error: Invalid persona-kit structure. Please ensure persona-kit is properly set up." -ForegroundColor Red
    exit 1
}

# Check if we're on a proper feature branch (only for git repos)
if (-not (Test-FeatureBranch $paths.CURRENT_BRANCH $paths.HAS_GIT)) {
    exit 1
}

$featuresDir = Join-Path $repoRoot ".features"
New-Item -ItemType Directory -Force -Path $featuresDir | Out-Null

# Find next feature number
$highest = 0
if (Test-Path $featuresDir) {
    Get-ChildItem $featuresDir -Directory | ForEach-Object {
        $dirName = $_.Name
        if ($dirName -match '^(\d+)') {
            $number = [int]$matches[1]
            if ($number -gt $highest) {
                $highest = $number
            }
        }
    }
}

$next = $highest + 1
$featureNum = "{0:D3}" -f $next

# Generate branch name
$branchName = $FeatureDescription.ToLower() -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-', '' -replace '-$'
$words = $branchName -split '-' | Where-Object { $_ } | Select-Object -First 3
$branchName = "$featureNum-$($words -join '-')"

if ($hasGit) {
    git checkout -b $branchName 2>$null | Out-Null
} else {
    Write-Host "[persona-kit] Warning: Git repository not detected; skipped branch creation for $branchName" -ForegroundColor Yellow
}

$featureDir = Join-Path $featuresDir $branchName
New-Item -ItemType Directory -Force -Path $featureDir | Out-Null

# Set the PERSONA_FEATURE environment variable for the current session
$env:PERSONA_FEATURE = $branchName

# Create feature structure
New-FeatureStructure $featureDir

# Copy selected personas if specified
if ($Personas) {
    $selectedPersonas = $Personas -split ',' | ForEach-Object { $_.Trim() }
    Write-Host "Copying selected personas: $($selectedPersonas -join ', ')"
    Copy-PersonaFiles $featureDir $paths.PERSONAS_DIR $selectedPersonas
}

# Copy selected patterns if specified
if ($Patterns) {
    $selectedPatterns = $Patterns -split ',' | ForEach-Object { $_.Trim() }
    Write-Host "Copying selected patterns: $($selectedPatterns -join ', ')"
    Copy-PatternFiles $featureDir $paths.PATTERNS_DIR $selectedPatterns
}

# Copy selected workflows if specified
if ($Workflows) {
    $selectedWorkflows = $Workflows -split ',' | ForEach-Object { $_.Trim() }
    Write-Host "Copying selected workflows: $($selectedWorkflows -join ', ')"
    Copy-WorkflowFiles $featureDir $paths.WORKFLOWS_DIR $selectedWorkflows
}

# Generate feature summary
New-FeatureSummary $featureDir $branchName

# Create a basic spec template if none exists
$specFile = $paths.FEATURE_SPEC
if (-not (Test-Path $specFile) -or (Get-Item $specFile).Length -eq 0) {
    $content = @"
# Feature Specification: $FeatureDescription

## Overview
[Brief description of the feature]

## User Stories
- As a [user type], I want [functionality] so that [benefit]

## Requirements
- [Technical requirements]
- [Functional requirements]
- [Non-functional requirements]

## Acceptance Criteria
- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] [Criteria 3]

## Technical Notes
- [Technical considerations]
- [Dependencies]
- [Architecture impact]

## Related Personas
$(if ($Personas) { ($Personas -split ',' | ForEach-Object { "- $_.Trim()" }) -join "`n" } else { "- [Relevant personas will be added here]" })

## Related Patterns
$(if ($Patterns) { ($Patterns -split ',' | ForEach-Object { "- $_.Trim()" }) -join "`n" } else { "- [Relevant patterns will be added here]" })

## Related Workflows
$(if ($Workflows) { ($Workflows -split ',' | ForEach-Object { "- $_.Trim()" }) -join "`n" } else { "- [Relevant workflows will be added here]" })
"@

    $content | Out-File -FilePath $specFile -Encoding UTF8
}

Write-Host
Write-Host "=== Feature Created Successfully ===" -ForegroundColor Green
Write-Host "BRANCH_NAME: $branchName"
Write-Host "FEATURE_DIR: $featureDir"
Write-Host "FEATURE_NUM: $featureNum"
Write-Host "SPEC_FILE: $specFile"
Write-Host "PERSONA_FEATURE environment variable set to: $branchName"

if ($Personas) {
    Write-Host "PERSONAS: $($Personas -split ',' | ForEach-Object { $_.Trim() } | Join-String -Separator ', ')"
}

if ($Patterns) {
    Write-Host "PATTERNS: $($Patterns -split ',' | ForEach-Object { $_.Trim() } | Join-String -Separator ', ')"
}

if ($Workflows) {
    Write-Host "WORKFLOWS: $($Workflows -split ',' | ForEach-Object { $_.Trim() } | Join-String -Separator ', ')"
}

Write-Host
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit $specFile to define your feature requirements"
Write-Host "2. Update $($paths.IMPL_PLAN) with implementation details"
Write-Host "3. Use the copied personas, patterns, and workflows as needed"
Write-Host "4. Follow the tasks in $($paths.TASKS)"

if ($Json) {
    $result = @{
        BRANCH_NAME = $branchName
        FEATURE_DIR = $featureDir
        FEATURE_NUM = $featureNum
        SPEC_FILE = $specFile
        PERSONAS = $Personas
        PATTERNS = $Patterns
        WORKFLOWS = $Workflows
    }
    $result | ConvertTo-Json
}