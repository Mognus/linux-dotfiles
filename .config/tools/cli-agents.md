# CLI Agents

This setup keeps assistant tooling in dotfiles so project defaults stay reproducible.

## Codex

Codex config lives in `.codex/config.toml`. Shared global instructions live in the repository-root `AGENTS.md`.
`install.sh` links it directly to `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md`; Stow excludes it.

## Does

- Uses `gpt-5.5`
- Sets reasoning effort to `high`
- Uses read-only sandboxing by default
- Marks selected project paths as trusted

## Claude

Claude settings live in `.claude/settings.json`. Global instructions load through `~/.claude/CLAUDE.md`.

## Does

- Reads the shared `AGENTS.md` through the direct global symlink
- Keeps global assistant behavior close to the dotfiles
- Avoids duplicating project instructions across tools

## Workflow

Use Codex for codebase edits and terminal-driven refactors. Use Claude config as a lightweight global pointer to shared global instructions.
