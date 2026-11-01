import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.modules.theme
import qs.modules.keyboard
import qs.services

// The only picker window: no routes, settings hierarchy or generic page frame.
PanelWindow {
    id: window

    readonly property int headerHeight: 44
    readonly property int contentHeight: 440
    readonly property int padding: 12

    visible: ShellState.themeSwitcherOpen
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    color: Qt.rgba(0, 0, 0, 0.5)
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "theme-switcher"

    Rectangle {
        id: panel

        anchors.centerIn: parent
        width: 960
        height: window.headerHeight + 1 + window.contentHeight + window.padding * 2 + hints.height
        color: Colors.background
        border.color: Colors.border
        border.width: 1

        Row {
            id: header

            anchors.left: parent.left
            anchors.leftMargin: window.padding
            height: window.headerHeight
            spacing: 12

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "×"
                color: closeMouse.containsMouse ? Colors.foreground : Colors.muted
                font.family: Fonts.family
                font.pixelSize: Fonts.largeSize

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: ShellState.closeThemeSwitcher()
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "THEMES"
                color: Colors.foreground
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }
        }

        Rectangle {
            id: divider
            anchors.top: header.bottom
            width: parent.width
            height: 1
            color: Colors.borderMuted
        }

        // Recreate the picker on opening, so every visit starts in normal mode.
        Loader {
            id: picker

            anchors.top: divider.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: hints.top
            anchors.margins: window.padding
            active: window.visible
            focus: true
            sourceComponent: ThemePicker {}
            onLoaded: item.activate()
        }

        KeyboardHints {
            id: hints
            bindings: picker.item ? picker.item.keyBindings : null
            extraHint: picker.item ? picker.item.extraHint : ""
        }
    }
}
