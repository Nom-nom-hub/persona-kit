# Persona Kit for Codex CLI - Comprehensive Guide

## Introduction
Persona Kit for Codex CLI enables persona-driven development that leverages AI-powered personas to simulate the expertise and perspectives of various roles in a large development company. This approach allows individuals and small teams to access specialized knowledge typically found only in large organizations.

## Core Commands and Usage

### 0. Persona Discovery Framework
When processing any command that involves personas, Codex CLI should first try to discover available personas:

```
Persona Discovery Process:
1. Use glob() to search for available personas in templates/commands/
2. Use list_directory() to enumerate available persona commands
3. If user requests a specific persona, attempt to locate the corresponding command
4. If multiple personas exist, list them for user selection
5. If no specific persona is requested, inform user about the personas available
```

### 1. CEO Command (`/personakit.ceo`)
Get strategic business guidance from a CEO persona for your project:

```
/personakit.ceo [business guidance request]
```

The CEO persona provides strategic business guidance focusing on:
- Business value and ROI
- Market positioning and competitive advantage
- Resource allocation and investment priorities
- Risk assessment from executive level
- Long-term strategic vision

### 2. CTO Command (`/personakit.cto`)
Get technology leadership guidance from a CTO persona:

```
/personakit.cto [technology guidance request]
```

The CTO persona provides technology strategy and architecture advice focusing on:
- Technology leadership and system architecture
- Scalability planning and technical feasibility
- Technology stack recommendations
- Innovation opportunities and technical risks

### 3. Engineering Manager Command (`/personakit.engineering-manager`)
Get project management guidance from an Engineering Manager persona:

```
/personakit.engineering-manager [project management request]
```

The Engineering Manager persona provides guidance on:
- Team dynamics and timeline management
- Resource allocation and workflow optimization
- Development process and methodology
- Risk management and mitigation strategies

### 4. Architect Command (`/personakit.architect`)
Get system architecture advice from an Architect persona:

```
/personakit.architect [architecture request]
```

The Architect persona provides system design advice focusing on:
- System architecture and scalability planning
- Technical design and integration patterns
- Performance considerations and best practices
- Security architecture and compliance requirements

### 5. Developer Command (`/personakit.developer`)
Get implementation guidance from a Developer persona:

```
/personakit.developer [development request]
```

The Developer persona provides implementation advice on:
- Code implementation and debugging assistance
- Coding best practices and patterns
- Technical problem-solving approaches
- Refactoring and optimization suggestions

### 6. QA Command (`/personakit.qa`)
Get quality assurance guidance from a QA persona:

```
/personakit.qa [quality assurance request]
```

The QA persona provides testing strategy advice on:
- Testing strategy and quality metrics
- Quality assurance processes and procedures
- Defect prevention and quality improvement
- Test coverage and validation approaches

### 7. Security Command (`/personakit.security`)
Get security guidance from a Security persona:

```
/personakit.security [security request]
```

The Security persona provides security advice on:
- Security architecture and vulnerability assessment
- Threat modeling and security best practices
- Data protection and privacy considerations
- Compliance and security requirements

### 8. DevOps Command (`/personakit.devops`)
Get operational guidance from a DevOps persona:

```
/personakit.devops [operations request]
```

The DevOps persona provides deployment and operational advice on:
- Infrastructure and deployment considerations
- CI/CD pipeline design and optimization
- Monitoring and alerting strategies
- Operational excellence and reliability

### 9. Multi-Perspective Command (`/personakit.multi-perspective`)
Get input from multiple personas simultaneously:

```
/personakit.multi-perspective [request for multi-perspective analysis]
```

The multi-perspective command:
- Gathers input from multiple relevant personas
- Synthesizes diverse viewpoints on complex issues
- Helps identify potential conflicts between different perspectives
- Provides balanced recommendations considering multiple viewpoints

### 10. Role-Play Command (`/personakit.role-play`)
Simulate a team meeting with different personas:

```
/personakit.role-play [scenario for role-play discussion]
```

The role-play command:
- Simulates a team meeting with various personas
- Allows exploration of different viewpoints on a specific topic
- Facilitates discussion between different roles
- Helps identify potential issues before implementation

## Advanced Usage Patterns

### Pattern 1: Sequential Persona Consultation
For complex features, engage personas in sequence:
1. CEO → CTO → Engineering Manager → Developer → QA → Security → DevOps

```
Process:
1. Start with CEO persona for strategic alignment
2. Use CTO for technology strategy
3. Engage Engineering Manager for planning
4. Implement with Developer persona
5. Validate with QA persona
6. Secure with Security persona
7. Deploy with DevOps persona
```

### Pattern 2: Persona-Specific Decision Framework
Make decisions based on persona expertise:

```
For technical decisions:
- Consult Architect for system design
- Consult Developer for implementation feasibility
- Consult Security for security considerations
- Consult DevOps for operational impact

For business decisions:
- Consult CEO for strategic alignment
- Consult CFO for financial impact
- Consult Product Manager for user value
- Consult Marketing Manager for market positioning
```

