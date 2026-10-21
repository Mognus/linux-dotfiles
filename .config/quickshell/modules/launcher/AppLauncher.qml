import Quickshell
import Quickshell.Widgets
import QtQuick
import qs
import qs.modules
import qs.modules.search
import qs.services
import qs.modules.keyboard

// App launcher: a GNOME-style grid of the desktop apps. The search line is
// always active: typing filters, the arrows or Ctrl+hjkl move, Enter starts.
OverlayPage {
    id: window

    readonly property int columns: 6
    readonly property int rows: 4
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
            { keys: [Qt.Key_Left], label: "SELECT", run: () => grid.moveCurrentIndexLeft() },
            { keys: [Qt.Key_Right], label: "SELECT", run: () => grid.moveCurrentIndexRight() },
            { keys: [Qt.Key_Up], label: "SELECT", run: () => grid.moveCurrentIndexUp() },
            { keys: [Qt.Key_Down], label: "SELECT", run: () => grid.moveCurrentIndexDown() },
            { keys: [Qt.Key_H], modifiers: Qt.ControlModifier, label: "SELECT", run: () => grid.moveCurrentIndexLeft() },
            { keys: [Qt.Key_L], modifiers: Qt.ControlModifier, label: "SELECT", run: () => grid.moveCurrentIndexRight() },
            { keys: [Qt.Key_K], modifiers: Qt.ControlModifier, label: "SELECT", run: () => grid.moveCurrentIndexUp() },
            { keys: [Qt.Key_J], modifiers: Qt.ControlModifier, label: "SELECT", run: () => grid.moveCurrentIndexDown() },
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "LAUNCH", enabled: window.current !== null, run: () => window.launchCurrent() },
            { keys: [Qt.Key_Escape], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => ShellState.backOverlay() }
        ]
    }

    function activate() {
        footer.forceActiveFocus();
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

    // Keys the search field hands over before typing: they drive the grid.
    Item {
        id: searchKeys

        Keys.onPressed: event => keys.handle(event)
    }

    SearchField {
        id: footer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: LauncherStyle.rowHeight
        focus: true
        keyTargets: [searchKeys]
    }
}
