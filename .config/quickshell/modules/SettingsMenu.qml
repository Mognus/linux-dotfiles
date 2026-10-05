import QtQuick
import qs.services

// The settings menu on Super+G: one LauncherEntry per settings page.
Launcher {
    open: ShellState.settingsOpen
    onCloseRequested: ShellState.closeSettings()

    entries: [
        LauncherEntry {
            title: "Audio"
            page: Component {
                AudioPage {}
            }
        }
    ]
}
