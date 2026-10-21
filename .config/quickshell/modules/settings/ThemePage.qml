import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import qs
import qs.modules
import qs.modules.search
import qs.modules.keyboard
import qs.services
import "theme"

// Highlighting only changes the previews; Enter applies the selected palette.
OverlayPage {
    id: view

    title: "Appearance / Theme"
    panelWidth: 960
    contentHeight: 440
    keyBindings: keys
    extraHint: view.searching ? "" : "* ACTIVE THEME"
    property bool searching: false

    readonly property var current: filter.matches[list.currentIndex] ?? null
    readonly property var previewPalette: view.current ? view.current.themeColors : null
    property string activeTheme: ""

    function activate() {
        if (view.searching) search.forceActiveFocus();
        else list.forceActiveFocus();
    }

    function applyCurrent() {
        if (view.current && view.current.themeColors) {
            Quickshell.execDetached([ThemePaths.binary, "theme", view.current.palettePath]);
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

    SearchFilter {
        id: filter
        entries: palettes.instances
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
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "APPLY", enabled: view.previewPalette !== null, run: () => view.applyCurrent() },
            { keys: [Qt.Key_Right, Qt.Key_L], label: "APPLY", enabled: !view.searching && view.previewPalette !== null, run: () => view.applyCurrent() },
            { keys: [Qt.Key_Slash], label: "FIND", enabled: !view.searching, run: () => view.startSearch() },
            { keys: [Qt.Key_Left, Qt.Key_H], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", enabled: !view.searching, run: () => ShellState.backOverlay() },
            { keys: [Qt.Key_Escape], label: view.searching ? "CLEAR" : ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => view.searching ? view.stopSearch() : ShellState.backOverlay() }
        ]
    }

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/themes/palettes"
        nameFilters: ["*.json"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    // Keep palette data outside list delegates so search can inspect every name.
    Variants {
        id: palettes

        model: Array.from({ length: folder.count }, (_, index) => ({
            name: folder.get(index, "fileBaseName"),
            path: folder.get(index, "filePath")
        }))

        Scope {
            id: entry

            required property var modelData
            readonly property string fileBaseName: entry.modelData.name
            readonly property string palettePath: entry.modelData.path
            readonly property string name: entry.themeColors ? entry.themeColors.name : entry.fileBaseName
            property var themeColors: null

            FileView {
                id: paletteFile

                path: entry.palettePath
                watchChanges: true
                onFileChanged: reload()
                onLoaded: {
                    try {
                        entry.themeColors = JSON.parse(paletteFile.text());
                    } catch (error) {
                        entry.themeColors = null;
                        console.warn("Invalid theme palette:", entry.palettePath, error);
                    }
                }
                onLoadFailed: entry.themeColors = null
            }
        }
    }

    FileView {
        id: currentTheme

        path: ThemePaths.stateDir + "/current"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: view.activeTheme = currentTheme.text().trim()
    }

    ListView {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: view.searching ? search.top : parent.bottom
        anchors.bottomMargin: view.searching ? 12 : 0
        width: 240
        clip: true
        focus: true
        model: filter.matches
        Keys.onPressed: event => keys.handle(event)

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: 52
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            Column {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: row.modelData.name + (view.activeTheme === row.modelData.fileBaseName ? " *" : "")
                    textFormat: Text.PlainText
                    color: row.ListView.isCurrentItem ? Colors.accent : Colors.foreground
                    font.family: Fonts.family
                    font.pixelSize: Fonts.size
                }

                Text {
                    text: row.modelData.themeColors ? row.modelData.themeColors.mode.toUpperCase() : "LOADING"
                    color: Colors.muted
                    font.family: Fonts.family
                    font.pixelSize: Fonts.captionSize
                }
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

    ThemePreview {
        id: previews

        anchors.top: parent.top
        anchors.left: list.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        palette: view.previewPalette
        emptyText: folder.count === 0 ? "No themes found" : filter.matches.length === 0 ? "No matches" : "Preview unavailable"
    }
}
