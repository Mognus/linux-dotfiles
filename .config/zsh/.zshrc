# Persistent history, shared between interactive shells.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

bindkey -e

# Treat / as a word boundary: Ctrl+W removes one path component at a time.
WORDCHARS=${WORDCHARS//\/}

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

# Keep the completion menu, but only show it on Tab, not while typing.
zstyle ':autocomplete:*' ignored-input '*'
# Runs compinit itself, so load it before any compdef.
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/autocomplete.zsh"
# Restore FZF history search after autocomplete overrides Ctrl+R.
if (( $+widgets[fzf-history-widget] )); then
    bindkey '^R' fzf-history-widget
fi
# Enter menu selection so the current completion is highlighted.
# Inside the menu, Tab / Shift+Tab already select the next / previous item.
bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

# Plain theme files, no generator. Alacritty reloads colors.toml automatically.
dark() {
    cp "$HOME/.config/alacritty/themes/gruvbox-dark.toml" "$HOME/.config/alacritty/colors.toml" || return
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
}

light() {
    cp "$HOME/.config/alacritty/themes/gruvbox-light.toml" "$HOME/.config/alacritty/colors.toml" || return
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
}

if [[ -n $WAYLAND_DISPLAY && -S $XDG_RUNTIME_DIR/ssh-agent ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
fi

source "$ZDOTDIR/prompt.zsh"
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/autosuggestions.zsh"
# Load last so highlighting sees all widgets, including FZF's bindings.
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/syntax-highlighting.zsh"
