---
allowed-tools: ["Task", "Bash", "Bash(gh pr list:*)", "Bash(gh pr view:*)", "Bash(gh pr diff:*)", "Bash(gh pr checks:*)", "Bash(git log:*)", "Bash(git diff:*)", "Read", "Grep", "Glob", "LS", "TodoWrite"]
description: Unified code review - PRs, local changes, or recent commits with expert agent analysis
---

# Intelligent Code Review with Expert Agents

I'll analyze your code changes using specialized expert agents. This command intelligently handles multiple input types.

## Understanding Your Request

Input: **$ARGUMENTS**

Let me determine what you want to review:
- **Number** (e.g., 123) → GitHub Pull Request #123
- **HEAD~N** (e.g., HEAD~3) → Last N local commits
- **No argument** → All local staged/unstaged changes
- **Branch name** → Changes from that branch
- **Commit SHA** → Changes from that specific commit

## Initial Analysis

First, I'll detect the type of review requested and gather the appropriate changes:

!# Detect input type and route accordingly
if [[ -z "$ARGUMENTS" ]]; then
  echo "Reviewing local staged and unstaged changes..."
elif [[ "$ARGUMENTS" =~ ^[0-9]+$ ]]; then
  echo "Reviewing Pull Request #$ARGUMENTS..."
elif [[ "$ARGUMENTS" =~ ^HEAD~[0-9]+$ ]]; then
  echo "Reviewing last ${ARGUMENTS#HEAD~} commits..."
elif [[ "$ARGUMENTS" == "HEAD" ]]; then
  echo "Reviewing last commit..."
else
  echo "Reviewing changes from $ARGUMENTS..."
fi

## Gathering Changes

### For Pull Requests (numeric input):
If this is a PR number, I'll:
1. Use `gh pr view $ARGUMENTS` to get PR details
2. Use `gh pr diff $ARGUMENTS` to get the full diff
3. Optionally use `gh pr checks $ARGUMENTS` to see CI status

### For Local Changes (no input or HEAD~N):
I'll check across all git repositories in subdirectories:
1. Find all git repositories: `find . -type d -name ".git"`
2. For each repo, gather:
   - Current status: `git status`
   - Staged changes: `git diff --cached`
   - Unstaged changes: `git diff`
   - Recent commits if HEAD~N: `git diff HEAD~N`

### For Branch/Commit (other input):
I'll get the diff from the specified reference:
- `git diff $ARGUMENTS` or `git show $ARGUMENTS`

## File Type Detection

Analyzing the changed files to determine which expert agents to launch:

!# Quick detection of file types in the changes
echo "Detecting file types in changes..."

## Expert Agent Analysis

Based on the file types detected, I'll launch specialized expert agents in parallel:

### Security Analysis (Always)
**Launching security-code-reviewer agent** to check all changes for:
- SQL injection vulnerabilities
- Authentication/authorization issues
- Data exposure risks
- Input validation problems
- Hardcoded credentials or secrets
- Cross-site scripting (XSS) risks
- Insecure dependencies

### Technology-Specific Analysis

**For Elixir/Phoenix files** (.ex, .exs, .heex):
**Launching elixir-phoenix-expert agent** to review:
- Phoenix conventions and patterns
- Ecto query optimization
- OTP design principles
- Context boundaries and schemas
- LiveView best practices
- GenServer implementations
- Pattern matching usage
- Error handling with {:ok, _} / {:error, _} tuples

**For React/TypeScript files** (.jsx, .tsx, .js, .ts with React):
**Launching react-code-reviewer agent** to analyze:
- Component structure and composition
- Hook usage and dependencies
- Performance optimizations (memoization, lazy loading)
- State management patterns
- TypeScript type safety
- Accessibility (a11y) considerations
- Testing coverage

**For other file types**:
- Configuration files: Check for sensitive data
- Documentation: Verify accuracy
- Tests: Ensure coverage and quality

## Deep Analysis

Before the expert agents provide their feedback, I'll use thinking to:
1. Understand the overall purpose of the changes
2. Identify the impact across the codebase
3. Detect patterns and relationships between files
4. Consider deployment and rollback implications
5. Generate hypotheses about potential issues

## Review Output Structure

The combined expert analysis will provide:

### 📋 Overview
- Summary of what the changes accomplish
- Scope and impact assessment

### ✅ Strengths
- Well-implemented patterns
- Good practices observed

### ⚠️ Issues & Recommendations
**Critical** (Must Fix):
- Security vulnerabilities
- Breaking changes
- Data corruption risks

**Important** (Should Fix):
- Performance problems
- Code quality issues
- Missing tests

**Suggestions** (Nice to Have):
- Refactoring opportunities
- Documentation improvements
- Style consistency

### 🔍 Detailed Analysis
File-by-file or component-by-component breakdown with specific line references

### 📊 Metrics
- Test coverage impact
- Complexity changes
- Performance implications

## Synthesis Phase

After all expert agents complete their analysis, I'll:
1. Combine insights from all agents
2. Prioritize findings by severity
3. Resolve any conflicting recommendations
4. Provide actionable next steps
5. Suggest an approval/revision decision (for PRs)

$ARGUMENTS
