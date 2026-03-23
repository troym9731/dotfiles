---
description: Fetch Jira issue details with parent context, show download URLs, and create action plan with deep sequential thinking
allowed-tools: ["mcp__atlassian__getAccessibleAtlassianResources", "mcp__atlassian__atlassianUserInfo", "mcp__atlassian__getJiraIssue", "mcp__atlassian__searchJiraIssuesUsingJql", "mcp__atlassian__getJiraIssueRemoteIssueLinks", "mcp__atlassian__getTransitionsForJiraIssue", "mcp__atlassian__lookupJiraAccountId", "mcp__atlassian__getVisibleJiraProjects", "mcp__atlassian__getJiraProjectIssueTypesMetadata", "mcp__atlassian__getConfluenceSpaces", "mcp__atlassian__getConfluencePage", "mcp__atlassian__getPagesInConfluenceSpace", "mcp__atlassian__getConfluencePageAncestors", "mcp__atlassian__getConfluencePageFooterComments", "mcp__atlassian__getConfluencePageInlineComments", "mcp__atlassian__getConfluencePageDescendants", "mcp__atlassian__searchConfluenceUsingCql", "Write", "Read", "TodoWrite", "TodoRead", "Task", "Bash", "WebFetch", "mcp__sequential-thinking__sequentialthinking"]
---

# Jira Issue Analysis and Action Plan with Deep Sequential Thinking

I'll analyze the Jira issue **$ARGUMENTS**, show attachment download URLs, and create a comprehensive action plan for implementation using deep sequential thinking for thorough analysis.

## Important Notes from Project Guidelines

- When creating tasks for tickets, they should be JIRA sub-tasks (make sure to include the parent key). The correct `issueTypeName` is `Sub-task`.
- To close a ticket, it can be transitioned to status `41`.
- Plans should be stored in the `~/instinct/claude_plans/` directory to find and store all plans for tickets.
- For any prompt that includes a JIRA ticket number (like `PF-1234` or `ITP-1234`), lookup the plan in the `~/instinct/claude_plans/` directory first.

## Deep Sequential Analysis of Issue

Before fetching data, I'll use sequential thinking to deeply analyze what we need to understand about this issue:

I'll now use sequential thinking to thoroughly analyze the Jira issue **$ARGUMENTS** before creating implementation plans. This will help me understand the full context, identify hidden complexities, and create more comprehensive action plans.

## Fetching Issue Data

First, I'll get the Atlassian Cloud ID and fetch the issue details:

Let me get the accessible Atlassian resources to find the correct Cloud ID:

I'll now fetch the Jira issue details for **$ARGUMENTS**. This will include the issue data, parent context if applicable, and any attachments.

## Check for Existing Plan

I'll check if there's already a plan for this ticket in ~/instinct/claude_plans/:

