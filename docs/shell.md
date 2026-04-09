# Shell Setup

## Keybindings

| Keybind      | Action                                    |
|--------------|-------------------------------------------|
| `Ctrl+R`     | Fuzzy search command history              |
| `Ctrl+T`     | Fuzzy search files (from `~`)             |
| `Ctrl+G`     | Fuzzy cd into directory (from `~`)        |
| `↑ / ↓`      | History substring search                  |
| `Ctrl+→ / ←` | Jump forward / backward by word           |

All shell keybinds work from anywhere in zsh.

## Tools

| Tool      | Usage                                                        |
|-----------|--------------------------------------------------------------|
| `fzf`     | Powers Ctrl+R, Ctrl+T, Ctrl+G                                |
| `fd`      | Fast file finder, used as fzf backend                        |
| `zoxide`  | Smart cd — learns frecent dirs (`z <name>`, `zi` for picker) |
| `bat`     | Syntax-highlighted cat (`bat file.txt`)                      |
| `ripgrep` | Fast grep (`rg pattern`)                                     |

## fzf Configuration

`Ctrl+T` and `Ctrl+G` always search from `~`, configured in `.zshrc`:

```zsh
export FZF_CTRL_T_COMMAND='fd --type f . $HOME'
export FZF_ALT_C_COMMAND='fd --type d . $HOME'
```
