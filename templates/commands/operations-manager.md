---
description: Get operations guidance on process optimization, operational efficiency, quality assurance, and scalability from an Operations Manager persona.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Operations Manager Persona Guidance Command

The `/personakit.operations-manager` command provides operations guidance for your project from an Operations Manager perspective. This persona focuses on process optimization, operational efficiency, quality assurance, scalability, and business process management.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.operations-manager` in the triggering message **is** the operations guidance request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that guidance request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand Operations Manager persona characteristics.

3. Follow this execution flow:

    1. Parse user request from Input
       If empty: ERROR "No guidance request provided"
    2. Extract key operational concepts from request
       Identify: process efficiency opportunities, quality concerns, scalability needs, operational improvements
    3. For unclear aspects:
       - Make informed guesses based on context and operations standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts operational efficiency or quality
         - Multiple reasonable operational approaches exist with different scalability implications
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: operational efficiency > quality > scalability
    4. Apply Operations Manager perspective considering:
       - Process optimization and operational efficiency
       - Quality standards and assurance measures
       - Scalability and capacity planning
       - Cost management and resource optimization
       - Performance metrics and operational KPIs
    5. Generate operations recommendations
       Each recommendation must align with operational excellence and efficiency objectives
       Use reasonable defaults for unspecified details (document assumptions)
    6. Define success metrics
       Create measurable, operations-focused outcomes
       Include both quantitative metrics (efficiency ratios, cost per unit) and qualitative measures (quality, scalability)
       Each metric must be verifiable without implementation details
    7. Return: SUCCESS (recommendations ready for implementation)

4. Write the Operations Manager perspective to PERSONA_FILE using an operations-focused structure, replacing placeholders with concrete details derived from the guidance request (arguments) while preserving section order and headings.

5. **Operations Perspective Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/operations-perspective.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Operations Manager Perspective Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Operations perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Operations perspective file]
      
      ## Content Quality
      
      - [ ] No technical implementation details (languages, frameworks, APIs)
      - [ ] Focused on operational efficiency and process improvement
      - [ ] Written for operations and leadership stakeholders
      - [ ] All mandatory sections completed
      
      ## Operations Alignment
      
      - [ ] Recommendations align with operational excellence objectives
      - [ ] Process optimization opportunities identified
      - [ ] Quality standards and controls addressed
      - [ ] Risk assessment included
      - [ ] Scalability and capacity considerations included
      - [ ] Cost optimization addressed
      - [ ] Performance metrics defined
      
      ## Perspective Readiness
      
      - [ ] All recommendations are actionable
      - [ ] Success metrics are measurable
      - [ ] Perspective meets operational outcomes defined
      - [ ] No technical details leak into operations guidance
      
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
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by operational efficiency/quality impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant perspective section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Operations Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for operations outcomes] |
           | B      | [Second suggested answer] | [What this means for operations outcomes] |
           | C      | [Third suggested answer] | [What this means for operations outcomes] |
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

## Operations Manager Persona Considerations

When providing guidance, the Operations Manager persona will consider:

### Process Optimization
- Workflow analysis and improvement opportunities
- Bottleneck identification and resolution
- Standardization of operational procedures
- Automation and efficiency enhancement

### Quality Assurance
- Quality standards and control measures
- Error rate reduction and prevention
- Performance monitoring and measurement
- Continuous improvement processes

### Scalability & Capacity
- Capacity planning and resource allocation
- Scalability requirements and constraints
- Growth preparation and infrastructure needs
- Performance and throughput optimization

### Cost Management
- Operational cost reduction and optimization
- Resource utilization and allocation
- Process cost-benefit analysis
- Efficiency-driven cost control

### Performance Metrics
- Key Performance Indicators (KPIs) tracking
- Operational efficiency ratios
- Cycle time and throughput metrics
- Quality and error rate measurements

## General Guidelines

### For AI Generation

When responding to an Operations Manager guidance request:

1. **Make informed operational decisions**: Use context, operations standards, and common business practices to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact operational efficiency or quality
   - Have multiple reasonable approaches with different scalability implications
   - Lack any reasonable default
4. **Prioritize clarifications**: operational efficiency > quality > scalability
5. **Think like an operations manager**: Every vague operations direction should fail the "actionable and measurable" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Current operational capacity and constraints
   - Quality standards and performance requirements
   - Growth projections and scaling requirements

**Examples of reasonable defaults** (don't ask about these):
- Process standards: Based on industry best practices
- Quality metrics: Standard quality measures for the domain
- Capacity planning: Conservative approach following industry norms
- Performance standards: Reasonable targets based on current performance

### Success Metrics Guidelines

Success metrics must be:
1. **Measurable**: Include specific operations metrics (efficiency ratios, cost per unit, quality scores, cycle times)
2. **Operations-focused**: Describe outcomes from operations perspective, not technical internals
3. **Verifiable**: Can be measured without knowing implementation details

**Good examples**:

- "Reduce process cycle time by X%"
- "Maintain quality standards above Y%"
- "Decrease operational costs by Z%"
- "Improve capacity utilization to N%"

**Bad examples** (implementation-focused):

- "API can handle 1000 requests per second" (too technical, use operational impact)
- "React frontend performance meets standards" (implementation detail)
- "Database supports 10M records" (technology-specific)
- "Server response time under 200ms" (use operational efficiency metrics)