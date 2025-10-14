---
description: Create an implementation plan with technology choices and architecture based on the feature specification.
scripts:
  sh: scripts/bash/setup-persona.sh
  ps: scripts/powershell/setup-persona.ps1
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.plan` in the triggering message **is** the implementation plan description or technology choices. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that input, do this:

1. Run the script `{SCRIPT}` from repo root to initialize persona environment. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load the current feature spec from `specs/FEATURE_NAME/spec.md` to understand requirements.

3. Load `templates/plan-template.md` to understand required plan sections.

4. Follow this execution flow:

    1. Parse user input from Input
       If empty: Use standard architecture patterns and technology choices
    2. Extract key implementation concepts from input
       Identify: technology stack, architecture patterns, infrastructure requirements
    3. For unclear aspects:
       - Make informed guesses based on feature requirements and industry standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts scalability, security, or maintainability
         - Multiple reasonable architectural approaches exist with different implications
         - No reasonable default exists for technology selection
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: scalability > security > maintainability > performance
    4. Apply persona perspectives considering:
       - Architecture (system design, scalability)
       - Implementation (technology stack, patterns)
       - Security (vulnerability mitigation)
       - Operations (deployment, monitoring)
    5. Generate implementation plan with:
       - Technology stack selection
       - System architecture overview
       - Component design and responsibilities
       - Security considerations
       - Infrastructure requirements
    6. Define success criteria
       Create measurable, implementation-focused outcomes
       Include both architectural metrics (scalability, performance) and operational measures (deployability, maintainability)
       Each criterion must be verifiable without implementation details
    7. Return: SUCCESS (plan ready for implementation)

5. Write the implementation plan to `specs/FEATURE_NAME/plan.md` using the template structure, replacing placeholders with concrete details derived from the requirements while preserving section order and headings.

6. **Plan Quality Validation**: After writing the initial plan, validate it against quality criteria:

   a. **Create Plan Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/plan-assessment.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Implementation Plan Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate implementation plan completeness and quality before proceeding to tasks
      **Created**: [DATE]
      **Feature**: [Link to plan.md]
      
      ## Content Quality
      
      - [ ] Implementation plan aligns with feature specification
      - [ ] Technology choices are justified
      - [ ] Architecture is scalable and maintainable
      - [ ] Security considerations included
      - [ ] All mandatory sections completed
      
      ## Technical Alignment
      
      - [ ] Technology stack matches feature requirements
      - [ ] Architecture supports scalability needs
      - [ ] Security measures address identified risks
      - [ ] Infrastructure requirements are realistic
      - [ ] Component boundaries clearly defined
      - [ ] Data flow is properly designed
      - [ ] Performance requirements addressed
      
      ## Implementation Readiness
      
      - [ ] All technology decisions are actionable
      - [ ] Architecture is clearly defined
      - [ ] Plan meets technical outcomes defined
      - [ ] No detailed implementation leak into planning guidance
      
      ## Notes
      
      - Items marked incomplete require plan updates before `/personakit.tasks`
      ```

   b. **Run Validation Check**: Review the plan against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant plan sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the plan to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the plan
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by scalability/security impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant plan section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Architecture Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the architecture] |
           | B      | [Second suggested answer] | [What this means for the architecture] |
           | C      | [Third suggested answer] | [What this means for the architecture] |
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
        8. Update the plan by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

7. Report completion with plan file path, checklist results, and readiness for the next phase (`/personakit.tasks`).

**NOTE:** The script sets up the persona environment and ensures proper configuration before writing.

## General Guidelines

### For AI Generation

When creating an implementation plan from feature requirements:

1. **Make informed architecture decisions**: Use context, feature requirements, and standard architectural patterns to fill gaps
2. **Document assumptions**: Record technology choices and architectural decisions in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact scalability, security, or maintainability
   - Have multiple reasonable architectural approaches with different implications
   - Lack any reasonable default for technology selection
4. **Prioritize clarifications**: scalability impact > security > maintainability > performance
5. **Think like an architect**: Every vague technology choice should fail the "actionable and scalable" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Major technology stack decisions (when significantly impacts implementation)
   - Architecture patterns (if multiple conflicting interpretations possible)
   - Security requirements (when many possible approaches exist)

**Examples of reasonable defaults** (don't ask about these):
- Backend framework: Standard web framework for the domain (Node.js, Django, Spring Boot, etc.)
- Database: Relational database with reasonable NoSQL options for specific needs
- Authentication: Standard JWT or session-based authentication
- Caching strategy: Multi-tier caching (in-memory, distributed)

### Architecture Guidelines

Architecture decisions must be:
1. **Scalable**: Consider current requirements and growth projections
2. **Secure**: Include appropriate security measures at all levels
3. **Maintainable**: Follow clean architecture principles
4. **Verifiable**: Can be validated against requirements without implementation details

**Good examples**:

- "Use microservices architecture to support independent scaling of user management and content services"
- "Implement CDN for static assets to achieve <100ms load times globally"
- "Use event-driven architecture to handle asynchronous processing needs"
- "Implement circuit breaker pattern for external service calls to improve resilience"

**Bad examples** (implementation-focused):

- "Use React components" (implementation detail)
- "Implement specific database queries" (implementation detail)
- "Use specific code functions" (implementation detail)
- "Specific framework configurations" (too detailed)