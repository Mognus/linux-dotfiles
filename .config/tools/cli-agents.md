# CLI Agents

This setup keeps assistant tooling in dotfiles so project defaults stay reproducible.

## Codex

Codex config lives in `~/.codex/config.toml`. That file is machine-local and
gitignored; model, reasoning effort, sandbox permissions and trusted projects
are not versioned defaults of this repository.

Shared global instructions live in the repository-root `AGENTS.md`.
Home Manager links it to `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md`.

## Claude

Claude settings live in `.claude/settings.json`. Global instructions load through `~/.claude/CLAUDE.md`.

## Does

- Reads the shared `AGENTS.md` through the direct global symlink
- Keeps global assistant behavior close to the dotfiles
- Avoids duplicating project instructions across tools

## Workflow

Use Codex for codebase edits and terminal-driven refactors. Use Claude config as a lightweight global pointer to shared global instructions.
