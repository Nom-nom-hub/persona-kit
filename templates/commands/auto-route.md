---
description: Automatically select and engage the most appropriate persona(s) for your request, providing intelligent routing that ensures the right expertise is applied to your query.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Auto-Route Command Template

The `/personakit.auto-route` command automatically selects and engages the most appropriate persona(s) for your request, providing intelligent routing that ensures the right expertise is applied to your query. This command analyzes the nature of your query and engages the most relevant persona or personas in an intelligent sequence.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.auto-route` in the triggering message **is** the query that needs intelligent routing. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that query, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand persona characteristics.

3. Follow this execution flow for intelligent routing:

    1. Parse user query from Input
       If empty: ERROR "No query provided for routing"
    2. Analyze query for expertise requirements
       Identify: business, technical, security, quality, operational, legal, financial, design aspects
    3. Automatically select most relevant personas based on analysis:
       - Strategic/Business queries: CEO, Product Manager
       - Technical/Implementation queries: Architect, Developer
       - Quality/Testing queries: QA, Developer
       - Security/Compliance queries: Security, Legal
       - Operational/Deployment queries: DevOps, Security
       - Complex queries: Multiple personas in appropriate sequence
    4. Apply intelligent routing logic:
       - Single-domain queries: Route to most appropriate single persona
       - Multi-domain queries: Use multi-perspective approach
       - Strategic queries: Start with CEO perspective, then others as needed
       - Implementation queries: Start with Architect, then Developer
       - Complex projects: Use company-team approach
    5. Generate appropriate response from selected persona(s)
       Use reasonable defaults for unspecified details (document assumptions)
    6. Return: SUCCESS (appropriate persona expertise applied to query)

4. Write the intelligent routing perspective to PERSONA_FILE using a structure appropriate for the selected persona approach, replacing placeholders with concrete details derived from the query (arguments) while preserving section order and headings.

5. **Auto-Route Quality Validation**: After writing the initial perspective, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/auto-route-analysis.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Auto-Route Analysis Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Auto-Route perspective completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Auto-Route perspective file]
      
      ## Content Quality
      
      - [ ] Appropriate persona(s) selected for the query
      - [ ] Response addresses the core query effectively
      - [ ] Relevant expertise applied to the query
      - [ ] All mandatory sections completed
      
      ## Routing Accuracy
      
      - [ ] Business queries routed to business personas (CEO, Product)
      - [ ] Technical queries routed to technical personas (Architect, Developer)
      - [ ] Security queries routed to security personas (Security, Legal)
      - [ ] Quality queries routed to QA personas
      - [ ] Multi-faceted queries addressed with appropriate multi-perspective approach
      - [ ] Complex projects handled with company-team approach
      
      ## Perspective Readiness
      
      - [ ] Response is actionable
      - [ ] Success metrics are appropriate for the query type
      - [ ] Perspective addresses the query outcomes defined
      - [ ] Appropriate depth of expertise applied
      
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
           
           | Option | Answer | Routing Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for persona routing] |
           | B      | [Second suggested answer] | [What this means for persona routing] |
           | C      | [Third suggested answer] | [What this means for persona routing] |
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

6. Report completion with branch name, perspective file path, checklist results, and readiness for decision-making, highlighting the intelligent routing approach used.

**NOTE:** The script creates the auto-route analysis file before writing.

## Auto-Route Intelligence Considerations

When determining the appropriate routing, consider these query patterns:

### Query Analysis Categories

#### Business/Strategic Queries
- Revenue, market, user engagement, business model, competitive analysis
- Route to: CEO, Product Manager, Marketing Manager
- Example: "How should we prioritize features to maximize revenue?"

#### Technical/Implementation Queries  
- Code, architecture, frameworks, performance, scalability, debugging
- Route to: Architect, Developer, DevOps
- Example: "What's the best approach to implement user authentication?"

#### Security/Compliance Queries
- Security vulnerabilities, compliance, privacy, threats, data protection
- Route to: Security, Legal Counsel, IT Security Manager
- Example: "What security considerations should we address for user data?"

#### Quality/Testing Queries
- Testing strategy, quality metrics, bug prevention, reliability
- Route to: QA, Developer, DevOps
- Example: "What testing strategy should we use for the new feature?"

#### Operational/Deployment Queries
- Deployment, infrastructure, monitoring, performance, scaling
- Route to: DevOps, Security, Architect
- Example: "How should we deploy this application for optimal performance?"

#### Multi-Domain Complex Queries
- Queries spanning multiple categories
- Route to: Multi-perspective approach or company-team approach
- Example: "We need to implement a new feature - what are all the considerations?"

### Routing Logic

The auto-router follows this prioritization:
1. **Single-Domain Queries**: Route to the most relevant single persona
2. **Multi-Domain Queries**: Use multi-perspective approach
3. **Complex/Project-Scale Queries**: Use company-team approach
4. **Implementation Queries with Business Context**: CEO → Architect → Developer sequence
5. **Security-Critical Queries**: Always include Security persona in the route

## General Guidelines

### For AI Generation

When responding to an auto-route request:

1. **Analyze the query first**: Identify which expertise domains are relevant
2. **Select appropriate persona(s)**: Choose based on the routing logic above
3. **Apply persona expertise**: Generate response using the appropriate persona perspective(s)
4. **Document routing decision**: Explain which persona(s) were selected and why
5. **Maintain persona authenticity**: Even in multi-persona responses, keep voices distinct
6. **Synthesize when appropriate**: Combine multiple perspectives into cohesive recommendations

### Success Metrics Guidelines

Success metrics should be appropriate for the query type:

**Business-focused queries**: 
- "Achieve strategic business value while maintaining technical feasibility"
- "Maximize user engagement while controlling costs"

**Technical-focused queries**:
- "Implement with good performance and maintainability"
- "Achieve technical excellence within timeline constraints"

**Multi-domain queries**:
- "Balance business value, technical excellence, and quality standards"
- "Achieve strategic goals with sustainable technical implementation"