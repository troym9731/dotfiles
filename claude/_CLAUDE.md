# Universal Context for All Prompts

## Bash alternatives
- `rg`: Use instead of `grep`
- `fd`: Use instead of `find`

## Workflow
- Check for the existence of a  `repomix-output.xml` file for help traversing a project.
- If the project has type checking, be sure to typecheck when you’re done making a series of code changes.
- Prefer running single tests, and not the whole test suite, for performance.
- DO NOT suggest code changes that include trailing whitespace! Always remove trailing whitespace.

## Custom Slash Commands
- Custom slash commands are user-defined prompts stored as Markdown files
- Project commands: `.claude/commands/` (shared with team, marked "(project)")
- Personal commands: `~/.claude/commands/` (available across all projects, marked "(user)")
- Support arguments with `$ARGUMENTS`, bash commands with `!`, file references with `@`
- Use YAML frontmatter for metadata like "allowed-tools" and "description"
- Create commands for repetitive tasks or team-specific workflows

### Available Personal Commands
- **`/jira`** - Fetch Jira issue details with parent context, show download URLs, and create comprehensive action plans with competing subagents
- **`/review-changes`** - Review local git changes including staged and unstaged modifications with code quality feedback

## Claude Code Assistant Configuration

### Subagent Task Execution
Claude Code should use subagents for parallel task execution to maximize efficiency and performance. When handling complex tasks that can be broken down into independent subtasks, Claude Code should:

1. **Launch Multiple Subagents Concurrently**: Use the Task tool to spawn multiple specialized subagents for different aspects of the work
2. **Parallel Processing**: Execute independent operations simultaneously rather than sequentially
3. **Task Specialization**: Delegate specific tasks to appropriate subagents based on their capabilities:
   - **Search Agent**: File searching, pattern matching, codebase exploration
   - **Analysis Agent**: Code analysis, dependency tracking, architecture review
   - **Implementation Agent**: Code writing, refactoring, file modifications
   - **Testing Agent**: Test execution, validation, quality assurance
   - **Documentation Agent**: Documentation updates, README generation

### Subagent Coordination Rules
- **Batch Operations**: Always batch independent tool calls in a single message for optimal performance
- **Concurrent Execution**: Use multiple Task tool invocations simultaneously when tasks are independent
- **Result Aggregation**: Collect and synthesize results from all subagents before providing final response
- **Error Handling**: If one subagent fails, other subagents should continue processing their tasks
- **Progress Tracking**: Use TodoWrite to track subagent progress and coordinate overall task completion

### Example Usage Patterns
```
# Instead of sequential execution:
1. Search for files → 2. Analyze code → 3. Implement changes → 4. Run tests

# Use concurrent subagents:
Task 1: Search Agent - Find all relevant files and patterns
Task 2: Analysis Agent - Analyze existing code architecture
Task 3: Implementation Agent - Prepare implementation strategy
Task 4: Testing Agent - Identify test requirements
(All running in parallel)
```

### Performance Optimization
- **Minimize Context Switching**: Keep subagents focused on their specialized tasks
- **Reduce Sequential Dependencies**: Break down tasks to minimize waiting for previous steps
- **Intelligent Task Distribution**: Route tasks to the most appropriate subagent type
- **Resource Efficiency**: Balance subagent count with system resources and API limits

## JIRA
Use the Atlassian/JIRA MCP to lookup ticket information in JIRA.

When creating tasks for tickets, they should be JIRA sub-tasks (make sure to inlcude the parent key). The correct `issueTypeName` is `Sub-task`.

To close a ticket , it can be transitioned to status `41`.

Usually I always want to reference a JIRA ticket when building a plan. All the context is there. Please remind me about this if I forget it in a session.

Please use the ./plans folder to find and store all plans for tickets.
For any prompt that includes a JIRA ticket number (like `PF-1234` or `ITP-1234`), please lookup the plan in the `./plans` project. If there is no plan yet, I want to store our plan in that project and work off of it.
