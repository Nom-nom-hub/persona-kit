# Installation Guide

This guide covers the installation and setup process for Persona Kit, including prerequisites, installation methods, and verification steps.

## 📋 Prerequisites

Before installing Persona Kit, ensure your system meets these requirements:

### System Requirements
- **Python**: 3.11 or higher
- **Operating System**: Windows, macOS, or Linux
- **Memory**: At least 512MB RAM
- **Storage**: At least 100MB free space

### Required Tools
- **Git**: For cloning repositories and version control
- **uv**: Fast Python package manager (recommended for better performance)

### Optional but Recommended
- **Visual Studio Code**: For development and debugging
- **GitHub CLI**: For repository management
- **Visual Studio Code**: For development and debugging
- **GitHub CLI**: For repository management

## 🚀 Installation Methods

### Method 1: Using uv (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd persona-kit

# Install with uv (faster and more reliable)
uv pip install -e .
```

### Method 2: Direct Installation from Git

```bash
# Install directly from Git repository using uv
uv pip install git+https://github.com/github/persona-kit.git
```

## 🔧 Post-Installation Setup

### 1. Verify Installation

After installation, verify that Persona Kit is properly installed:

```bash
# Check version
persona-kit --version

# View help
persona-kit --help
```

Expected output:
```
Persona Kit v0.1.0
A toolkit for persona-driven development workflows and AI agent management.
```

### 2. Initialize Configuration

Initialize Persona Kit in your project or globally:

```bash
# Initialize in current project
persona-kit init

# Initialize globally (affects all projects)
persona-kit init --global

# Initialize in specific directory
persona-kit init --path /path/to/project
```

### 3. Verify Project Structure

After initialization, your project should have this structure:

```
your-project/
├── .persona-kit/           # Core system directory
│   ├── memory/            # Shared knowledge and context
│   ├── personas/          # Persona definitions
│   ├── patterns/          # Interaction patterns
│   ├── workflows/         # Workflow templates
│   ├── templates/         # Reusable templates
│   └── scripts/           # Automation scripts
├── pyproject.toml         # Updated with Persona Kit config
└── persona-kit.log        # Log file
```

## ⚙️ Configuration

### Basic Configuration

The `pyproject.toml` file contains the main configuration:

```toml
[project]
name = "your-project"
version = "0.1.0"
description = "Your project description"

[tool.persona-kit]
default-persona = "assistant"
memory-backend = "local"
log-level = "INFO"
auto-save = true
```

### Environment Variables

You can also configure Persona Kit using environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `PERSONA_KIT_CONFIG` | Path to config file | `pyproject.toml` |
| `PERSONA_KIT_LOG_LEVEL` | Logging level | `INFO` |
| `PERSONA_KIT_MEMORY_PATH` | Memory storage path | `.persona-kit/memory` |
| `PERSONA_KIT_AUTO_SAVE` | Auto-save memory | `true` |

### Configuration File Locations

Persona Kit looks for configuration in this order:

1. Environment variable `PERSONA_KIT_CONFIG`
2. `./pyproject.toml` (current directory)
3. `./.persona-kit/config.toml`
4. `~/.persona-kit/config.toml` (global config)

## 🐛 Troubleshooting

### Common Installation Issues

#### Issue: "persona-kit command not found"
**Solution**: Ensure Persona Kit is properly installed and your PATH includes Python scripts.

```bash
# Check if installed
uv pip list | grep persona-kit

# Add to PATH if needed
export PATH="$HOME/.local/bin:$PATH"

# Restart terminal or run
source ~/.bashrc  # or ~/.zshrc
```

#### Issue: "Python version not supported"
**Solution**: Upgrade Python to version 3.11 or higher.

```bash
# Check Python version
python --version

# Update Python (Ubuntu/Debian)
sudo apt update
sudo apt install python3.11 python3.11-venv

# Update Python (macOS with Homebrew)
brew install python@3.11
```

#### Issue: "Permission denied" during installation
**Solution**: Use virtual environment or install with user flag.

```bash
# Create virtual environment with uv
uv venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install in virtual environment
uv pip install -e .

# Or install for current user only
uv pip install --user -e .
```

### Getting Help

If you encounter issues:

1. **Check the logs**: Look at `persona-kit.log` in your project directory
2. **View help**: Run `persona-kit --help` for command reference
3. **Check configuration**: Verify your `pyproject.toml` configuration
4. **Test installation**: Run `persona-kit --version` to verify installation

## 🔍 Verification

### Test Basic Functionality

After installation, test that everything works:

```bash
# Test CLI functionality
persona-kit --help

# Test persona system
persona-kit persona list

# Test workflow system
persona-kit workflow list

# Test memory system
persona-kit memory status
```

### Integration Tests

Test integration with your development environment:

```bash
# Test with existing project
cd /path/to/your/project
persona-kit init --here

# Create a test persona
persona-kit persona create "Test Developer" --role developer

# Test workflow creation
persona-kit workflow create "test-workflow" --template feature
```

## 🚀 Next Steps

After successful installation:

1. **[Quick Start](./quickstart.md)** - Get up and running quickly
2. **[Persona-Driven Development](./persona-driven.md)** - Learn the core philosophy
3. **[Local Development](./local-development.md)** - Set up your development environment

## 📞 Support

Need help? Check out:

- **[Troubleshooting Guide](./troubleshooting.md)** - Common issues and solutions
- **[FAQ](./faq.md)** - Frequently asked questions
- **[Community Support](../../SUPPORT.md)** - Get help from the community