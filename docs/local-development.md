# Local Development Guide

This guide covers setting up your local development environment, using the Persona Kit CLI, automation scripts, and integrating with different AI agents.

## 🛠️ Development Environment Setup

### Prerequisites

Ensure you have the following installed:

- **Python 3.11+**
- **Git**
- **uv** (recommended) or **pip**
- **Visual Studio Code** (recommended) or your preferred editor

### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd persona-kit

# Create virtual environment
uv venv  # or python -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install in development mode
uv pip install -e ".[dev]"
```

### 2. Development Configuration

Create a development configuration file:

```toml
# .persona-kit/dev-config.toml
[development]
debug = true
log-level = "DEBUG"
auto-reload = true
hot-reload-scripts = true

[testing]
run-tests-on-save = true
coverage-report = true
lint-on-save = true
```

### 3. IDE Integration

#### Visual Studio Code

Install recommended extensions:

```bash
# Python extension
# Pylint
# mypy
# Python Docstring Generator
# TODO Highlight
```

#### Configuration Files

```json
// .vscode/settings.json
{
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.formatting.provider": "black",
    "python.linting.mypyEnabled": true,
    "files.associations": {
        "*.md": "markdown"
    }
}
```

```json
// .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Persona Kit CLI",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/src/persona_kit_cli/__init__.py",
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}",
            "python": "${workspaceFolder}/venv/bin/python"
        }
    ]
}
```

## 🎮 CLI Usage Guide

### Basic Commands

```bash
# View help
persona-kit --help

# Check version
persona-kit --version

# View configuration
persona-kit config show

# Check system status
persona-kit status
```

### Persona Management

```bash
# Create a new persona
persona-kit persona create "Code Reviewer" \
  --role reviewer \
  --expertise "code-quality,security,best-practices" \
  --personality "thorough,constructive,detail-oriented"

# List all personas
persona-kit persona list

# Show persona details
persona-kit persona show "Code Reviewer"

# Switch active persona
persona-kit persona use "Code Reviewer"

# Edit persona
persona-kit persona edit "Code Reviewer" --add-expertise "performance"

# Delete persona
persona-kit persona delete "Code Reviewer"
```

### Workflow Management

```bash
# Create a workflow
persona-kit workflow create "api-development" \
  --steps "design,implement,test,document" \
  --personas "architect,developer,tester"

# List workflows
persona-kit workflow list

# Start a workflow
persona-kit workflow start "api-development"

# Check workflow status
persona-kit workflow status

# Complete current phase
persona-kit workflow complete-phase

# Abort workflow
persona-kit workflow abort
```

### Memory Management

```bash
# Show memory status
persona-kit memory status

# View persona memory
persona-kit memory show --persona "developer"

# Search memory
persona-kit memory search "authentication" --persona "developer"

# Export memory
persona-kit memory export --format json --output backup.json

# Import memory
persona-kit memory import --file shared-knowledge.json

# Clear memory (with confirmation)
persona-kit memory clear --persona "developer" --force
```

### Pattern Management

```bash
# Create a pattern
persona-kit pattern create "error-handling" \
  --type feedback-loop \
  --template "Standard error handling with logging and user feedback"

# List patterns
persona-kit pattern list

# Use pattern in workflow
persona-kit workflow use-pattern "error-handling"

# Export patterns
persona-kit pattern export --output patterns-backup.json
```

## 🤖 AI Agent Integration

### Supported AI Agents

Persona Kit integrates with multiple AI agents:

#### Claude (Anthropic)
```bash
# Configure Claude integration
persona-kit config set agent.claude.api-key "your-api-key"
persona-kit config set agent.claude.model "claude-3-sonnet-20250229"

# Test integration
persona-kit agent test claude
```

#### GPT (OpenAI)
```bash
# Configure GPT integration
persona-kit config set agent.openai.api-key "your-api-key"
persona-kit config set agent.openai.model "gpt-4"

# Test integration
persona-kit agent test openai
```

#### Local Models (Ollama)
```bash
# Configure local model
persona-kit config set agent.ollama.base-url "http://localhost:11434"
persona-kit config set agent.ollama.model "llama2:13b"

# Test integration
persona-kit agent test ollama
```

### Agent-Specific Features

#### Multi-Agent Conversations
```bash
# Start multi-agent discussion
persona-kit agent conversation start \
  --agents "developer,architect,qa" \
  --topic "system architecture design"

# Add message to conversation
persona-kit agent conversation add \
  --message "Consider security implications" \
  --persona "security-expert"
```

#### Agent Switching
```bash
# Switch between agents mid-conversation
persona-kit agent switch claude

# Compare responses from different agents
persona-kit agent compare \
  --agents "claude,gpt,ollama" \
  --prompt "Explain quantum computing"
