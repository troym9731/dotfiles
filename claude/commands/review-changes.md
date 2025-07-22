---
description: Review local git changes including staged and unstaged modifications with deep sequential thinking code quality feedback across all git repos in subdirectories
allowed-tools: ["Task", "Bash", "LS", "mcp__sequential-thinking__sequentialthinking"]
---

# Comprehensive Git Changes Review with Deep Sequential Thinking

I'll analyze your git changes using two independent subagents with deep sequential thinking capabilities who will then compare their findings to provide a unified, comprehensive code review. This will search all subdirectories for git repositories and analyze changes across all of them using multi-step reasoning.

## Finding All Git Repositories
First, let me discover all git repositories in the current directory and subdirectories:

!find . -type d -name ".git" | head -20

## Comprehensive Git Analysis
Now I'll analyze changes across all discovered repositories:

For each repository found, I'll check:
- Current git status
- Staged changes (git diff --cached)
- Unstaged changes (git diff)  
- Recent commits for context

Let me gather all this information systematically across all repositories.

## Deep Sequential Analysis Phase
Before spawning subagents, I'll use sequential thinking to deeply understand the context and nature of the changes:

I'll use the mcp__sequential-thinking__sequentialthinking tool to analyze the git changes systematically, considering:
- The overall scope and impact of changes
- Patterns and relationships between modified files
- Potential ripple effects across the codebase
- Hidden dependencies or assumptions
- Security and performance implications

## Analysis Results
Now I'll spawn two subagents to independently analyze these changes with deep sequential thinking:

**Subagent 1 - Deep Methodical Review:**
Please use the mcp__sequential-thinking__sequentialthinking tool to thoroughly analyze the git changes above. Your sequential thinking should cover:
- Step-by-step analysis of each change's impact
- Identification of code quality issues through multi-step reasoning
- Deep exploration of potential bugs by considering edge cases
- Systematic security analysis through threat modeling
- Verification of project-specific guidelines (CLAUDE.md compliance)
- Generation and testing of hypotheses about code behavior

Focus on thoroughness and depth, even if it requires many thought steps.

**Subagent 2 - Rapid Insightful Review:**
Please use the mcp__sequential-thinking__sequentialthinking tool to efficiently analyze the git changes above. Your sequential thinking should focus on:
- Quick identification of critical issues
- Pattern recognition across changes
- Pragmatic suggestions for improvement
- Risk assessment and prioritization
- Compliance verification with minimal steps
- Hypothesis generation for the most impactful improvements

Focus on actionable insights and practical recommendations.

**Synthesis Phase:**
After both independent analyses are complete, I'll use sequential thinking to:
1. Compare and contrast both review perspectives
2. Identify consensus points and divergent insights
3. Generate a unified understanding of the changes
4. Create prioritized recommendations based on impact and effort
5. Verify that all critical issues have been addressed

The final synthesis will provide you with a comprehensive, well-reasoned code review that balances depth with practicality.

$ARGUMENTS