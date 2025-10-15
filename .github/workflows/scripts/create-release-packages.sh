#!/bin/bash

# create-release-packages.sh - Generate multiple package formats for persona-kit
# Usage: ./create-release-packages.sh [version]

set -euo pipefail

VERSION=${1:-}

echo "Creating release packages for persona-kit v${VERSION}..."

# Ensure we're in the project root
cd "$(git rev-parse --show-toplevel)"

# Clean any existing dist directory - try multiple approaches for Windows compatibility
if [ -d "dist" ]; then
    echo "Cleaning existing dist directory..."
    # Try Unix rm first
    rm -rf dist 2>/dev/null || true
    # If that fails, try Windows rmdir
    if [ -d "dist" ]; then
        rmdir /s /q dist 2>/dev/null || true
    fi
    # Check if it still exists
    if [ -d "dist" ]; then
        echo "Warning: Could not remove existing dist directory, will try to continue..."
    fi
fi

# Create dist directory and set DIST_DIR to absolute path
mkdir -p dist 2>/dev/null || mkdir dist 2>/dev/null || echo "Warning: Could not create dist directory, may already exist"
DIST_DIR="$(pwd)/dist"

# Convert to Windows path format if on Windows (for Git Bash)
if command -v cygpath &> /dev/null; then
    DIST_DIR_WIN="$(cygpath -w "$DIST_DIR")"
    echo "Windows path for dist directory: $DIST_DIR_WIN"
fi

echo "Using dist directory: $DIST_DIR"

# Install build dependencies if not already installed
if ! command -v python &> /dev/null; then
    echo "Error: Python is not installed or not in PATH"
    exit 1
fi

# Check if build package is installed
if ! python -c "import build" &> /dev/null; then
    echo "Installing build package..."
    python -m pip install build
fi

# Build source distribution (sdist) and wheel
echo "Building source distribution and wheel..."
python -m build

# Now create the AI assistant template packages
# List of supported AI assistants
AI_ASSISTANTS=("copilot" "claude" "gemini" "cursor-agent" "qwen" "opencode" "codex" "windsurf" "kilocode" "auggie" "codebuddy" "roo" "q")

# List of script types
SCRIPT_TYPES=("sh" "ps")

# Create a temporary directory for building packages
TEMP_DIR=$(mktemp -d)
echo "Building template packages in temporary directory: $TEMP_DIR"

# Create .persona-kit directory with full structure
mkdir -p "$TEMP_DIR/.persona-kit"
mkdir -p "$TEMP_DIR/.persona-kit/templates"
mkdir -p "$TEMP_DIR/.persona-kit/patterns"
mkdir -p "$TEMP_DIR/.persona-kit/personas" 
mkdir -p "$TEMP_DIR/.persona-kit/workflows"
mkdir -p "$TEMP_DIR/.persona-kit/scripts"
mkdir -p "$TEMP_DIR/.persona-kit/memory"

# Copy necessary files to the .persona-kit directory
cp -r templates/ "$TEMP_DIR/.persona-kit/templates/"
cp -r patterns/ "$TEMP_DIR/.persona-kit/patterns/" 2>/dev/null || echo "No patterns directory found, skipping"
cp -r personas/ "$TEMP_DIR/.persona-kit/personas/" 2>/dev/null || echo "No personas directory found, skipping"
cp -r workflows/ "$TEMP_DIR/.persona-kit/workflows/" 2>/dev/null || echo "No workflows directory found, skipping"

# Add basic README to the package
cat > "$TEMP_DIR/README.md" << EOF
# Persona Kit Template
This is a template for setting up a Persona Kit project with an AI assistant.

The project includes a .persona-kit directory containing:
- templates/: Command templates and workflow templates
- patterns/: Communication and development patterns
- personas/: Persona definitions and configurations
- workflows/: Development workflow definitions
- scripts/: Helper scripts for different platforms
- memory/: Project memory and context files

## Getting Started
1. Initialize the project with \\`persona-kit init\\` or use this template directly
2. Use the slash commands for different workflows:
   - \\`/persona-kit.constitution\\` - Establish project principles
   - \\`/persona-kit.personas\\` - Set up team personas
   - \\`/persona-kit.patterns\\` - Define communication patterns
   - \\`/persona-kit.workflows\\` - Create development workflows
   - \\`/persona-kit.implement\\` - Execute implementation
EOF

# Create .gitignore
cat > "$TEMP_DIR/.gitignore" << EOF
# Dependencies & Virtual Environments
.env
venv/
env/
.venv/
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Secrets
*.key
*.pem
*.crt
*.cert
.env*
config.json
credentials.json

# AI agent config files (adjust based on agent)
.claude/
.gemini/
.cursor/
.kilocode/
.augment/
.codebuddy/
.roo/
.amazonq/
EOF

