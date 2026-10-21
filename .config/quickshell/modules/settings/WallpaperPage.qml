import Quickshell
import QtQuick
import Qt.labs.folderlistmodel
import qs
import qs.modules
import qs.modules.search
import qs.modules.keyboard
import qs.services
import "wallpaper"

// Selection previews a file; only confirmation hands it to awww.
OverlayPage {
    id: view

    title: "Appearance / Wallpaper"
    panelWidth: 1100
    contentHeight: 520
    keyBindings: keys
    property bool searching: false

    readonly property var entries: Array.from({ length: folder.count }, (_, index) => ({
        name: folder.get(index, "fileBaseName"),
        path: folder.get(index, "filePath"),
        url: folder.get(index, "fileUrl")
    }))
    readonly property var current: filter.matches[list.currentIndex] ?? null

    function applyCurrent() {
        if (view.current) {
            Quickshell.execDetached(["awww", "img", view.current.path, "--transition-type", "any", "--transition-duration", "1", "--transition-fps", "60"]);
        }
    }

    function startSearch() {
        view.searching = true;
        search.forceActiveFocus();
    }

    function stopSearch() {
        search.clear();
        view.searching = false;
        list.forceActiveFocus();
    }

    function activate() {
        if (view.searching) search.forceActiveFocus();
        else list.forceActiveFocus();
    }

    SearchFilter {
        id: filter
        entries: view.entries
        query: search.text
        onMatchesChanged: list.currentIndex = filter.matches.length ? 0 : -1
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_Up], label: "SELECT", run: () => list.decrementCurrentIndex() },
            { keys: [Qt.Key_Down], label: "SELECT", run: () => list.incrementCurrentIndex() },
            { keys: [Qt.Key_K], modifiers: view.searching ? Qt.ControlModifier : Qt.NoModifier, label: "SELECT", run: () => list.decrementCurrentIndex() },
            { keys: [Qt.Key_J], modifiers: view.searching ? Qt.ControlModifier : Qt.NoModifier, label: "SELECT", run: () => list.incrementCurrentIndex() },
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "APPLY", enabled: view.current !== null, run: () => view.applyCurrent() },
            { keys: [Qt.Key_Right, Qt.Key_L], label: "APPLY", enabled: !view.searching && view.current !== null, run: () => view.applyCurrent() },
            { keys: [Qt.Key_Slash], label: "FIND", enabled: !view.searching, run: () => view.startSearch() },
            { keys: [Qt.Key_Left, Qt.Key_H], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", enabled: !view.searching, run: () => ShellState.backOverlay() },
            { keys: [Qt.Key_Escape], label: view.searching ? "CLEAR" : ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => view.searching ? view.stopSearch() : ShellState.backOverlay() }
        ]
    }

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/wallpapers"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif"]
        caseSensitive: false
        showDirs: false
        sortField: FolderListModel.Name
    }

    ListView {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: view.searching ? search.top : parent.bottom
        anchors.bottomMargin: view.searching ? 12 : 0
        width: 310
        clip: true
        focus: true
        model: filter.matches
        currentIndex: 0
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
                    view.activate();
                }
                onDoubleClicked: view.applyCurrent()
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
        anchors.bottom: parent.bottom
        width: list.width
        height: 36
        visible: view.searching
        keyTargets: [searchKeys]
    }

    WallpaperPreview {
        id: preview

        anchors.top: parent.top
        anchors.left: list.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        entry: view.current
        emptyText: folder.count === 0 ? "No wallpapers found" : "No matches"
    }
}
