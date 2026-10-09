import QtQuick
import qs

// Search line under a list: / cy▏. Typing goes into the field; the keys that
// drive a list are only reported, whoever uses it decides what they mean.
FocusScope {
    id: footer

    readonly property alias text: field.text

    signal nextRequested
    signal previousRequested
    signal openRequested
    signal closeRequested

    function clear() {
        field.text = "";
    }

    // Keys the field leaves alone (Left at the start) must not reach the owner's keys.
    Keys.onPressed: event => {
        event.accepted = true;
    }

    Rectangle {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 1
        color: Colors.divider
    }

    Text {
        id: slash

        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }

        text: "/"
        color: Colors.muted
        font.family: "Syne, MesloLGS Nerd Font, monospace"
        font.pixelSize: 15
    }

    TextInput {
        id: field

        anchors {
            left: slash.right
            leftMargin: 12
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        focus: true
        color: Colors.foreground
        font.family: "Syne, MesloLGS Nerd Font, monospace"
        font.pixelSize: 15

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Down) {
                footer.nextRequested();
            } else if (event.key === Qt.Key_Up) {
                footer.previousRequested();
            } else if ([Qt.Key_Return, Qt.Key_Enter].includes(event.key)) {
                footer.openRequested();
            } else if (event.key === Qt.Key_Escape) {
                footer.closeRequested();
            } else {
                return;
            }
            event.accepted = true;
        }
    }
}
