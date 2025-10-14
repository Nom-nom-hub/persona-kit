---
description: Orchestrates full team collaboration by automatically engaging all relevant personas, coordinating their inputs, and synthesizing a comprehensive, multi-perspective solution that addresses all stakeholder concerns.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Full Team Orchestrator Command Template

The `/personakit.orchestrator` command orchestrates full team collaboration by automatically engaging all relevant personas, coordinating their inputs, and synthesizing a comprehensive, multi-perspective solution that addresses all stakeholder concerns. This command ensures that every important perspective is considered and integrated into a cohesive response.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.orchestrator` in the triggering message **is** the request that requires comprehensive team collaboration. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand all persona characteristics.

3. Follow this execution flow for comprehensive team orchestration:

    1. Parse user request from Input
       If empty: ERROR "No request provided for team orchestration"
    2. Determine scope of team engagement required:
       - For strategic decisions: Engage CEO, CTO, CFO, Chief Design Officer, Product Manager
       - For technical decisions: Engage Architect, Developer, DevOps, Security
       - For operational decisions: Engage Engineering Manager, Operations Manager, HR Director
       - For compliance decisions: Engage Legal Counsel, IT Security Manager, Security
       - Default: Engage ALL personas for comprehensive input
    3. Execute full team collaboration protocol:
       - Initialize: Engage CEO to establish strategic context
       - Architectural Review: Architect provides system design input
       - Resource Assessment: Engineering Manager evaluates feasibility
       - Technical Implementation: Developer provides details
       - Quality Assurance: QA ensures quality standards
       - Security Validation: Security ensures protection
       - Operational Planning: DevOps handles deployment/operations
       - Financial Assessment: CFO/Finance Manager evaluates costs
       - Compliance Check: Legal Counsel and IT Security ensure compliance
       - User Experience: Chief Design Officer and Customer Success Manager contribute
       - Additional Specialists: Data Scientist, Marketing, Sales, etc. as relevant
    4. Facilitate cross-team dialogue:
       - Each persona reviews inputs from other personas
       - Conflicting perspectives are identified and reconciled
       - Complementary perspectives are integrated
       - Consensus areas are highlighted
    5. Generate synthesized team response:
       - Comprehensive solution addressing all stakeholder concerns
       - Clear action items assigned to appropriate role owners
       - Success metrics covering all dimensions
       - Risk assessments and mitigation strategies
    6. Return: SUCCESS (comprehensive team response ready for implementation)

4. Write the orchestrated team response to PERSONA_FILE using a comprehensive structure that integrates all persona inputs, replacing placeholders with concrete details derived from the request (arguments) while preserving section order and headings.

5. **Team Orchestration Quality Validation**: After writing the initial response, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/team-orchestration.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Team Orchestration Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate comprehensive team orchestration completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Team Orchestration file]
      
      ## Comprehensive Coverage
      
      - [ ] CEO perspective included (strategic alignment)
      - [ ] CTO perspective included (technology strategy)
      - [ ] CFO perspective included (financial considerations)
      - [ ] Architect perspective included (system design)
      - [ ] Developer perspective included (implementation details)
      - [ ] QA perspective included (quality assurance)
      - [ ] Security perspective included (protection & compliance)
      - [ ] DevOps perspective included (operations & deployment)
      - [ ] Engineering Manager perspective included (resources & timelines)
      - [ ] Product Manager perspective included (user requirements)
      - [ ] Legal Counsel perspective included (compliance & risk)
      - [ ] HR Director perspective included (people impact)
      - [ ] Chief Design Officer perspective included (user experience)
      - [ ] Customer Success perspective included (user satisfaction)
      - [ ] Marketing perspective included (market positioning)
      - [ ] Sales perspective included (customer acquisition)
      - [ ] Operations perspective included (process efficiency)
      - [ ] Data Scientist perspective included (analytics & insights)
      - [ ] IT Security perspective included (cybersecurity)
      - [ ] Finance Manager perspective included (budget & costs)
      - [ ] Procurement Manager perspective included (vendors & suppliers)
      - [ ] PR Manager perspective included (brand & communication)
      
      ## Coordination Quality
      
      - [ ] Cross-persona dialogue facilitated
      - [ ] Conflicting perspectives resolved
      - [ ] Complementary perspectives integrated
      - [ ] Consensus areas clearly identified
      - [ ] Action items assigned to appropriate personas
      - [ ] Success metrics cover all stakeholder groups
      
      ## Response Readiness
      
      - [ ] Response addresses all stakeholder concerns
      - [ ] Comprehensive risk assessment included
      - [ ] Mitigation strategies for all risks
      - [ ] Clear implementation pathway defined
      - [ ] Success metrics are measurable across all dimensions
      
      ## Notes
      
      - Items marked incomplete require perspective updates before implementation
      ```

   b. **Run Validation Check**: Review the response against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant response sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the response to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the response
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant response section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Team Orchestration Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for team coordination] |
           | B      | [Second suggested answer] | [What this means for team coordination] |
           | C      | [Third suggested answer] | [What this means for team coordination] |
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
        8. Update the response by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with branch name, response file path, checklist results, and readiness for implementation, highlighting the comprehensive team collaboration outcomes.

