import Quickshell
import Quickshell.Widgets
import QtQuick
import qs
import qs.modules
import qs.modules.search
import qs.services
import qs.modules.keyboard

// App launcher: navigate the grid in normal mode; i or / edits the filter.
OverlayPage {
    id: window

    readonly property int columns: 6
    readonly property int rows: 4
    property bool searching: false
    // The page supplies sorted data; SearchFilter handles the query.
    readonly property var entries: Array.from(DesktopEntries.applications.values).sort((a, b) => a.name.localeCompare(b.name))
    readonly property var current: filter.matches[grid.currentIndex] ?? null

    function launch(app) {
        app.execute();
        ShellState.closeLauncher();
    }

    function launchCurrent() {
        const app = window.current;
        if (app) {
            window.launch(app);
        }
    }

    title: "APPS"
    settingsTitle: "Launcher / Applications"
    panelWidth: window.columns * LauncherStyle.gridCellSize + LauncherStyle.padding * 2
    contentHeight: window.rows * LauncherStyle.gridCellSize + LauncherStyle.rowHeight + LauncherStyle.padding
    padding: LauncherStyle.padding
    keyBindings: keys
    Keys.onPressed: event => keys.handle(event)

    SearchFilter {
        id: filter
        entries: window.entries
        query: footer.text
        textFor: app => [app.name, app.genericName].concat(Array.from(app.keywords)).join("\n")
        onMatchesChanged: grid.currentIndex = filter.matches.length ? 0 : -1
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_Left, Qt.Key_H], label: "SELECT", enabled: !window.searching, run: () => grid.moveCurrentIndexLeft() },
            { keys: [Qt.Key_Right, Qt.Key_L], label: "SELECT", enabled: !window.searching, run: () => grid.moveCurrentIndexRight() },
            { keys: [Qt.Key_Up, Qt.Key_K], label: "SELECT", enabled: !window.searching, run: () => grid.moveCurrentIndexUp() },
            { keys: [Qt.Key_Down, Qt.Key_J], label: "SELECT", enabled: !window.searching, run: () => grid.moveCurrentIndexDown() },
            { keys: [Qt.Key_I, Qt.Key_Slash], label: "FIND", enabled: !window.searching, run: () => window.startSearch() },
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "LAUNCH", enabled: window.current !== null, run: () => window.launchCurrent() },
            { keys: [Qt.Key_Escape], label: window.searching ? "NORMAL" : ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => window.searching ? window.stopSearch() : ShellState.backOverlay() }
        ]
    }

    function activate() {
        if (window.searching) footer.forceActiveFocus();
        else grid.forceActiveFocus();
    }

    function startSearch() {
        window.searching = true;
        footer.forceActiveFocus();
    }

    function stopSearch() {
        window.searching = false;
        grid.forceActiveFocus();
    }

    GridView {
        id: grid

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
            bottomMargin: LauncherStyle.padding
        }

        cellWidth: LauncherStyle.gridCellSize
        cellHeight: LauncherStyle.gridCellSize
        clip: true
        model: filter.matches
        focus: true
        Keys.forwardTo: [window]

        delegate: Item {
            id: cell

            required property var modelData

            width: grid.cellWidth
            height: grid.cellHeight

            Rectangle {
                anchors {
                    fill: parent
                    margins: 4
                }

                color: cell.GridView.isCurrentItem ? Colors.hoverOverlay : "transparent"
            }

            IconImage {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: LauncherStyle.gridIconTopMargin
                }

                implicitSize: LauncherStyle.gridIconSize
                asynchronous: true
                source: Quickshell.iconPath(cell.modelData.icon, "application-x-executable")
            }

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: LauncherStyle.contentInset
                    bottomMargin: LauncherStyle.gridLabelBottomMargin
                }

                text: cell.modelData.name
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                color: cell.GridView.isCurrentItem ? Colors.accent : Colors.foregroundSoft
                font.family: Fonts.family
                font.pixelSize: Fonts.smallSize
            }

            MouseArea {
                anchors.fill: parent
                onClicked: window.launch(cell.modelData)
            }
        }
    }

    SearchField {
        id: footer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: LauncherStyle.rowHeight
        keyTargets: [window]
    }
}
