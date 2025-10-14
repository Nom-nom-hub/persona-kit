---
description: Generate custom quality checklists that validate requirements completeness, clarity, and consistency (like "unit tests for English").
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

The text the user typed after `/personakit.checklist` in the triggering message **is** the quality checklist generation request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and CHECKLIST_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `templates/checklist-template.md` to understand checklist structure.

3. Load the current feature spec from `specs/FEATURE_NAME/spec.md` if available.

4. Follow this execution flow:

    1. Parse user request from Input
       If empty: Generate comprehensive quality checklist based on standard requirements practices
    2. Extract checklist focus areas from request
       Identify: specific quality aspects to validate, validation criteria, checklist scope
    3. For unclear aspects:
       - Make informed decisions based on standard quality assurance practices
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The checklist focus significantly impacts which validation items to include
         - Multiple reasonable validation approaches exist with different effectiveness
         - No reasonable default exists for validation scope
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: validation scope > effectiveness > implementation details
    4. Apply systematic checklist approach considering:
       - Completeness validation (are all requirements present?)
       - Clarity validation (are requirements clear and unambiguous?)
       - Consistency validation (do requirements align with each other?)
       - Quality standards validation (do requirements meet standards?)
    5. Generate checklist with:
       - Specific, testable validation items
       - Clear pass/fail criteria for each item
       - Validation examples where helpful
       - Priority indicators for critical items
    6. Define success criteria
       Create measurable, validation-focused outcomes
       Include both completeness metrics (number of validation items) and quality measures (checklist effectiveness)
       Each criterion must be verifiable by reviewing the checklist
    7. Return: SUCCESS (quality checklist ready for validation)

4. Write the checklist to CHECKLIST_FILE using a structured format, replacing placeholders with concrete validation items derived from quality standards while preserving section order and headings.

5. **Checklist Quality Validation**: After writing the initial checklist, validate it against quality criteria:

   a. **Create Checklist Quality Validation**: Generate validation items to check the checklist itself:
   
      ```markdown
      # Checklist for Validating Quality Checklists: [FEATURE NAME]
      
      **Purpose**: Validate checklist completeness and quality before using for requirements validation
      **Created**: [DATE]
      **Checklist**: [Link to checklist.md being validated]
      
      ## Content Quality
      
      - [ ] All validation items are specific and testable
      - [ ] Pass/fail criteria are clearly defined for each item
      - [ ] Checklist covers key quality dimensions (completeness, clarity, consistency)
      - [ ] Priority indicators provided for critical validation items
      - [ ] All mandatory sections completed
      
      ## Validation Alignment
      
      - [ ] Checklist items align with quality standards
      - [ ] Validation criteria are objective and measurable
      - [ ] Critical requirements aspects covered
      - [ ] Checklist is comprehensive but not overly burdensome
      - [ ] Validation examples provided where helpful
      - [ ] Checklist can be applied to requirements effectively
      - [ ] Validation approach is practical and actionable
      
      ## Checklist Readiness
      
      - [ ] All validation items are actionable
      - [ ] Success metrics are measurable through validation
      - [ ] Checklist meets validation outcomes defined
      - [ ] No implementation details leak into validation criteria
      
      ## Notes
      
      - Items marked incomplete require checklist updates before using for requirements validation
      ```

   b. **Run Validation Check**: Review the checklist against each validation item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant checklist sections)

   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark validation complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the checklist to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in validation notes and warn user
   
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the checklist
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by validation scope/effectiveness impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant checklist section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Validation Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for validation] |
           | B      | [Second suggested answer] | [What this means for validation] |
           | C      | [Third suggested answer] | [What this means for validation] |
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
        8. Update the checklist by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with checklist file path, validation results, and readiness for the next phase (using the checklist for requirements validation).

**NOTE:** The script creates the checklist file before writing.

## General Guidelines

### For AI Generation

When generating quality checklists for requirements validation:

1. **Be Specific**: Create validation items that are clearly testable and unambiguous
2. **Focus on Quality Dimensions**: Include items for completeness, clarity, consistency, and correctness
3. **Provide Clear Criteria**: Each validation item should have clear pass/fail criteria
4. **Prioritize Critical Items**: Mark the most important validation items with priority indicators
5. **Use Actionable Language**: Write items that can be objectively assessed
6. **Balance Coverage and Practicality**: Include comprehensive validation without making it too burdensome

**Checklist Focus Areas**:
- Completeness: Are all necessary requirements included?
- Clarity: Are requirements stated clearly without ambiguity?
- Consistency: Do requirements align with each other and with project goals?
- Validity: Do requirements accurately reflect user needs?
- Feasibility: Are requirements realistic and achievable?
- Testability: Can the requirements be validated?
- Traceability: Are requirements properly linked to user needs?

### Checklist Quality

Checklists must:
1. **Be Testable**: Each validation item must have clear, objective criteria
2. **Be Comprehensive**: Cover all important quality dimensions
3. **Be Practical**: Be usable without excessive effort or complexity
4. **Be Effective**: Help identify real quality issues in requirements

**Good validation item examples**:

- "[ ] All functional requirements include clear acceptance criteria"
- "[ ] Requirements avoid implementation details (no technology references)"
- "[ ] Success criteria are measurable and technology-agnostic"
- "[ ] No requirements conflict with each other"

**Poor validation item examples**:
- "[ ] Requirements look good" (not specific enough)
- "[ ] Everything is perfect" (not measurable)
- "[ ] The document is well-written" (not objective)
- "[ ] Requirements are detailed" (ambiguous - detailed how?)