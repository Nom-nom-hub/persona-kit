---
description: Clarify underspecified areas in the feature specification before planning, following structured questioning that records answers in a Clarifications section.
scripts:
  sh: scripts/bash/create-new-persona.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-persona.ps1 -Json "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.clarify` in the triggering message **is** the specification clarification request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and CLARIFICATION_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load the current feature spec from `specs/FEATURE_NAME/spec.md` to identify unclear areas.

3. Follow this execution flow:

    1. Parse user request from Input
       If empty: Focus on clarifying underspecified areas in the current spec
    2. Extract clarification focus areas from request
       Identify: specific parts of spec to clarify, user concerns, ambiguous requirements
    3. For unclear aspects:
       - Make informed guesses based on context and standard requirements practices
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The ambiguity significantly impacts feature scope or implementation approach
         - Multiple reasonable interpretations exist with different project implications
         - No reasonable default exists for the ambiguous requirement
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: scope impact > implementation approach > user experience details
    4. Apply systematic clarification approach considering:
       - Requirement completeness and clarity
       - Impact on project scope and timeline
       - Implementation feasibility
       - User experience consistency
    5. Generate clarifications with:
       - Specific questions about ambiguous requirements
       - Multiple answer options with implications
       - Recommended approach based on best practices
    6. Define success criteria
       Create measurable, clarity-focused outcomes
       Include both completeness metrics (unresolved ambiguities) and quality measures (requirement clarity)
       Each criterion must be verifiable by reviewing the clarifications
    7. Return: SUCCESS (specification clarifications ready for planning)

4. Write the clarifications to CLARIFICATION_FILE using a structured format, replacing placeholders with concrete details derived from the specification while preserving section order and headings.

5. **Clarification Quality Validation**: After writing the initial clarifications, validate them against quality criteria:

   a. **Create Clarification Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/clarification.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Specification Clarification Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate clarification completeness and quality before proceeding to planning
      **Created**: [DATE]
      **Feature**: [Link to clarifications.md]
      
      ## Content Quality
      
      - [ ] All ambiguous requirements have been identified
      - [ ] Questions are specific and actionable
      - [ ] Answer options clearly differentiate implications
      - [ ] All mandatory sections completed
      
      ## Clarification Alignment
      
      - [ ] Clarifications address significant ambiguity impacts
      - [ ] Multiple answer options provided with clear implications
      - [ ] Recommended approach aligns with best practices
      - [ ] Scope impact of each clarification is understood
      - [ ] Implementation implications clearly stated
      - [ ] User experience considerations addressed
      - [ ] Dependencies on clarifications identified
      
      ## Clarification Readiness
      
      - [ ] All clarifications are actionable
      - [ ] Success metrics are measurable through review
      - [ ] Clarifications meet completeness outcomes defined
      - [ ] No implementation details leak into clarifications
      
      ## Notes
      
      - Items marked incomplete require clarification updates before `/personakit.plan`
      ```

   b. **Run Validation Check**: Review the clarifications against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant clarification sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the clarifications to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the clarifications
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by scope impact/implementation approach impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant clarification section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Project Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the project] |
           | B      | [Second suggested answer] | [What this means for the project] |
           | C      | [Third suggested answer] | [What this means for the project] |
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
        8. Update the clarifications by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with clarifications file path, checklist results, and readiness for the next phase (`/personakit.plan`).

**NOTE:** The script creates the clarifications file before writing.

## General Guidelines

### For AI Generation

When clarifying specification requirements:

1. **Focus on critical ambiguities**: Address requirements that significantly impact scope, implementation, or user experience
2. **Provide clear options**: For each clarification, provide 2-3 distinct options with clear implications
3. **Document implications**: Clearly state the project implications of each answer option
4. **Apply best practices**: Suggest the recommended approach based on industry standards
5. **Limit clarifications**: Focus on the most impactful ambiguities (max 3 per clarification session)
6. **Verify completeness**: Ensure all critical ambiguities are addressed before planning

**Clarification Focus Areas**:
- Feature scope and boundaries
- User types and permissions
- Performance requirements
- Security considerations
- Integration requirements
- Data constraints and limitations
- User experience expectations

### Clarification Quality

Clarifications must:
1. **Address Impact**: Focus on requirements with significant project impact
2. **Provide Options**: Offer clear, distinct answer options for each question
3. **State Implications**: Clearly explain the implications of each option
4. **Be Actionable**: Questions and answers must be clear enough for decision-making

**Good clarification examples**:

- "Should the file upload feature support files up to 10MB or 100MB? (10MB: Better performance, 100MB: More flexibility for users)"
- "Should users be able to share content publicly or only with specific users? (Public: Wider reach but privacy concerns, Specific: Better privacy control)"
- "Should the notification system send real-time or batch notifications? (Real-time: Better UX but higher resource usage, Batch: More efficient but delayed)"

**Poor clarification examples**:
- "How should it work?" (too vague)
- "Should button be red or blue?" (trivial detail that doesn't impact project significantly)
- "What's the exact shade of blue?" (implementation detail)