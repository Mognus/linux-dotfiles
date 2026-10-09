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
    // True while the search footer is open; "/" opens it.
    property bool searching: false
    // Search text, empty while not searching.
    readonly property string query: footer.text
    // Entries the list shows: all, or those whose title contains the query,
    // ignoring case: "ger" → tiger-dragon.
    readonly property var matches: Array.from(launcher.entries).filter(entry => entry.title.toLowerCase().includes(launcher.query.toLowerCase()))
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

    // A back key on the list: nothing left to leave here.
    signal closeRequested

    function startSearch() {
        launcher.searching = true;
        footer.forceActiveFocus();
    }

    function stopSearch() {
        footer.clear();
        launcher.searching = false;
        list.forceActiveFocus();
    }

    function openEntry(entry) {
        // Opening ends a search; the highlight stays on the entry in the whole list.
        launcher.stopSearch();
        list.currentIndex = Array.from(launcher.entries).indexOf(entry);
        if (entry.page === null) {
            entry.triggered();
            return;
        }
        launcher.current = entry;
        // The list holds the focus while listing; the page takes it over.
        page.forceActiveFocus();
    }

    function openCurrent() {
        const entry = launcher.matches[list.currentIndex];
        if (entry) {
            launcher.openEntry(entry);
        }
    }

    function reset() {
        launcher.current = null;
        launcher.stopSearch();
        list.currentIndex = 0;
    }

    focus: true

    // Back keys travel up to here from whichever child has the focus: they leave
    // the page, or on the list ask to close.
    Keys.onPressed: event => {
        const backKeys = [Qt.Key_Escape, Qt.Key_Left, Qt.Key_H];
        if (!backKeys.includes(event.key)) {
            return;
        }
        if (launcher.current === null) {
            launcher.closeRequested();
            // Unaccepted, the key travels on to an outer Launcher, which leaves this page.
            return;
        }
        launcher.current = null;
        list.forceActiveFocus();
        event.accepted = true;
    }

    ListView {
        id: list

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: launcher.searching ? footer.top : parent.bottom
        }

        focus: true
        clip: true
        visible: launcher.current === null
        model: launcher.matches

        // Each group of keys does one job: move down, move up, or open the highlighted entry.
        Keys.onPressed: event => {
            if ([Qt.Key_Down, Qt.Key_J].includes(event.key)) {
                list.incrementCurrentIndex();
            } else if ([Qt.Key_Up, Qt.Key_K].includes(event.key)) {
                list.decrementCurrentIndex();
            } else if ([Qt.Key_Return, Qt.Key_Enter, Qt.Key_Right, Qt.Key_L].includes(event.key)) {
                launcher.openCurrent();
            } else if (event.key === Qt.Key_Slash) {
                launcher.startSearch();
            } else {
                // Not ours: back keys travel on to the Launcher.
                return;
            }
            event.accepted = true;
        }

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

    SearchFooter {
        id: footer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: launcher.rowHeight
        visible: launcher.searching && launcher.current === null

        onNextRequested: list.incrementCurrentIndex()
        onPreviousRequested: list.decrementCurrentIndex()
        onOpenRequested: launcher.openCurrent()
        onCloseRequested: launcher.stopSearch()
    }

    Loader {
        id: page

        anchors.fill: parent
        active: launcher.current !== null
        sourceComponent: launcher.current ? launcher.current.page : null
    }
}
