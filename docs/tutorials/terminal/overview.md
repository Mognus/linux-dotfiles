# Terminal Overview

The terminal setup is designed for fast daily use, not for visual gimmicks alone.

## What this topic covers

- Terminal emulator defaults
- Prompt structure and shell context
- Multiplexer usage
- Readability and startup ergonomics

## Main files

- `.config/alacritty/alacritty.toml`
- `.tmux.conf`

## Design goals

- Fast startup
- Clear prompt information
- Good contrast
- Minimal friction for multi-session work

## Current setup details

### Alacritty

The terminal emulator uses:

- `JetBrainsMono Nerd Font`
- font size `11`
- transparent background with `0.7` opacity
- custom window padding
- no window decorations

That keeps the terminal readable while visually fitting into the rest of the desktop.

### tmux

The terminal topic also includes `.tmux.conf`, and the shell aliases are already built around fast tmux usage:

- `ta`: attach to a named session
- `tn`: create a named session
- `tk`: kill a named session

The practical idea is that terminal work should be split into persistent sessions instead of relying on one long-lived shell tab.

## Practical idea

The terminal should be reliable enough to stay open all day. The configuration is meant to support coding, navigation, and service management without needing constant manual tweaking.