**NOTE:** The script creates the team orchestration file before writing.

## Full Team Orchestration Process

When executing the orchestration, the system follows this comprehensive process:

### Phase 1: Strategic Alignment
- CEO establishes strategic context and business objectives
- CTO aligns technology strategy with business goals
- CFO assesses financial feasibility and constraints
- Product Manager defines user requirements and success metrics

### Phase 2: Technical Design & Feasibility
- Architect designs the system to meet strategic and user requirements
- Engineering Manager evaluates resource and timeline feasibility
- Developer assesses implementation details and technical challenges
- Security identifies security requirements and risks

### Phase 3: Quality & Risk Assessment
- QA defines testing strategy and quality standards
- Legal Counsel identifies compliance requirements and risks
- IT Security Manager assesses cybersecurity considerations
- Operations Manager evaluates operational efficiency

### Phase 4: User Experience & Market Considerations
- Chief Design Officer designs user experience and interface
- Customer Success Manager considers user adoption and satisfaction
- Marketing Manager evaluates market positioning and acquisition
- Sales Manager considers customer acquisition and revenue impact

### Phase 5: Implementation & Operations
- DevOps plans deployment and operational procedures
- HR Director considers people impact and organizational change
- Data Scientist provides analytics and data-driven insights
- Finance Manager manages budget and cost considerations

### Phase 6: Specialized Considerations
- Procurement Manager handles vendor and supplier considerations
- PR Manager manages brand reputation and communications
- Additional specialists as relevant to the specific request

### Cross-Phase Coordination
- Each persona reviews and validates the inputs from other personas
- Conflicts between personas are identified and resolved
- Dependencies between different personas are clearly mapped
- Consensus areas are highlighted and prioritized
- Action items are assigned to the appropriate persona roles

## General Guidelines

### For AI Generation

When responding to a full team orchestration request:

1. **Engage all personas systematically**: Follow the orchestration process to include every relevant perspective
2. **Facilitate cross-team dialogue**: Show how personas consider and respond to each other's input
3. **Synthesize comprehensively**: Integrate all perspectives into a cohesive response
4. **Resolve conflicts explicitly**: Address any disagreements between personas
5. **Assign clear ownership**: Define which persona is responsible for each action item
6. **Address all stakeholder concerns**: Ensure no important perspective is overlooked
7. **Provide comprehensive metrics**: Include success measures for all stakeholder groups

### Success Metrics Guidelines

Success metrics must be comprehensive and address ALL stakeholder groups:

**Multi-Stakeholder Success Metrics**:
- "Achieve business growth (CEO) while maintaining architectural excellence (Architect), meeting timeline commitments (Engineering Manager), implementing securely (Security), ensuring quality (QA), operating efficiently (DevOps), satisfying users (Customer Success), and remaining within budget (CFO)"
- "Deliver strategic value with technical excellence, quality, security, operational efficiency, user satisfaction, and financial responsibility"
- "Achieve market success through innovative technology, high quality, security, efficiency, user experience, team satisfaction, and profitability"