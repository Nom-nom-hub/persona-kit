# Goal Kit Project Context

**Project**: persona-kit
**Agent**: kilocode
**Updated**: 2025-10-19T23:41:16Z

## 🎯 CRITICAL: Goal-Driven Development Methodology

**YOU MUST FOLLOW THESE RULES EXACTLY:**

### 🚨 STRICT WORKFLOW ENFORCEMENT - ONE COMMAND AT A TIME
**🛑 STOP AFTER EACH COMMAND - WAIT FOR USER**

1. **`/goalkit.vision`** → Create vision file → **🛑 STOP**
2. **User runs** `/goalkit.goal`** → Create goal → **🛑 STOP**
3. **User runs** `/goalkit.strategies`** → Explore strategies → **🛑 STOP**
4. **User runs** `/goalkit.milestones`** → Create milestones → **🛑 STOP**
5. **User runs** `/goalkit.execute`** → Implement with learning → **Continue**

### Core Methodology Rules
1. **OUTCOMES FIRST**: Always focus on measurable user/business outcomes, NOT implementation details
2. **NO IMPLEMENTATION DETAILS IN GOALS**: Never put languages, frameworks, APIs, or methods in goal definitions
3. **USE THE 5-CMD WORKFLOW**: Always follow vision → goal → strategies → milestones → execute sequence
4. **MEASURABLE SUCCESS**: Every goal must have specific, quantifiable metrics (%, $, time, user counts)
5. **STRATEGY EXPLORATION**: Before implementing, ALWAYS explore multiple approaches using /goalkit.strategies
6. **ADAPTIVE EXECUTION**: Be ready to pivot based on learning and evidence during /goalkit.execute

### When to Use Each Command
- **/goalkit.vision**: Establish project foundation and guiding principles
- **/goalkit.goal**: Create goals with specific success metrics (no implementation details!)
- **/goalkit.strategies**: Explore 3+ different approaches to achieve goals
- **/goalkit.milestones**: Create measurable progress checkpoints
- **/goalkit.execute**: Implement with learning loops and measurement

### 🚨 FORBIDDEN AGENT BEHAVIORS
**❌ STOP: DO NOT chain commands automatically**
- ❌ Running `/goalkit.goal` after `/goalkit.vision` without user input
- ❌ Starting coding or implementation after vision creation
- ❌ Skipping any methodology steps
- ❌ Proceeding without explicit user commands

**✅ ALLOWED: Only these specific actions**
- ✅ Creating vision file after `/goalkit.vision` → **🛑 STOP**
- ✅ Creating goal files after `/goalkit.goal` → **🛑 STOP**
- ✅ Starting implementation after `/goalkit.execute` → Continue

### ⚠️ CRITICAL ANTI-PATTERNS TO AVOID
- ✗ Implementing features directly without following methodology
- ✗ Adding implementation details to goal definitions
- ✗ Skipping strategy exploration phase
- ✗ Creating goals without measurable success criteria
- ✗ Treating this as traditional requirement-driven development

## 📋 Available Commands

### Core Commands
- **/goalkit.vision** - Establish project vision and principles
- **/goalkit.goal** - Define goals and success criteria
- **/goalkit.strategies** - Explore implementation strategies
- **/goalkit.milestones** - Create measurable milestones
- **/goalkit.execute** - Execute with learning and adaptation

## 🚀 Project Vision

Vision document not yet created

## 🎯 Active Goals

No active goals yet. Use /goalkit.goal to create your first goal.

## 📊 Development Principles

Remember these core principles:
1. **Outcome-First**: Prioritize user and business outcomes
2. **Strategy Flexibility**: Multiple valid approaches exist for any goal
3. **Measurement-Driven**: Progress must be measured and validated
4. **Learning Integration**: Treat implementation as hypothesis testing
5. **Adaptive Planning**: Change course based on evidence

## 🔧 Next Recommended Actions

1. Use /goalkit.vision to establish project vision
2. Use /goalkit.goal to define first goal
3. Use /goalkit.strategies to explore implementation approaches
4. Use /goalkit.milestones to plan measurable progress steps

## Agent Development Guidelines
When working with Python scripts and code in this project, AI agents should follow these critical guidelines to avoid common mistakes:

### 1. Verify Before Modifying
- Always check current repository state: `git status`, `git diff`
- Validate syntax before making changes: `python -m py_compile script_name.py`
- Understand file structure before modifying complex elements like heredocs or multi-line strings

### 2. Safe Editing Practices
- Use targeted `edit` operations when possible instead of overwriting entire files
- For complex files with heredocs (`<< EOF`), be especially careful with structure and command substitution
- Always verify conditional blocks remain properly balanced (`if/fi`, `for/done`, etc.)

### 3. Thorough Validation After Changes
- Immediately validate syntax after each change: `python -m py_compile script_name.py`
- Test functionality before moving on to next tasks
- Verify all related files (Python equivalents) have consistent changes

### 4. Systematic Conflict Resolution
- Resolve merge conflicts one at a time, not all at once
- Verify each conflict resolution before proceeding
- Look for special characters or encoding issues introduced during merges

### 5. Cross-Platform Consistency
- When fixing an issue in Python scripts, check for similar patterns in other Python scripts
- Maintain consistent validation logic across implementations

### 6. Python Script Specific Guidelines
- When working with Python scripts (.py), use Python-specific validation: `importlib` or `py_compile` instead of shell equivalents
- For Python syntax checking, use Python-specific tools like `python -m py_compile` rather than shell commands
- Be aware of Python-specific escaping and path handling using `os.path` or `pathlib`
- Remember Python built-in functions and libraries behave differently than shell commands

### 6. Verification Checklist for Python Scripts
- [ ] `python -m py_compile script_name.py` returns no errors
- [ ] All variables are properly defined before use
- [ ] All conditional blocks are properly closed
- [ ] Heredoc structures are intact
- [ ] No special characters from merge conflicts remain

### 7. Critical Warning Signs
If you see syntax errors like "unexpected token" or "unexpected EOF", check for:
- Unbalanced parentheses in command substitutions
- Special characters from merge conflicts
- Broken heredoc structures
- Missing closing brackets or quotes

Following these guidelines will help prevent the syntax errors, merge conflict issues, and validation problems that can occur during development.

---

*This context is automatically created by goalkeeper init. Last updated: 2025-10-19 23:41:16*
