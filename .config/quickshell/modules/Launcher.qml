import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

// Rofi-style box that lists its entries. It knows nothing about what an entry
// stands for; SettingsMenu.qml fills it.
PanelWindow {
    id: launcher

    property bool open: false
    property list<LauncherEntry> entries
    // Entry whose page replaces the list, null while listing.
    property LauncherEntry current: null

    readonly property int rowHeight: 36
    readonly property int bodyHeight: 340
    readonly property int padding: 12

    signal closeRequested

    function openEntry(entry) {
        launcher.current = entry;
        // The list holds the focus while listing; a page needs another holder so Esc still arrives.
        keys.forceActiveFocus();
    }

    function openCurrent() {
        const entry = launcher.entries[list.currentIndex];
        if (entry) {
            launcher.openEntry(entry);
        }
    }

    // Esc leaves the page first and closes the launcher once the list is showing.
    function back() {
        if (launcher.current === null) {
            launcher.closeRequested();
            return;
        }
        launcher.current = null;
        list.forceActiveFocus();
    }

    function reset() {
        launcher.current = null;
        list.currentIndex = 0;
        list.forceActiveFocus();
    }

    visible: launcher.open
    // Without anchors the compositor centers the window.
    implicitWidth: 600
    implicitHeight: launcher.bodyHeight + launcher.padding * 2
    color: "transparent"

    // Overlay sits above fullscreen windows; Exclusive routes the keyboard here.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    // Name that Hyprland layer rules can match.
    WlrLayershell.namespace: "launcher"

    // Every opening starts at the top of the list.
    onVisibleChanged: {
        if (launcher.visible) {
            launcher.reset();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
        border.width: 1
        border.color: Colors.subtle
    }

    Item {
        id: keys

        anchors.fill: parent
        // Esc travels up to here from whichever child has the focus.
        Keys.onEscapePressed: launcher.back()

        ListView {
            id: list

            anchors {
                fill: parent
                margins: launcher.padding
            }

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
            anchors {
                fill: parent
                margins: launcher.padding
            }

            active: launcher.current !== null
            sourceComponent: launcher.current ? launcher.current.page : null
        }
    }
}
