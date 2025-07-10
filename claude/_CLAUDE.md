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
