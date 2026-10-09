import QtQuick
import qs

// Search line under a list: / cy▏. It only types; every key goes to
// keyTargets first, so whoever uses it can still drive a list with it.
FocusScope {
    id: footer

    readonly property alias text: field.text
    // Items that see each key before the field types it.
    property list<Item> keyTargets

    function clear() {
        field.text = "";
    }

    // Keys the field leaves alone (Left at the start) stay here instead of reaching the owner.
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
        Keys.forwardTo: footer.keyTargets

        // Ctrl+W deletes the word before the cursor like in a terminal: "fire fox▏" → "fire ▏".
        Keys.onPressed: event => {
            if (event.key === Qt.Key_W && (event.modifiers & Qt.ControlModifier)) {
                const before = field.text.slice(0, field.cursorPosition);
                field.remove(before.replace(/\S*\s*$/, "").length, field.cursorPosition);
                event.accepted = true;
            }
        }
    }
}
