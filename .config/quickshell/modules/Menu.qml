import QtQuick
import qs

// Rofi-style list of entries. It knows nothing about what an entry stands for;
// whoever uses it fills it. A page may be another Menu: Esc on that inner
// list falls through to this one.
FocusScope {
    id: menu

    property list<MenuEntry> entries
    // Entry whose page replaces the list, null while listing.
    property MenuEntry current: null
    // True while the search footer is open; "/" opens it.
    property bool searching: false
    // Search text, empty while not searching.
    readonly property string query: footer.text
    // Entries the list shows: all, or those whose title contains the query,
    // ignoring case: "ger" → tiger-dragon.
    readonly property var matches: Array.from(menu.entries).filter(entry => entry.title.toLowerCase().includes(menu.query.toLowerCase()))
    // Titles of the opened entries, outermost first, including those of a
    // Menu shown as page: Theme opened, then Colors in it → ["Theme", "Colors"].
    readonly property var path: {
        if (menu.current === null) {
            return [];
        }
        const inner = page.item && page.item.path ? page.item.path : [];
        return [menu.current.title].concat(inner);
    }

    readonly property int rowHeight: 36

    // A back key on the list: nothing left to leave here.
    signal closeRequested

    function startSearch() {
        menu.searching = true;
        footer.forceActiveFocus();
    }

    function stopSearch() {
        footer.clear();
        menu.searching = false;
        list.forceActiveFocus();
    }

    function openEntry(entry) {
        // Opening ends a search; the highlight stays on the entry in the whole list.
        menu.stopSearch();
        list.currentIndex = Array.from(menu.entries).indexOf(entry);
        if (entry.page === null) {
            entry.triggered();
            return;
        }
        menu.current = entry;
        // The list holds the focus while listing; the page takes it over.
        page.forceActiveFocus();
    }

    function openCurrent() {
        const entry = menu.matches[list.currentIndex];
        if (entry) {
            menu.openEntry(entry);
        }
    }

    function reset() {
        menu.current = null;
        menu.stopSearch();
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
        if (menu.current === null) {
            menu.closeRequested();
            // Unaccepted, the key travels on to an outer Menu, which leaves this page.
            return;
        }
        menu.current = null;
        list.forceActiveFocus();
        event.accepted = true;
    }

    ListView {
        id: list

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: menu.searching ? footer.top : parent.bottom
        }

        focus: true
        clip: true
        visible: menu.current === null
        model: menu.matches

        // Each group of keys does one job: move down, move up, or open the highlighted entry.
        Keys.onPressed: event => {
            if ([Qt.Key_Down, Qt.Key_J].includes(event.key)) {
                list.incrementCurrentIndex();
            } else if ([Qt.Key_Up, Qt.Key_K].includes(event.key)) {
                list.decrementCurrentIndex();
            } else if ([Qt.Key_Return, Qt.Key_Enter, Qt.Key_Right, Qt.Key_L].includes(event.key)) {
                menu.openCurrent();
            } else if (event.key === Qt.Key_Slash) {
                menu.startSearch();
            } else {
                // Not ours: back keys travel on to the Menu.
                return;
            }
            event.accepted = true;
        }

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: menu.rowHeight
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
                    menu.openEntry(row.modelData);
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

        height: menu.rowHeight
        visible: menu.searching && menu.current === null

        onNextRequested: list.incrementCurrentIndex()
        onPreviousRequested: list.decrementCurrentIndex()
        onOpenRequested: menu.openCurrent()
        onCloseRequested: menu.stopSearch()
    }

    Loader {
        id: page

        anchors.fill: parent
        active: menu.current !== null
        sourceComponent: menu.current ? menu.current.page : null
    }
}
