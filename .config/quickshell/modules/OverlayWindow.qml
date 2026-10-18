import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

// Full-screen dimmed backdrop; Hyprland blurs behind it, the centered panel stays sharp.
PanelWindow {
    id: window

    required property int panelWidth
    required property int panelHeight
    property color panelColor: Colors.panel
    property color panelBorderColor: "#888888"
    property int panelBorderWidth: 2
    default property alias panelContent: panel.data

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    color: Qt.rgba(0, 0, 0, 0.5)

    // Overlay sits above fullscreen windows; Exclusive routes the keyboard here.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Rectangle {
        id: panel

        anchors.centerIn: parent
        width: window.panelWidth
        height: window.panelHeight
        color: window.panelColor
        // Match the special-workspace borders in hypr/lua/workspaces.lua.
        border.width: window.panelBorderWidth
        border.color: window.panelBorderColor
    }
}
