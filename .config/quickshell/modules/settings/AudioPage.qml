import QtQuick
import Quickshell.Services.Pipewire
import qs
import qs.modules

Column {
    width: parent.width
    spacing: 18

    AudioControl {
        width: parent.width
        title: "Output"
        node: Pipewire.defaultAudioSink
        accent: Colors.accent
        showPresets: true
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Colors.divider
    }

    AudioControl {
        width: parent.width
        title: "Microphone"
        node: Pipewire.defaultAudioSource
        accent: Colors.secondary
    }

    Text {
        width: parent.width
        text: Pipewire.ready ? "PIPEWIRE READY" : "PIPEWIRE WAIT"
        color: Pipewire.ready ? Colors.foregroundSoft : Colors.danger
        horizontalAlignment: Text.AlignRight
        font.family: "Syne, MesloLGS Nerd Font, monospace"
        font.pixelSize: 10
        font.bold: true
    }
}
