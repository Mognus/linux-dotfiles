import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import qs.modules
import qs.services

ShellRoot {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    BottomBar {}

    WorkspaceHud {}

    QuickSettingsPanel {}

    TuxMascot {}

    TuxMascot {
        angel: true
        bottomInset: ShellState.workspaceHudVisible ? 34 : 0
    }
}
