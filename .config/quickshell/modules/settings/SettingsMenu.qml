import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.modules
import qs.services
import qs.modules.settings.menus

// The settings menu on Super+G: a window around the top Menu, one
// MenuEntry per settings page.
OverlayWindow {
    id: window

    readonly property int padding: 12
    readonly property int headerHeight: 44

    visible: ShellState.settingsOpen
    panelWidth: 600
    panelHeight: window.headerHeight + divider.height + 340 + window.padding * 2

    // Name that Hyprland layer rules can match.
    WlrLayershell.namespace: "settings"

    // Every opening starts at the top of the list.
    onVisibleChanged: {
        if (window.visible) {
            menu.reset();
        }
    }

    Breadcrumbs {
        id: header

        // No top margin: the header's own height centers the crumbs between edge and divider.
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: window.padding
            rightMargin: window.padding
        }

        height: window.headerHeight
        path: menu.path
        onCloseRequested: ShellState.closeSettings()
    }

    Rectangle {
        id: divider

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }

        height: 1
        color: Colors.divider
    }

    Menu {
        id: menu

        anchors {
            top: divider.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: window.padding
        }

        onCloseRequested: ShellState.closeSettings()

        entries: [
            MenuEntry {
                title: "Audio"
                page: Component {
                    AudioPage {}
                }
            },
            MenuEntry {
                title: "Theme"
                page: Component {
                    ThemeMenu {}
                }
            }
        ]
    }
}
