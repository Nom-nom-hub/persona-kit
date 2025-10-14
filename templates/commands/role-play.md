---
description: Simulate a team meeting with different personas providing input, allowing you to role-play through complex decisions with the perspectives of a full company team.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

# Role-Play Persona Command

The `/personakit.role-play` command simulates a team meeting with different personas providing input, allowing you to role-play through complex decisions with the perspectives of a full company team. This command creates a collaborative environment where personas interact with each other's viewpoints, similar to a real team meeting.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.role-play` in the triggering message **is** the role-play scenario request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that scenario request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and PERSONA_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/persona-template.md` to understand persona characteristics.

3. Follow this execution flow for the role-play simulation:

    1. Parse user scenario from Input
       If empty: ERROR "No scenario request provided"
    2. Identify key stakeholders for the scenario
       Identify: which personas would participate in a real meeting about this topic
    3. Simulate a collaborative team meeting with appropriate personas:
       - CEO: Provides strategic direction and business priorities
       - Product Manager: Presents user requirements and success metrics
       - Engineering Manager: Discusses resources and timeline feasibility
       - Architect: Outlines technical approach and constraints
       - Developer: Addresses implementation details and practical concerns
       - Security: Raises security considerations and compliance requirements
       - QA: Presents testing strategy and quality concerns
       - Additional personas as relevant to the scenario
    4. Create realistic meeting dynamics:
       - Personas respond to and build upon each other's input
       - Natural discussion flow with questions and clarifications
       - Resolution of disagreements with compromise solutions
       - Consensus building around key decisions
    5. Generate meeting summary and decisions:
       - Key decisions made during the role-play
       - Action items and responsibilities assigned
       - Potential risks and mitigation strategies identified
       - Success metrics and success criteria defined
    6. Return: SUCCESS (role-play simulation completed with actionable outcomes)

4. Write the role-play simulation to PERSONA_FILE using a meeting format that captures the dialogue and discussion between different personas, replacing placeholders with concrete details derived from the scenario request (arguments) while preserving section order and headings.

5. **Role-Play Simulation Quality Validation**: After writing the initial simulation, validate it against quality criteria:

   a. **Create Perspective Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/role-play-simulation.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Role-Play Simulation Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate Role-Play simulation completeness and quality before proceeding 
      **Created**: [DATE]
      **Feature**: [Link to Role-Play simulation file]
      
      ## Content Quality
      
      - [ ] Simulates realistic meeting dynamics
      - [ ] Each persona maintains their distinct perspective and priorities
      - [ ] Personas respond to and build upon each other's input
      - [ ] All mandatory sections completed
      
      ## Meeting Simulation Alignment
      
      - [ ] CEO perspective includes strategic considerations
      - [ ] Technical perspectives address implementation feasibility
      - [ ] Quality and security perspectives are adequately represented
      - [ ] Business value and user needs are considered
      - [ ] Resource and timeline constraints are addressed
      - [ ] Potential conflicts are resolved constructively
      - [ ] Action items and responsibilities are clearly defined
      
      ## Simulation Readiness
      
      - [ ] Meeting outcomes are actionable
      - [ ] Success metrics are clearly defined
      - [ ] Simulation addresses realistic project outcomes
      - [ ] Personas maintain consistent characteristics throughout
      
      ## Notes
      
      - Items marked incomplete require perspective updates before implementation
      ```

   b. **Run Validation Check**: Review the simulation against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant simulation sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the simulation to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the simulation
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant simulation section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Meeting Simulation Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the meeting simulation] |
           | B      | [Second suggested answer] | [What this means for the meeting simulation] |
           | C      | [Third suggested answer] | [What this means for the meeting simulation] |
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
        8. Update the simulation by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with branch name, simulation file path, checklist results, and readiness for implementation, highlighting the simulated meeting outcomes and actionable items.

**NOTE:** The script creates the role-play simulation file before writing.

## Role-Play Simulation Considerations

When simulating a meeting, the role-play approach will simulate realistic interaction between personas:

### Executive Participants
- **CEO**: Sets strategic direction, makes final decisions on conflicting priorities
- **CFO**: Raises financial concerns, budget constraints, and ROI considerations
- **Chief of Staff**: Facilitates the meeting, ensures all perspectives are heard

### Product & Management Participants
- **Product Manager**: Presents user needs, feature priorities, and success metrics
- **Engineering Manager**: Discusses team capacity, timeline feasibility, and resource allocation
- **Marketing Manager**: Provides market insights and customer acquisition considerations

### Technical Participants
- **Architect**: Outlines technical approach, scalability considerations, and system design
- **CTO**: Provides technology strategy and innovation insights
- **Developer**: Addresses implementation details, code quality, and practical concerns
- **DevOps**: Discusses deployment, monitoring, and operational requirements

### Quality & Risk Participants
- **QA**: Presents testing strategy, quality standards, and risk assessment
- **Security**: Raises security requirements, compliance needs, and potential vulnerabilities
- **Legal Counsel**: Addresses compliance requirements and legal risks

### Supporting Function Participants
- **Sales Manager**: Provides customer feedback and revenue impact insights
- **Customer Success Manager**: Presents user adoption and satisfaction considerations
- **HR Director**: Addresses people impact and organizational change considerations
- **Operations Manager**: Discusses process optimization and operational efficiency
- **Data Scientist**: Provides analytics insights and data-driven recommendations
- **Chief Design Officer**: Addresses user experience and design requirements
- **IT Security Manager**: Raises cybersecurity and information protection concerns
- **Finance Manager**: Provides budget and cost management insights
- **Procurement Manager**: Addresses vendor and supplier considerations
- **PR Manager**: Discusses brand reputation and communication implications

## Meeting Simulation Format

The role-play simulation will follow this structure:
1. **Meeting Objective**: Clear statement of the decision or issue to be addressed
2. **Attendees**: List of personas participating in the simulation
3. **Opening**: CEO or Chief of Staff sets context and objectives
4. **Personas' Input**: Each persona provides their perspective in turn
5. **Discussion**: Personas respond to and build upon each other's input
6. **Conflict Resolution**: Address disagreements and reach consensus
7. **Decisions Made**: Clear summary of decisions reached
8. **Action Items**: Specific tasks assigned to personas with timelines
9. **Success Metrics**: How the success of the decision will be measured
10. **Next Steps**: Follow-up meetings or activities planned

## General Guidelines

### For AI Generation

When responding to a role-play simulation request:

1. **Simulate realistic meeting dynamics**: Include back-and-forth discussion between personas
2. **Maintain persona authenticity**: Each persona should speak in their characteristic style and focus on their priorities
3. **Show genuine disagreements**: Sometimes personas will have different perspectives that need to be resolved
4. **Facilitate productive resolution**: Show how conflicts are constructively resolved
5. **Document decisions and actions**: Clearly specify what was decided and who is responsible
6. **Consider practical constraints**: Include realistic timeline, budget, and resource limitations
7. **Build upon others' input**: Show personas responding to and incorporating other perspectives

### Success Metrics Guidelines

Success metrics must be:
1. **Measurable**: Specific outcomes that can be tracked
2. **Multi-stakeholder**: Address success from different persona viewpoints
3. **Realistic**: Achievable within practical constraints