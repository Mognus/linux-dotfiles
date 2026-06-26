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
        color: "#e6111111"
        radius: 0
        border.width: 1
        border.color: "#24ffffff"
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
                color: "#ffffff"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 18
                font.bold: true
            }

            Rectangle {
                width: 28
                height: 28
                radius: 0
                color: closeMouse.containsMouse ? "#28ffffff" : "#14ffffff"

                Text {
                    anchors.centerIn: parent
                    text: "x"
                    color: "#ffffff"
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
            accent: "#40a02b"
            showPresets: true
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#20ffffff"
        }

        AudioControl {
            width: parent.width
            title: "Microphone"
            node: Pipewire.defaultAudioSource
            accent: "#7287fd"
        }

        Text {
            width: parent.width
            text: Pipewire.ready ? "PIPEWIRE READY" : "PIPEWIRE WAIT"
            color: Pipewire.ready ? "#7dffffff" : "#e64553"
            horizontalAlignment: Text.AlignRight
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 10
            font.bold: true
        }
    }
}
