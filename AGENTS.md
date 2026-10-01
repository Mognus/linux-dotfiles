# Shared Agent Instructions


## Conduct
- Talk and explain thinks, like you're Talking to someone with ADHD, use examples to explain stuff.
- Answer at the lowest level of abstraction: show the plain mechanism first (e.g. `ls -l /proc/<PID>/cwd`) instead of a wrapper, a tool or a clever one-liner. Especially on Linux the lowest level is usually the simplest.

## Engineering
- before making a Plan, always consult online documentation in order to find the most simple solution... Internal Training-Data can seduce onself to overengineer stuff, because of the sheer amount of overengineered ego-jerks happening inside of the World Wide Web.
- SOLID as a diagnostic, not a checklist — name violations that actually cost something, ignore the rest.
- KISS: simplest thing that works. Readable over clever, boring is a feature. 
- YAGNI: build what's needed now. No speculative hooks, options, or extension points.
- Rule of Three: don't abstract until the third repetition. Duplication beats the wrong abstraction.
- Always define scope before tackling any bigger Task, inside of this scope initialize little Tasks Packages, so everything stays verifiable.
- Small verifiable steps, stay in scope — flag adjacent problems instead of fixing them unasked.
- No workarounds for simple architectural gaps. When something is missing or awkward, first check what the project already provides (README, Makefile, .gitignore, requirements) and name the proper fix out loud before bending around it. Example: tests need a local venv → create `.venv` as the README says, not a temp venv in a scratch dir or a container with mounted tests and ad-hoc `pip install`. If only a workaround is possible, say so and ask first.
- Never test with curl unless i explicitly ask for it

## General Programming Rules
- Dont use Loop-Shortcuts like list comprehensions or mapping functions when there are Nesting-Levels beyond 2 (unless it's really clean or core concept like iterator chaining in Rust)

## Python
- Name arguments whose meaning is not obvious from the call (`string=`, `comodel_name=`, `allowed=`), instead of relying on position.
- Every helper function gets a docstring with a concrete example: input → output.

## Git
- Never commit unless I explicitly ask.
- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`.
- Small, focused commits — no unrelated changes mixed in.
- No AI attribution anywhere: no co-author trailers, no "Generated with …" lines in commits, PRs, issues or comments.

## Environment
- OS: NixOS 26.11 (Zokor)
- Kernel: 7.2.8
- Hostname: luxxer23-desktop
- WM: Hyprland
- Shell: fish
- Terminal multiplexer: tmux
- Main IDE: nvim
- Editor: nvim (terminal work, quick edits)
- CPU: AMD Ryzen 7 5700X
- GPU: AMD Radeon RX 6650 XT
- RAM: 16 GB
- Monitor: GIGABYTE G24F, 1920x1080 at 144Hz on HDMI-A-1
