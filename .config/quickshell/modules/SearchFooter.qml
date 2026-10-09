import QtQuick
import qs
import "../lib/Navigation.js" as Navigation

// Search line under a list: / cy▏. Typing goes into the field; the keys that
// drive a list (Navigation.js) are only reported, whoever uses it decides what
// they mean.
FocusScope {
    id: footer

    readonly property alias text: field.text

    signal nextRequested
    signal previousRequested
    signal openRequested
    signal backRequested

    function clear() {
        field.text = "";
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

        // Runs before the field's own handling, so Left/Right navigate instead of moving the cursor.
        Keys.onPressed: event => {
            if (Navigation.isNext(event)) {
                footer.nextRequested();
            } else if (Navigation.isPrevious(event)) {
                footer.previousRequested();
            } else if (Navigation.isOpen(event)) {
                footer.openRequested();
            } else if (Navigation.isBack(event)) {
                footer.backRequested();
            } else {
                return;
            }
            event.accepted = true;
        }
    }
}
