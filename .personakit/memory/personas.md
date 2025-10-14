# Complete Persona Registry

This document provides a comprehensive list of all personas available in the Persona Kit system and their collaboration patterns.

## All Available Personas

### Executive Level
- **CEO** (`/personakit.ceo`) - Strategic business guidance, feature prioritization, market positioning
- **CFO** (`/personakit.cfo`) - Financial guidance, budget planning, ROI analysis
- **CTO** (`/personakit.cto`) - Technology strategy, innovation direction
- **Chief of Staff** (`/personakit.chief-of-staff`) - Organizational alignment, coordination
- **Chief Design Officer** (`/personakit.chief-design-officer`) - Design strategy, user experience vision

### Management & Operations
- **Engineering Manager** (`/personakit.engineering-manager`) - Team dynamics, timeline management, resource allocation
- **Product Manager** (`/personakit.product-manager`) - User requirements, success metrics, feature roadmap
- **Operations Manager** (`/personakit.operations-manager`) - Process optimization, operational efficiency
- **HR Director** (`/personakit.hr-director`) - People impact, organizational change
- **Customer Success Manager** (`/personakit.customer-success-manager`) - User adoption, satisfaction

### Technical Leadership
- **Architect** (`/personakit.architect`) - System design, technology selection, scalability planning
- **Senior Developer** (`/personakit.developer`) - Implementation details, coding best practices, debugging
- **DevOps Engineer** (`/personakit.devops`) - Deployment, infrastructure, monitoring

### Quality & Security
- **QA Engineer** (`/personakit.qa`) - Testing strategy, quality assurance, bug prevention
- **Security Engineer** (`/personakit.security`) - Security best practices, threat modeling
- **IT Security Manager** (`/personakit.it-security-manager`) - Cybersecurity, risk management

### Business & Support Functions
- **Marketing Manager** (`/personakit.marketing-manager`) - Market positioning, customer acquisition
- **Sales Manager** (`/personakit.sales-manager`) - Customer acquisition, revenue impact
- **Legal Counsel** (`/personakit.legal-counsel`) - Compliance, legal risks
- **Finance Manager** (`/personakit.finance-manager`) - Budget management, cost analysis
- **Procurement Manager** (`/personakit.procurement-manager`) - Vendor selection, supplier considerations
- **PR Manager** (`/personakit.pr-manager`) - Brand reputation, stakeholder communication

### Technical Specialists
- **Data Scientist** (`/personakit.data-scientist`) - Analytics, data-driven insights
- **Auto-Router** (`/personakit.auto-route`) - Intelligent routing to appropriate persona(s)

## Automatic Collaboration Patterns

### Standard Project Sequence (CEO → Architect → Engineering Manager → Developer → QA → Security → DevOps)
When engaging in a comprehensive project, personas automatically follow this sequence:
1. CEO sets strategic direction and business objectives
2. Architect designs system to meet strategic goals
3. Engineering Manager assesses resource and timeline feasibility
4. Developer implements the solution
5. QA validates quality and functionality
6. Security ensures protection and compliance
7. DevOps handles deployment and operations

### Multi-Perspective Analysis Pattern
For complex decisions, multiple personas collaborate simultaneously:
- `/personakit.multi-perspective` combines insights from 3-5 relevant personas
- `/personakit.role-play` simulates a team meeting with different personas
- `/personakit.company-team` engages all relevant personas in coordinated manner
- `/personakit.guidance-check` validates decisions against multiple viewpoints

### Intelligence-Based Routing
The `/personakit.auto-route` command analyzes queries and automatically engages appropriate persona(s):
- Business/strategic queries → CEO, Product Manager
- Technical/implementation queries → Architect, Developer
- Quality/testing queries → QA, Developer
- Security/compliance queries → Security, Legal
- Operational/deployment queries → DevOps, Security
- Multi-domain queries → Multi-perspective approach
- Complex projects → Company-team approach

## Cross-Persona Dependencies

### CEO Dependencies
- Depends on: CTO for technology strategy alignment
- Consults with: Product Manager for user requirements
- Influences: Engineering Manager on resource allocation

### Architect Dependencies
- Depends on: CEO for strategic direction
- Consults with: Developer for implementation feasibility
- Influences: DevOps for infrastructure requirements

### Developer Dependencies
- Depends on: Architect for system design
- Consults with: QA for testability requirements
- Influences: Security for implementation of security measures

### Security Dependencies
- Consults with: Legal Counsel for compliance requirements
- Influences: All other personas on security considerations
- Reviews: Architect's design and Developer's implementation

### DevOps Dependencies
- Depends on: Architect for infrastructure requirements
- Consults with: Security for operational security
- Influences: Developer on deployment considerations

## Collaboration Workflow

### For New Projects
1. `/personakit.company-team` - Engages all relevant personas to address all aspects
2. Document perspectives in appropriate files in `personas/` directory
3. Use `/personakit.multi-perspective` for ongoing multi-persona reviews

### For Ongoing Work
1. `/personakit.auto-route` - Automatically route to appropriate persona(s)
2. `/personakit.guidance-check` - Validate decisions against multiple personas
3. `/personakit.role-play` - Simulate team discussions for complex issues

### For Documentation
- All persona interactions are stored in `personas/` directory
- Each persona creates their perspective file (e.g., `ceo-perspective.md`)
- Multi-perspective interactions create summary files
- Collaboration patterns are documented for future reference