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

    ShellOverlay {}

    NotificationPopups {}

    TuxMascot {}

    TuxMascot {
        angel: true
    }
}
