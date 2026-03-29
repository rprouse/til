# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal "Today I Learned" (TIL) Obsidian vault — short write-ups on small learnings across languages and technologies. Notes are also read on GitHub, so GitHub compatibility matters.

## Key Conventions

### Link Style: Standard Markdown Only

Obsidian is configured with `"useMarkdownLinks": true`. **Always use standard markdown links**, not Obsidian wikilinks:
- Correct: `[Link Text](./category/note.md)`
- Wrong: `[[note]]`

This is critical because the vault is read on GitHub where wikilinks don't render.

### Note Format

- **One H1 title** at the top of each note
- Concise and practical — favor code examples over lengthy explanation
- Code blocks use language-specific syntax highlighting (```sh, ```python, ```csharp, etc.)
- No YAML frontmatter/properties
- Filenames: `kebab_case.md` or `snake_case.md` (varies, match the existing category style)

### Adding a New TIL

1. Create the `.md` file in the appropriate category subdirectory (e.g., `git/`, `python/`, `linux/`)
2. Create the subdirectory if the category is new
3. **Add a link to `Readme.md`** under the correct category heading — this is the index file
4. Categories in `Readme.md` use emoji headers (e.g., `## 🐍 Python`) and are listed alphabetically
5. Links use relative paths: `- [Title](./category/filename.md)`

### Images

Attachments go in the `img/` directory at the vault root.

## Editor Config

- 2-space indentation (default), UTF-8, LF line endings
- Python and assembly (`.s`, `.asm`): 4-space indentation
- Makefiles: tab indentation

## Git

Line endings are forced to LF across platforms:
```sh
git config core.autocrlf false
git config core.eol lf
```

Commits are created by the Obsidian Git plugin with message format: `vault backup: YYYY-MM-DD HH:MM:SS`

## License

CC BY-NC-SA 4.0 — do not add content that conflicts with this license.
