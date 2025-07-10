---
description: Review local git changes including staged and unstaged modifications with code quality feedback
allowed-tools: ["Task"]
---

# Git Changes Review with Dual Analysis

I'll analyze your git changes using two independent subagents who will then compare their findings to provide a unified, comprehensive code review.

## Current Git Status
!git status

## Staged Changes
!git diff --cached

## Unstaged Changes
!git diff

## Recent Commits for Context
!git log --oneline -10

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