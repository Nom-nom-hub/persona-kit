---
description: List all available personas and get guidance on how to interact with each one effectively. The entry point for persona-driven development.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Personas Command Template

The `/personakit.personas` command lists all available personas and provides guidance on how to interact with each one effectively. This command serves as the entry point for persona-driven development.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.personas` in the triggering message **is** the persona guidance request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that guidance request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand general persona characteristics.

3. Follow this execution flow:

    1. Parse user request from Input
       If empty: Display list of all personas with brief descriptions
    2. Extract persona interaction concepts from request
       Identify: specific persona queries, usage patterns, interaction guidance
    3. For unclear aspects:
       - Make informed guesses based on context and persona interaction standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts persona effectiveness or project success
         - Multiple reasonable interaction patterns exist with different outcomes
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: project success > persona effectiveness > interaction efficiency
    4. Apply general perspective considering:
       - Persona availability and expertise areas
       - Interaction sequences for complex decisions
       - Multi-perspective consultation approaches
       - Persona engagement best practices
    5. Generate persona guidance
       Each recommendation must be clear and actionable
       Use reasonable defaults for unspecified details (document assumptions)
    6. Define success metrics
       Create measurable, persona interaction outcomes
       Include both quantitative metrics (consultation frequency, decision speed) and qualitative measures (persona effectiveness, guidance quality)
       Each metric must be verifiable through persona engagement tracking
    7. Return: SUCCESS (persona guidance ready for use)

4. Write the Personas perspective to PERSONA_FILE using a persona-focused structure, replacing placeholders with concrete details derived from the guidance request (arguments) while preserving section order and headings.

5. **Personas Perspective Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/persona-interactions.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Personas Perspective Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Personas perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Personas perspective file]
      
      ## Content Quality
      
      - [ ] Persona list is complete and accurate
      - [ ] Usage guidelines are clear and actionable
      - [ ] Interaction sequences are logical
      - [ ] All mandatory sections completed
      
      ## Personas Alignment
      
      - [ ] Recommendations align with persona expertise areas
      - [ ] Interaction guidance is practical
      - [ ] Persona sequences make logical sense
      - [ ] Multi-perspective consultation approaches detailed
      - [ ] Persona engagement best practices covered
      - [ ] Available command references accurate
      - [ ] Usage examples appropriate
      
      ## Perspective Readiness
      
      - [ ] All recommendations are actionable
      - [ ] Success metrics are measurable through engagement tracking
      - [ ] Perspective meets persona interaction outcomes defined
      - [ ] No implementation details leak into persona guidance
      
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
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by project success/persona effectiveness impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant perspective section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Interaction Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for persona interaction] |
           | B      | [Second suggested answer] | [What this means for persona interaction] |
           | C      | [Third suggested answer] | [What this means for persona interaction] |
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

## Available Personas

### Executive Level
- **CEO** (`/personakit.ceo`) - Strategic business guidance, feature prioritization, market positioning
- **Engineering Manager** (`/personakit.engineering-manager`) - Team dynamics, timeline management, resource allocation

### Technical Leadership
- **Architect** (`/personakit.architect`) - System design, technology selection, scalability planning
- **Senior Developer** (`/personakit.developer`) - Implementation details, coding best practices, debugging

### Quality & Operations
- **QA Engineer** (`/personakit.qa`) - Testing strategy, quality assurance, bug prevention
- **Security Engineer** (`/personakit.security`) - Security best practices, threat modeling
- **DevOps Engineer** (`/personakit.devops`) - Deployment, infrastructure, monitoring

## Usage Guidelines

For complex projects or decisions, consider engaging personas in this order:
1. **CEO** - For strategic alignment and business value
2. **Engineering Manager** - For resource and timeline feasibility
3. **Architect** - For system design and technology decisions
4. **Developer** - For implementation details
5. **QA** - For testing strategy and quality considerations
6. **Security** - For security implementation
7. **DevOps** - For deployment and operational considerations

This sequence ensures you consider all important aspects before implementation begins.

## Command Examples

- List all personas: `/personakit.personas`
- Consult CEO: `/personakit.ceo How should we prioritize features to maximize user engagement?`
- Consult multiple personas: Use `/personakit.multi-perspective` for combined insights

## Multi-Perspective Commands

- `/personakit.multi-perspective` - Get input from multiple personas on a single topic
- `/personakit.role-play` - Simulate a team meeting with different personas
- `/personakit.guidance-check` - Validate decisions against multiple persona viewpoints

## General Guidelines

### For AI Generation

When responding to a Personas guidance request:

1. **Make informed persona recommendations**: Use context and standard persona interaction patterns to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact project success or persona effectiveness
   - Have multiple reasonable interaction patterns with different outcomes
   - Lack any reasonable default
4. **Prioritize clarifications**: project success > persona effectiveness > interaction efficiency
5. **Think like a persona coordinator**: Every vague guidance should fail the "actionable and clear" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Persona interaction priorities (when significantly impacts project outcomes)
   - Consultation sequences (if multiple conflicting interpretations possible)
   - Engagement frequency (when many possible approaches exist)

**Examples of reasonable defaults** (don't ask about these):
- Persona availability: All personas are available when needed
- Interaction approach: Standard question-and-answer format
- Consultation order: Follow the recommended sequence for complex decisions
- Multi-perspective usage: Use when decisions affect multiple domains

### Success Metrics Guidelines

Success metrics must be:
1. **Measurable**: Include specific persona engagement metrics (consultation frequency, decision speed, guidance relevance)
2. **Interaction-focused**: Describe outcomes from persona usage perspective, not just implementation details
3. **Verifiable**: Can be measured through persona engagement tracking, user satisfaction, or decision quality assessment

**Good examples**:

- "Engage CEO persona for all strategic decisions"
- "Consult appropriate persona before 90% of technical implementations"
- "Use multi-perspective validation for high-impact decisions"
- "Achieve 85% decision confidence after persona consultation"

**Bad examples** (implementation-focused):

- "Implement with <500ms response time" (performance requirement)
- "Achieve 80% code coverage" (development metric)
- "Follow clean code principles" (development practice)
- "Handle all edge cases" (development implementation)