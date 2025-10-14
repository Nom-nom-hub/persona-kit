---
description: Automatically engage multiple personas in a coordinated manner to collaboratively work on a project like a real company team, providing comprehensive insights covering all business and technical aspects.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Collaborative Company Team Persona Command

The `/personakit.company-team` command automatically engages multiple personas in a coordinated manner to work together on a project like a real company team. This command simulates a full company environment where different roles collaborate to address all aspects of a project, from strategy to implementation.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.company-team` in the triggering message **is** the project request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that project request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand persona characteristics.

3. Follow this execution flow for automatic collaboration:

    1. Parse user project from Input
       If empty: ERROR "No project request provided"
    2. Identify project dimensions from request
       Identify: business, technical, security, quality, operational, legal, financial aspects
    3. Automatically engage appropriate personas based on project dimensions:
       - CEO: For strategic alignment and business value
       - Product Manager: For user requirements and success metrics
       - Engineering Manager: For resource and timeline feasibility
       - Architect: For system design and scalability
       - Developer: For implementation details
       - Security: For security considerations
       - QA: For testing strategy
       - DevOps: For deployment and operations
       - Additional personas as relevant: HR, Finance, Legal, etc.
    4. Facilitate cross-persona collaboration:
       - Each persona contributes their expertise
       - Personas consider input from other relevant personas
       - Conflicts between perspectives are identified and addressed
       - Consensus areas are highlighted
    5. Synthesize collaborative recommendations
       Each recommendation must consider multiple perspectives
       Use reasonable defaults for unspecified details (document assumptions)
    6. Define success metrics
       Create comprehensive, multi-faceted outcomes
       Include metrics across business, technical, security, and quality dimensions
       Each metric must be verifiable across different stakeholder groups
    7. Return: SUCCESS (collaborative recommendations ready for implementation)

4. Write the collaborative company team perspective to PERSONA_FILE using a comprehensive structure that includes input from all relevant personas, replacing placeholders with concrete details derived from the project request (arguments) while preserving section order and headings.

5. **Collaborative Perspective Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/collaborative-perspective.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Collaborative Company Team Perspective Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Collaborative perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Collaborative perspective file]
      
      ## Content Quality
      
      - [ ] Represents multiple persona perspectives
      - [ ] Balances business, technical, and operational considerations
      - [ ] Addresses cross-functional dependencies
      - [ ] All mandatory sections completed
      
      ## Multi-Perspective Alignment
      
      - [ ] Strategic perspective from CEO included
      - [ ] Technical architecture considerations addressed
      - [ ] Implementation feasibility evaluated
      - [ ] Quality and security requirements included
      - [ ] Operational and deployment aspects considered
      - [ ] Financial and resource implications evaluated
      - [ ] Risk assessment across multiple domains
      
      ## Perspective Readiness
      
      - [ ] All recommendations are actionable across multiple domains
      - [ ] Success metrics are comprehensive and measurable
      - [ ] Perspective addresses business and technical outcomes
      - [ ] Conflicting perspectives are resolved or clearly identified
      
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
           
           | Option | Answer | Multi-Persona Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for cross-persona collaboration] |
           | B      | [Second suggested answer] | [What this means for cross-persona collaboration] |
           | C      | [Third suggested answer] | [What this means for cross-persona collaboration] |
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

6. Report completion with branch name, perspective file path, checklist results, and readiness for implementation, highlighting the multi-persona collaboration outcomes.

**NOTE:** The script creates the collaborative persona guidance file before writing.

## Collaborative Company Team Persona Considerations

When providing guidance, the collaborative approach will consider input from multiple personas:

### Executive Perspectives
- **CEO**: Strategic business value and market positioning
- **CFO**: Financial implications and investment returns
- **Chief of Staff**: Organizational alignment and coordination

### Product & Management Perspectives
- **Product Manager**: User requirements and success metrics
- **Engineering Manager**: Resource allocation and timeline feasibility
- **Marketing Manager**: Market positioning and customer acquisition

### Technical Perspectives
- **Architect**: System design and scalability
- **CTO**: Technology strategy and innovation
- **Developer**: Implementation details and best practices
- **Security**: Security requirements and threat mitigation
- **DevOps**: Deployment and operational considerations

### Quality & Operations Perspectives
- **QA**: Testing strategy and quality assurance
- **Operations Manager**: Process optimization and efficiency
- **Customer Success Manager**: User adoption and satisfaction

### Supporting Functions Perspectives
- **Legal Counsel**: Compliance and risk mitigation
- **HR Director**: People impact and organizational considerations
- **Data Scientist**: Analytics and data-driven decision making
- **Chief Design Officer**: User experience and visual design
- **IT Security Manager**: Cybersecurity and risk management
- **Sales Manager**: Customer acquisition and revenue impact
- **Finance Manager**: Budget and cost management
- **Procurement Manager**: Vendor and supplier considerations
- **PR Manager**: Brand reputation and stakeholder communication

## General Guidelines

### For AI Generation

When responding to a collaborative company team request:

1. **Simulate multi-persona collaboration**: Consider multiple stakeholder perspectives simultaneously
2. **Balance competing priorities**: Acknowledge when different personas have conflicting recommendations
3. **Synthesize comprehensive solutions**: Integrate multiple perspectives into cohesive recommendations
4. **Document assumptions**: Record reasonable defaults in the Assumptions section
5. **Consider interdependencies**: Recognize how decisions in one area affect other areas
6. **Highlight consensus areas**: Identify where multiple personas agree
7. **Flag conflict areas**: Clearly identify where personas have different perspectives

### Success Metrics Guidelines

Success metrics must be:
1. **Multi-dimensional**: Include business, technical, quality, security, and operational metrics
2. **Stakeholder-focused**: Address outcomes for different stakeholder groups
3. **Verifiable**: Can be measured across different domains and functions

**Good examples**:

- "Achieve 20% increase in user engagement while maintaining 99.9% system availability"
- "Generate $X revenue within 12 months with 95% customer satisfaction and zero critical security vulnerabilities"
- "Deliver feature within 3-month timeline under $Y budget while supporting 10K concurrent users"

**Bad examples** (single-perspective):

- "Deliver feature within 3-month timeline" (only timeline, no quality/revenue/security considerations)
- "Implement with <500ms response time" (only technical, no business value)
- "Achieve 80% code coverage" (only development, no business impact)