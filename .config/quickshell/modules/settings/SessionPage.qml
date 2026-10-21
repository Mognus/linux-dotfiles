import Quickshell
import QtQuick
import qs
import qs.modules
import qs.services
import qs.modules.search
import qs.modules.keyboard

OverlayPage {
    id: page

    title: "General / Session"
    keyBindings: keys
    property bool searching: false
    readonly property var current: filter.matches[list.currentIndex] ?? null

    function activate() {
        if (page.searching) search.forceActiveFocus();
        else list.forceActiveFocus();
    }

    function executeCurrent() {
        if (!page.current) return;
        const command = page.current.command;
        ShellState.dismissOverlay();
        Quickshell.execDetached(command);
    }

    function startSearch() {
        page.searching = true;
        search.forceActiveFocus();
    }

    function stopSearch() {
        search.clear();
        page.searching = false;
        list.forceActiveFocus();
    }

    SearchFilter {
        id: filter
        entries: page.actions
        query: search.text
        onMatchesChanged: list.currentIndex = filter.matches.length ? 0 : -1
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_Up], label: "SELECT", run: () => list.decrementCurrentIndex() },
            { keys: [Qt.Key_Down], label: "SELECT", run: () => list.incrementCurrentIndex() },
            { keys: [Qt.Key_K], modifiers: page.searching ? Qt.ControlModifier : Qt.NoModifier, label: "SELECT", run: () => list.decrementCurrentIndex() },
            { keys: [Qt.Key_J], modifiers: page.searching ? Qt.ControlModifier : Qt.NoModifier, label: "SELECT", run: () => list.incrementCurrentIndex() },
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "EXECUTE", enabled: page.current !== null, run: () => page.executeCurrent() },
            { keys: [Qt.Key_Right, Qt.Key_L], label: "EXECUTE", enabled: !page.searching && page.current !== null, run: () => page.executeCurrent() },
            { keys: [Qt.Key_Slash], label: "FIND", enabled: !page.searching, run: () => page.startSearch() },
            { keys: [Qt.Key_Left, Qt.Key_H], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", enabled: !page.searching, run: () => ShellState.backOverlay() },
            { keys: [Qt.Key_Escape], label: page.searching ? "CLEAR" : ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => page.searching ? page.stopSearch() : ShellState.backOverlay() }
        ]
    }

    readonly property var actions: [
        { name: "Lock", description: "Lock the screen using the existing Hypridle handler.", command: ["loginctl", "lock-session"] },
        { name: "Log out", description: "End the current Hyprland session.", command: ["hyprctl", "dispatch", "exit"] },
        { name: "Restart", description: "Restart the computer.", command: ["systemctl", "reboot"] },
        { name: "Power off", description: "Shut down the computer.", command: ["systemctl", "poweroff"] }
    ]

    ListView {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: page.searching ? search.top : description.top
        anchors.bottomMargin: 16
        clip: true
        focus: true
        model: filter.matches
        Keys.onPressed: event => keys.handle(event)

        delegate: Rectangle {
            id: row
            required property var modelData
            required property int index
            width: ListView.view.width
            height: 36
            color: ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"
            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                anchors.verticalCenter: parent.verticalCenter
                text: row.modelData.name
                textFormat: Text.PlainText
                elide: Text.ElideRight
                color: row.ListView.isCurrentItem ? Colors.accent : Colors.foregroundSoft
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    list.currentIndex = row.index;
                    page.activate();
                }
                onDoubleClicked: page.executeCurrent()
            }
        }
    }

    Item {
        id: searchKeys
        Keys.onPressed: event => keys.handle(event)
    }

    SearchField {
        id: search
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: description.top
        anchors.bottomMargin: 16
        height: 36
        visible: page.searching
        keyTargets: [searchKeys]
    }

    Text {
        id: description

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: page.current ? page.current.description : "No matching actions"
        wrapMode: Text.WordWrap
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.smallSize
    }
}
