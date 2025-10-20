# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.21] - 2025-10-20

### Fixed
- **CLI Installation Error**: Fixed naming mismatch between script entry point and installation command
  - Changed script entry point from `personakit` to `persona-kit` in `pyproject.toml`
  - Updated all documentation to use `persona-kit` consistently
  - Users can now successfully install with `uv tool install persona-kit --from git+https://github.com/Nom-nom-hub/persona-kit.git`

### Changed
- **CLI Command Rename**: Renamed CLI command from `personakit` to `persona-kit` for consistency
- **Documentation Updates**: Updated all installation and usage examples to use correct command name

## [0.0.20] - 2025-10-19

### Added
- Recent git commits and improvements since v0.0.19

## [0.0.5] - 2025-10-14

### Added
- Initial release of Persona Kit
- Core persona-driven development framework
- Comprehensive documentation structure
- Template system for personas, patterns, and workflows
- CLI tools for project management
- Memory system for context retention
- Pattern library for common development scenarios

### Changed
- Restructured project organization for better maintainability
- Updated documentation to reflect persona-driven philosophy
- Enhanced CLI interface for better user experience

### Fixed
- Minor configuration issues in project setup
- Documentation formatting inconsistencies

## [0.0.4] - 2025-10-13

### Added
- **Core Features**
  - Persona Kit framework for AI-driven development
  - Constitution system for project governance
  - Pattern library for development workflows
  - Template system for rapid setup
  - Memory management for context retention

- **Documentation**
  - Comprehensive README with setup instructions
  - Installation and quickstart guides
  - Local development environment setup
  - Best practices and usage examples

- **Development Tools**
  - CLI tools for project initialization
  - Script templates for common tasks
  - Workflow definitions for different development scenarios

- **Project Structure**
  - Organized personas by role (Developer, Designer, QA, etc.)
  - Pattern categorization by use case
  - Template system for consistent outputs
  - Memory templates for context management

### Philosophy
- Established persona-driven development methodology
- Defined 5-step workflow process
- Created knowledge management systems
- Implemented continuous improvement loops

## [0.0.3] - 2025-10-13

### Added
- **Initial Concept**
  - Basic persona-driven development framework
  - Core philosophy documentation
  - Initial template structures
  - Basic CLI prototype

- **Research & Planning**
  - Market analysis for AI development tools
  - Competitive landscape assessment
  - Technical feasibility studies
  - User experience research

### Documentation
- Initial project documentation
- Technical specifications
- Development roadmap
- API design concepts

## [0.0.2] - 2025-10-12

### Added
- **Project Genesis**
  - Initial project conception
  - Problem statement definition
  - Solution approach brainstorming
  - Technology stack selection

- **Planning**
  - Project scope definition
  - Timeline estimation
  - Resource planning
  - Risk assessment

## Types of Changes

- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Now removed features
- **Fixed** - Bug fixes
- **Security** - Vulnerability fixes

## Contributing

When contributing to this project, please ensure you update the changelog with your changes.

## Version History

- **v0.0.21** (2025-10-20) - CLI installation fix and command rename
- **v0.0.20** (2025-10-19) - Latest stable release
- **v0.0.5** (2025-10-14) - First stable release
- **v0.0.4** (2025-10-13) - Beta release with core features
- **v0.0.3** (2025-10-12) - Initial development version

---

*This changelog follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.*