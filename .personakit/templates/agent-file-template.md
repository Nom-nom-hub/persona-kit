# Persona Kit Agent Configuration

This configuration file sets up the Persona Kit environment for your AI assistant. It provides access to multiple AI personas that simulate various roles in a development company.

## Directory Structure

```
.
├── .personakit/                 # Persona Kit configuration directory
│   ├── memory/                  # Long-term memory for the AI assistant
│   │   ├── constitution.md      # Project principles, guidelines & governance
│   │   └── personas.md          # AI persona definitions and characteristics
│   ├── scripts/                 # Cross-platform automation scripts
│   │   ├── bash/                # POSIX shell scripts (Linux/macOS)
│   │   │   ├── common.sh        # Common utility functions
│   │   │   ├── check-prerequisites.sh # Prerequisites validation
│   │   │   ├── create-new-persona.sh    # Create new persona interactions
│   │   │   ├── setup-persona.sh         # Persona setup & configuration
│   │   │   └── update-agent-context.sh  # Context management for AI
│   │   └── powershell/          # PowerShell scripts (Windows/cross-platform)
│   │       ├── common.ps1       # Common utility functions
│   │       ├── check-prerequisites.ps1  # Prerequisites validation
│   │       ├── create-new-persona.ps1   # Create new persona interactions
│   │       ├── setup-persona.ps1        # Persona setup & configuration
│   │       └── update-agent-context.ps1 # Context management for AI
│   ├── templates/               # Template files for personas and responses
│   │   ├── commands/            # Persona command templates
│   │   │   ├── ceo.md           # CEO persona guidance template
│   │   │   ├── engineering-manager.md   # Engineering manager template
│   │   │   ├── architect.md     # Software architect template
│   │   │   ├── developer.md     # Developer persona template
│   │   │   ├── qa.md            # QA engineer template
│   │   │   ├── devops.md        # DevOps engineer template
│   │   │   ├── security.md      # Security engineer template
│   │   │   └── product.md       # Product manager template
│   │   ├── agent-file-template.md      # This file
│   │   ├── checklist-template.md       # Quality checklist template
│   │   ├── persona-template.md         # Base persona definition template
│   │   └── guidance-template.md        # Guidance generation template
│   └── vision.md              # Project vision and principles
├── personas/                 # Generated persona interactions and outputs
│   └── [YYYY-MM-DD-persona-name]/ # Date-stamped persona interaction sessions
│       ├── ceo-perspective.md      # CEO persona analysis and guidance
│       ├── engineering-perspective.md  # Engineering manager perspective
│       ├── architecture-notes.md       # Architectural considerations
│       ├── development-plan.md         # Developer-level implementation plan
│       ├── qa-assessment.md            # Quality assurance assessment
│       ├── security-review.md          # Security review and recommendations
│       ├── devops-considerations.md    # DevOps and deployment notes
│       └── multi-perspective-summary.md # Combined multi-perspective summary
└── .gitignore               # Standard git ignore for persona kit projects
```

## Available Slash Commands

After loading this configuration, you'll have access to these commands for persona-driven development:

### Core Persona Commands

Essential commands for accessing different development perspectives:

| Command                  | Description                                                           |
|--------------------------|-----------------------------------------------------------------------|
| `/personakit.personas`   | List all available personas and their expertise areas                 |
| `/personakit.ceo`        | Access the CEO persona for strategic business guidance                |
| `/personakit.cfo`        | Get financial guidance, budget planning, and ROI analysis             |
| `/personakit.cto`        | Consult with the CTO persona for technology strategy and innovation   |
| `/personakit.chief-design-officer` | Access design strategy and user experience vision           |
| `/personakit.chief-of-staff` | Get organizational alignment and coordination guidance            |
| `/personakit.engineering-manager` | Get insights from an engineering manager perspective         |
| `/personakit.product-manager` | Access product management guidance for user requirements and success metrics |
| `/personakit.architect`  | Consult with a software architect persona for design decisions        |
| `/personakit.developer`  | Get hands-on development guidance from a senior developer persona     |
| `/personakit.qa`         | Access QA engineer perspective for testing strategy and quality       |
| `/personakit.security`   | Get security best practices and vulnerability considerations          |
| `/personakit.devops`     | Access DevOps perspective for deployment and infrastructure guidance  |
| `/personakit.customer-success-manager` | Get guidance on user adoption and satisfaction                |
| `/personakit.data-scientist` | Access data-driven insights and analytics guidance                 |
| `/personakit.hr-director` | Get guidance on people impact and organizational change             |
| `/personakit.it-security-manager` | Access cybersecurity and risk management expertise              |
| `/personakit.legal-counsel` | Get legal compliance and risk guidance                            |
| `/personakit.marketing-manager` | Access market positioning and customer acquisition advice       |
| `/personakit.operations-manager` | Get process optimization and operational efficiency guidance   |
| `/personakit.sales-manager` | Get customer acquisition and revenue impact guidance              |
| `/personakit.finance-manager` | Access budget and cost management guidance                      |
| `/personakit.procurement-manager` | Get vendor and supplier consideration guidance                |
| `/personakit.pr-manager` | Access brand reputation and stakeholder communication advice        |

