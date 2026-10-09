import QtQuick
import qs

// Rofi-style list of entries. It knows nothing about what an entry stands for;
// whoever uses it fills it. A page may be another Launcher: Esc on that inner
// list falls through to this one.
FocusScope {
    id: launcher

    property list<LauncherEntry> entries
    // Entry whose page replaces the list, null while listing.
    property LauncherEntry current: null
    // Titles of the opened entries, outermost first, including those of a
    // Launcher shown as page: Theme opened, then Colors in it → ["Theme", "Colors"].
    readonly property var path: {
        if (launcher.current === null) {
            return [];
        }
        const inner = page.item && page.item.path ? page.item.path : [];
        return [launcher.current.title].concat(inner);
    }

    readonly property int rowHeight: 36

    // Esc on the list: nothing left to leave here.
    signal closeRequested

    function openEntry(entry) {
        if (entry.page === null) {
            entry.triggered();
            return;
        }
        launcher.current = entry;
        // The list holds the focus while listing; the page takes it over.
        page.forceActiveFocus();
    }

    function openCurrent() {
        const entry = launcher.entries[list.currentIndex];
        if (entry) {
            launcher.openEntry(entry);
        }
    }

    function reset() {
        launcher.current = null;
        list.currentIndex = 0;
        list.forceActiveFocus();
    }

    focus: true

    // Esc travels up to here from whichever child has the focus.
    Keys.onEscapePressed: event => {
        if (launcher.current === null) {
            launcher.closeRequested();
            // Unaccepted, Esc travels on to an outer Launcher, which leaves this page.
            event.accepted = false;
            return;
        }
        launcher.current = null;
        list.forceActiveFocus();
    }

    ListView {
        id: list

        anchors.fill: parent
        focus: true
        clip: true
        visible: launcher.current === null
        model: launcher.entries

        // Up/Down already move the selection while the list has the focus.
        Keys.onReturnPressed: launcher.openCurrent()
        Keys.onEnterPressed: launcher.openCurrent()

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: launcher.rowHeight
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            Text {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }

                text: row.modelData.title
                color: row.ListView.isCurrentItem ? Colors.foreground : Colors.foregroundSoft
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 15
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    list.currentIndex = row.index;
                    launcher.openEntry(row.modelData);
                }
            }
        }
    }

    Loader {
        id: page

        anchors.fill: parent
        active: launcher.current !== null
        sourceComponent: launcher.current ? launcher.current.page : null
    }
}
