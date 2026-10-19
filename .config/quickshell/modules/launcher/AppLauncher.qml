import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs
import qs.modules
import qs.services
import "../../lib/Navigation.js" as Navigation

// App launcher: a GNOME-style grid of the desktop apps. The search line is
// always active: typing filters, the arrows or Ctrl+hjkl move, Enter starts.
OverlayWindow {
    id: window

    readonly property int columns: 6
    readonly property int rows: 4
    // Apps that fit the search, sorted by name.
    readonly property var matches: Array.from(DesktopEntries.applications.values).filter(app => window.fits(app, footer.text.toLowerCase())).sort((a, b) => a.name.localeCompare(b.name))

    // True if the app's name, description or a keyword contains the query:
    // "browser" → LibreWolf, "term" → Alacritty.
    function fits(app, query) {
        const words = [app.name, app.genericName].concat(Array.from(app.keywords));
        for (const word of words) {
            if (word.toLowerCase().includes(query)) {
                return true;
            }
        }
        return false;
    }

    function launch(app) {
        app.execute();
        ShellState.closeLauncher();
    }

    function launchCurrent() {
        const app = window.matches[grid.currentIndex];
        if (app) {
            window.launch(app);
        }
    }

    visible: ShellState.launcherOpen
    title: ShellState.overlayFromSettings ? "SETTINGS / Launcher / Applications" : "APPS"
    panelWidth: window.columns * LauncherStyle.gridCellSize + LauncherStyle.padding * 2
    panelHeight: window.headerHeight + window.dividerHeight + window.rows * LauncherStyle.gridCellSize + LauncherStyle.rowHeight + LauncherStyle.padding * 2
    onCloseRequested: ShellState.closeLauncher()

    // Name that Hyprland layer rules can match.
    WlrLayershell.namespace: "launcher"

    // Every opening starts with an empty search on the first app.
    onVisibleChanged: {
        if (window.visible) {
            footer.clear();
            grid.currentIndex = 0;
            footer.forceActiveFocus();
        }
    }

    GridView {
        id: grid

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
            margins: LauncherStyle.padding
        }

        cellWidth: LauncherStyle.gridCellSize
        cellHeight: LauncherStyle.gridCellSize
        clip: true
        model: window.matches

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

        Keys.onPressed: event => {
            if (Navigation.isLeft(event)) {
                grid.moveCurrentIndexLeft();
            } else if (Navigation.isRight(event)) {
                grid.moveCurrentIndexRight();
            } else if (Navigation.isUp(event)) {
                grid.moveCurrentIndexUp();
            } else if (Navigation.isDown(event)) {
                grid.moveCurrentIndexDown();
            } else if (Navigation.isConfirm(event)) {
                window.launchCurrent();
            } else if (Navigation.isCancel(event)) {
                ShellState.closeLauncher();
            } else {
                return;
            }
            event.accepted = true;
        }
    }

    SearchFooter {
        id: footer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: LauncherStyle.padding
        }

        height: LauncherStyle.rowHeight
        focus: true
        keyTargets: [searchKeys]
    }
}
