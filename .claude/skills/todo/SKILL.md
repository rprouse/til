---
name: todo
description: >
  Manage your todo.txt task list using the `todo` CLI. Add, complete, prioritize,
  list, filter, and triage tasks. Use when the user mentions todos, tasks, to-do
  lists, or wants to review what they need to do.
---

# Todo: Manage Your Task List

This skill manages tasks via the `todo` CLI, a .NET port of Todo.txt. It supports adding, completing, prioritizing, listing, filtering, and triaging tasks from your todo.txt file.

## Before any operation

Always run `todo ls` first to get current line numbers. Line numbers shift after adds and deletes, so a stale number can target the wrong task.

## CLI reference

| Operation | Command | Notes |
|-----------|---------|-------|
| Add | `todo add -t "task @category"` | Always use `-t` to auto-add today's date |
| List all | `todo ls` | Sorted by priority with line numbers |
| Filter | `todo ls <term>` | Filter by any term, e.g. `@work`, `@home` |
| Filter priority | `todo lsp A` or `todo lsp A-C` | List tasks by priority or range |
| Complete | `todo do <item#>` | Mark done by line number |
| Prioritize | `todo pri <item#> <A-Z>` | Set priority A (highest) through Z |
| Deprioritize | `todo dp <item#>` | Remove priority |
| Delete | `todo rm <item#>` | Remove task — always confirm with user first |
| Append | `todo app <item#> "text"` | Add text to end of task |
| List contexts | `todo lsc` | Show all `@` categories in use |
| List projects | `todo lspj` | Show all `+` projects in use |
| Archive | `todo archive` | Move done tasks to done.txt |
| List all (incl. done) | `todo lsa` | Show todo.txt and done.txt combined |

## Managing tasks

### Adding tasks

Always use the `-t` flag so today's date is recorded automatically. Infer whether a task belongs to `@home` or `@work` from context:

- **@home** — chores, errands, family, health, bills, insurance, permits, videos, house, personal items
- **@work** — meetings, code, deploys, metrics, colleagues, tools, PRs, repos, professional items

Known contextual tags (`@victoria`, `@anju`, `@asteris`, `@computer`) go alongside the primary category, not instead of it. If the category is ambiguous, ask the user before adding.

Example:

```
todo add -t "Fix deployment pipeline @work"
todo add -t "Schedule dentist appointment @home"
todo add -t "Review PR with @anju @work"
```

### Completing tasks

Use `todo do <item#>` to mark a task done. Always run `todo ls` afterward to show the updated list.

### Prioritizing tasks

Use `todo pri <item#> <letter>` to set priority. The scale is:

| Priority | Meaning |
|----------|---------|
| A | Urgent and important |
| B | Important |
| C | Normal |
| D | Low |
| E | Someday / maybe |

### Deleting tasks

Use `todo rm <item#>`. Always confirm with the user before deleting a task.

### After any mutation

After adding, completing, prioritizing, or deleting a task, run `todo ls` to display the updated list.

## Triage and review

### When to triage

- **Explicit:** the user asks to "review my todos", "triage my list", "clean up my tasks", or similar
- **Proactive:** after any `todo ls`, if items older than 6 months are visible, note: "I notice N items are over 6 months old. Want me to help triage your list?"

### Triage workflow

1. Run `todo ls` to get the full list with line numbers and dates
2. Calculate the age of each item from its creation date
3. Group items by category (`@home`, `@work`, etc.)
4. For stale items (6+ months old), ask about each one:
   - **Keep / reprioritize** — still relevant, optionally adjust priority
   - **Mark done** — already completed, use `todo do <item#>`
   - **Delete** — no longer needed, use `todo rm <item#>` after confirmation
5. For unprioritized items, suggest an appropriate priority (A through E) based on the task description
6. Summarize all changes at the end: how many items were completed, deleted, reprioritized, and how many remain
