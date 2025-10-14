---
description: Execute the development tasks to build the feature according to the plan and specification.
scripts:
  sh: scripts/bash/update-agent-context.sh "{ARGS}"
  ps: scripts/powershell/update-agent-context.ps1 -AgentFile "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/personakit.implement` in the triggering message **is** the implementation execution request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that request, do this:

1. Run the script `{SCRIPT}` from repo root to update AI agent context with latest persona recommendations. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load the current feature spec from `specs/FEATURE_NAME/spec.md` to understand requirements.

3. Load the current plan from `specs/FEATURE_NAME/plan.md` to understand implementation approach.

4. Load the current tasks from `specs/FEATURE_NAME/tasks.md` to understand development steps.

5. Follow this execution flow:

    1. Parse user request from Input
       If empty: Execute all tasks following sequence in tasks.md
    2. Extract key implementation parameters from request
       Identify: task filters, implementation options, execution preferences
    3. For unclear aspects:
       - Make informed guesses based on standard development practices
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts implementation success or code quality
         - Multiple reasonable implementation approaches exist with different outcomes
         - No reasonable default exists for implementation approach
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: implementation success > code quality > performance
    4. Apply implementation perspective considering:
       - Task execution sequence and dependencies
       - Code quality and best practices
       - Testing and validation requirements
       - Integration with existing codebase
    5. Execute implementation following:
       - Task breakdown from tasks.md
       - Technology choices from plan.md
       - Requirements from spec.md
       - Quality standards defined in project constitution
    6. Validate implementation against:
       - Functional requirements from specification
       - Technical requirements from plan
       - Quality standards and best practices
       - Test requirements defined in tasks
    7. Return: SUCCESS (feature implemented according to specification)

6. Execute the implementation by:
   - Creating or updating files as specified in tasks.md
   - Implementing functionality that meets spec.md requirements
   - Following technology approach from plan.md
   - Including appropriate tests and validation
   - Applying quality standards and best practices

7. **Implementation Quality Validation**: After completing implementation, validate it against quality criteria:

   a. **Create Implementation Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/implementation.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Implementation Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate implementation completeness and quality against specification and plan
      **Created**: [DATE]
      **Feature**: [Link to implementation files]
      
      ## Content Quality
      
      - [ ] All tasks from tasks.md have been completed
      - [ ] Implementation meets requirements in spec.md
      - [ ] Technology choices from plan.md have been applied
      - [ ] Code follows quality standards and best practices
      - [ ] All mandatory components implemented
      
      ## Implementation Alignment
      
      - [ ] All functional requirements implemented
      - [ ] Implementation follows specified architecture
      - [ ] Security considerations addressed
      - [ ] Performance requirements met
      - [ ] Data validation and error handling included
      - [ ] User scenarios from spec covered
      - [ ] Success criteria from spec achieved
      
      ## Feature Readiness
      
      - [ ] All components are fully implemented
      - [ ] Implementation is tested and validated
      - [ ] Feature meets outcomes defined in specification
      - [ ] No missing functionality from specification
      
      ## Notes
      
      - Items marked incomplete require implementation updates
      ```

   b. **Run Validation Check**: Review the implementation against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (reference relevant code sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 8
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the implementation to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the implementation
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by implementation success/code quality impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Reference relevant implementation section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Implementation Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the implementation] |
           | B      | [Second suggested answer] | [What this means for the implementation] |
           | C      | [Third suggested answer] | [What this means for the implementation] |
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
        8. Update the implementation by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

8. Report completion with implementation status, checklist results, and overall feature readiness.

**NOTE:** The script updates the agent context with latest persona guidance before implementation begins.

## General Guidelines

### For AI Generation

When executing implementation from tasks, plan, and specification:

1. **Follow task sequence**: Execute tasks in the order specified, respecting dependencies
2. **Maintain quality**: Apply coding standards and best practices consistently
3. **Validate continuously**: Check implementation against specification requirements as you go
4. **Integrate properly**: Ensure new code integrates well with existing codebase
5. **Document assumptions**: Add comments for any implementation decisions that aren't obvious
6. **Test functionality**: Implement appropriate tests for each component

**Implementation Approach**:
- Create files in the proper directories as specified in tasks
- Follow the architecture and technology choices from the plan
- Implement all functionality required by the specification
- Add appropriate error handling and validation
- Write clean, maintainable code following best practices

### Quality Standards

Implementation must meet:
1. **Functional Requirements**: All features specified in the requirements must be implemented
2. **Technical Requirements**: Implementation must follow the specified technology approach
3. **Quality Standards**: Code must be clean, maintainable, and follow best practices
4. **Test Coverage**: Appropriate tests must be included for all functionality

**Good implementation practices**:

- Follow the specified architecture and design patterns
- Include proper error handling and validation
- Write clean, readable code with appropriate comments
- Implement all test requirements specified in tasks
- Ensure proper integration with existing codebase

**Implementation validation**:

- Verify all functional requirements are met
- Confirm technology choices from plan are implemented
- Ensure code quality standards are maintained
- Validate that tests pass and cover required functionality