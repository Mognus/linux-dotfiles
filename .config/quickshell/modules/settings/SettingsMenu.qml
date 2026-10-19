import QtQuick
import qs
import qs.modules
import qs.services
import "../../lib/Navigation.js" as Navigation

// Categories only group entries; every entry opens a page in the shared overlay.
OverlayPage {
    id: menu

    title: "SETTINGS"
    contentHeight: 456
    searchEnabled: true
    searching: start.searching
    confirmLabel: "OPEN"

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
        start.select(0);
    }

    SearchableList {
        id: start

        anchors.fill: parent
        entries: menu.entries
        sectionRole: "category"
        Keys.onPressed: event => {
            if (Navigation.isOpen(event)) {
                start.activateCurrent();
                event.accepted = true;
            }
        }
        onActivated: entry => ShellState.openSettingsPage(entry.page)

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
                onClicked: start.select(row.index)
                onDoubleClicked: start.activateCurrent()
            }
        }
    }
}
