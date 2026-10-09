import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import qs.modules
import qs.modules.launcher
import qs.modules.settings
import qs.services

ShellRoot {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    BottomBar {}

    WorkspaceHud {}

    SettingsMenu {}

    AppLauncher {}

    WindowSwitcher {}

    ClipboardHistory {}

    TuxMascot {}

    TuxMascot {
        angel: true
        bottomInset: ShellState.workspaceHudVisible ? 34 : 0
    }
}
