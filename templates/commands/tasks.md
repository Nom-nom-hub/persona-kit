---
description: Generate actionable development tasks from the implementation plan and specification.
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

The text the user typed after `/personakit.tasks` in the triggering message **is** the task generation request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and TASKS_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load the current feature spec from `specs/FEATURE_NAME/spec.md` to understand requirements.

3. Load the current plan from `specs/FEATURE_NAME/plan.md` to understand implementation approach.

4. Load `templates/tasks-template.md` to understand required task structure.

5. Follow this execution flow:

    1. Parse user request from Input
       If empty: Generate tasks following standard best practices
    2. Extract key task concepts from request
       Identify: task priorities, dependencies, implementation approach
    3. For unclear aspects:
       - Make informed guesses based on feature requirements and standard development practices
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts task sequence or project success
         - Multiple reasonable task breakdowns exist with different effectiveness
         - No reasonable default exists for task structure
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: project success > task effectiveness > implementation details
    4. Apply development perspective considering:
       - Task dependencies and critical path
       - Development workflow and best practices
       - Test-driven development approach
       - Code quality and review requirements
    5. Generate development tasks with:
       - Clear, actionable step descriptions
       - Proper task sequencing and dependencies
       - File paths and implementation details
       - Test requirements for each task
    6. Define success criteria
       Create measurable, task-focused outcomes
       Include both completion metrics (task completion rate) and quality measures (code quality, test coverage)
       Each criterion must be verifiable during implementation
    7. Return: SUCCESS (tasks ready for implementation)

6. Write the development tasks to TASKS_FILE using the template structure, replacing placeholders with concrete details derived from the feature specification and implementation plan while preserving section order and headings.

7. **Tasks Quality Validation**: After writing the initial tasks, validate them against quality criteria:

   a. **Create Tasks Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/tasks-assessment.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Development Tasks Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate development tasks completeness and quality before proceeding to implementation
      **Created**: [DATE]
      **Feature**: [Link to tasks.md]
      
      ## Content Quality
      
      - [ ] All tasks are clear and actionable
      - [ ] Task dependencies are properly identified
      - [ ] File paths and implementation details provided
      - [ ] Test requirements specified for each task
      - [ ] All mandatory sections completed
      
      ## Development Alignment
      
      - [ ] Tasks align with feature specification requirements
      - [ ] Task sequence follows logical implementation flow
      - [ ] Dependencies are correctly identified and ordered
      - [ ] Test-driven approach applied where appropriate
      - [ ] Code quality requirements specified
      - [ ] Review and validation steps included
      - [ ] Implementation approach matches plan decisions
      
      ## Task Readiness
      
      - [ ] All tasks are actionable with clear instructions
      - [ ] Success criteria are measurable during implementation
      - [ ] Tasks meet development outcomes defined
      - [ ] No ambiguous requirements in task descriptions
      
      ## Notes
      
      - Items marked incomplete require task updates before `/personakit.implement`
      ```

   b. **Run Validation Check**: Review the tasks against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant task sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 8
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the tasks to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the tasks
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by project success/task effectiveness impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant task section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Task Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the task] |
           | B      | [Second suggested answer] | [What this means for the task] |
           | C      | [Third suggested answer] | [What this means for the task] |
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
        8. Update the tasks by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

8. Report completion with tasks file path, checklist results, and readiness for the next phase (`/personakit.implement`).

**NOTE:** The script creates the tasks file before writing.

## General Guidelines

### For AI Generation

When creating development tasks from a specification and plan:

1. **Make informed task breakdowns**: Use context, feature requirements, and standard development practices to create actionable tasks
2. **Document assumptions**: Record task dependencies and implementation assumptions
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact task sequence or project success
   - Have multiple reasonable task breakdowns with different effectiveness
   - Lack any reasonable default for task structure
4. **Prioritize clarifications**: project success > task effectiveness > implementation details
5. **Think like a developer**: Every ambiguous task should fail the "actionable and clear" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Task dependencies (when significantly impacts project timeline)
   - Implementation approach priorities (if multiple conflicting interpretations possible)
   - Test strategy requirements (when many possible approaches exist)

**Examples of reasonable defaults** (don't ask about these):
- Task size: Medium-sized tasks that take 1-3 hours to complete
- Dependencies: Standard dependency order (models before services, services before endpoints)
- Test requirements: Unit tests for business logic, integration tests for API endpoints
- Code review: Standard pull request process with peer review

### Task Structure Guidelines

Tasks must be:
1. **Actionable**: Clear instructions that a developer can follow
2. **Sequenced**: Properly ordered with dependencies respected
3. **Verifiable**: Each task has clear success criteria
4. **Consistent**: Follow similar format and level of detail

**Good examples**:

- "Create User model with fields: id (UUID), email (string, unique), created_at (timestamp). Add validation for email format."
- "Implement GET /api/users endpoint that returns paginated list of users. Handle pagination parameters and return proper HTTP status codes."
- "Write unit tests for User model validation methods. Include tests for valid and invalid email formats."

**Bad examples** (too vague or too detailed):

- "Set up database" (too vague)
- "Create User model with id field as UUID, set it as primary key, make it not nullable, then create email field as string..." (too detailed)
- "Do the API part" (too vague)
- "For the validation function, first check if the email string exists, then check if it has an @ symbol..." (too detailed)