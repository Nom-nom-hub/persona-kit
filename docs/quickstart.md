# Quick Start Guide

This guide will help you get started with Persona-Driven Development using Persona Kit in just a few minutes.

## 🎯 The 5-Step Workflow

Persona Kit introduces a structured 5-step workflow for effective development:

1. **📋 Constitution** - Define project principles and values
2. **🎭 Personas** - Create specialized AI roles and behaviors
3. **🔄 Patterns** - Establish reusable interaction patterns
4. **⚡ Workflows** - Define structured development processes
5. **🚀 Implement** - Execute with consistency and quality

## 🚀 Quick Start

### Step 1: Install Persona Kit

```bash
# Install Persona Kit (choose one method)

# Install using uv (recommended)
uv pip install git+https://github.com/github/persona-kit.git
```

### Step 2: Initialize Your Project

```bash
# Navigate to your project directory
cd /path/to/your/project

# Initialize Persona Kit
persona-kit init
```

This creates the `.persona-kit/` directory structure and configuration files.

### Step 3: Create Your Development Constitution

The constitution defines your project's core principles and values:

```bash
# Create a constitution for your project
persona-kit constitution create "web-application" --description "A modern web application with clean architecture and user-centric design"
```

### Step 4: Set Up Your First Persona

Create specialized AI personas for different roles:

```bash
# Create a Senior Developer persona
persona-kit persona create "Senior Python Developer" \
  --role developer \
  --expertise "python,architecture,testing,performance" \
  --personality "experienced,thorough,mentor-like"

# Create a Product Manager persona
persona-kit persona create "Product Manager" \
  --role product-manager \
  --expertise "strategy,roadmap,user-experience,business-value" \
  --personality "strategic,analytical,user-focused"

# Create a QA Engineer persona
persona-kit persona create "QA Engineer" \
  --role qa-engineer \
  --expertise "testing,quality-assurance,automation,user-acceptance" \
  --personality "detail-oriented,thorough,quality-focused"
```

### Step 5: Create a Development Workflow

Set up structured workflows for common development tasks:

```bash
# Create a feature development workflow
persona-kit workflow create "feature-development" \
  --template feature \
  --personas "Product Manager,Senior Python Developer,QA Engineer"

# Create a bug fix workflow
persona-kit workflow create "bug-fix" \
  --template bug \
  --personas "QA Engineer,Senior Python Developer"
```

## 🎨 Example: Building a Web Application

Let's walk through a complete example of building a web application:

### Project Setup

```bash
# Create project directory
mkdir my-web-app
cd my-web-app

# Initialize Persona Kit
persona-kit init

# Create constitution
persona-kit constitution create "modern-web-app" \
  --description "A responsive web application with modern UX patterns" \
  --principles "mobile-first,responsive-design,accessibility,performance"
```

### Persona Setup

```bash
# Create development team personas
persona-kit persona create "Frontend Architect" \
  --role designer \
  --expertise "react,vue,css,ux-design,accessibility" \
  --personality "creative,detail-oriented,user-advocate"

persona-kit persona create "Backend Developer" \
  --role developer \
  --expertise "python,fastapi,postgresql,api-design,security" \
  --personality "reliable,security-conscious,performance-focused"

persona-kit persona create "DevOps Engineer" \
  --role devops \
  --expertise "docker,kubernetes,ci-cd,monitoring,scalability" \
  --personality "systematic,reliable,automation-focused"
```

### Workflow Creation

```bash
# Create feature development workflow
persona-kit workflow create "new-feature" \
  --steps "design,develop,test,deploy" \
  --personas "Frontend Architect,Backend Developer,DevOps Engineer" \
  --phases "planning,implementation,review,deployment"
```

### Pattern Creation

Create reusable interaction patterns:

```bash
# Create API design pattern
persona-kit pattern create "api-design" \
  --type communication \
  --template "RESTful API design with OpenAPI specification" \
  --context "backend-development"

# Create testing pattern
persona-kit pattern create "comprehensive-testing" \
  --type feedback-loop \
  --template "Unit tests, integration tests, and end-to-end tests" \
  --context "quality-assurance"
```

## 🎭 Using Personas in Development

### Switch Between Personas

```bash
# Switch to a specific persona
persona-kit persona use "Senior Python Developer"

# List available personas
persona-kit persona list

# Show current persona details
persona-kit persona show
```

### Context-Aware Development

```bash
# Start a development session with context
persona-kit workflow start "feature-development" \
  --feature "user-authentication" \
  --context "Building a secure login system with OAuth integration"
```

### Memory and Learning

```bash
# View accumulated knowledge
persona-kit memory show --persona "Senior Python Developer"

# Export memory for sharing
persona-kit memory export --format json --output project-knowledge.json

# Import shared knowledge
persona-kit memory import --file shared-knowledge.json
```

## 🔄 Workflow Execution

### Start a Workflow

```bash
# Start feature development workflow
persona-kit workflow start "feature-development"

# The workflow will guide you through:
# 1. Planning phase (Product Manager persona)
# 2. Implementation phase (Developer persona)
# 3. Review phase (QA Engineer persona)
# 4. Deployment phase (DevOps persona)
```

### Track Progress

```bash
# Check workflow status
persona-kit workflow status

# View current phase
persona-kit workflow current-phase

# Complete current phase and move to next
persona-kit workflow complete-phase
```

## 📚 Best Practices

### Persona Design
- **Be specific** about roles and expertise areas
- **Define clear personalities** that match the role
- **Include relevant context** and domain knowledge
- **Keep personas focused** on specific responsibilities

### Workflow Structure
- **Start simple** and iterate based on experience
- **Include review phases** for quality assurance
- **Define clear handoffs** between personas
- **Document decisions** for future reference

### Knowledge Management
- **Regularly review** accumulated knowledge
- **Share insights** across team members
- **Archive outdated** information
- **Maintain context** for better decision making

## 🚀 Next Steps

Now that you're up and running:

1. **[Installation](./installation.md)** - For detailed setup information
2. **[Persona-Driven Development](./persona-driven.md)** - Deep dive into the philosophy
3. **[Local Development](./local-development.md)** - Advanced development setup
4. **[Templates](./templates.md)** - Create reusable templates
5. **[Best Practices](./best-practices.md)** - Optimize your workflow

## 💡 Tips for Success

- **Start small**: Begin with 2-3 personas and one workflow
- **Iterate often**: Refine personas and workflows based on experience
- **Document everything**: Keep track of decisions and learnings
- **Share knowledge**: Export and share successful patterns with your team
- **Stay consistent**: Use the same personas and workflows across projects

Happy developing with Persona Kit! 🎭