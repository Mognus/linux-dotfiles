import QtQuick
import qs

// Where a Launcher is: × ~ / Theme / Colors. The × only reports the click;
// whoever uses it decides what closing means.
Row {
    id: breadcrumbs

    // Titles below the root, outermost first, e.g. a Launcher's path.
    property var path: []

    signal closeRequested

    spacing: 12

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "×"
        color: closeMouse.containsMouse ? Colors.foreground : Colors.muted
        font.family: "Syne, MesloLGS Nerd Font, monospace"
        font.pixelSize: 18

        MouseArea {
            id: closeMouse

            anchors.fill: parent
            hoverEnabled: true
            onClicked: breadcrumbs.closeRequested()
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "~"
        color: Colors.foreground
        font.family: "Syne, MesloLGS Nerd Font, monospace"
        font.pixelSize: 15
    }

    Repeater {
        model: breadcrumbs.path

        Row {
            id: crumb

            required property string modelData

            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            Text {
                text: "/"
                color: Colors.muted
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 15
            }

            Text {
                text: crumb.modelData
                color: Colors.foreground
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 15
            }
        }
    }
}
