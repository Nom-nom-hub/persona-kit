---
description: Advanced intelligent routing that coordinates multiple personas automatically based on query analysis, enabling seamless collaboration between all relevant expertise areas.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Advanced Auto-Route Command Template

The `/personakit.advanced-auto-route` command provides advanced intelligent routing that coordinates multiple personas automatically based on query analysis, enabling seamless collaboration between all relevant expertise areas. This command analyzes the nature of your query and orchestrates a collaborative response involving the most appropriate persona(s).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.advanced-auto-route` in the triggering message **is** the query that needs advanced intelligent routing. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that query, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand persona characteristics.

3. Follow this advanced execution flow for intelligent multi-persona orchestration:

    1. Parse user query from Input
       If empty: ERROR "No query provided for routing"
    2. Analyze query for expertise requirements across ALL dimensions
       Identify: business, technical, security, quality, operational, legal, financial, design, HR, marketing, sales aspects
    3. Apply automatic coordination logic:
       - Identify primary persona: The one most directly relevant to the core query
       - Identify secondary personas: Those whose input would enhance the primary response
       - Identify mandatory personas: Those required for compliance, security, or best-practice reasons
       - Determine collaboration sequence: Order in which personas should contribute
    4. Execute multi-persona collaboration:
       - Engage primary persona first
       - Have secondary personas review and add to the primary response
       - Ensure mandatory personas validate appropriately
       - Facilitate cross-persona dialogue where perspectives need to be balanced
    5. Generate comprehensive response integrating all relevant perspectives
       Use reasonable defaults for unspecified details (document assumptions)
    6. Return: SUCCESS (fully coordinated response from all relevant personas)

4. Write the advanced coordinated perspective to PERSONA_FILE using an integrated structure that shows how all relevant personas contributed to the solution, replacing placeholders with concrete details derived from the query (arguments) while preserving section order and headings.

5. **Advanced Auto-Route Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/advanced-auto-route-analysis.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Advanced Auto-Route Analysis Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Advanced Auto-Route perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Advanced Auto-Route perspective file]
      
      ## Content Quality
      
      - [ ] All relevant personas' perspectives included
      - [ ] Response addresses the core query effectively
      - [ ] Cross-persona collaboration is evident
      - [ ] All mandatory sections completed
      
      ## Coordination Accuracy
      
      - [ ] Primary persona correctly identified and contributed
      - [ ] Secondary personas appropriately engaged
      - [ ] Mandatory personas (security, legal, etc.) included when needed
      - [ ] Collaboration sequence was logical
      - [ ] Conflicting perspectives were resolved
      - [ ] Complementary perspectives were integrated
      
      ## Perspective Integration
      
      - [ ] All relevant business aspects covered (CEO, CFO, Marketing, Sales)
      - [ ] All relevant technical aspects covered (Architect, Developer, DevOps)
      - [ ] All relevant quality/security aspects covered (QA, Security, Legal)
      - [ ] All relevant operational aspects covered (Engineering Manager, Operations, HR)
      - [ ] All relevant design/experience aspects covered (Chief Design Officer, Customer Success)
      - [ ] All relevant specialist aspects covered (Data Scientist, IT Security, etc.)
      
      ## Response Readiness
      
      - [ ] Response is actionable
      - [ ] Success metrics are appropriate and comprehensive
      - [ ] Perspective addresses all relevant stakeholder outcomes
      - [ ] Appropriate depth of expertise applied from all relevant personas
      
      ## Notes
      
      - Items marked incomplete require perspective updates before implementation
      ```

   b. **Run Validation Check**: Review the perspective against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant perspective sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the perspective to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the perspective
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant perspective section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Coordination Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for multi-persona coordination] |
           | B      | [Second suggested answer] | [What this means for multi-persona coordination] |
           | C      | [Third suggested answer] | [What this means for multi-persona coordination] |
           | Custom | Provide your own answer | [Explain how to provide custom input] |
           
           **Your choice**: _[Wait for user response]_
           ```

        4. **CRITICAL - Table Formatting**: Ensure markdown tables are properly formatted:
           - Use consistent spacing with pipes aligned
           - Each cell should have spaces around content: `| Content |` not `|Content|`
           - Header separator must have at least 3 dashes: `|--------|`
           - Test that the table renders correctly in markdown preview
        5. Number questions sequentially (Q1, Q2, Q3 - max 3 total)
        6. Present all questions together before waiting for responses
        7. Wait for user to respond with their choices for all questions (e.g., "Q1: A, Q2: Custom - [details], Q3: B")
        8. Update the perspective by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with branch name, perspective file path, checklist results, and readiness for decision-making, highlighting the multi-persona orchestration approach used.

**NOTE:** The script creates the advanced auto-route analysis file before writing.

## Advanced Coordination Intelligence Considerations

When determining the appropriate multi-persona orchestration, consider these comprehensive interaction patterns:

### Comprehensive Query Analysis Categories

#### Business Strategy Dimension
- Revenue, market positioning, user acquisition, competitive analysis, growth metrics
- Engage: CEO, CFO, Marketing Manager, Sales Manager, Product Manager
- Verify with: Customer Success Manager, Data Scientist

#### Technical Implementation Dimension
- Architecture, frameworks, performance, scalability, debugging
- Engage: Architect, Developer, DevOps
- Verify with: Security, QA

#### Security & Compliance Dimension
- Security vulnerabilities, compliance requirements, privacy laws, data protection
- Engage: Security, Legal Counsel, IT Security Manager
- Verify with: Architect, Developer

#### Quality & Reliability Dimension
- Testing strategy, quality metrics, bug prevention, reliability
- Engage: QA, Developer, DevOps
- Verify with: Security, Architect

#### Operations & Deployment Dimension
- Deployment, infrastructure, monitoring, performance, scaling
- Engage: DevOps, Security, Architect
- Verify with: Developer, Operations Manager

#### People & Organization Dimension
- Team dynamics, organizational change, HR implications, training needs
- Engage: Engineering Manager, HR Director
- Verify with: Chief of Staff, Operations Manager

#### Design & User Experience Dimension
- User experience, interface design, accessibility, visual design
- Engage: Chief Design Officer, Customer Success Manager
- Verify with: Product Manager, Developer

#### Financial & Resource Dimension
- Budget, resource allocation, ROI, cost management
- Engage: CFO, Engineering Manager, Finance Manager
- Verify with: CEO, Product Manager

#### Legal & Risk Dimension
- Legal compliance, risk mitigation, contract considerations
- Engage: Legal Counsel, Chief of Staff
- Verify with: Security, HR Director

### Coordination Logic

The advanced router follows this comprehensive orchestration pattern:
1. **Query Analysis**: Identify all applicable dimensions in the user's query
2. **Primary Engagement**: Engage the most directly relevant persona first
3. **Secondary Input**: Have related personas add their specialized perspective
4. **Verification Check**: Mandatory verification by compliance/security personas when applicable
5. **Integration**: Synthesize all perspectives into a cohesive, balanced recommendation
6. **Conflict Resolution**: Address any conflicting recommendations between personas
7. **Final Validation**: Ensure all stakeholder concerns are addressed

### Cross-Persona Dependencies

The system recognizes dependencies between personas:
- CEO strategy must align with CTO technical vision
- Architect decisions need Developer feasibility confirmation
- Security requirements must be implementable by Developer
- DevOps deployment needs must influence Architect design decisions
- User requirements from Product Manager must be technically feasible per Developer
- Legal requirements from Legal Counsel must be accommodated by all other personas
- HR implications from HR Director affect Engineering Manager's team considerations

## General Guidelines

### For AI Generation

When responding to an advanced auto-route request:

1. **Analyze comprehensively**: Identify all relevant business, technical, and operational dimensions
2. **Engage systematically**: Follow the coordination logic to engage appropriate personas
3. **Integrate perspectives**: Combine all relevant viewpoints into a cohesive response
4. **Resolve conflicts**: Address any conflicting recommendations between personas
5. **Maintain authenticity**: Keep each persona's voice distinct while creating a unified response
6. **Document process**: Explain which personas were engaged and why
7. **Verify completeness**: Ensure all stakeholder perspectives are considered

### Success Metrics Guidelines

Success metrics should address ALL relevant stakeholder groups:

**Business-success metrics**:
- "Achieve strategic business value while maintaining technical feasibility and security compliance"
- "Maximize user engagement while controlling costs and meeting regulatory requirements"

**Technical-success metrics**:
- "Implement with good performance, maintainability, and security standards"
- "Achieve technical excellence within timeline, budget, and compliance constraints"

**Cross-dimensional metrics**:
- "Balance business value, technical excellence, quality standards, security requirements, user experience, operational efficiency, and regulatory compliance"
- "Achieve strategic goals with sustainable, secure, maintainable, high-quality implementation that meets all stakeholder needs"