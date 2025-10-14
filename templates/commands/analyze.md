---
description: Cross-artifact consistency & coverage analysis between specification, plan, and other development artifacts.
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

The text the user typed after `/personakit.analyze` in the triggering message **is** the consistency and coverage analysis request. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that request, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and ANALYSIS_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load the current feature spec from `specs/FEATURE_NAME/spec.md` to understand requirements.

3. Load the current plan from `specs/FEATURE_NAME/plan.md` to understand implementation approach.

4. Load any available tasks from `specs/FEATURE_NAME/tasks.md` and other artifacts.

5. Follow this execution flow:

    1. Parse user request from Input
       If empty: Perform comprehensive consistency and coverage analysis
    2. Extract analysis focus areas from request
       Identify: specific artifacts to compare, consistency concerns, coverage gaps
    3. For unclear aspects:
       - Make informed analysis decisions based on standard quality practices
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The analysis focus significantly impacts which artifacts to examine
         - Multiple reasonable analysis approaches exist with different outcomes
         - No reasonable default exists for analysis scope
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: analysis scope > consistency approach > coverage details
    4. Apply systematic analysis approach considering:
       - Cross-artifact consistency (spec vs plan vs tasks)
       - Requirement coverage (are all requirements addressed?)
       - Implementation alignment (do plan and tasks match spec?)
       - Quality standards (do artifacts meet quality criteria?)
    5. Generate analysis with:
       - Consistency findings between artifacts
       - Coverage gaps identification
       - Alignment issues between requirements and implementation
       - Quality assessment of each artifact
    6. Define success criteria
       Create measurable, consistency-focused outcomes
       Include both consistency metrics (artifact alignment score) and quality measures (requirement coverage percentage)
       Each criterion must be verifiable by reviewing the analysis
    7. Return: SUCCESS (comprehensive analysis ready for implementation)

4. Write the analysis to ANALYSIS_FILE using a structured format, replacing placeholders with concrete findings derived from the artifact comparison while preserving section order and headings.

5. **Analysis Quality Validation**: After writing the initial analysis, validate it against quality criteria:

   a. **Create Analysis Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/analysis.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Cross-Artifact Analysis Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate analysis completeness and quality across all development artifacts
      **Created**: [DATE]
      **Feature**: [Link to analysis.md]
      
      ## Content Quality
      
      - [ ] All relevant artifacts have been analyzed
      - [ ] Consistency findings are specific and actionable
      - [ ] Coverage gaps are clearly identified
      - [ ] Alignment issues are properly documented
      - [ ] All mandatory sections completed
      
      ## Analysis Alignment
      
      - [ ] Analysis covers all major artifacts (spec, plan, tasks)
      - [ ] Consistency assessment addresses requirement-to-implementation flow
      - [ ] Coverage gaps are tied to specific requirements
      - [ ] Quality assessment is objective and measurable
      - [ ] Inconsistencies between artifacts identified
      - [ ] Dependencies between artifacts understood
      - [ ] Risk areas properly highlighted
      
      ## Analysis Readiness
      
      - [ ] All findings are actionable for improvement
      - [ ] Success metrics are measurable through review
      - [ ] Analysis meets quality outcomes defined
      - [ ] No implementation details leak into analysis
      
      ## Notes
      
      - Items marked incomplete require analysis updates before `/personakit.implement`
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
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by analysis scope/consistency approach impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant analysis section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           ## Suggested Answers:
           
           | Option | Answer | Analysis Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the analysis] |
           | B      | [Second suggested answer] | [What this means for the analysis] |
           | C      | [Third suggested answer] | [What this means for the analysis] |
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

6. Report completion with analysis file path, checklist results, and readiness for the next phase (addressing identified inconsistencies/gaps).

**NOTE:** The script creates the analysis file before writing.

## General Guidelines

### For AI Generation

When performing cross-artifact consistency and coverage analysis:

1. **Compare systematically**: Analyze each artifact against others to identify inconsistencies
2. **Focus on alignment**: Ensure requirements in spec align with implementation in plan and tasks
3. **Identify gaps**: Find missing elements that exist in one artifact but not others
4. **Assess quality**: Evaluate each artifact against quality standards
5. **Document findings**: Clearly explain what's inconsistent and why it matters
6. **Prioritize issues**: Focus on inconsistencies that significantly impact implementation

**Analysis Focus Areas**:
- Requirement coverage from spec to plan to tasks
- Consistency of technical decisions across artifacts
- Alignment of success criteria with implementation approach
- Completeness of security considerations across artifacts
- Consistency of performance requirements
- Proper decomposition of requirements into tasks

### Analysis Quality

Analysis must:
1. **Be Comprehensive**: Cover all major artifacts related to the feature
2. **Be Specific**: Identify exact locations of inconsistencies or gaps
3. **Be Actionable**: Provide clear recommendations for addressing issues
4. **Be Objective**: Base findings on artifact content rather than assumptions

**Good analysis examples**:

- "The spec requires real-time notifications, but the plan only addresses batch processing - this is a critical alignment gap"
- "Tasks include user authentication but the spec doesn't define user permissions clearly - coverage gap in requirements"
- "The plan specifies PostgreSQL but the spec mentions support for multiple database types - consistency issue"

**Poor analysis examples**:
- "The documents look different" (too vague)
- "There are some differences" (not specific enough)
- "It's not perfect" (not actionable)
- Analysis focused only on formatting or minor details