# Shell Overview

The shell configuration is focused on everyday productivity and low-friction command-line work.

## Main file

- `.zshrc`

## What this topic covers

- Completion with menu selection
- Shared history with substring search
- Autosuggestions and syntax highlighting
- Fast directory jumping with `zoxide`
- FZF-powered movement and completion helpers
- Screenshot and tmux helper aliases
- A prompt that shows context without staying visually heavy

## Main features

### Completion and command recall

The shell enables interactive completion and menu-based selection, so command and path completion feels more navigable than a plain fallback list.

History is configured to be shared and deduplicated, and the up/down arrow keys are mapped to substring history search. That means command recall is based on what you already typed, instead of forcing linear history scrolling.

### Interactive helpers

The setup includes:

- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `zsh-history-substring-search`
- `fzf` keybindings and completion
- `zoxide`

Together, those make navigation and recall much faster than relying on raw shell defaults.

### Directory jumping

`zoxide` is initialized for Zsh, and `Ctrl + G` is bound to the FZF directory jump widget. The goal is to move between frequently used project locations with as little typing as possible.

### Useful aliases

The shell includes a few practical aliases for recurring actions:

- `ll`: detailed directory listing
- `sc`: area screenshot to file
- `scf`: full screenshot to file
- `sce`: area screenshot piped into `swappy`
- `scc`: area screenshot copied to clipboard
- `ta`: attach to a tmux session
- `tn`: create a new tmux session
- `tk`: kill a tmux session

### Prompt behavior

The prompt is custom-built directly in `.zshrc`, instead of being delegated to an external prompt tool.

It includes:

- user and host
- current path
- current Git branch
- current time

It also uses a transient prompt behavior: after you submit a command, the large context prompt is replaced with a compact `❯`. That keeps long terminal sessions readable without losing useful context before execution.

### Custom styling

The shell does not just change behavior, it also shapes the visual experience directly:

- custom prompt layout
- custom prompt colors
- Git branch integration through `vcs_info`
- transient prompt behavior after command execution

That means the shell styling is part of the shell config itself, not a separate prompt layer sitting on top of it.

### Environment setup

The shell extends `PATH` with:

- `~/.local/bin`
- `/usr/local/go/bin`

## Workflow idea

The shell is designed to reduce repetition and keep navigation fast. Reused actions become aliases, recall is accelerated through search and suggestions, and the prompt gives context without permanently filling the screen.
