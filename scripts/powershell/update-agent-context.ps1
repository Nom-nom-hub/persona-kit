#!/usr/bin/env pwsh

param(
    [string]$AgentType,
    [switch]$Help
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [agent_type]"
    Write-Host "Agent types: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|q"
    Write-Host "Leave empty to update all existing agent files"
    exit 0
}

# Get script directory and load common functions
$scriptDir = Split-Path -Parent $PSCommandPath
$commonScript = Join-Path $scriptDir "common.ps1"
. $commonScript

# Get all paths and variables from common functions
$paths = Get-FeaturePaths

#==============================================================================
# Configuration and Global Variables
#==============================================================================

$agentType = $AgentType

# Agent-specific file paths
$claudeFile = Join-Path $paths.REPO_ROOT "CLAUDE.md"
$geminiFile = Join-Path $paths.REPO_ROOT "GEMINI.md"
$copilotFile = Join-Path $paths.REPO_ROOT ".github/copilot-instructions.md"
$cursorFile = Join-Path $paths.REPO_ROOT ".cursor/rules/persona-kit-rules.mdc"
$qwenFile = Join-Path $paths.REPO_ROOT "QWEN.md"
$agentsFile = Join-Path $paths.REPO_ROOT "AGENTS.md"
$windsurfFile = Join-Path $paths.REPO_ROOT ".windsurf/rules/persona-kit-rules.md"
$kilocodeFile = Join-Path $paths.REPO_ROOT ".kilocode/rules/persona-kit-rules.md"
$auggieFile = Join-Path $paths.REPO_ROOT ".augment/rules/persona-kit-rules.md"
$rooFile = Join-Path $paths.REPO_ROOT ".roo/rules/persona-kit-rules.md"
$codebuddyFile = Join-Path $paths.REPO_ROOT ".codebuddy/rules/persona-kit-rules.md"
$qFile = Join-Path $paths.REPO_ROOT "AGENTS.md"

# Template file
$templateFile = Join-Path $paths.REPO_ROOT "persona-kit/templates/agent-file-template.md"

# Global variables for parsed feature data
$featureDescription = ""
$activePersonas = @()
$relevantPatterns = @()
$applicableWorkflows = @()

#==============================================================================
# Utility Functions
#==============================================================================

