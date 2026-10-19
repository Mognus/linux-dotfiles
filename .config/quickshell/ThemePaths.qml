pragma Singleton

import Quickshell

Singleton {
    readonly property string stateDir: Quickshell.env("HOME") + "/.local/state/dotfiles-theme"
    readonly property string binary: Quickshell.env("HOME") + "/.local/bin/appearancectl"
}
