# Shared Agent Instructions

Used as the canonical instruction file for Codex and imported by Claude via `.claude/CLAUDE.md`.

## Communication
- Keep answers short and to the point.
- Default to the shortest answer that fully solves the user's request.
- No filler and no unnecessary preamble.
- Do not pad responses with motivational text, generic praise, or repeated context.
- Do not add a summary at the end unless it adds real value.
- If requirements are unclear and the ambiguity matters, ask before doing risky work.
- Respond in the same language the user writes in.
- Give longer explanations only when explicitly requested.

## Workflow
- Proceed in small, verifiable steps instead of attempting broad changes all at once.
- Prefer the smallest useful next change over ambitious multi-part refactors.
- Re-align early if assumptions are unclear or if implementation starts to drift from the user's intent.
- For larger tasks, break the work into short checkpoints with validation between them.

## Engineering
- Call out architectural problems when they matter, especially SOLID violations.
- Re-check your own work against SOLID principles before considering it done.
- Prefer clean, readable code over clever code.
- Avoid over-engineering by default.
- Use comments sparingly and keep them short.
- Prefer no comment over a comment that only restates the code.
- Only add a comment when it gives context, intent, or a constraint that is not obvious from the code itself.
- Do not add docstrings unless explicitly requested.
- Do not introduce abstractions or helpers for one-time use without a clear reason.
- Do not commit unless explicitly asked.
- Do not add co-author trailers to commit messages.
- Aim for thoughtful, maintainable code, not just code that happens to work.
- When committing, use Conventional Commits such as `feat: ...`, `fix: ...`, `refactor: ...`, `docs: ...`, or `chore: ...`.
- Never use a free-form commit message when a Conventional Commit is expected.
- Keep commits small and focused. Do not mix unrelated changes in one commit.

## Frontend
- In React and Next.js, prefer `cn()` for large or conditional `className` strings.
- Use inline `style` only for values Tailwind cannot express well, such as CSS variables, `clamp()`, or container query units.
- Put layout-specific structure directly in the assembly component that owns the markup.
- Keep Flexbox and Grid dependencies visible in JSX when they are important for understanding the layout.
- Prefer composite CSS classes for visual styling such as typography, colors, borders, transitions, and hover states.
- Avoid fragile child-selector styling when explicit class hooks in component markup are practical.

## Environment
- OS: Arch Linux
- Kernel: 6.19.8-arch1-1
- Hostname: FreierFreier23
- WM: Hyprland
- Shell: zsh
- Terminal multiplexer: tmux
- Editor: nvim
- CPU: AMD Ryzen 7 5700X
- GPU: AMD Radeon RX 6650 XT
- RAM: 16 GB
- Monitor: GIGABYTE G24F, 1920x1080 at 144Hz on HDMI-A-1
