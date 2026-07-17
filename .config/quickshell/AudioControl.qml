import QtQuick
import "lib/Audio.js" as Audio

Column {
    id: control

    property string title: ""
    property var node: null
    property color accent: Colors.accent
    property bool showPresets: false

    spacing: 10

    Row {
        width: parent.width
        height: 24

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 76
            text: control.title
            color: Colors.foreground
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 15
            font.bold: true
        }

        Rectangle {
            width: 76
            height: 24
            radius: 0
            color: Audio.muted(control.node) ? Colors.withAlpha(Colors.danger, 0.21) : Colors.lowOverlay

            Text {
                anchors.centerIn: parent
                text: Audio.muted(control.node) ? "MUTED" : "MUTE"
                color: Audio.muted(control.node) ? Colors.danger : Colors.foreground
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 11
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Audio.toggleMute(control.node)
            }
        }
    }

    Text {
        width: parent.width
        text: Audio.label(control.node)
        color: Colors.foregroundSoft
        elide: Text.ElideRight
        font.family: "Syne, MesloLGS Nerd Font, monospace"
        font.pixelSize: 12
    }

    Row {
        width: parent.width
        height: 30
        spacing: 10

        Rectangle {
            id: track
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 52
            height: 10
            radius: 0
            color: Colors.subtle

            Rectangle {
                width: track.width * Audio.volumeRatio(control.node)
                height: parent.height
                radius: 0
                color: Audio.muted(control.node) ? Colors.danger : control.accent
            }

            MouseArea {
                anchors.fill: parent
                onPressed: mouse => Audio.setVolume(control.node, mouse.x / width)
                onPositionChanged: mouse => {
                    if (pressed) {
                        Audio.setVolume(control.node, mouse.x / width);
                    }
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: 42
            text: Audio.percent(control.node) + "%"
            color: Colors.foreground
            horizontalAlignment: Text.AlignRight
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 13
            font.bold: true
        }
    }

    Row {
        id: presetRow

        width: parent.width
        height: control.showPresets ? 28 : 0
        spacing: 8
        visible: control.showPresets

        Repeater {
            model: [25, 50, 75, 100]

            Rectangle {
                width: (presetRow.width - 24) / 4
                height: 28
                radius: 0
                color: Math.abs(Audio.percent(control.node) - modelData) < 3 ? Colors.withAlpha(control.accent, 0.19) : Colors.lowOverlay

                Text {
                    anchors.centerIn: parent
                    text: modelData
                    color: Colors.foreground
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 12
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Audio.setVolume(control.node, modelData / 100)
                }
            }
        }
    }
}
