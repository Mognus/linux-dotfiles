import QtQuick
import qs
import "../lib/Audio.js" as Audio

Rectangle {
    id: control

    property string title: ""
    property var node: null
    property color accent: Colors.accent
    property bool showPresets: false
    readonly property bool available: Audio.ready(control.node)
    readonly property int padding: 12

    implicitHeight: (control.showPresets ? presetRow.y + presetRow.height : volumeRow.y + volumeRow.height) + control.padding
    color: Colors.surface
    border.width: 1
    border.color: Colors.borderMuted

    Item {
        id: header

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: control.padding
        height: 28

        Text {
            anchors.left: parent.left
            anchors.right: percent.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: control.title
            elide: Text.ElideRight
            color: Colors.foreground
            font.family: Fonts.family
            font.pixelSize: Fonts.size
            font.bold: true
        }

        Text {
            id: percent

            anchors.right: mute.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: control.available ? Audio.percent(control.node) + "%" : "--"
            color: Audio.muted(control.node) ? Colors.muted : Colors.foreground
            font.family: Fonts.family
            font.pixelSize: Fonts.largeSize
        }

        Rectangle {
            id: mute

            anchors.right: parent.right
            width: 84
            height: parent.height
            color: Audio.muted(control.node) ? Colors.withAlpha(Colors.danger, 0.15) : muteMouse.containsMouse ? Colors.hoverOverlay : Colors.lowOverlay
            border.width: 1
            border.color: Audio.muted(control.node) ? Colors.danger : Colors.borderMuted
            opacity: control.available ? 1 : 0.45

            Text {
                anchors.centerIn: parent
                text: Audio.muted(control.node) ? "UNMUTE" : "MUTE"
                color: Audio.muted(control.node) ? Colors.danger : Colors.foreground
                font.family: Fonts.family
                font.pixelSize: Fonts.captionSize
                font.bold: true
            }

            MouseArea {
                id: muteMouse

                anchors.fill: parent
                enabled: control.available
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Audio.toggleMute(control.node)
            }
        }
    }

    Text {
        id: device

        anchors.top: header.bottom
        anchors.topMargin: 6
        anchors.left: header.left
        anchors.right: header.right
        text: Audio.label(control.node)
        textFormat: Text.PlainText
        color: Colors.foregroundSoft
        elide: Text.ElideRight
        font.family: Fonts.family
        font.pixelSize: Fonts.smallSize
    }

    Item {
        id: volumeRow

        anchors.top: device.bottom
        anchors.topMargin: 8
        anchors.left: header.left
        anchors.right: header.right
        height: 28

        Rectangle {
            id: track

            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 8
            color: Colors.subtle

            Rectangle {
                width: track.width * Audio.volumeRatio(control.node)
                height: parent.height
                color: Audio.muted(control.node) ? Colors.muted : control.accent
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: Audio.volumeRatio(control.node) * (volumeRow.width - width)
            width: 8
            height: 18
            visible: control.available
            color: Audio.muted(control.node) ? Colors.muted : control.accent
            border.width: 1
            border.color: Colors.foreground
        }

        MouseArea {
            anchors.fill: parent
            enabled: control.available
            cursorShape: Qt.PointingHandCursor
            onPressed: mouse => Audio.setVolume(control.node, mouse.x / width)
            onPositionChanged: mouse => {
                if (pressed) {
                    Audio.setVolume(control.node, mouse.x / width);
                }
            }
            onWheel: wheel => {
                Audio.setVolume(control.node, Audio.volumeRatio(control.node) + wheel.angleDelta.y / 120 * 0.02);
                wheel.accepted = true;
            }
        }
    }

    Row {
        id: presetRow

        anchors.top: volumeRow.bottom
        anchors.topMargin: 8
        anchors.left: header.left
        anchors.right: header.right
        height: 24
        spacing: 8
        visible: control.showPresets

        Repeater {
            model: [25, 50, 75, 100]

            Rectangle {
                required property int modelData
                readonly property bool selected: Math.abs(Audio.percent(control.node) - modelData) < 3

                width: (presetRow.width - 24) / 4
                height: 24
                color: selected ? Colors.withAlpha(control.accent, 0.19) : presetMouse.containsMouse ? Colors.hoverOverlay : Colors.lowOverlay
                border.width: 1
                border.color: selected ? control.accent : Colors.borderMuted
                opacity: control.available ? 1 : 0.45

                Text {
                    anchors.centerIn: parent
                    text: modelData + "%"
                    color: Colors.foreground
                    font.family: Fonts.family
                    font.pixelSize: Fonts.smallSize
                    font.bold: true
                }

                MouseArea {
                    id: presetMouse

                    anchors.fill: parent
                    enabled: control.available
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Audio.setVolume(control.node, modelData / 100)
                }
            }
        }
    }
}
