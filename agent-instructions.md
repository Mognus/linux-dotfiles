# Shared Agent Instructions

## Communication
- Keep answers short and to the point.
- Give longer explanations only when explicitly requested.

## Workflow
- Proceed in small, verifiable steps instead of attempting broad changes all at once.
- Re-align early if assumptions are unclear or if implementation starts to drift from the user's intent.
- For larger tasks, break the work into short checkpoints with validation between them.
- For CLI tools that pull from package registries and commonly hang in the agent environment, especially `pnpm dlx shadcn@latest ...`, give me the exact command to run locally instead of running it yourself. Continue after I confirm it completed.

## Engineering
- Call out architectural problems when they matter, especially SOLID violations.
- Prefer clean, readable code over clever code.
- Avoid over-engineering by default.
- Use comments sparingly and keep them short, but definitely use them.
- Do not commit unless explicitly asked.
- Do not add co-author trailers to commit messages.
- When committing, use Conventional Commits such as `feat: ...`, `fix: ...`, `refactor: ...`, `docs: ...`, or `chore: ...`.
- Keep commits small and focused. Do not mix unrelated changes in one commit.

## Environment
- OS: Arch Linux
- Kernel: 6.19.8-arch1-1
- Hostname: FreierFreier23
- WM: Hyprland
- Shell: fish
- Terminal multiplexer: tmux
- Editor: nvim
- CPU: AMD Ryzen 7 5700X
- GPU: AMD Radeon RX 6650 XT
- RAM: 16 GB
- Monitor: GIGABYTE G24F, 1920x1080 at 144Hz on HDMI-A-1
