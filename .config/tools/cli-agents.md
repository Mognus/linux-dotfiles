# CLI Agents

This setup keeps assistant tooling in dotfiles so project defaults stay reproducible.

## Codex

Codex config lives in `.codex/config.toml`.

## Does

- Uses `gpt-5.5`
- Sets reasoning effort to `high`
- Uses read-only sandboxing by default
- Marks selected project paths as trusted

## Claude

Claude config lives in `.claude/CLAUDE.md` and `.claude/settings.json`.

## Does

- Points Claude back to the repository-level `AGENTS.md`
- Keeps global assistant behavior close to the dotfiles
- Avoids duplicating project instructions across tools

## Workflow

Use Codex for codebase edits and terminal-driven refactors. Use Claude config as a lightweight global pointer to shared project instructions.
