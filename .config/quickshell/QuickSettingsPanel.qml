import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

PanelWindow {
    id: panel

    property bool open: false

    signal closeRequested()

    visible: panel.open

    anchors {
        top: true
        right: true
        bottom: true
    }

    margins {
        top: 0
        right: 0
        bottom: 0
    }

    implicitWidth: 320
    color: "transparent"
    aboveWindows: true
    focusable: true
    exclusiveZone: 0

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
        radius: 0
        border.width: 1
        border.color: Colors.subtle
    }

    Column {
        anchors {
            fill: parent
            margins: 18
        }

        spacing: 18

        Row {
            width: parent.width
            height: 28

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 32
                text: "Quick Settings"
                color: Colors.foreground
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 18
                font.bold: true
            }

            Rectangle {
                width: 28
                height: 28
                radius: 0
                color: closeMouse.containsMouse ? Colors.hoverOverlay : Colors.lowOverlay

                Text {
                    anchors.centerIn: parent
                    text: "x"
                    color: Colors.foreground
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 15
                    font.bold: true
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: panel.closeRequested()
                }
            }
        }

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
}
