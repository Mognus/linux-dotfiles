import QtQuick
import qs
import "../lib/Navigation.js" as Navigation

// Rofi-style list of entries with a search line that is always active: typing
// filters, the keys in Navigation.js move, open and go back. It knows nothing
// about what an entry stands for; whoever uses it fills it. A page may be
// another Menu, which makes a sub menu.
FocusScope {
    id: menu

    property list<MenuEntry> entries
    // Entry whose page replaces the list, null while listing.
    property MenuEntry current: null
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

    // Back on the list: nothing left to leave here.
    signal closeRequested

    function openEntry(entry) {
        // Opening clears the search; the highlight stays on the entry in the whole list.
        footer.clear();
        list.currentIndex = Array.from(menu.entries).indexOf(entry);
        if (entry.page === null) {
            entry.triggered();
            return;
        }
        menu.current = entry;
        // The search line holds the focus while listing; the page takes it over.
        page.forceActiveFocus();
    }

    function openCurrent() {
        const entry = menu.matches[list.currentIndex];
        if (entry) {
            menu.openEntry(entry);
        }
    }

    // Leaves the page, or on the list asks to close.
    function back() {
        if (menu.current === null) {
            menu.closeRequested();
            return;
        }
        menu.current = null;
        footer.forceActiveFocus();
    }

    function reset() {
        menu.current = null;
        footer.clear();
        list.currentIndex = 0;
        footer.forceActiveFocus();
    }

    focus: true

    // Pages without keys of their own (AudioPage) go back here.
    Keys.onPressed: event => {
        if (Navigation.isBack(event)) {
            menu.back();
            event.accepted = true;
        }
    }

    ListView {
        id: list

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
        }

        clip: true
        visible: menu.current === null
        model: menu.matches

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
        focus: true
        visible: menu.current === null

        onNextRequested: list.incrementCurrentIndex()
        onPreviousRequested: list.decrementCurrentIndex()
        onOpenRequested: menu.openCurrent()
        onBackRequested: menu.back()
    }

    Loader {
        id: page

        anchors.fill: parent
        active: menu.current !== null
        sourceComponent: menu.current ? menu.current.page : null
    }

    // A sub menu shown as page asks to close on its own list: that leaves the page here.
    Connections {
        target: page.item
        ignoreUnknownSignals: true

        function onCloseRequested() {
            menu.back();
        }
    }
}
