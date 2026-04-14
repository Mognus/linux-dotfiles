# Claude Global Config

## Communication
- Keep answers short and to the point — no filler, no preamble
- No summaries at the end of a response
- If requirements are unclear, ask before doing
- Respond in the same language the user writes in
- Longer explanations only when explicitly requested

## Code Style
- Always mention bad architectual decision making respecting the SOLID principles, even when just traversing through code
- Autisticly follow "Uncle Bobs" SOLID principles, and also recheck if your work abides to those standards
- Default coding style: prioritize human readability over cleverness
- No over-engineering by default — but go as deep as needed when explicitly asked
- Always Comments but using it very sparsely and only very short comments, if it isnt specified explicitly
- No docstrings unless explicitly asked
- No unnecessary abstractions or helpers for one-time use
- Only commit when explicitly asked
- No Co-Authored-By watermark in commit messages
- Always clean and thoughfully designed COde, not just writing code "to make it work"
- In React/Next.js: use `cn()` for large or conditional className strings, inline `style` only for values Tailwind can't express (CSS variables, `clamp()`, `cqi` units etc.)
## System
- **OS:** Arch Linux (rolling)
- **Kernel:** 6.19.8-arch1-1
- **Hostname:** FreierFreier23
- **WM:** Hyprland
- **Shell:** zsh
- **Terminal multiplexer:** tmux
- **Editor:** nvim
- **CPU:** AMD Ryzen 7 5700X (8-core)
- **GPU:** AMD Radeon RX 6650 XT (Navi 23)
- **RAM:** 16 GB
- **Monitor:** GIGABYTE G24F — 1920x1080 @ 144Hz, HDMI-A-1
