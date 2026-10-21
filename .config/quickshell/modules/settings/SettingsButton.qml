import QtQuick
import qs
import qs.modules.keyboard

// A keyboard-focusable, square button for the settings pages.
Rectangle {
    id: button

    property string text: ""
    property bool checked: false
    readonly property alias keyBindings: keys
    signal clicked

    implicitWidth: label.implicitWidth + 24
    implicitHeight: 32
    activeFocusOnTab: true
    opacity: enabled ? 1 : 0.45
    color: button.checked ? Colors.foreground : mouse.containsMouse ? Colors.hoverOverlay : Colors.lowOverlay
    border.width: 1
    border.color: activeFocus ? Colors.accent : Colors.borderMuted

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Space], label: "ACTIVATE", enabled: button.enabled, run: () => button.clicked() }
        ]
    }

    Keys.onPressed: event => keys.handle(event)

    Text {
        id: label

        anchors.centerIn: parent
        width: parent.width - 24
        text: button.text
        textFormat: Text.PlainText
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        color: button.checked ? Colors.background : Colors.foreground
        font.family: Fonts.family
        font.pixelSize: Fonts.smallSize
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            button.forceActiveFocus();
            button.clicked();
        }
    }
}
