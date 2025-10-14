# Contributing to Persona Kit

Thank you for your interest in contributing to Persona Kit! We welcome contributions from everyone, regardless of your experience level. This document will help you get started.

## 🚀 Quick Start

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Set up** your development environment
4. **Make** your changes
5. **Test** your changes
6. **Submit** a pull request

## 📋 Development Process

We use a structured development process based on our persona-driven methodology:

### 1. 📋 Constitution - Understand the Project

Before contributing, please read:
- [README.md](./README.md) - Project overview and setup
- [docs/persona-driven.md](./docs/persona-driven.md) - Core philosophy
- [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) - Community guidelines

### 2. 🎭 Choose Your Persona

When contributing, consider which persona aligns with your contribution:

- **🔧 Developer**: Code changes, bug fixes, new features
- **🎨 Designer**: UI/UX improvements, documentation formatting
- **📊 Product Manager**: Feature requests, user experience improvements
- **🧪 QA Engineer**: Testing, quality assurance, documentation
- **🏗️ Architect**: System design, performance improvements

### 3. 🔄 Follow Our Patterns

We encourage contributors to follow our established patterns:
- Use existing templates when possible
- Follow the coding standards and style guides
- Write clear commit messages
- Update documentation for any changes

## 🛠️ Development Setup

### Prerequisites

- **Python 3.8+**
- **Git**
- **Make** (optional, for using Makefile commands)
- **Virtual environment tool** (venv, conda, etc.)

### Local Development Environment

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/persona-kit.git
   cd persona-kit
   ```

2. **Set up virtual environment:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -e .
   ```

4. **Set up pre-commit hooks:**
   ```bash
   pip install pre-commit
   pre-commit install
   ```

5. **Run tests:**
   ```bash
   pytest
   ```

### Project Structure

```
persona-kit/
├── src/                    # Source code
│   └── persona_kit_cli/   # Main CLI package
├── docs/                  # Documentation
├── templates/             # Template files
├── scripts/               # Development scripts
├── tests/                 # Test files
├── workflows/             # Workflow definitions
├── personas/              # Persona definitions
├── patterns/              # Pattern definitions
└── memory/                # Memory templates
```

## 🔧 Making Changes

### Code Contributions

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes:**
   - Follow PEP 8 style guidelines
   - Add tests for new functionality
   - Update documentation as needed
   - Ensure all tests pass

3. **Commit your changes:**
   ```bash
   git add .
   git commit -m "Add amazing feature"
   ```

4. **Push to your fork:**
   ```bash
   git push origin feature/amazing-feature
   ```

### Documentation Contributions

- Use Markdown format
- Follow existing documentation structure
- Include examples where helpful
- Update related documentation when making changes

### Template Contributions

- Follow existing template patterns
- Test templates with various inputs
- Include clear documentation for template usage
- Consider edge cases and error conditions

## ✅ Testing

### Running Tests

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/test_specific.py

# Run with coverage
pytest --cov=src

# Run with verbose output
pytest -v
```

### Writing Tests

- Use descriptive test names
- Test both happy path and edge cases
- Mock external dependencies
- Follow AAA pattern (Arrange, Act, Assert)

Example test structure:
```python
def test_feature_functionality():
    # Arrange
    setup_test_data()

    # Act
    result = function_under_test()

    # Assert
    assert result == expected_value
```

## 📝 Documentation

### Building Documentation

```bash
# Install documentation dependencies
pip install -r docs/requirements.txt

# Build HTML documentation
cd docs
docfx build
```

### Documentation Guidelines

- Use clear, concise language
- Include code examples where helpful
- Keep instructions up to date
- Use consistent formatting

## 🔀 Submitting Pull Requests

### Before Submitting

- [ ] All tests pass
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] Branch is up to date with main

### Pull Request Process

1. **Create a pull request** from your feature branch
2. **Fill out the template** with clear description
3. **Reference related issues** if applicable
4. **Request review** from maintainers
5. **Respond to feedback** and make necessary changes
6. **Wait for approval** and merge

### Pull Request Template

```
## Description
Brief description of changes

## Related Issues
Closes #123

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- Test case 1
- Test case 2

## Documentation
- Updated docs/file.md
- Added examples in docs/examples/
```

## 🚨 Reporting Issues

### Bug Reports

When reporting bugs, please include:

- **Description**: Clear description of the issue
- **Steps to Reproduce**: Step-by-step instructions
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Environment**: OS, Python version, etc.
- **Additional Context**: Screenshots, error messages, etc.

### Feature Requests

When requesting features, please include:

- **Problem Statement**: What problem does this solve?
- **Proposed Solution**: How should it work?
- **Alternatives Considered**: Other approaches you've considered
- **Additional Context**: Use cases, examples, etc.

## 💬 Communication

### Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For questions and discussions
- **Email**: For private inquiries

### Community Guidelines

- Be respectful and inclusive
- Use welcoming and inclusive language
- Be collaborative
- Focus on what is best for the community
- Show empathy towards other community members

## 🎯 Contribution Ideas

Looking for ways to contribute? Here are some suggestions:

### For Beginners
- Fix typos in documentation
- Improve error messages
- Add missing test cases
- Update outdated documentation

### For Experienced Contributors
- Implement new CLI commands
- Add new persona templates
- Improve performance
- Enhance the plugin system

### For Experts
- Core architecture improvements
- New workflow patterns
- Advanced memory management features
- Integration with other tools

## 🔒 Security

If you discover a security vulnerability, please follow our [Security Policy](./SECURITY.md) instead of opening a public issue.

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the original project.

## 🙏 Acknowledgments

Thank you for contributing to Persona Kit! Your contributions help make AI-driven development more accessible and effective for everyone.

---

*This contributing guide is inspired by open-source best practices and the [Contributor Covenant](https://www.contributor-covenant.org/).*