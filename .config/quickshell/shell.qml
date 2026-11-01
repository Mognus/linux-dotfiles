import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import qs.modules
import qs.services

ShellRoot {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    BottomBar {}

    ThemeSwitcher {}

    NotificationPopups {}

    TuxMascot {}

    TuxMascot {
        angel: true
    }
}
