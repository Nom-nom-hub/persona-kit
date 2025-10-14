#!/usr/bin/env pwsh

param(
    [switch]$Json,
    [switch]$Force,
    [switch]$Help,
    [string]$Personas,
    [string]$Patterns,
    [string]$Workflows
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Json] [-Force] [-Personas persona1,persona2] [-Patterns pattern1,pattern2] [-Workflows workflow1,workflow2]"
    Write-Host "  -Json       Output results in JSON format"
    Write-Host "  -Force      Overwrite existing files"
    Write-Host "  -Personas   Comma-separated list of personas to include"
    Write-Host "  -Patterns   Comma-separated list of patterns to include"
    Write-Host "  -Workflows  Comma-separated list of workflows to include"
    Write-Host "  -Help       Show this help message"
    exit 0
}

# Get script directory and load common functions
$scriptDir = Split-Path -Parent $PSCommandPath
$commonScript = Join-Path $scriptDir "common.ps1"
. $commonScript

# Get all paths and variables from common functions
$paths = Get-FeaturePaths

# Validate persona-kit structure
if (-not (Test-PersonaKitStructure $paths.REPO_ROOT)) {
    Write-Host "Error: Invalid persona-kit structure. Please ensure persona-kit is properly set up." -ForegroundColor Red
    exit 1
}

# Check if we're on a proper feature branch (only for git repos)
if (-not (Test-FeatureBranch $paths.CURRENT_BRANCH $paths.HAS_GIT)) {
    exit 1
}

# Ensure the feature directory exists
New-Item -ItemType Directory -Force -Path $paths.FEATURE_DIR | Out-Null

Write-Host "=== Setting up Persona Workflow for Feature: $($paths.CURRENT_BRANCH) ===" -ForegroundColor Green
Write-Host

# Set up personas
Write-Host "Setting up personas..." -ForegroundColor Cyan
if ($Personas) {
    $selectedPersonas = $Personas -split ',' | ForEach-Object { $_.Trim() }
    Write-Host "Using specified personas: $($selectedPersonas -join ', ')"
    Copy-PersonaFiles $paths.FEATURE_DIR $paths.PERSONAS_DIR $selectedPersonas
} else {
    Write-Host "Copying all available personas..." -ForegroundColor Cyan
    $availablePersonas = Get-AvailablePersonas $paths.PERSONA_KIT_DIR
    if ($availablePersonas.Count -gt 0) {
        Copy-PersonaFiles $paths.FEATURE_DIR $paths.PERSONAS_DIR $availablePersonas
    } else {
        Write-Host "  ⚠ No personas found in $($paths.PERSONAS_DIR)" -ForegroundColor Yellow
    }
}

Write-Host

# Set up patterns
Write-Host "Setting up patterns..." -ForegroundColor Cyan
if ($Patterns) {
    $selectedPatterns = $Patterns -split ',' | ForEach-Object { $_.Trim() }
    Write-Host "Using specified patterns: $($selectedPatterns -join ', ')"
    Copy-PatternFiles $paths.FEATURE_DIR $paths.PATTERNS_DIR $selectedPatterns
} else {
    Write-Host "Copying all available patterns..." -ForegroundColor Cyan
    $availablePatterns = Get-AvailablePatterns $paths.PERSONA_KIT_DIR
    if ($availablePatterns.Count -gt 0) {
        Copy-PatternFiles $paths.FEATURE_DIR $paths.PATTERNS_DIR $availablePatterns
    } else {
        Write-Host "  ⚠ No patterns found in $($paths.PATTERNS_DIR)" -ForegroundColor Yellow
    }
}

Write-Host

# Set up workflows
Write-Host "Setting up workflows..." -ForegroundColor Cyan
if ($Workflows) {
    $selectedWorkflows = $Workflows -split ',' | ForEach-Object { $_.Trim() }
    Write-Host "Using specified workflows: $($selectedWorkflows -join ', ')"
    Copy-WorkflowFiles $paths.FEATURE_DIR $paths.WORKFLOWS_DIR $selectedWorkflows
} else {
    Write-Host "Copying all available workflows..." -ForegroundColor Cyan
    $availableWorkflows = Get-AvailableWorkflows $paths.PERSONA_KIT_DIR
    if ($availableWorkflows.Count -gt 0) {
        Copy-WorkflowFiles $paths.FEATURE_DIR $paths.WORKFLOWS_DIR $availableWorkflows
    } else {
        Write-Host "  ⚠ No workflows found in $($paths.WORKFLOWS_DIR)" -ForegroundColor Yellow
    }
}

