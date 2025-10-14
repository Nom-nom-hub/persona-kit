---
description: Validate decisions against multiple persona viewpoints to ensure comprehensive consideration of business, technical, quality, and operational implications before implementation.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Guidance Check Persona Command

The `/personakit.guidance-check` command validates decisions against multiple persona viewpoints to ensure comprehensive consideration of business, technical, quality, and operational implications before implementation. This command serves as a checkpoint to ensure that major decisions have been evaluated from all relevant perspectives.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.guidance-check` in the triggering message **is** the guidance validation request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that validation request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand persona characteristics.

3. Follow this execution flow for guidance validation:

    1. Parse user request from Input (should contain a decision, plan, or approach to validate)
       If empty: ERROR "No guidance to validate provided"
    2. Identify key decision dimensions from request
       Identify: business, technical, security, quality, operational, legal, financial aspects
    3. Critically evaluate the request from multiple persona perspectives:
       - CEO: Strategic alignment and business value
       - Product Manager: User requirements and success metrics
       - Engineering Manager: Resource and timeline feasibility
       - Architect: Technical soundness and scalability
       - Developer: Implementation practicality and complexity
       - Security: Security implications and vulnerabilities
       - QA: Quality and testing considerations
       - DevOps: Deployment and operational implications
       - Additional personas as relevant to the decision
    4. Identify potential issues and recommend improvements:
       - Highlight missing considerations or risks
       - Suggest alternative approaches where appropriate
       - Flag potential conflicts or implementation challenges
    5. Generate comprehensive validation feedback:
       - Strengths of the approach from each perspective
       - Areas needing improvement or additional consideration
       - Recommended changes or additions
       - Risk assessment across all relevant domains
    6. Return: SUCCESS (comprehensive validation feedback ready for decision refinement)

4. Write the guidance validation to PERSONA_FILE using a structured format that evaluates the request from each relevant persona perspective, replacing placeholders with concrete details derived from the validation request (arguments) while preserving section order and headings.

5. **Guidance Validation Quality Validation**: After writing the initial validation, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/guidance-validation.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Guidance Validation Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Guidance validation completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Guidance validation file]
      
      ## Content Quality
      
      - [ ] Evaluates from multiple distinct persona perspectives
      - [ ] Provides constructive feedback and recommendations
      - [ ] Balances critique with recognition of strengths
      - [ ] All mandatory sections completed
      
      ## Multi-Perspective Validation
      
      - [ ] Business perspective evaluation included (CEO/Product)
      - [ ] Technical perspective evaluation included (Architect/Developer)
      - [ ] Quality and security perspectives evaluated (QA/Security)
      - [ ] Operational considerations evaluated (DevOps/Operations)
      - [ ] Risk assessment across multiple domains completed
      - [ ] Improvement recommendations provided
      - [ ] Feasibility assessment completed
      
      ## Validation Readiness
      
      - [ ] Feedback is actionable and specific
      - [ ] Recommendations are practical and achievable
      - [ ] Validation addresses both risks and opportunities
      - [ ] Conflicting perspectives are constructively addressed
      
      ## Notes
      
      - Items marked incomplete require validation updates before implementation
      ```

   b. **Run Validation Check**: Review the validation against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant validation sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the validation to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the validation
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant validation section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Validation Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for validation quality] |
           | B      | [Second suggested answer] | [What this means for validation quality] |
           | C      | [Third suggested answer] | [What this means for validation quality] |
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
        8. Update the validation by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with branch name, validation file path, checklist results, and readiness for implementation, highlighting the validation findings and recommendations.

**NOTE:** The script creates the guidance validation file before writing.

## Guidance Check Considerations

When providing validation, the guidance check approach will evaluate from multiple persona perspectives:

### Business Validation
- **CEO**: Strategic alignment and market positioning
- **CFO**: Financial implications and ROI assessment
- **Sales/Marketing**: Customer acquisition and market fit
- **Product Manager**: User value and success metrics

### Technical Validation
- **Architect**: System design soundness and scalability
- **CTO**: Technology strategy alignment and innovation impact
- **Developer**: Implementation feasibility and complexity
- **Security**: Security posture and vulnerability assessment

### Quality & Risk Validation
- **QA**: Testability and quality assurance approach
- **DevOps**: Deployment and operational feasibility
- **Legal**: Compliance and regulatory risks
- **Risk/Security**: Risk assessment and mitigation strategies

### Operational Validation
- **Engineering Manager**: Resource allocation and timeline feasibility
- **Operations Manager**: Process efficiency and operational impact
- **Customer Success**: User adoption and satisfaction impact
- **HR**: People impact and organizational change considerations

### Supporting Function Validation
- **Data Scientist**: Analytics and data-driven decision impact
- **Design**: User experience and interface considerations
- **IT Security**: Cybersecurity and information protection
- **Finance**: Budget and cost management implications
- **Procurement**: Vendor and supplier considerations
- **PR**: Brand reputation and communication implications

## General Guidelines

### For AI Generation

When responding to a guidance check validation request:

1. **Be thorough and constructive**: Evaluate from all relevant perspectives with actionable feedback
2. **Identify risks and opportunities**: Highlight both potential issues and positive aspects
3. **Suggest specific improvements**: Provide clear recommendations for enhancement
4. **Consider feasibility**: Assess whether recommendations are practically achievable
5. **Maintain persona authenticity**: Each evaluation should reflect the specific priorities of that persona
6. **Balance perspectives**: Acknowledge when different personas might have conflicting views
7. **Focus on outcomes**: Evaluate how the decision will impact desired business and technical outcomes

### Success Metrics Guidelines

Validation should address metrics that are:
1. **Comprehensive**: Cover business, technical, quality, and operational outcomes
2. **Measurable**: Specific enough to track actual impact
3. **Balanced**: Consider multiple stakeholder perspectives