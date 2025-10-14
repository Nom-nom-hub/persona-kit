# Feature Prioritization Pattern

## Pattern Purpose and Context

This pattern provides a structured framework for prioritizing features and user stories when faced with limited development capacity and competing stakeholder interests. It ensures decisions are data-driven, transparent, and aligned with business objectives while respecting technical constraints.

## When to Use This Pattern

- **Product Backlog Grooming**: When maintaining and prioritizing the product backlog
- **Sprint Planning**: When selecting features for upcoming development sprints
- **Resource Allocation**: When deciding how to allocate limited development resources
- **Stakeholder Conflicts**: When different stakeholders advocate for different features
- **Scope Management**: When managing feature requests against fixed timelines

## Step-by-Step Process

### Phase 1: Preparation (1-2 days)
1. **Gather All Inputs**
   - Collect all pending feature requests and user stories
   - Document stakeholder priorities and rationale
   - Review user feedback and analytics data
   - Assess technical dependencies and constraints

2. **Define Evaluation Framework**
   - Establish prioritization criteria (business value, user impact, technical complexity)
   - Create scoring rubric with weighted criteria
   - Define success metrics for each feature
   - Set decision timeline and process

### Phase 2: Evaluation (2-3 days)
3. **Individual Assessment**
   - Score each feature against evaluation criteria
   - Estimate development effort and complexity
   - Assess technical dependencies and risks
   - Evaluate user impact and business value

4. **Stakeholder Review**
   - Present features to relevant stakeholders for input
   - Gather additional context and requirements
   - Identify any critical path dependencies
   - Surface conflicting priorities and concerns

### Phase 3: Prioritization (1 day)
5. **Build Prioritized Backlog**
   - Rank features based on weighted scores
   - Group related features into themes
   - Identify minimum viable product (MVP) features
   - Create phased implementation roadmap

6. **Finalize and Communicate**
   - Review prioritized list with key stakeholders
   - Document rationale for prioritization decisions
   - Communicate decisions to all affected parties
   - Establish review cadence for ongoing prioritization

## Roles and Responsibilities

| Role | Responsibilities | Decision Authority |
|------|------------------|-------------------|
| **Product Manager** | Business value assessment, stakeholder coordination, final prioritization | Primary |
| **Development Team** | Technical complexity estimation, dependency identification, effort sizing | Consultative |
| **Design Team** | User experience impact, usability considerations, design complexity | Consultative |
| **QA Engineer** | Testing complexity, quality assurance approach, risk assessment | Consultative |
| **Stakeholders** | Business priority input, success criteria definition, impact assessment | Input |
| **Users/Customers** | Usage patterns, pain points, feature requests | Input |

## Success Criteria

- **Business Alignment**: Prioritized features support key business objectives and user needs
- **Stakeholder Satisfaction**: All stakeholders understand and accept prioritization rationale
- **Implementation Feasibility**: Prioritized features can be delivered within resource constraints
- **Value Delivery**: High-priority features deliver measurable business and user value
- **Transparency**: Prioritization process and rationale are clearly documented and communicated

## Common Pitfalls and How to Avoid Them

### ❌ Political Prioritization
**Problem**: Features prioritized based on who shouts loudest rather than business value
**Solution**: Use data-driven scoring framework with clear, objective criteria

### ❌ Technical Bias
**Problem**: Over-prioritizing technically interesting features while ignoring user needs
**Solution**: Include diverse stakeholders and balance technical and business perspectives

### ❌ Scope Creep
**Problem**: Adding too many features without removing lower-priority items
**Solution**: Set clear capacity limits and regularly prune backlog

### ❌ Analysis Paralysis
**Problem**: Endless debate preventing timely prioritization decisions
**Solution**: Set decision deadlines and use structured evaluation framework

### ❌ Poor Communication
**Problem**: Stakeholders surprised by prioritization decisions they don't understand
**Solution**: Involve stakeholders throughout process and clearly communicate rationale

## Examples and Use Cases

### Example 1: Mobile App Feature Prioritization
**Context**: Social media app with 50+ feature requests across user engagement, content creation, and platform features
**Process**:
- Product manager creates RICE scoring framework (Reach, Impact, Confidence, Effort)
- Development team estimates technical complexity for each feature
- Design team assesses user experience impact
- Marketing provides input on business value and competitive positioning

**Outcome**: Prioritized feature set focusing on core user engagement features that could be delivered in 3-month cycles

### Example 2: Enterprise Software Prioritization
**Context**: B2B SaaS platform with competing requests from sales, customer success, and product teams
**Process**:
- Used MoSCoW method (Must-have, Should-have, Could-have, Won't-have)
- Sales team identified revenue-generating features
- Customer success highlighted support-reducing capabilities
- Product team assessed strategic platform enhancements

**Outcome**: Balanced roadmap addressing immediate revenue needs while building long-term platform capabilities

## Integration with Other Patterns

- **Use with Communication Patterns**: Present prioritization decisions using clear visual frameworks
- **Combine with Feedback Loop Patterns**: Establish regular review cycles to reassess priorities
- **Apply with Conflict Resolution Patterns**: When stakeholders have competing priorities
- **Connect with Risk Assessment Patterns**: For evaluating uncertain or experimental features

## Related Patterns

- [[../communication/structured-update|Structured Update Pattern]]
- [[../feedback-loops/prioritization-review|Prioritization Review Pattern]]
- [[../conflict-resolution/interest-based-negotiation|Interest-Based Negotiation Pattern]]