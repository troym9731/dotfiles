---
description: Execute a plan from a markdown file using sequential thinking with incremental changes and user confirmation
allowed-tools: ["Read", "Edit", "Write", "MultiEdit", "Bash", "Grep", "Glob", "LS", "TodoWrite", "TodoRead", "mcp__sequential-thinking__sequentialthinking", "Task"]
---

# Execute Plan with Sequential Thinking and Incremental Changes

I'll execute the plan from **$ARGUMENTS** using sequential thinking to break down the implementation into small, reviewable changes.

## Initial Setup

First, I'll read the plan file and use sequential thinking to analyze the implementation strategy:

@$ARGUMENTS

## Expert Validation Phase

Before starting execution, I'll consult the appropriate expert agents based on the plan content:

**Technology Detection:**
- Analyzing the plan to identify which technologies are involved
- Routing to appropriate expert agents for validation

**Expert Consultation:**
- For Elixir/Phoenix changes: elixir-phoenix-expert validates the approach
- For React/TypeScript changes: react-code-reviewer validates the implementation strategy
- For all changes: security-code-reviewer checks for potential security risks

The expert agents will review the plan and provide guidance on:
- Best practices for the specific technology
- Potential pitfalls to avoid
- Optimization opportunities
- Security considerations

## Sequential Analysis of Implementation Steps

After expert validation, I'll use sequential thinking to:
1. Break down the plan into atomic, executable steps
2. Identify dependencies between steps
3. Determine the safest order of execution
4. Plan verification methods for each change
5. Consider potential rollback strategies

## Execution Strategy

### Implementation Principles:
- **Small Changes**: Each change should be minimal and focused on a single concern
- **User Confirmation**: After each change, I'll show what was done and ask for confirmation before proceeding
- **Verification**: Each step includes verification that the change was successful
- **Rollback Ready**: Keep track of changes to enable easy rollback if needed
- **Sequential Thinking**: Use deep analysis before each step to ensure correctness

### Execution Flow:
1. Use sequential thinking to analyze the next step from the plan
2. Implement the smallest possible change that makes progress
3. Show the exact changes made (using git diff or file comparison)
4. Verify the change doesn't break existing functionality
5. Ask: "This change [description]. Should I continue with the next step?"
6. Wait for user confirmation before proceeding
7. If user says no, discuss alternatives or adjustments
8. Repeat until plan is complete

## Progress Tracking

I'll use TodoWrite to track:
- Overall plan steps (from the markdown file)
- Current step being executed
- Completed steps
- Any issues or blockers encountered

## Change Documentation

For each change, I'll provide:
- **What**: Brief description of the change
- **Why**: How it fits into the overall plan
- **Files Modified**: List of affected files
- **Diff Preview**: Show the actual changes made
- **Verification**: How I verified the change is correct
- **Next Step Preview**: What I plan to do next

## Safety Checks

Before each change:
- Verify I'm in the correct directory
- Check git status to ensure clean working directory
- Confirm I understand the current state
- Use sequential thinking to predict potential issues

## User Control Points

You can at any time:
- Say "stop" to pause execution
- Say "rollback" to undo the last change
- Say "skip" to skip the current step
- Say "continue" to proceed with the next change
- Ask questions about why a change is being made
- Request modifications to the approach

## Starting Execution

I'll now begin by reading the plan and using sequential thinking to determine the first small change to make.

$ARGUMENTS