Write-Host

# Create workflow integration file
$workflowIntegration = Join-Path $paths.FEATURE_DIR "workflow-integration.md"
if ((-not (Test-Path $workflowIntegration)) -or $Force) {
    # Build content for available personas
    $personasContent = ""
    $personasPath = Join-Path $paths.FEATURE_DIR "personas"
    if (Test-Path $personasPath) {
        Get-ChildItem $personasPath -File | ForEach-Object {
            $personaName = $_.BaseName
            $personasContent += "- **$personaName**: See personas/$personaName.md for detailed role definition`n"
        }
    } else {
        $personasContent = "- No personas have been set up for this feature`n"
    }

    # Build content for available patterns
    $patternsContent = ""
    $patternsPath = Join-Path $paths.FEATURE_DIR "patterns"
    if (Test-Path $patternsPath) {
        Get-ChildItem $patternsPath -Directory | ForEach-Object {
            $patternName = $_.Name
            $patternsContent += "- **$patternName**: See patterns/$patternName/ for pattern documentation`n"
        }
    } else {
        $patternsContent = "- No patterns have been set up for this feature`n"
    }

    # Build content for available workflows
    $workflowsContent = ""
    $workflowsPath = Join-Path $paths.FEATURE_DIR "workflows"
    if (Test-Path $workflowsPath) {
        Get-ChildItem $workflowsPath -File | ForEach-Object {
            $workflowName = $_.BaseName
            $workflowsContent += "- **$workflowName**: See workflows/$workflowName.md for workflow steps`n"
        }
    } else {
        $workflowsContent = "- No workflows have been set up for this feature`n"
    }

    $content = @"
# Workflow Integration Guide

This document outlines how to integrate the provided personas, patterns, and workflows for feature development.

## Available Personas
$personasContent
## Available Patterns
$patternsContent
## Available Workflows
$workflowsContent

## Integration Guidelines

### 1. Role Assignment
- Review each persona and assign team members or AI agents to these roles
- Ensure clear responsibility boundaries between different personas

### 2. Pattern Selection
- Choose patterns that match your specific development scenario
- Combine multiple patterns when dealing with complex situations
- Adapt patterns to your team's context and constraints

### 3. Workflow Customization
- Modify workflows to fit your team's processes and tools
- Identify the most relevant phases for your feature development
- Create checkpoints for pattern and persona integration

### 4. Communication Strategy
- Use persona communication preferences for stakeholder updates
- Apply communication patterns for structured information sharing
- Establish regular check-ins aligned with workflow phases

## Next Steps

1. **Review Artifacts**: Examine all copied personas, patterns, and workflows
2. **Customize Content**: Adapt materials to your specific feature context
3. **Assign Roles**: Designate team members to different persona roles
4. **Plan Integration**: Schedule how and when to apply each pattern and workflow
5. **Track Progress**: Use the provided workflows to monitor development progress

## Support

If you need help integrating these materials:
- Refer to the original persona-kit documentation in persona-kit/
- Consult with team leads familiar with persona-driven development
- Use the patterns for guidance on complex situations
"@

    $content | Out-File -FilePath $workflowIntegration -Encoding UTF8
    Write-Host "✓ Created workflow integration guide: $workflowIntegration" -ForegroundColor Green
} else {
    Write-Host "✓ Workflow integration guide already exists (use -Force to overwrite)" -ForegroundColor Green
}

Write-Host

# Output results
if ($Json) {
    $result = @{
        FEATURE_DIR = $paths.FEATURE_DIR
        PERSONAS = $Personas
        PATTERNS = $Patterns
        WORKFLOWS = $Workflows
        WORKFLOW_INTEGRATION = $workflowIntegration
    }
    $result | ConvertTo-Json
} else {
    Write-Host "=== Setup Complete ===" -ForegroundColor Green
    Write-Host "FEATURE_DIR: $($paths.FEATURE_DIR)"
    Write-Host "PERSONAS: $(if ($Personas) { $Personas } else { 'All available' })"
    Write-Host "PATTERNS: $(if ($Patterns) { $Patterns } else { 'All available' })"
    Write-Host "WORKFLOWS: $(if ($Workflows) { $Workflows } else { 'All available' })"
    Write-Host "WORKFLOW_INTEGRATION: $workflowIntegration"
    Write-Host
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Review the workflow integration guide"
    Write-Host "2. Customize personas, patterns, and workflows for your feature"
    Write-Host "3. Assign team roles based on persona definitions"
    Write-Host "4. Follow the established workflows for development"
}