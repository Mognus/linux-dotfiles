import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import qs
import qs.modules
import qs.services
import "../../lib/Navigation.js" as Navigation

// Window switcher: the open windows of every workspace on the left, a live view
// of the highlighted one on the right. The search line is always active: typing
// filters by app and title, Up/Down or Ctrl+j/k move, Enter focuses.
PanelWindow {
    id: window

    readonly property int padding: 12
    readonly property int rowHeight: 36
    readonly property int listWidth: 380
    // Windows whose app or title contains the search: "wolf" → LibreWolf.
    readonly property var matches: Array.from(Hyprland.toplevels.values).filter(toplevel => window.label(toplevel).toLowerCase().includes(footer.text.toLowerCase()))
    readonly property var current: window.matches[list.currentIndex] ?? null

    // "librewolf" for a LibreWolf window; empty until Wayland reports it.
    function appOf(toplevel) {
        return toplevel.wayland ? toplevel.wayland.appId : "";
    }

    // App and title in one string to search in: "librewolf GitHub".
    function label(toplevel) {
        return window.appOf(toplevel) + " " + toplevel.title;
    }

    function jumpTo(toplevel) {
        // With the Lua config, dispatch takes a Lua dispatcher. Quickshell reports
        // the address without the 0x that Hyprland's window selector expects.
        Hyprland.dispatch(`hl.dsp.focus({ window = "address:0x${toplevel.address}" })`);
        ShellState.closeWindowSwitcher();
    }

    function jumpToCurrent() {
        if (window.current) {
            window.jumpTo(window.current);
        }
    }

    visible: ShellState.windowSwitcherOpen
    // Without anchors the compositor centers the window.
    implicitWidth: 1100
    implicitHeight: 560
    color: "transparent"

    // Overlay sits above fullscreen windows; Exclusive routes the keyboard here.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    // Shares the app launcher's Hyprland layer rule.
    WlrLayershell.namespace: "launcher"

    // Every opening reads the windows afresh and starts with an empty search.
    onVisibleChanged: {
        if (window.visible) {
            Hyprland.refreshToplevels();
            footer.clear();
            list.currentIndex = 0;
            footer.forceActiveFocus();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
        border.width: 1
        border.color: Colors.subtle
    }

    ListView {
        id: list

        anchors {
            top: parent.top
            left: parent.left
            bottom: footer.top
            margins: window.padding
        }

        width: window.listWidth
        clip: true
        model: window.matches

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: window.rowHeight
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            Text {
                id: app

                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }

                width: 110
                text: window.appOf(row.modelData)
                color: Colors.muted
                elide: Text.ElideRight
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 15
            }

            Text {
                anchors {
                    left: app.right
                    leftMargin: 12
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }

                text: row.modelData.title
                color: row.ListView.isCurrentItem ? Colors.foreground : Colors.foregroundSoft
                elide: Text.ElideRight
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 15
            }

            MouseArea {
                anchors.fill: parent
                onClicked: window.jumpTo(row.modelData)
            }
        }
    }

    // Keys the search field hands over before typing: they drive the list.
    Item {
        id: searchKeys

        Keys.onPressed: event => {
            if (Navigation.isDown(event)) {
                list.incrementCurrentIndex();
            } else if (Navigation.isUp(event)) {
                list.decrementCurrentIndex();
            } else if ([Qt.Key_Return, Qt.Key_Enter].includes(event.key)) {
                window.jumpToCurrent();
            } else if (event.key === Qt.Key_Escape) {
                ShellState.closeWindowSwitcher();
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
            bottom: parent.bottom
            margins: window.padding
        }

        width: window.listWidth
        height: window.rowHeight
        focus: true
        keyTargets: [searchKeys]
    }

    Rectangle {
        id: divider

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: list.right
            leftMargin: window.padding
        }

        width: 1
        color: Colors.divider
    }

    Item {
        id: preview

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: divider.right
            right: parent.right
            margins: window.padding
        }

        // Only the highlighted window streams, and only while the switcher is open.
        ScreencopyView {
            anchors.centerIn: parent
            captureSource: window.visible && window.current ? window.current.wayland : null
            live: true
            constraintSize: Qt.size(preview.width, preview.height)
        }
    }
}