# Create basic .gitattributes
cat > "$TEMP_DIR/.gitattributes" << EOF
# Set default behavior to automatically normalize line endings
* text=auto

# Force the following file types to have Unix line endings
*.sh text eol=lf
*.py text eol=lf
*.md text eol=lf
*.yml text eol=lf
*.yaml text eol=lf
*.json text eol=lf
*.toml text eol=lf

# Force the following file types to have Windows line endings
*.bat text eol=crlf
*.cmd text eol=crlf
*.ps1 text eol=crlf
*.psm1 text eol=crlf
EOF

# Process each combination of AI assistant and script type
for assistant in "${AI_ASSISTANTS[@]}"; do
    for script_type in "${SCRIPT_TYPES[@]}"; do
        echo "Creating template package for ${assistant} with ${script_type} scripts..."
        
        # Create a package directory for this combination
        package_dir="${TEMP_DIR}/pkg-${assistant}-${script_type}"
        mkdir -p "$package_dir"
        
        # Copy the .persona-kit directory to this package
        cp -r "$TEMP_DIR/.persona-kit" "$package_dir/"
        
        # Create assistant-specific files
        assistant_dir="$package_dir/.${assistant}"
        mkdir -p "$assistant_dir"
        mkdir -p "$assistant_dir/commands"  # Create commands directory for all assistants
        
        # Create a basic config file for the assistant
        case "$assistant" in
            "claude")
                echo "# Claude-specific configuration" > "$assistant_dir/config.txt"
                echo "Claude Code project setup" >> "$assistant_dir/config.txt"
                # Add basic command TOML files for Claude
                cat > "$assistant_dir/commands/constitution.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.constitution"
description = "Establish project principles and guidelines"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/personas.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.personas"
description = "Set up team personas for development"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/patterns.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.patterns"
description = "Define communication and development patterns"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/workflows.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.workflows"
description = "Create development workflows"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/implement.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.implement"
description = "Execute implementation phase"

[parameters]
none = true
TOML_EOF
                ;;
            "qwen")
                echo "# Qwen-specific configuration" > "$assistant_dir/config.txt"
                echo "Qwen Code project setup" >> "$assistant_dir/config.txt"
                # Add basic command TOML files for Qwen
                cat > "$assistant_dir/commands/constitution.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.constitution"
description = "Establish project principles and guidelines"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/personas.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.personas"
description = "Set up team personas for development"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/patterns.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.patterns"
description = "Define communication and development patterns"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/workflows.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.workflows"
description = "Create development workflows"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/implement.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.implement"
description = "Execute implementation phase"

[parameters]
none = true
TOML_EOF
                ;;
            "copilot")
                echo "# GitHub Copilot-specific configuration" > "$assistant_dir/config.txt"
                echo "GitHub Copilot project setup" >> "$assistant_dir/config.txt"
                # Add basic command TOML files for Copilot
                cat > "$assistant_dir/commands/constitution.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.constitution"
description = "Establish project principles and guidelines"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/personas.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.personas"
description = "Set up team personas for development"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/patterns.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.patterns"
description = "Define communication and development patterns"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/workflows.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.workflows"
description = "Create development workflows"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/implement.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.implement"
description = "Execute implementation phase"

[parameters]
none = true
TOML_EOF
                ;;
            "cursor-agent")
                echo "# Cursor Agent-specific configuration" > "$assistant_dir/config.txt"
                echo "Cursor project setup" >> "$assistant_dir/config.txt"
                # Add basic command TOML files for Cursor
                cat > "$assistant_dir/commands/constitution.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.constitution"
description = "Establish project principles and guidelines"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/personas.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.personas"
description = "Set up team personas for development"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/patterns.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.patterns"
description = "Define communication and development patterns"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/workflows.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.workflows"
description = "Create development workflows"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/implement.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.implement"
description = "Execute implementation phase"

[parameters]
none = true
TOML_EOF
                ;;
            "gemini")
                echo "# Gemini-specific configuration" > "$assistant_dir/config.txt"
                echo "Gemini project setup" >> "$assistant_dir/config.txt"
                # Add basic command TOML files for Gemini
                cat > "$assistant_dir/commands/constitution.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.constitution"
description = "Establish project principles and guidelines"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/personas.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.personas"
description = "Set up team personas for development"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/patterns.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.patterns"
description = "Define communication and development patterns"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/workflows.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.workflows"
description = "Create development workflows"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/implement.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.implement"
description = "Execute implementation phase"

[parameters]
none = true
TOML_EOF
                ;;
            *)
                echo "# ${assistant}-specific configuration" > "$assistant_dir/config.txt"
                echo "${assistant} project setup" >> "$assistant_dir/config.txt"
                # Add basic command TOML files for other assistants
                cat > "$assistant_dir/commands/constitution.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.constitution"
