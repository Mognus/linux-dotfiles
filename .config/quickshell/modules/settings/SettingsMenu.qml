import QtQuick
import qs
import qs.modules
import qs.services
import qs.modules.search
import qs.modules.keyboard

// Categories only group entries; every entry opens a page in the shared overlay.
OverlayPage {
    id: menu

    title: "SETTINGS"
    contentHeight: 456
    keyBindings: keys
    Keys.onPressed: event => keys.handle(event)
    property bool searching: false
    readonly property var current: filter.matches[start.currentIndex] ?? null

    function openCurrent() {
        if (menu.current) ShellState.openSettingsPage(menu.current.page);
    }

    function startSearch() {
        menu.searching = true;
        search.forceActiveFocus();
    }

    function stopSearch() {
        search.clear();
        menu.searching = false;
        start.forceActiveFocus();
    }

    SearchFilter {
        id: filter
        entries: menu.entries
        query: search.text
        onMatchesChanged: start.currentIndex = filter.matches.length ? 0 : -1
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_Up], label: "SELECT", run: () => start.decrementCurrentIndex() },
            { keys: [Qt.Key_Down], label: "SELECT", run: () => start.incrementCurrentIndex() },
            { keys: [Qt.Key_K], modifiers: menu.searching ? Qt.ControlModifier : Qt.NoModifier, label: "SELECT", run: () => start.decrementCurrentIndex() },
            { keys: [Qt.Key_J], modifiers: menu.searching ? Qt.ControlModifier : Qt.NoModifier, label: "SELECT", run: () => start.incrementCurrentIndex() },
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "OPEN", enabled: menu.current !== null, run: () => menu.openCurrent() },
            { keys: [Qt.Key_Right, Qt.Key_L], label: "OPEN", enabled: !menu.searching && menu.current !== null, run: () => menu.openCurrent() },
            { keys: [Qt.Key_Slash], label: "FIND", enabled: !menu.searching, run: () => menu.startSearch() },
            { keys: [Qt.Key_Left, Qt.Key_H], label: "CLOSE", enabled: !menu.searching, run: () => ShellState.backOverlay() },
            { keys: [Qt.Key_Escape], label: menu.searching ? "CLEAR" : "CLOSE", run: () => menu.searching ? menu.stopSearch() : ShellState.backOverlay() }
        ]
    }

    readonly property var sections: [
        {
            name: "General",
            entries: [
                { name: "Audio", page: "audio" },
                { name: "Notifications", page: "notifications" },
                { name: "Session", page: "session" }
            ]
        },
        {
            name: "Appearance",
            entries: [
                { name: "Theme", page: "theme" },
                { name: "Wallpaper", page: "wallpaper" },
                { name: "Adjustments", page: "adjustments" }
            ]
        },
        {
            name: "Launcher",
            entries: [
                { name: "Applications", page: "launcher", shortcut: "Super+Space" },
                { name: "Windows", page: "windowSwitcher", shortcut: "Super+Ctrl+Space" },
                { name: "Clipboard", page: "clipboard", shortcut: "Super+V" }
            ]
        }
    ]
    readonly property var entries: {
        const result = [];
        for (const section of menu.sections) {
            for (const entry of section.entries) {
                result.push(Object.assign({ category: section.name }, entry));
            }
        }
        return result;
    }

    function activate() {
        if (menu.searching) search.forceActiveFocus();
        else start.forceActiveFocus();
    }

    ListView {
        id: start

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: menu.searching ? search.top : parent.bottom
        anchors.bottomMargin: menu.searching ? 12 : 0
        clip: true
        focus: true
        model: filter.matches
        section.property: "category"
        section.delegate: Item {
            required property string section
            width: start.width
            height: 28
            Rectangle {
                id: lead
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 12
                height: 1
                color: Colors.borderMuted
            }
            Text {
                id: sectionLabel
                anchors.left: lead.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: section.toUpperCase()
                textFormat: Text.PlainText
                color: Colors.muted
                font.family: Fonts.family
                font.pixelSize: Fonts.smallSize
            }
            Rectangle {
                anchors.left: sectionLabel.right
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: Colors.borderMuted
            }
        }
        Keys.forwardTo: [menu]

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index
            readonly property bool selected: row.ListView.isCurrentItem

            width: ListView.view.width
            height: 36
            color: row.selected ? Colors.foreground : "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: row.selected ? ">" : ""
                color: Colors.background
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 36
                anchors.right: shortcut.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: row.modelData.name
                textFormat: Text.PlainText
                elide: Text.ElideRight
                color: row.selected ? Colors.background : Colors.foreground
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }

            Text {
                id: shortcut

                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: row.modelData.shortcut ?? ""
                color: row.selected ? Colors.background : Colors.muted
                font.family: Fonts.family
                font.pixelSize: Fonts.smallSize
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    start.currentIndex = row.index;
                    menu.activate();
                }
                onDoubleClicked: menu.openCurrent()
            }
        }
    }

    SearchField {
        id: search
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 36
        visible: menu.searching
        keyTargets: [menu]
    }
}
