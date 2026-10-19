import QtQuick
import Quickshell.Services.Pipewire
import qs
import qs.modules

OverlayPage {
    id: page

    title: "General / Audio"
    navigationHint: "SCROLL ON SLIDER  +/- 2%"

    Flickable {
        id: scroll

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: status.top
        anchors.bottomMargin: 12
        contentWidth: width
        contentHeight: controls.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: controls

            width: scroll.width
            spacing: 12

            AudioControl {
                width: parent.width
                title: "OUTPUT"
                node: Pipewire.defaultAudioSink
                showPresets: true
            }

            AudioControl {
                width: parent.width
                title: "MICROPHONE"
                node: Pipewire.defaultAudioSource
            }
        }
    }

    Item {
        id: status

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 18

        Rectangle {
            id: indicator

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            height: 6
            color: Pipewire.ready ? Colors.accent : Colors.danger
        }

        Text {
            anchors.left: indicator.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: Pipewire.ready ? "PIPEWIRE READY" : "PIPEWIRE WAIT"
            color: Pipewire.ready ? Colors.muted : Colors.danger
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }
}
