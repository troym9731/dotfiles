---
description: Build a comprehensive plan through sequential thinking and clarifying questions
allowed-tools: ["mcp__sequential-thinking__sequentialthinking", "Write", "Read", "TodoWrite", "LS", "Bash", "Task"]
---

# Interactive Plan Builder with Sequential Thinking

I'll help you build a comprehensive plan using sequential thinking and up to 10 clarifying questions. The final plan will be saved to ~/instinct/claude_plans/ for use with /execute-plan.

## Initial Setup

First, let me ensure the plans directory exists:

!mkdir -p ~/instinct/claude_plans

## Starting the Planning Process

$ARGUMENTS

## Sequential Planning Analysis

I'll now use sequential thinking with specific analysis steps to deeply understand your planning request:

Let me use sequential thinking to:
1. **Decompose Requirements**: Break down your request into atomic, executable tasks
2. **Map Dependencies**: Identify which tasks depend on others and optimal execution order
3. **Identify Edge Cases**: Consider what could go wrong and plan mitigation strategies
4. **Generate Implementation Hypotheses**: Form theories about the best approach
5. **Verify Feasibility**: Check that each step is actually achievable
6. **Optimize Sequence**: Arrange tasks for maximum efficiency and safety

## Adaptive Questioning Strategy

Using sequential thinking, I'll determine which questions are most relevant to your specific plan. Not all plans need all 10 questions - I'll adapt based on:
- The complexity of your request
- Areas that need clarification from your initial overview
- Your responses to previous questions
- The type of implementation (new feature, bug fix, refactor, etc.)

I'll ask questions that help me understand:
- **Scope & Boundaries**: What's included and what's not
- **Dependencies**: What needs to be in place first
- **Success Criteria**: How we'll know when we're done
- **Risks & Constraints**: What could go wrong or limit us
- **Technical Details**: Specific implementation requirements
- **Timeline**: Any deadlines or milestones
- **Resources**: What tools, APIs, or systems are involved

## Expert Planning Process

After gathering requirements through questioning, I'll spawn specialized expert agents based on the technology stack:

### Technology-Specific Expert Planning

**For Elixir/Phoenix Backend Features:**
I'll launch the elixir-phoenix-expert agent to create a plan that:
- Follows Phoenix conventions and directory structure
- Designs proper contexts and boundaries
- Plans Ecto schema and migration strategies
- Considers GenServer and OTP patterns where appropriate
- Includes ExUnit test strategies
- Plans for proper error handling with pattern matching

**For React/TypeScript Frontend Features:**
I'll launch the react-code-reviewer agent to create a plan that:
- Designs component hierarchy and composition
- Plans state management approach (hooks, context, etc.)
- Considers performance optimization strategies
- Includes proper TypeScript typing
- Plans for Jest/React Testing Library tests
- Considers accessibility requirements

**Security Planning (Always Included):**
I'll launch the security-code-reviewer agent in parallel to:
- Identify security requirements and risks
- Plan authentication/authorization strategies
- Design input validation and sanitization
- Consider data protection and encryption needs
- Plan security testing approaches
- Identify potential vulnerabilities to avoid

The expert agents will:
1. Use sequential thinking to deeply analyze requirements
2. Create plans following project-specific conventions
3. Structure plans with detailed steps for /execute-plan compatibility
4. Balance thoroughness with practicality
5. DO NOT save plans - only design for review

### Subagent C: Plan Synthesizer

You are reviewing two implementation plans to create an optimal unified approach. Your task is to:

1. Use mcp__sequential-thinking__sequentialthinking to analyze both plans
2. Identify the best elements from each:
   - Comprehensive plan's safety and thoroughness
   - Efficient plan's speed and simplicity
3. Create a unified plan that:
   - Balances completeness with practicality
   - Includes critical safety measures without over-engineering
   - Maintains clear structure for /execute-plan compatibility
4. Resolve any conflicts between approaches
5. Generate the final plan following the exact format specified
6. Only this synthesized plan should be saved to ~/instinct/claude_plans/

Your unified plan should capture the best of both approaches.

## Plan Structure for /execute-plan Compatibility

The final plan will be structured for seamless execution:

```markdown
# Plan: [Feature/Component Description]

## Overview
[High-level description and goals]

## Prerequisites
- [ ] Prerequisite 1
- [ ] Prerequisite 2

## Implementation Steps

### Step 1: [Specific Action]
**What**: [Detailed description of what to do]
**Files**: [List of files to modify/create]
**Changes**: [Specific changes to make]

#### Verification
- [ ] Test that [specific check]
- [ ] Confirm [expected behavior]

#### Rollback
- If this fails, [specific rollback action]

### Step 2: [Next Specific Action]
[Same structure as Step 1]

## Success Metrics
- [ ] All tests pass
- [ ] [Specific functionality works]
- [ ] No regressions in [area]
```

## Checking for Existing Plans

Before creating a new plan, I'll check if similar plans already exist:

!ls -la ~/instinct/claude_plans/plan_*_*.md 2>/dev/null | tail -10 || echo "No existing plans found"

## Saving the Plan

Once we've built the plan together, I'll:
1. Generate a descriptive filename: `plan_[component]_[feature]_[YYYYMMDD].md`
   - component: main area affected (e.g., auth, api, ui, db)
   - feature: brief description (e.g., user_login, data_export)
   - date: today's date in YYYYMMDD format

2. Show you a preview of the complete plan

3. Ask for your confirmation before saving

4. Save the plan to `~/instinct/claude_plans/`

5. Create a TodoWrite checklist from the plan steps for tracking

## Plan Preview and Confirmation

After building the plan, I'll:
- Display the full plan for your review
- Highlight any areas that might need adjustment
- Ask: "Does this plan look good? Should I save it as `[filename]`?"
- Make any requested adjustments before saving

Let's begin building your plan!
