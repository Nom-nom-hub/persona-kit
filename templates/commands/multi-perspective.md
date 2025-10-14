---
description: Combine insights from multiple personas on a single topic, allowing for multi-perspective analysis that considers business, technical, quality, and operational viewpoints simultaneously.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Multi-Perspective Persona Command

The `/personakit.multi-perspective` command combines insights from multiple personas on a single topic, allowing for multi-perspective analysis that considers business, technical, quality, and operational viewpoints simultaneously. This command enables you to get input from multiple specialized perspectives at once.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.multi-perspective` in the triggering message **is** the multi-perspective analysis request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that analysis request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand persona characteristics.

3. Follow this execution flow for multi-perspective analysis:

    1. Parse user request from Input
       If empty: ERROR "No analysis request provided"
    2. Identify relevant perspectives from request
       Identify: which personas would provide valuable input (business, technical, quality, security, etc.)
    3. Automatically engage appropriate personas based on context:
       - Select 3-5 most relevant personas for the specific request
       - Examples: Business/Technical/Security for database schema
       - Examples: Product/Engineering/QA for feature implementation
       - Examples: CEO/Architect/Security for strategic decisions
    4. Generate perspective-specific insights:
       - Each persona provides their specialized viewpoint
       - Perspectives are clearly distinguished and labeled
       - Cross-perspective considerations are highlighted
    5. Identify consensus and conflicts:
       - Highlight areas where personas agree
       - Flag areas where personas have different recommendations
       - Suggest approaches to resolve conflicts
    6. Synthesize balanced recommendations
       Each recommendation considers multiple perspectives
       Use reasonable defaults for unspecified details (document assumptions)
    7. Return: SUCCESS (multi-perspective analysis ready for decision-making)

4. Write the multi-perspective analysis to PERSONA_FILE using a structured format that presents each persona's perspective separately before synthesizing common themes, replacing placeholders with concrete details derived from the analysis request (arguments) while preserving section order and headings.

5. **Multi-Perspective Analysis Quality Validation**: After writing the initial analysis, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/multi-perspective-analysis.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Multi-Perspective Analysis Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Multi-Perspective analysis completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Multi-Perspective analysis file]
      
      ## Content Quality
      
      - [ ] Represents at least 3 distinct persona perspectives
      - [ ] Each perspective is clearly labeled and distinct
      - [ ] Cross-perspective implications addressed
      - [ ] All mandatory sections completed
      
      ## Multi-Perspective Alignment
      
      - [ ] Business perspective included (CEO/Product)
      - [ ] Technical perspective included (Architect/Developer)
      - [ ] Quality/security perspective included (QA/Security)
      - [ ] Operational considerations addressed (DevOps/Operations)
      - [ ] Conflicting viewpoints identified and addressed
      - [ ] Consensus areas highlighted
      - [ ] Balanced recommendations provided
      
      ## Analysis Readiness
      
      - [ ] All perspectives are actionable
      - [ ] Success metrics address multiple domains
      - [ ] Analysis addresses cross-functional outcomes
      - [ ] Conflicting perspectives are resolved or clearly identified
      
      ## Notes
      
      - Items marked incomplete require perspective updates before implementation
      ```

   b. **Run Validation Check**: Review the analysis against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant analysis sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the analysis to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the analysis
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant analysis section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Multi-Perspective Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for different perspectives] |
           | B      | [Second suggested answer] | [What this means for different perspectives] |
           | C      | [Third suggested answer] | [What this means for different perspectives] |
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
        8. Update the analysis by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with branch name, analysis file path, checklist results, and readiness for decision-making, highlighting the multi-perspective insights provided.

**NOTE:** The script creates the multi-perspective analysis file before writing.

## Multi-Perspective Analysis Considerations

When providing analysis, the multi-perspective approach will consider input from relevant personas:

### Business Perspectives
- **CEO**: Strategic value and market positioning
- **CFO**: Financial implications and ROI
- **Sales/Marketing**: Customer acquisition and market fit
- **Product Manager**: User requirements and success metrics

### Technical Perspectives
- **Architect**: System design and scalability
- **Developer**: Implementation feasibility and complexity
- **Security**: Security requirements and vulnerabilities
- **DevOps**: Deployment and operational considerations

### Quality & Risk Perspectives
- **QA**: Testing strategy and quality metrics
- **Legal**: Compliance and regulatory requirements
- **Risk/Security**: Risk assessment and mitigation
- **Operations**: Process and efficiency considerations

### User & Organizational Perspectives
- **Customer Success**: User adoption and satisfaction
- **HR**: People impact and organizational change
- **Data Scientist**: Analytics and data-driven insights
- **Design**: User experience and interface considerations

## General Guidelines

### For AI Generation

When responding to a multi-perspective analysis request:

1. **Select appropriate perspectives**: Choose 3-5 personas most relevant to the specific request
2. **Present distinct viewpoints**: Clearly separate each persona's perspective
3. **Identify conflicts and consensus**: Highlight where perspectives align or differ
4. **Synthesize balanced recommendations**: Integrate multiple viewpoints into cohesive advice
5. **Document assumptions**: Record reasonable defaults in the Assumptions section
6. **Consider trade-offs**: Acknowledge that different perspectives may have conflicting priorities
7. **Provide actionable insights**: Each perspective should offer concrete guidance

### Success Metrics Guidelines

Success metrics must be:
1. **Multi-dimensional**: Reflect multiple stakeholder priorities
2. **Perspective-balanced**: Address concerns from different persona viewpoints
3. **Verifiable**: Measurable across different domains and functions

**Good examples**:

- "Achieve strategic business value while maintaining technical excellence and operational efficiency"
- "Balance user experience, security requirements, and implementation feasibility"
- "Consider financial impact, customer satisfaction, and technical sustainability"

**Bad examples** (single-perspective):

- "Implement with <500ms response time" (only technical)
- "Focus on user engagement" (only user perspective)
- "Prioritize security above all else" (only security perspective)