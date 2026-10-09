import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs
import qs.services
import "../lib/Navigation.js" as Navigation

// App launcher: a GNOME-style grid of the desktop apps. The search line is
// always active: typing filters, the arrows or Ctrl+hjkl move, Enter starts.
PanelWindow {
    id: window

    readonly property int padding: 12
    readonly property int cellSize: 120
    readonly property int columns: 6
    readonly property int rows: 4
    readonly property int footerHeight: 36
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
    // Without anchors the compositor centers the window.
    implicitWidth: window.columns * window.cellSize + window.padding * 2
    implicitHeight: window.rows * window.cellSize + window.footerHeight + window.padding * 2
    color: "transparent"

    // Overlay sits above fullscreen windows; Exclusive routes the keyboard here.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
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

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
        border.width: 1
        border.color: Colors.subtle
    }

    GridView {
        id: grid

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
            margins: window.padding
        }

        cellWidth: window.cellSize
        cellHeight: window.cellSize
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
                    topMargin: 20
                }

                implicitSize: 48
                asynchronous: true
                source: Quickshell.iconPath(cell.modelData.icon, "application-x-executable")
            }

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 10
                    bottomMargin: 18
                }

                text: cell.modelData.name
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                color: cell.GridView.isCurrentItem ? Colors.foreground : Colors.foregroundSoft
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 13
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
            } else if ([Qt.Key_Return, Qt.Key_Enter].includes(event.key)) {
                window.launchCurrent();
            } else if (event.key === Qt.Key_Escape) {
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
            margins: window.padding
        }

        height: window.footerHeight
        focus: true
        keyTargets: [searchKeys]
    }
}
