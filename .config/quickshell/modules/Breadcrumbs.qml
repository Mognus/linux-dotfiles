import QtQuick
import qs

// Display-only title with a close button; the owner decides what closing means.
Row {
    id: breadcrumbs

    property string title: ""

    signal closeRequested

    spacing: 12

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "×"
        color: closeMouse.containsMouse ? Colors.foreground : Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.largeSize

        MouseArea {
            id: closeMouse

            anchors.fill: parent
            hoverEnabled: true
            onClicked: breadcrumbs.closeRequested()
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: breadcrumbs.title
        textFormat: Text.PlainText
        color: Colors.foreground
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }
}
