import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

// Full-screen dimmed backdrop; Hyprland blurs behind it, the centered panel stays sharp.
// Every overlay shares the same chrome: a breadcrumb header, a divider and a body.
// The title is display-only text, e.g. "SETTINGS / Launcher / Applications".
PanelWindow {
    id: window

    required property int panelWidth
    required property int panelHeight
    property color panelColor: Colors.background
    property color panelBorderColor: Colors.border
    property int panelBorderWidth: 1
    property string title: ""

    readonly property int headerHeight: 44
    readonly property int dividerHeight: 1

    signal closeRequested

    // Everything the overlay declares lands in the body below the header.
    default property alias panelContent: body.data

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

        Breadcrumbs {
            id: header

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 12
                rightMargin: 12
            }

            height: window.headerHeight
            title: window.title
            onCloseRequested: window.closeRequested()
        }

        Rectangle {
            id: divider

            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
            }

            height: window.dividerHeight
            color: Colors.borderMuted
        }

        Item {
            id: body

            anchors {
                top: divider.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
    }
}
