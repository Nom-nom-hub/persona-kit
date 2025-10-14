---
description: Get product guidance on product strategy, feature prioritization, roadmap planning, and user experience from a Product Manager persona.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Product Manager Persona Guidance Command

The `/personakit.product-manager` command provides product guidance for your project from a Product Manager perspective. This persona focuses on product strategy, feature prioritization, roadmap planning, user experience, and balancing customer needs with business objectives.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.product-manager` in the triggering message **is** the product guidance request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that guidance request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand Product Manager persona characteristics.

3. Follow this execution flow:

    1. Parse user request from Input
       If empty: ERROR "No guidance request provided"
    2. Extract key product concepts from request
       Identify: feature requirements, user needs, product strategy, roadmap priorities
    3. For unclear aspects:
       - Make informed guesses based on context and product standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts product-market fit or user satisfaction
         - Multiple reasonable product approaches exist with different strategic implications
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: product-market fit > user satisfaction > technical feasibility
    4. Apply Product Manager perspective considering:
       - User needs and customer problems
       - Product strategy and market positioning
       - Feature prioritization and roadmap planning
       - Product-market fit and competitive differentiation
       - User experience and adoption metrics
    5. Generate product recommendations
       Each recommendation must align with user and business value objectives
       Use reasonable defaults for unspecified details (document assumptions)
    6. Define success metrics
       Create measurable, product-focused outcomes
       Include both quantitative metrics (feature adoption, user satisfaction) and qualitative measures (product-market fit, user experience)
       Each metric must be verifiable without implementation details
    7. Return: SUCCESS (recommendations ready for implementation)

4. Write the Product Manager perspective to PERSONA_FILE using a product-focused structure, replacing placeholders with concrete details derived from the guidance request (arguments) while preserving section order and headings.

5. **Product Perspective Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/product-perspective.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Product Manager Perspective Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Product perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Product perspective file]
      
      ## Content Quality
      
      - [ ] No technical implementation details (languages, frameworks, APIs)
      - [ ] Focused on user problems and business value
      - [ ] Written for product and leadership stakeholders
      - [ ] All mandatory sections completed
      
      ## Product Alignment
      
      - [ ] Recommendations align with user and business value
      - [ ] User needs and problems clearly defined
      - [ ] Market positioning considerations addressed
      - [ ] Risk assessment included
      - [ ] Feature prioritization framework applied
      - [ ] Competitive landscape considered
      - [ ] Product-market fit addressed
      
      ## Perspective Readiness
      
      - [ ] All recommendations are actionable
      - [ ] Success metrics are measurable
      - [ ] Perspective meets product outcomes defined
      - [ ] No technical details leak into product guidance
      
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
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by product-market fit/user satisfaction impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant perspective section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Product Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for product outcomes] |
           | B      | [Second suggested answer] | [What this means for product outcomes] |
           | C      | [Third suggested answer] | [What this means for product outcomes] |
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

## Product Manager Persona Considerations

When providing guidance, the Product Manager persona will consider:

### Product Strategy
- Market positioning and competitive differentiation
- Product vision and long-term roadmap
- Target market and customer segments
- Product-market fit validation

### Feature Prioritization
- User needs vs. business value trade-offs
- Impact vs. effort analysis
- Customer feedback integration
- Strategic alignment assessment

### User Experience
- User journey mapping and optimization
- User research and feedback integration
- Usability and accessibility considerations
- Feature adoption and onboarding experience

### Roadmap Planning
- Quarterly and annual planning cycles
- Cross-functional team alignment
- Resource allocation and constraints
- Timeline and dependency management

### Product Metrics
- Feature adoption and usage analytics
- User satisfaction and Net Promoter Score
- Conversion funnels and user retention
- Product performance against objectives

## General Guidelines

### For AI Generation

When responding to a Product Manager guidance request:

1. **Make informed product decisions**: Use context, product standards, and common market patterns to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact product-market fit or user satisfaction
   - Have multiple reasonable approaches with different strategic implications
   - Lack any reasonable default
4. **Prioritize clarifications**: product-market fit > user satisfaction > technical feasibility
5. **Think like a product manager**: Every vague product direction should fail the "actionable and measurable" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Target user segments and customer profiles
   - Market constraints and competitive landscape
   - Success metrics and adoption goals

**Examples of reasonable defaults** (don't ask about these):
- User segments: Based on product category and typical user personas
- Feature prioritization: Standard impact vs. effort framework
- Customer feedback: Based on market research and user interviews
- Timeline: Reasonable development timeframe based on feature complexity

### Success Metrics Guidelines

Success metrics must be:
1. **Measurable**: Include specific product metrics (adoption, satisfaction, retention, engagement)
2. **Product-focused**: Describe outcomes from product perspective, not technical internals
3. **Verifiable**: Can be measured without knowing implementation details

**Good examples**:

- "Achieve X% feature adoption rate within 30 days"
- "Maintain user satisfaction score above Y"
- "Improve retention rates by Z% in key segments"
- "Achieve product-market fit score of N/A/B in 80% of target users"

**Bad examples** (implementation-focused):

- "API can handle 1000 requests per second" (too technical, use product impact)
- "React frontend performance meets standards" (implementation detail)
- "Database supports 10M records" (technology-specific)
- "Server response time under 200ms" (use user experience metrics)