# Shared Agent Instructions


## Conduct
- Talk and explain thinks, like you're Talking to someone with ADHD, use examples to explain stuff.
- Answer at the lowest level of abstraction: show the plain mechanism first (e.g. `ls -l /proc/<PID>/cwd`) instead of a wrapper, a tool or a clever one-liner. Especially on Linux the lowest level is usually the simplest.

## Engineering
- SOLID as a diagnostic, not a checklist — name violations that actually cost something, ignore the rest.
- KISS: simplest thing that works. Readable over clever, boring is a feature.
- YAGNI: build what's needed now. No speculative hooks, options, or extension points.
- Rule of Three: don't abstract until the third repetition. Duplication beats the wrong abstraction.
- Always define scope before tackling any bigger Task, inside of this scope initialize little Tasks Packages, so everything stays verifiable,
we dont do things, that are completely unnecessary / make the code unclean because AI makes code that does the Job, but is unmaintainable in the long-term
- Small verifiable steps, stay in scope — flag adjacent problems instead of fixing them unasked.
- Never test with curl unless i explicitly ask for it

## Python
- Write Python like Go: plain `for` loops and `if` blocks, one step per line, early returns. Spread code over more lines instead of compressing it; readable beats short.
- No "magic" one-liners in project code: no `next(... for ...)`, no nested comprehensions, no `map`/`filter`/`lambda` chains, no conditional expressions inside comprehensions, no `**`/`*` unpacking tricks to merge things. A simple comprehension over one collection with at most one condition is fine.
- Name arguments whose meaning is not obvious from the call (`string=`, `comodel_name=`, `allowed=`), instead of relying on position.
- Every helper function gets a docstring with a concrete example: input → output.

## Git
- Never commit unless I explicitly ask.
- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`.
- Small, focused commits — no unrelated changes mixed in.
- No co-author trailers.

## Environment
- OS: Arch Linux
- Kernel: 6.19.8-arch1-1
- Hostname: FreierFreier23
- WM: Hyprland
- Shell: fish
- Terminal multiplexer: tmux
- Main IDE: Zed
- Editor: nvim (terminal work, quick edits)
- CPU: AMD Ryzen 7 5700X
- GPU: AMD Radeon RX 6650 XT
- RAM: 16 GB
- Monitor: GIGABYTE G24F, 1920x1080 at 144Hz on HDMI-A-1