!ls -la ~/instinct/claude_plans/*$ARGUMENTS* 2>/dev/null || echo "No existing plan found for $ARGUMENTS"

## Attachment Download Management

### Download Directory Setup

!mkdir -p ~/instinct/claude_downloads

### Check for Previously Downloaded Attachments

!ls -la ~/instinct/claude_downloads/*$ARGUMENTS* 2>/dev/null || echo "No previously downloaded attachments found for $ARGUMENTS"

## Issue Component Analysis

I'll analyze the issue to determine which component of the Instinct system it affects:

### Component Mapping:
- **[FE]** = Frontend (kong-fu) - React/TypeScript user interface
- **[BE]** = Backend (chunky-kong) - Elixir/Phoenix server logic  
- **[SD]** = Standard Data - JSON configuration files
- **[Admin]** = General administrative tasks

## Action Plan Generation

I'll now spawn two competing subagents to create implementation plans. Each will review the project guidelines and propose their own approach, then collaborate to create a unified plan.

### Expert Implementation Planning

I'll use specialized expert agents based on the component type to create implementation plans:

**For Backend ([BE]) Components:**
Launching elixir-phoenix-expert agent to create a Phoenix/Elixir implementation plan that:
- Follows Phoenix conventions and patterns
- Designs proper Ecto schemas and queries
- Implements proper contexts and boundaries
- Considers OTP principles and supervision trees
- Plans for testing with ExUnit

**For Frontend ([FE]) Components:**
Launching react-code-reviewer agent to create a React implementation plan that:
- Designs component architecture
- Plans state management strategy
- Considers performance optimizations
- Implements proper hook patterns
- Plans for testing with Jest/React Testing Library

**For All Components:**
Launching security-code-reviewer agent in parallel to:
- Identify security requirements
- Plan authentication/authorization checks
- Design input validation strategies
- Consider data protection needs
- Plan security testing

The expert agents will:
1. Read the project guidelines from @/Users/troymullaney/instinct/CLAUDE.md
2. Use sequential thinking to deeply analyze the requirements
3. Create a comprehensive implementation plan following project conventions
4. Consider creating JIRA sub-tasks for major implementation steps (using issueTypeName: "Sub-task")
5. Save the plan to ~/instinct/claude_plans/expert_plan_$ARGUMENTS.md
6. Use the TodoWrite tool to create a detailed action plan for documentation purposes only

### Parallel Expert Analysis

The expert agents are now working in parallel to create comprehensive implementation plans from their specialized perspectives. Each agent brings unique expertise:

- **elixir-phoenix-expert**: Deep knowledge of Phoenix patterns, Ecto optimization, and OTP design
- **react-code-reviewer**: Expertise in React patterns, performance, and modern frontend architecture
- **security-code-reviewer**: Focus on vulnerabilities, authentication, and data protection

They will collaborate to produce a unified plan that balances:
- Technical excellence with practical delivery
- Security requirements with development speed
- Best practices with project-specific conventions

### Collaborative Plan Synthesis with Deep Sequential Thinking

Now I'll have both agents collaborate using sequential thinking to create the final unified plan.

You are facilitating a collaboration between two senior engineers who have created competing implementation plans for the same Jira ticket. Your task is to:

1. Use the mcp__sequential-thinking__sequentialthinking tool to deeply synthesize both plans:
   - Compare and contrast the approaches systematically
   - Identify synergies and conflicts between plans
   - Generate hypotheses about the optimal combined approach
   - Verify the unified plan addresses all requirements
   - Consider second and third-order effects of implementation choices
2. Review both Implementation Plan Alpha (thorough/methodical) and Implementation Plan Beta (efficient/rapid)
3. Identify the best elements from each approach
4. Synthesize a unified plan that balances thoroughness with efficiency
5. Resolve any conflicts between the approaches
6. **Ask clarifying questions** if you need more information about requirements, constraints, or priorities
7. **IMPORTANT**: Create a markdown document with the unified plan - DO NOT execute any code or make changes
8. Use the Write tool to save the final plan as a markdown file in ~/instinct/claude_plans/
9. Create a final TodoWrite action plan that incorporates the best of both strategies for documentation purposes only
10. If creating JIRA sub-tasks, remember to use the parent issue key and issueTypeName: "Sub-task"

Consider the project context from @/Users/troymullaney/instinct/CLAUDE.md and the issue details provided.

Your final plan should be practical, achievable, and well-structured for implementation.

**Output Format**: Create a comprehensive markdown document and save it to ~/instinct/claude_plans/unified_plan_$ARGUMENTS.md

**Questions Welcome**: Feel free to ask clarifying questions about requirements, technical constraints, or implementation priorities before finalizing your unified plan.

## Plan Storage

The final unified plan will be stored at: ~/instinct/claude_plans/unified_plan_$ARGUMENTS.md

Any downloaded attachments will be saved to: ~/instinct/claude_downloads/ with the pattern: $ARGUMENTS_[filename]

$ARGUMENTS