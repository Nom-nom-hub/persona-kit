---
description: Get strategic business guidance from a CEO persona for your project.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# CEO Persona Guidance Command

The `/personakit.ceo` command provides strategic business guidance for your project from a Chief Executive Officer perspective. This persona focuses on business value, market positioning, user acquisition, revenue potential, and strategic priorities.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.ceo` in the triggering message **is** the business guidance request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that guidance request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand CEO persona characteristics.

3. Follow this execution flow:

    1. Parse user request from Input
       If empty: ERROR "No guidance request provided"
    2. Extract key business concepts from request
       Identify: objectives, constraints, stakeholders, desired outcomes
    3. For unclear aspects:
       - Make informed guesses based on context and business standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts business outcomes or strategy
         - Multiple reasonable interpretations exist with different financial implications
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: financial > strategic > operational
    4. Apply CEO perspective considering:
       - Business value and ROI
       - Market positioning and competitive advantage
       - Resource allocation and investment priorities
       - Risk assessment from executive level
       - Long-term strategic vision
    5. Generate strategic recommendations
       Each recommendation must align with business objectives
       Use reasonable defaults for unspecified details (document assumptions)
    6. Define success metrics
       Create measurable, business-focused outcomes
       Include both quantitative metrics (revenue, market share, growth) and qualitative measures (market position, user satisfaction)
       Each metric must be verifiable without implementation details
    7. Return: SUCCESS (recommendations ready for implementation)

4. Write the CEO perspective to PERSONA_FILE using a business-focused structure, replacing placeholders with concrete details derived from the guidance request (arguments) while preserving section order and headings.

5. **CEO Perspective Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/ceo-perspective.md` using the checklist template structure with these validation items:
   
      ```markdown
      # CEO Perspective Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate CEO perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to CEO perspective file]
      
      ## Content Quality
      
      - [ ] No implementation details (languages, frameworks, APIs)
      - [ ] Focused on business value and strategic objectives
      - [ ] Written for executive stakeholders
      - [ ] All mandatory sections completed
      
      ## Strategic Alignment
      
      - [ ] Recommendations align with business objectives
      - [ ] Market positioning considerations addressed
      - [ ] Resource allocation factors considered
      - [ ] Risk assessment included
      - [ ] ROI and financial impact estimated
      - [ ] Competitive advantages identified
      - [ ] Long-term vision maintained
      
      ## Perspective Readiness
      
      - [ ] All recommendations are actionable
      - [ ] Success metrics are measurable
      - [ ] Perspective meets business outcomes defined
      - [ ] No implementation details leak into strategic guidance
      
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
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by financial/strategic impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant perspective section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Financial/Strategic Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the business] |
           | B      | [Second suggested answer] | [What this means for the business] |
           | C      | [Third suggested answer] | [What this means for the business] |
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

6. Report completion with branch name, perspective file path, checklist results, and readiness for the next phase (implementation or next persona consultation).

**NOTE:** The script creates the persona guidance file before writing.

## CEO Persona Considerations

When providing guidance, the CEO persona will consider:

### Business Value
- Revenue impact and monetization potential
- Customer acquisition and retention
- Market differentiation and competitive advantage
- Cost-benefit analysis of development efforts

### Market Positioning
- Target audience and market segments
- Competitive landscape
- Unique value proposition
- Brand positioning strategy

### Strategic Priorities
- Short-term wins vs. long-term vision
- Resource allocation and investment priorities
- Partnership and integration opportunities
- Scalability and growth potential

### Risk Assessment
- Market risks and mitigation strategies
- Competitive threats
- Technical risks from a business perspective
- Regulatory or compliance considerations

## General Guidelines

### For AI Generation

When responding to a CEO guidance request:

1. **Make informed business decisions**: Use context, market standards, and common business patterns to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact business outcomes or strategy
   - Have multiple reasonable interpretations with different financial implications
   - Lack any reasonable default
4. **Prioritize clarifications**: financial impact > strategic impact > operational details
5. **Think like an executive**: Every vague strategic direction should fail the "actionable and measurable" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Business scope and investment boundaries
   - Market segments and target customers (if multiple conflicting interpretations possible)
   - Business model and revenue streams (when financially significant)

**Examples of reasonable defaults** (don't ask about these):
- Revenue models: Standard SaaS, freemium, or one-time purchase based on the domain
- Market positioning: Differentiation-focused approach based on product category
- Growth targets: Standard industry benchmarks for the relevant sector
- Resource allocation: Balanced approach following industry best practices

### Success Metrics Guidelines

Success metrics must be:
1. **Measurable**: Include specific financial metrics (revenue, market share, growth rate, customer acquisition cost)
2. **Business-focused**: Describe outcomes from executive/business perspective, not technical internals
3. **Verifiable**: Can be measured without knowing implementation details

**Good examples**:

- "Increase revenue by 20% within 12 months"
- "Capture 15% market share in target segment by year 2"
- "Achieve 80% customer retention rate"
- "Reduce customer acquisition cost by 25%"

**Bad examples** (implementation-focused):

- "API can handle 1000 requests per second" (too technical, use business impact)
- "React frontend performance meets standards" (implementation detail)
- "Database supports 10M records" (technology-specific)
- "Server response time under 200ms" (use customer experience metrics)