### Advanced Persona Commands

Additional commands for enhanced multi-perspective development:

| Command                  | Description                                                           |
|--------------------------|-----------------------------------------------------------------------|
| `/personakit.multi-perspective` | Combine insights from multiple personas on a single topic     |
| `/personakit.role-play`  | Simulate a team meeting with different personas providing input       |
| `/personakit.guidance-check` | Validate decisions against multiple persona viewpoints         |
| `/personakit.company-team` | Engage multiple personas in coordinated manner like a real company team |
| `/personakit.auto-route` | Automatically route to the most appropriate persona(s) for your query |
| `/personakit.advanced-auto-route` | Advanced intelligent routing with comprehensive multi-persona coordination |
| `/personakit.orchestrator` | Full team orchestration - engages all relevant personas automatically |
| `/personakit.analyze` | Cross-artifact consistency and coverage analysis                    |
| `/personakit.specify` | Create or update feature specification from natural language        |
| `/personakit.plan` | Create implementation plan with technology choices and architecture  |
| `/personakit.clarify` | Clarify underspecified areas before planning                        |
| `/personakit.tasks` | Generate actionable development tasks from the implementation plan   |
| `/personakit.checklist` | Generate custom quality checklists for validation                 |
| `/personakit.implement` | Execute development tasks to build the feature according to plan and spec |

## Usage Examples

### 1. CEO Perspective
Get strategic business guidance:
```
/personakit.ceo How should we prioritize features to maximize user engagement and revenue in our photo organization app?
```

### 2. Architecture Consultation
Get architectural guidance:
```
/personakit.architect Review the proposed architecture for our photo organization app and suggest improvements focusing on scalability and maintainability.
```

### 3. Development Guidance
Get implementation details:
```
/personakit.developer What's the best approach to implement drag-and-drop functionality in the photo organization app using vanilla JavaScript?
```

### 4. Multi-Perspective Analysis
Get multiple viewpoints:
```
/personakit.multi-perspective Analyze the proposed database schema for the photo organization app from development, QA, and security perspectives.
```

### 5. Quality Assurance
Get testing strategy:
```
/personakit.qa What testing strategy should we implement for the drag-and-drop functionality in our photo organization app?
```

## Environment Variables

| Variable         | Description                                                                                    |
|------------------|------------------------------------------------------------------------------------------------|
| `PERSONAKIT_FEATURE` | Override feature detection for non-Git repositories. Set to the feature directory name (e.g., `2024-11-15-photo-sharing`) to work on a specific feature when not using Git branches.<br/>**Must be set in the context of the agent you're working with prior to using personas or follow-up commands. |

## Best Practices

1. **Default to Collaboration**: For complex decisions, automatically engage multiple personas using `/personakit.company-team` or `/personakit.multi-perspective` rather than single-persona consultation
2. **Use Multiple Perspectives**: Before making major architectural decisions, consult multiple personas to understand various implications
3. **Sequential Consultation**: For complex features, follow the sequence: CEO → Architect → Engineering Manager → Developer → QA → Security → DevOps
4. **Intelligent Routing**: Use `/personakit.auto-route` for automatic routing to the most appropriate persona(s) for your query
5. **Documentation**: Document persona recommendations in the `personas/` directory for future reference
6. **Validation**: Use `/personakit.guidance-check` to validate decisions against multiple personas
7. **Team Simulation**: Use `/personakit.role-play` to simulate team discussions before implementing controversial changes

## Troubleshooting

If persona commands are not available, ensure that:
1. You've loaded this configuration file in your AI assistant
2. The `.personakit` directory exists in your project root
3. You're running commands from the project root directory
4. The required scripts are properly configured in `.personakit/scripts/`

For additional help, use `/personakit.personas` to list available commands and their usage.