```

## 🔧 Automation Scripts

### Script Categories

Persona Kit includes automation scripts for common tasks:

#### Bash Scripts (Linux/macOS)
```bash
# Setup new project
./persona-kit/scripts/bash/setup-persona-workflow.sh

# Create new feature
./persona-kit/scripts/bash/create-new-feature.sh "user-authentication"

# Update agent context
./persona-kit/scripts/bash/update-agent-context.sh
```

#### PowerShell Scripts (Windows)
```powershell
# Setup new project
.\persona-kit\scripts\powershell\setup-persona-workflow.ps1

# Create new feature
.\persona-kit\scripts\powershell\create-new-feature.ps1 "user-authentication"

# Update agent context
.\persona-kit\scripts\powershell\update-agent-context.ps1
```

### Custom Script Development

Create custom automation scripts:

```bash
# Create script template
persona-kit script create "my-custom-script" \
  --template bash \
  --description "Custom automation for my workflow"

# Edit script
persona-kit script edit "my-custom-script"

# Test script
persona-kit script test "my-custom-script"

# Register script
persona-kit script register "my-custom-script"
```

## 🔍 Debugging and Troubleshooting

### Enable Debug Mode

```bash
# Enable debug logging
persona-kit config set log-level DEBUG

# View debug information
persona-kit debug info

# Test specific components
persona-kit debug test persona-system
persona-kit debug test workflow-engine
persona-kit debug test memory-system
```

### Common Issues

#### Memory Issues
```bash
# Clear corrupted memory
persona-kit memory repair

# Rebuild memory index
persona-kit memory rebuild-index

# Check memory integrity
persona-kit memory integrity-check
```

#### Workflow Issues
```bash
# Reset stuck workflow
persona-kit workflow reset

# View workflow logs
persona-kit workflow logs

# Debug workflow state
persona-kit workflow debug
```

#### Agent Connection Issues
```bash
# Test agent connectivity
persona-kit agent ping

# View agent status
persona-kit agent status

# Reset agent connections
persona-kit agent reset
```

## 📊 Development Workflow

### Daily Development Process

```bash
# 1. Start development session
persona-kit session start

# 2. Review current tasks
persona-kit workflow status

# 3. Continue current workflow or start new one
persona-kit workflow continue
# or
persona-kit workflow start "feature-development"

# 4. Work with active persona
persona-kit persona use "developer"

# 5. End session and save state
persona-kit session end
```

### Code Quality Tools

```bash
# Run tests
persona-kit test run

# Check code quality
persona-kit quality check

# Format code
persona-kit format

# Lint code
persona-kit lint
```

## 🚀 Performance Optimization

### Memory Optimization

```bash
# Optimize memory usage
persona-kit memory optimize

# Set memory limits
persona-kit config set memory.max-size "1GB"

# Enable memory compression
persona-kit config set memory.compression true
```

### Performance Monitoring

```bash
# Monitor performance
persona-kit performance monitor

# View performance stats
persona-kit performance stats

# Generate performance report
persona-kit performance report --output performance.html
```

## 🔒 Security Considerations

### Secure Development Practices

```bash
# Encrypt sensitive data
persona-kit security encrypt --file secrets.json

# Set up secure communication
persona-kit security setup-tls

# Audit security settings
persona-kit security audit
```

### API Key Management

```bash
# Store API keys securely
persona-kit secrets set "openai-api-key" "your-key-here"

# Use API keys in scripts
persona-kit secrets use "openai-api-key"

# Rotate API keys
persona-kit secrets rotate "openai-api-key"
```

## 📚 Advanced Configuration

### Custom Configuration File

```toml
# .persona-kit/config.toml
[core]
default-persona = "assistant"
memory-backend = "local"
log-level = "INFO"

[agents]
default-provider = "claude"
timeout = 30
max-tokens = 4096

[workflows]
auto-save = true
parallel-execution = false
notification-enabled = true

[development]
debug = true
hot-reload = true
auto-test = true

[performance]
cache-enabled = true
compression = true
optimization-level = "high"
```

## 🚀 Next Steps

- **[Persona-Driven Development](./persona-driven.md)** - Learn the core philosophy
- **[Templates](./templates.md)** - Create reusable templates
- **[Best Practices](./best-practices.md)** - Optimize your workflow
- **[Migration Guide](./migration.md)** - Migrate from other tools

## 💡 Tips for Developers

- **Use debug mode** during development for detailed logging
- **Create custom scripts** for repetitive tasks
- **Leverage multiple AI agents** for different types of tasks
- **Monitor performance** to identify bottlenecks
- **Secure sensitive data** using built-in security features
- **Contribute back** by sharing useful scripts and configurations