function Write-Info {
    param([string]$Message)
    Write-Host "INFO: $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

#==============================================================================
# Validation Functions
#==============================================================================

function Test-Environment {
    # Check if we have a current branch/feature (git or non-git)
    if (-not $paths.CURRENT_BRANCH) {
        Write-Error "Unable to determine current feature"
        if ($paths.HAS_GIT) {
            Write-Info "Make sure you're on a feature branch"
        } else {
            Write-Info "Set PERSONA_FEATURE environment variable or create a feature first"
        }
        exit 1
    }

    # Check if feature directory exists
    if (-not (Test-Path $paths.FEATURE_DIR)) {
        Write-Error "No feature directory found at $($paths.FEATURE_DIR)"
        Write-Info "Make sure you're working on a feature with a corresponding .features directory"
        if (-not $paths.HAS_GIT) {
            Write-Info "Use: `$env:PERSONA_FEATURE='your-feature-name' or create a new feature first"
        }
        exit 1
    }

    # Check if spec.md exists
    if (-not (Test-Path $paths.FEATURE_SPEC)) {
        Write-Error "No spec.md found at $($paths.FEATURE_SPEC)"
        Write-Info "Create a feature specification file to provide context for AI agents"
        exit 1
    }

    # Validate persona-kit structure
    if (-not (Test-PersonaKitStructure $paths.REPO_ROOT)) {
        Write-Error "Invalid persona-kit structure"
        exit 1
    }
}

#==============================================================================
# Feature Data Extraction Functions
#==============================================================================

function Read-FeatureField {
    param([string]$FieldPattern, [string]$FeatureFile)

    $matchResults = Select-String "^\*\*$FieldPattern\*\*: " $FeatureFile -ErrorAction SilentlyContinue
    if ($matchResults) {
        $value = $matches[0].Line -replace "^\*\*$FieldPattern\*\*: ", "" -replace '^[ \t]*', '' -replace '[ \t]*$', ''
        if ($value -notmatch "NEEDS CLARIFICATION" -and $value -ne "N/A") {
            return $value
        }
    }
    return ""
}

function Read-FeatureData {
    param([string]$SpecFile)

    if (-not (Test-Path $SpecFile)) {
        Write-Error "Feature spec file not found: $SpecFile"
        return $false
    }

    Write-Info "Parsing feature data from $SpecFile"

    $featureDescription = Read-FeatureField "Overview" $SpecFile

    # Extract personas, patterns, and workflows from feature directory
    $personasPath = Join-Path $paths.FEATURE_DIR "personas"
    if (Test-Path $personasPath) {
        Get-ChildItem $personasPath -File | ForEach-Object {
            $activePersonas += $_.BaseName
        }
    }

    $patternsPath = Join-Path $paths.FEATURE_DIR "patterns"
    if (Test-Path $patternsPath) {
        Get-ChildItem $patternsPath -Directory | ForEach-Object {
            $relevantPatterns += $_.Name
        }
    }

    $workflowsPath = Join-Path $paths.FEATURE_DIR "workflows"
    if (Test-Path $workflowsPath) {
        Get-ChildItem $workflowsPath -File | ForEach-Object {
            $applicableWorkflows += $_.BaseName
        }
    }

    # Log what we found
    if ($featureDescription) {
        Write-Info "Found feature description"
    } else {
        Write-Warning "No feature description found in spec"
    }

    if ($activePersonas.Count -gt 0) {
        Write-Info "Found active personas: $($activePersonas -join ', ')"
    } else {
        Write-Warning "No active personas found"
    }

    if ($relevantPatterns.Count -gt 0) {
        Write-Info "Found relevant patterns: $($relevantPatterns -join ', ')"
    }

    if ($applicableWorkflows.Count -gt 0) {
        Write-Info "Found applicable workflows: $($applicableWorkflows -join ', ')"
    }

    return $true
}

#==============================================================================
# Agent File Update Function
#==============================================================================

function Update-AgentFile {
    param([string]$TargetFile, [string]$AgentName)

    if (-not $TargetFile -or -not $AgentName) {
        Write-Error "Update-AgentFile requires TargetFile and AgentName parameters"
        return $false
    }

    Write-Info "Updating $AgentName context file: $TargetFile"

    $projectName = Split-Path $paths.REPO_ROOT -Leaf
    $currentDate = Get-Date -Format "yyyy-MM-dd"

    # Create directory if it doesn't exist
    $targetDir = Split-Path $TargetFile
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    }

    if (-not (Test-Path $TargetFile)) {
        # Create new file from template
        $tempFile = [System.IO.Path]::GetTempFileName()

        if (Test-Path $templateFile) {
            Copy-Item $templateFile $tempFile -Force
        } else {
            Write-Warning "Template not found at $templateFile, creating basic agent file"
            # Create a basic template
            $basicTemplate = @"
# AI Agent Context: $projectName

**Last updated**: $currentDate

## Project Overview
Persona-Kit Framework ($($paths.CURRENT_BRANCH))

## Active Technologies
persona-kit/
.features/$($paths.CURRENT_BRANCH)/

## Development Commands
# Use persona-kit scripts for development workflow

## Coding Standards
Follow persona-driven development practices

## Recent Changes
- $($paths.CURRENT_BRANCH): Persona-driven feature development

## Active Personas
$(if ($activePersonas.Count -gt 0) { ($activePersonas | ForEach-Object { "- $_" }) -join "`n" } else { "- No active personas defined" })

## Relevant Patterns
$(if ($relevantPatterns.Count -gt 0) { ($relevantPatterns | ForEach-Object { "- $_" }) -join "`n" } else { "- No patterns defined" })

## Applicable Workflows
$(if ($applicableWorkflows.Count -gt 0) { ($applicableWorkflows | ForEach-Object { "- $_" }) -join "`n" } else { "- No workflows defined" })

## Development Guidelines
- Follow the active persona definitions for role-specific guidance
- Apply relevant patterns when dealing with complex situations
- Follow established workflows for consistent development processes
- Maintain clear separation of concerns between different personas
- Use pattern-driven approaches for decision-making and problem-solving
"@
            $basicTemplate | Out-File -FilePath $tempFile -Encoding UTF8
        }

        # Replace template placeholders
        $content = Get-Content $tempFile -Raw
        $content = $content -replace "\[PROJECT NAME\]", $projectName
        $content = $content -replace "\[DATE\]", $currentDate
        $content | Out-File -FilePath $TargetFile -Encoding UTF8

        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        Write-Success "Created new $AgentName context file"
    } else {
        # Update existing file with persona information
        $content = Get-Content $TargetFile -Raw

        # Update persona section if it exists
        if ($content -match "Active Personas") {
            $content = $content -replace "(?s)(## Active Personas\s*\n).*?(?=\n## )", "## Active Personas`n$(if ($activePersonas.Count -gt 0) { ($activePersonas | ForEach-Object { "- $_" }) -join "`n" } else { "- No active personas defined" })`n`n"
        }

        # Update patterns section if it exists
        if ($content -match "Relevant Patterns") {
            $content = $content -replace "(?s)(## Relevant Patterns\s*\n).*?(?=\n## )", "## Relevant Patterns`n$(if ($relevantPatterns.Count -gt 0) { ($relevantPatterns | ForEach-Object { "- $_" }) -join "`n" } else { "- No patterns defined" })`n`n"
        }

        # Update workflows section if it exists
        if ($content -match "Applicable Workflows") {
            $content = $content -replace "(?s)(## Applicable Workflows\s*\n).*?(?=\n## )", "## Applicable Workflows`n$(if ($applicableWorkflows.Count -gt 0) { ($applicableWorkflows | ForEach-Object { "- $_" }) -join "`n" } else { "- No workflows defined" })`n`n"
        }

        # Update timestamp
        $content = $content -replace "\*\*Last updated\*\*: \d{4}-\d{2}-\d{2}", "**Last updated**: $currentDate"

        $content | Out-File -FilePath $TargetFile -Encoding UTF8
        Write-Success "Updated existing $AgentName context file"
    }

    return $true
}

#==============================================================================
# Agent Selection and Processing
#==============================================================================

function Update-SpecificAgent {
    param([string]$AgentType)

    switch ($AgentType) {
        "claude" { Update-AgentFile $claudeFile "Claude Code"; break }
        "gemini" { Update-AgentFile $geminiFile "Gemini CLI"; break }
        "copilot" { Update-AgentFile $copilotFile "GitHub Copilot"; break }
        "cursor-agent" { Update-AgentFile $cursorFile "Cursor IDE"; break }
        "qwen" { Update-AgentFile $qwenFile "Qwen Code"; break }
        "opencode" { Update-AgentFile $agentsFile "opencode"; break }
        "codex" { Update-AgentFile $agentsFile "Codex CLI"; break }
        "windsurf" { Update-AgentFile $windsurfFile "Windsurf"; break }
        "kilocode" { Update-AgentFile $kilocodeFile "Kilo Code"; break }
        "auggie" { Update-AgentFile $auggieFile "Auggie CLI"; break }
        "roo" { Update-AgentFile $rooFile "Roo Code"; break }
        "codebuddy" { Update-AgentFile $codebuddyFile "CodeBuddy"; break }
        "q" { Update-AgentFile $qFile "Amazon Q Developer CLI"; break }
        default {
            Write-Error "Unknown agent type '$AgentType'"
            Write-Error "Expected: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|q"
            exit 1
        }
    }
}

function Update-AllExistingAgents {
    $foundAgent = $false

    # Check each possible agent file and update if it exists
    $agentFiles = @{
        $claudeFile = "Claude Code"
        $geminiFile = "Gemini CLI"
        $copilotFile = "GitHub Copilot"
        $cursorFile = "Cursor IDE"
        $qwenFile = "Qwen Code"
        $agentsFile = "Codex/opencode"
        $windsurfFile = "Windsurf"
        $kilocodeFile = "Kilo Code"
        $auggieFile = "Auggie CLI"
        $rooFile = "Roo Code"
        $codebuddyFile = "CodeBuddy"
        $qFile = "Amazon Q Developer CLI"
    }

    foreach ($file in $agentFiles.Keys) {
        if (Test-Path $file) {
            Update-AgentFile $file $agentFiles[$file]
            $foundAgent = $true
        }
    }

    # If no agent files exist, create a default Claude file
    if (-not $foundAgent) {
        Write-Info "No existing agent files found, creating default Claude file..."
        Update-AgentFile $claudeFile "Claude Code"
    }
}

function Write-Summary {
    Write-Host
    Write-Info "Summary of persona-kit integration:"

    if ($activePersonas.Count -gt 0) {
        Write-Host "  - Active Personas: $($activePersonas -join ', ')"
    }

    if ($relevantPatterns.Count -gt 0) {
        Write-Host "  - Relevant Patterns: $($relevantPatterns -join ', ')"
    }

    if ($applicableWorkflows.Count -gt 0) {
        Write-Host "  - Applicable Workflows: $($applicableWorkflows -join ', ')"
    }

    Write-Host

    Write-Info "Usage: $($MyInvocation.MyCommand.Name) [claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|codebuddy|q]"
}

#==============================================================================
# Main Execution
#==============================================================================

# Validate environment before proceeding
Test-Environment

Write-Host "=== Updating agent context files for feature $($paths.CURRENT_BRANCH) ===" -ForegroundColor Green

# Parse the feature files to extract project information
if (-not (Read-FeatureData $paths.FEATURE_SPEC)) {
    Write-Error "Failed to parse feature data"
    exit 1
}

# Process based on agent type argument
if (-not $agentType) {
    # No specific agent provided - update all existing agent files
    Write-Info "No agent specified, updating all existing agent files..."
    Update-AllExistingAgents
} else {
    # Specific agent provided - update only that agent
    Write-Info "Updating specific agent: $agentType"
    Update-SpecificAgent $agentType
}

# Print summary
Write-Summary

Write-Success "Agent context update completed successfully"