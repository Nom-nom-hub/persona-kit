# Contributing to Persona Kit

We welcome contributions to Persona Kit! This document provides guidelines and information to help you contribute effectively.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

## Getting Started

### Prerequisites

- Python 3.11+
- Git
- [uv](https://docs.astral.sh/uv/) for package management

### Setting Up Your Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/persona-kit.git
   cd persona-kit
   ```

3. Create a virtual environment and install dependencies:
   ```bash
   uv venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   uv pip install -e .
   ```

4. Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

### Reporting Issues

- Use the issue tracker to report bugs or suggest features
- Check existing issues before creating a new one
- Provide detailed information to help us understand and reproduce the issue

### Submitting Changes

1. Make your changes in your feature branch
2. Test your changes thoroughly
3. Update documentation as needed
4. Commit your changes with clear, descriptive commit messages
5. Push your changes to your fork
6. Submit a pull request to the main repository

### Pull Request Guidelines

- Keep pull requests focused on a single feature or bug fix
- Follow the existing code style and conventions
- Include tests for new functionality
- Update documentation as needed
- Ensure all tests pass before submitting

## Development Process

### Testing

Before submitting your changes, ensure all tests pass:

```bash
# Run tests
uv run pytest

# Run linters
uv run ruff check .
uv run black --check .
```

### Code Style

We follow Python's PEP 8 style guide. Use `black` for code formatting and `ruff` for linting:

```bash
# Format code
uv run black .

# Check for linting issues
uv run ruff check .
```

## Project Structure

- `src/personakit_cli/` - Main CLI implementation
- `templates/` - Template files for persona-driven development
- `scripts/` - Cross-platform automation scripts (bash and PowerShell)
- `memory/` - Default memory files like constitution
- `docs/` - Documentation files
- `tests/` - Test files

## Adding New Personas

To add a new persona:

1. Create a command template in `templates/commands/`
2. Update the CLI code in `src/personakit_cli/__init__.py` to include the new command
3. Add appropriate documentation in README.md
4. Update the agent file template if needed

## Community

- Join the conversation in our GitHub Discussions
- Report security issues following our [Security Policy](SECURITY.md)

## Questions?

If you have questions about contributing, feel free to open an issue for clarification.

Thank you for contributing to Persona Kit!