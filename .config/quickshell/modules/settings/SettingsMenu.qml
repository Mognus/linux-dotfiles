import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.modules
import qs.services
import qs.modules.settings.launchers

// The settings menu on Super+G: a window around the top Launcher, one
// LauncherEntry per settings page.
PanelWindow {
    id: menu

    readonly property int padding: 12
    readonly property int headerHeight: 44

    visible: ShellState.settingsOpen
    // Without anchors the compositor centers the window.
    implicitWidth: 600
    implicitHeight: menu.headerHeight + divider.height + 340 + menu.padding * 2
    color: "transparent"

    // Overlay sits above fullscreen windows; Exclusive routes the keyboard here.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    // Name that Hyprland layer rules can match.
    WlrLayershell.namespace: "launcher"

    // Every opening starts at the top of the list.
    onVisibleChanged: {
        if (menu.visible) {
            launcher.reset();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
        border.width: 1
        border.color: Colors.subtle
    }

    Breadcrumbs {
        id: header

        // No top margin: the header's own height centers the crumbs between edge and divider.
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: menu.padding
            rightMargin: menu.padding
        }

        height: menu.headerHeight
        path: launcher.path
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

    Launcher {
        id: launcher

        anchors {
            top: divider.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: menu.padding
        }

        onCloseRequested: ShellState.closeSettings()

        entries: [
            LauncherEntry {
                title: "Audio"
                page: Component {
                    AudioPage {}
                }
            },
            LauncherEntry {
                title: "Theme"
                page: Component {
                    ThemeLauncher {}
                }
            }
        ]
    }
}