description = "Establish project principles and guidelines"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/personas.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.personas"
description = "Set up team personas for development"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/patterns.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.patterns"
description = "Define communication and development patterns"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/workflows.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.workflows"
description = "Create development workflows"

[parameters]
none = true
TOML_EOF
                cat > "$assistant_dir/commands/implement.toml" << 'TOML_EOF'
[command]
name = "/persona-kit.implement"
description = "Execute implementation phase"

[parameters]
none = true
TOML_EOF
                ;;
        esac
        
        # Create script files based on the script type
        scripts_dir="$package_dir/.persona-kit/scripts"
        mkdir -p "$scripts_dir"
        
        if [ "$script_type" = "sh" ]; then
            # Create POSIX shell scripts
            cat > "$scripts_dir/setup.sh" << SHELL_EOF
#!/bin/sh
# Setup script for ${assistant} (${script_type})
echo "Setting up persona-kit for ${assistant} with POSIX shell scripts..."
echo "Current directory: \\$(pwd)"
echo "Initializing persona-kit project..."
SHELL_EOF
            chmod +x "$scripts_dir/setup.sh"
        else
            # Create PowerShell scripts
            cat > "$scripts_dir/setup.ps1" << POWERSHELL_EOF
# Setup script for ${assistant} (${script_type})
Write-Host "Setting up persona-kit for ${assistant} with PowerShell scripts..."
Write-Host "Current directory: \\$PWD"
Write-Host "Initializing persona-kit project..."
POWERSHELL_EOF
        fi
        
        # Create the slash command files based on templates (these will be created by the CLI when needed)
        # We'll still copy them for completeness but they'll be handled by the CLI
        cp "$TEMP_DIR/.persona-kit/templates/constitution-cmd-template.md" "$package_dir/constitution-cmd.md" 2>/dev/null || echo "constitution-cmd-template.md not found"
        cp "$TEMP_DIR/.persona-kit/templates/personas-cmd-template.md" "$package_dir/personas-cmd.md" 2>/dev/null || echo "persons-cmd-template.md not found"
        cp "$TEMP_DIR/.persona-kit/templates/patterns-cmd-template.md" "$package_dir/patterns-cmd.md" 2>/dev/null || echo "patterns-cmd-template.md not found"
        cp "$TEMP_DIR/.persona-kit/templates/workflows-cmd-template.md" "$package_dir/workflows-cmd.md" 2>/dev/null || echo "workflows-cmd-template.md not found"
        cp "$TEMP_DIR/.persona-kit/templates/implement-cmd-template.md" "$package_dir/implement-cmd.md" 2>/dev/null || echo "implement-cmd-template.md not found"
        
        # Create the final template package as a ZIP file
        template_name="persona-kit-template-${assistant}-${script_type}-v${VERSION}.zip"
        
        # Create the zip package with all files using absolute path
        (cd "$package_dir" && zip -r "${DIST_DIR}/${template_name}" . -x "*.DS_Store" "*/.*.swp" "*/.*.swo" > /dev/null 2>&1) || \
        (cd "$package_dir" && tar -czf "${DIST_DIR}/${template_name}" . > /dev/null 2>&1)
        
        echo "Created: $template_name"
    done
done

# Also create a complete package with all files
complete_name="persona-kit-complete-${VERSION}.zip"
# Create the complete package using absolute path
(cd "$TEMP_DIR" && zip -r "${DIST_DIR}/${complete_name}" . -x "*.DS_Store" "*/.*.swp" "*/.*.swo" > /dev/null 2>&1) || \
(cd "$TEMP_DIR" && tar -czf "${DIST_DIR}/${complete_name}" . > /dev/null 2>&1)

echo "Created complete package: $complete_name"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

# Verify packages were created
if [ ! -d "dist" ]; then
    echo "Error: dist directory was not created"
    exit 1
fi

# List created packages
echo "Created packages:"
ls -la dist/

# Generate checksums for all packages
echo "Generating checksums..."
(cd dist && \
if command -v sha256sum &> /dev/null; then
    sha256sum * > checksums.sha256
    echo "Created checksums.sha256"
elif command -v shasum &> /dev/null; then
    shasum -a 256 * > checksums.sha256
    echo "Created checksums.sha256"
else
    echo "Warning: sha256sum/shasum not available - skipping checksum generation"
fi)

# List final packages with checksums
echo "Final release packages:"
ls -la dist/
if [ -f "dist/checksums.sha256" ]; then
    echo "With checksums file"
    ls -la dist/checksums.sha256
fi

echo "Package creation completed successfully!"
echo "Packages ready for upload in: $(pwd)"