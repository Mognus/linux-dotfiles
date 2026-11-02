pragma Singleton

import Quickshell

Singleton {
    readonly property string stateDir: Quickshell.env("HOME") + "/.local/state/dotfiles-theme"
}
