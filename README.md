<div align="center">
    <h1>🎭 Persona Kit</h1>
    <h3><em>Build software with persona-driven development workflows.</em></h3>
</div>

<p align="center">
    <strong>A toolkit for creating, managing, and utilizing AI personas to enhance software development workflows and decision-making processes.</strong>
</p>

<p align="center">
    <a href="#"><img src="https://img.shields.io/badge/version-0.0.19-blue" alt="Version"/></a>
    <a href="#"><img src="https://img.shields.io/badge/python-3.11+-green" alt="Python"/></a>
    <a href="#"><img src="https://img.shields.io/badge/license-MIT-yellow" alt="License"/></a>
</p>

---

## Table of Contents

- [🌟 What is Persona Kit?](#-what-is-persona-kit)
- [🚀 Key Features](#-key-features)
- [⚡ Quick Start](#-quick-start)
- [📁 Project Structure](#-project-structure)
- [🔧 Configuration](#-configuration)
- [🎭 Persona Management](#-persona-management)
- [🔄 Workflows](#-workflows)
- [📚 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🌟 What is Persona Kit?

Persona Kit is a comprehensive toolkit designed for **persona-driven development** - an approach that leverages AI personas to enhance software development workflows, improve decision-making, and maintain consistency across projects.

Unlike traditional development approaches, Persona Kit allows you to:

- **Define specialized AI personas** for different roles (architect, developer, tester, product manager, etc.)
- **Create reusable interaction patterns** that maintain consistency across development sessions
- **Establish structured workflows** that guide development processes
- **Maintain shared knowledge bases** that evolve with your project
- **Generate templates** for common development tasks and documentation

## 🚀 Key Features

### 🎭 Persona System
- **Role-based personas** with specialized knowledge and behaviors
- **Context-aware interactions** that adapt to project needs
- **Persona memory** that accumulates project-specific knowledge
- **Persona switching** for multi-role development scenarios

### 🔄 Workflow Management
- **Structured development workflows** with clear phases
- **Template-based task generation** for consistency
- **Progress tracking** and state management
- **Integration with popular development tools**

### 📚 Knowledge Management
- **Shared memory system** for project context
- **Pattern libraries** for common development scenarios
- **Template repositories** for documentation and code
- **Historical context** preservation

### ⚙️ Developer Experience
- **Python-based CLI** for easy integration
- **Rich configuration system** for customization
- **Extensive documentation** and examples
- **Cross-platform compatibility**

## ⚡ Quick Start

### 1. Installation

#### Option 1: Install as a tool (Recommended)

```bash
# Install persona-kit as a global tool
uv tool install persona-kit --from git+https://github.com/Nom-nom-hub/persona-kit.git

# The tool is now available as 'persona-kit' command
persona-kit init <PROJECT_NAME>
```

#### Option 2: Use with uvx (No installation required)

```bash
# Run directly with uvx (requires uv installed)
uvx --from git+https://github.com/Nom-nom-hub/persona-kit.git persona-kit init <PROJECT_NAME>

# Or initialize in current directory
uvx --from git+https://github.com/Nom-nom-hub/persona-kit.git persona-kit init --here
```

#### Option 3: Traditional installation (For development)

```bash
# Clone the repository
git clone https://github.com/Nom-nom-hub/persona-kit.git
cd persona-kit

# Install in development mode
uv pip install -e .
```

### 2. Initialize a Project

```bash
# Initialize persona-kit in your project
persona-kit init <PROJECT_NAME>

# Or initialize in current directory
persona-kit init --here

# Or use with uvx (no installation required)
uvx --from git+https://github.com/Nom-nom-hub/persona-kit.git persona-kit init <PROJECT_NAME>
```

### 3. Create Your First Persona

```bash
# Create a development persona
persona-kit persona create "Senior Python Developer" --role developer --expertise python,architecture,testing
```

### 4. Set Up a Workflow

```bash
# Create a standard development workflow
persona-kit workflow create "feature-development" --template feature
```

## 📁 Project Structure

```
persona-kit/
├── .github/               # GitHub workflows and scripts
├── docs/                  # Documentation
├── memory/                # Memory system templates
├── patterns/              # Pattern definitions
├── personas/              # Persona definitions
├── scripts/               # Automation scripts (bash/powershell)
├── src/                   # Source code (persona_kit_cli)
├── templates/             # Base templates
├── workflows/             # Workflow definitions
├── pyproject.toml         # Project configuration
├── README.md             # This file
├── LICENSE               # License file
├── .gitignore           # Git ignore patterns
└── [other project files]
```

## 🔧 Configuration

### Basic Configuration

The `pyproject.toml` file contains the main project configuration:

```toml
[project]
name = "persona-kit"
version = "0.1.0"
description = "A toolkit for persona-driven development workflows"

[tool.persona-kit]
default-persona = "assistant"
memory-backend = "local"
log-level = "INFO"
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PERSONA_KIT_CONFIG` | Path to config file | `pyproject.toml` |
| `PERSONA_KIT_LOG_LEVEL` | Logging level | `INFO` |
| `PERSONA_KIT_MEMORY_PATH` | Memory storage path | `.persona-kit/memory` |

## 🎭 Persona Management

### Creating Personas

Personas define AI behaviors, knowledge domains, and interaction patterns:

```bash
# Create a specialized persona
persona-kit persona create "Code Reviewer" \
  --role reviewer \
  --expertise "code-quality,security,best-practices" \
  --personality "thorough,constructive,detail-oriented"
```

### Using Personas

```bash
# Switch to a persona for a session
persona-kit persona use "Senior Developer"

# List available personas
persona-kit persona list

# Show current persona details
persona-kit persona show
```

## 🔄 Workflows

### Available Workflow Templates

- **feature-development**: Standard feature development lifecycle
- **bug-fix**: Bug investigation and resolution process
- **code-review**: Code review and quality assurance
- **documentation**: Documentation creation and maintenance
- **architecture**: System design and architecture planning

### Creating Custom Workflows

```bash
# Create a custom workflow
persona-kit workflow create "api-development" \
  --steps "design,implement,test,document" \
  --personas "architect,developer,tester"
```

## 📚 Documentation

- **[User Guide](./docs/)**: Comprehensive usage documentation
- **[API Reference](./docs/api.md)**: Complete API documentation
- **[Persona Guide](./docs/personas.md)**: Creating and managing personas
- **[Workflow Guide](./docs/workflows.md)**: Custom workflow development
- **[Examples](./docs/examples/)**: Real-world usage examples

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](./CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone and setup development environment
git clone https://github.com/Nom-nom-hub/persona-kit.git
cd persona-kit
uv pip install -e ".[dev]"

# Run tests
uv run pytest

# Format code
uv run black src/
uv run isort src/

# Install as a tool for testing
uv tool install persona-kit --from git+https://github.com/Nom-nom-hub/persona-kit.git
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
    <p><strong>Built with ❤️ for developers who want to enhance their AI-assisted development workflows</strong></p>
</div>