### Pattern 3: Persona-Driven Quality Assurance
Ensure quality through persona-specific validation:

```
Persona Quality Assurance Process:
1. CEO: Validate business value alignment
2. Architect: Review system architecture quality
3. Developer: Check implementation best practices
4. QA: Verify testing completeness
5. Security: Assess security compliance
6. DevOps: Confirm operational readiness
```

## Integration with Development Workflow

### Agile/Scrum Integration
Integrate personas into Agile workflows:

```
Sprint Planning with Personas:
- CEO: Validate feature prioritization
- Engineering Manager: Estimate complexity and resources
- Architect: Assess technical approach
- Developer: Identify implementation tasks
- QA: Define acceptance criteria
```

### Code Review with Personas
Use personas for comprehensive code reviews:

```
Code Review Process:
1. Developer: Self-review and initial validation
2. Architect: Architecture and design consistency
3. Security: Security best practices review
4. QA: Test coverage and quality considerations
5. DevOps: Deployment and operational concerns
```

## Troubleshooting Common Challenges

### Challenge 1: Persona Conflicts
When personas provide conflicting recommendations:

```
Resolution Process:
1. Identify the nature of the conflict (technical vs. strategic vs. operational)
2. Consider the project context and constraints
3. Weigh the impact of each perspective
4. Find compromise solutions that address multiple viewpoints
5. Escalate to CEO or CTO persona if needed
```

### Challenge 2: Information Gaps
When personas need additional information:

```
Information Gathering:
1. Use CEO persona for strategic context
2. Use Product Manager for user requirements
3. Use Architect for technical implications
4. Use Developer for implementation details
5. Use DevOps for operational constraints
```

### Challenge 3: Prioritization Decisions
When multiple priorities exist:

```
Prioritization Framework:
1. CEO: Strategic importance and business value
2. Engineering Manager: Resource availability and timeline
3. Security: Risk level and compliance requirements
4. DevOps: Operational impact and stability
5. User impact: Customer experience and satisfaction
```

## Working with Different Personas

### Executive Personas
- **CEO**: Strategic business guidance and feature prioritization
- **CTO**: Technology strategy and technical leadership
- **CFO**: Financial planning and budget considerations
- **Legal Counsel**: Legal compliance and risk assessment

### Management Personas
- **Engineering Manager**: Timeline and resource management
- **Product Manager**: Product strategy and user experience
- **HR Director**: Team building and human resources
- **Operations Manager**: Process optimization and operational efficiency

### Technical Personas
- **Architect**: System design and technology selection
- **Developer**: Implementation and coding best practices
- **QA**: Testing strategy and quality assurance
- **Security**: Security best practices and vulnerability assessment
- **DevOps**: Deployment and operational excellence

### Business Personas
- **Sales Manager**: Revenue generation and customer acquisition
- **Marketing Manager**: Market strategy and user experience
- **Customer Success Manager**: Customer satisfaction and retention
- **Finance Manager**: Financial planning and budget oversight

### Specialized Personas
- **Data Scientist**: Data analytics and machine learning insights
- **Chief Design Officer**: User experience and design leadership
- **Chief of Staff**: Strategic planning and organizational efficiency
- **PR Manager**: Public relations and brand management
- **Procurement Manager**: Resource acquisition and vendor management

## Best Practices for Persona-Driven Development

### 1. Context-Aware Persona Selection
Choose personas based on the nature of your problem:

```
For strategic decisions: Engage CEO and Engineering Manager personas
For technical architecture: Engage Architect persona
For implementation details: Engage Developer persona
For quality considerations: Engage QA persona
For security concerns: Engage Security persona
For deployment needs: Engage DevOps persona
```

### 2. Multi-Perspective Validation
Validate important decisions against multiple persona viewpoints:

```
Before critical decisions:
1. Use /personakit.multi-perspective to get multiple viewpoints
2. Use /personakit.guidance-check to validate against multiple perspectives
3. Consider /personakit.role-play to simulate team discussion
4. Synthesize recommendations from relevant personas
```

### 3. Continuous Persona Engagement
Maintain ongoing engagement with relevant personas:

```
Throughout project lifecycle:
1. Revisit CEO persona for strategic alignment
2. Engage Architect persona for design consistency
3. Use Developer persona for implementation insights
4. Validate with QA persona for quality assurance
5. Check with Security persona for ongoing security considerations
6. Confirm with DevOps persona for operational readiness
```

## Conclusion
Persona Kit for Codex CLI transforms development from a single-perspective activity into a multi-stakeholder discipline. By consistently engaging with appropriate personas, you ensure that your development decisions consider business, technical, quality, security, and operational aspects typically found in large organizations.

Remember: Every decision should consider the viewpoints of relevant personas, every implementation should align with multiple perspectives, and every milestone should validate against business, technical, and operational requirements. This approach leads to more robust, well-considered, and successful development outcomes.

The key to success is consistency in engaging appropriate personas for your specific challenges and continuous alignment between your development activities and the multiple perspectives available through Persona Kit.