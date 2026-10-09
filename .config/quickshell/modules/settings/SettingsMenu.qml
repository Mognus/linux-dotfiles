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

    visible: ShellState.settingsOpen
    // Without anchors the compositor centers the window.
    implicitWidth: 600
    implicitHeight: 340 + menu.padding * 2
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

    Launcher {
        id: launcher

        anchors {
            fill: parent
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
