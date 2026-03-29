# Todo

A Claude Code skill for managing your todo.txt task list via the `todo` CLI. Add, complete, prioritize, list, filter, and triage tasks using natural language.

## Prerequisites

This skill requires the [dotnet-todo](https://github.com/rprouse/dotnet-todo) CLI, a .NET command line port of the Todo.txt shell script. Install it as a global .NET tool (requires [.NET 8.0](https://dotnet.microsoft.com/download) or newer):

```bash
dotnet tool install -g dotnet-todo
```

## Installation

### Recommended (clone directly into Claude Code skills directory)

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/robprouse/ai-skills.git ~/.claude/skills/todo
```

### Manual install/update (only the skill file)

If you already have this repo cloned (or you downloaded `SKILL.md`), copy the skill file into Claude Code's skills directory:

```bash
mkdir -p ~/.claude/skills/todo
cp SKILL.md ~/.claude/skills/todo/
```

## Usage

Ask Claude to manage your tasks in natural language:

- **Adding:** "Add a todo to fix the deployment pipeline"
- **Listing:** "Show my work todos" or "What are my home tasks?"
- **Completing:** "Mark the insurance task as done"
- **Prioritizing:** "Set the migration task to priority A"
- **Triage:** "Review my todo list" or "Help me triage my tasks"

## CLI Command Reference

| Operation | Command | Notes |
|-----------|---------|-------|
| Add | `todo add -t "task @category"` | `-t` auto-adds today's date |
| List all | `todo ls` | Sorted by priority with line numbers |
| Filter | `todo ls <term>` | Filter by term, e.g. `@work`, `@home` |
| Filter priority | `todo lsp A` or `todo lsp A-C` | List by priority or range |
| Complete | `todo do <item#>` | Mark done by line number |
| Prioritize | `todo pri <item#> <A-Z>` | Set priority A (highest) through Z |
| Deprioritize | `todo dp <item#>` | Remove priority |
| Delete | `todo rm <item#>` | Remove task (confirms first) |
| Append | `todo app <item#> "text"` | Add text to end of task |
| Archive | `todo archive` | Move done tasks to done.txt |

## Category Inference

The skill automatically infers `@home` or `@work` categories from task context:

- **@home** -- chores, errands, family, health, bills, insurance, permits, house, personal items
- **@work** -- meetings, code, deploys, metrics, colleagues, tools, PRs, repos, professional items

If the category is ambiguous, the skill will ask before adding.

## Priority Scale

| Priority | Meaning |
|----------|---------|
| A | Urgent and important |
| B | Important |
| C | Normal |
| D | Low |
| E | Someday / maybe |

## License

MIT
