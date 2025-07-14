---
description: Review local git changes including staged and unstaged modifications with code quality feedback across all git repos in subdirectories
allowed-tools: ["Task", "Bash", "LS"]
---

# Comprehensive Git Changes Review with Dual Analysis

I'll analyze your git changes using two independent subagents who will then compare their findings to provide a unified, comprehensive code review. This will search all subdirectories for git repositories and analyze changes across all of them.

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

## Analysis Results
Now I'll spawn two subagents to independently analyze these changes:

**Subagent 1 - Independent Review:**
Please analyze the git changes above and provide feedback on:
- Code quality and best practices
- Potential issues or bugs
- Suggestions for improvement
- Security considerations
- Project-specific guidelines (CLAUDE.md compliance)

**Subagent 2 - Independent Review:**
Please analyze the git changes above and provide feedback on:
- Code quality and best practices
- Potential issues or bugs
- Suggestions for improvement
- Security considerations
- Project-specific guidelines (CLAUDE.md compliance)

After both independent analyses are complete, I'll have them compare their findings, identify areas of agreement and disagreement, and synthesize their insights into a unified summary with prioritized recommendations.

$ARGUMENTS