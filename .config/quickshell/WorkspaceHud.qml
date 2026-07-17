import Quickshell
import Quickshell.Hyprland
import QtQuick

PanelWindow {
    id: hud

    property bool shown: false
    readonly property int itemWidth: 36
    readonly property int horizontalMargin: 8
    readonly property int hudHeight: 34
    readonly property int hudWidth: workspaces.implicitWidth + (horizontalMargin * 2)

    signal workspaceSelected(int id)

    function workspaceFor(id) {
        const allWorkspaces = Hyprland.workspaces.values;

        for (let i = 0; i < allWorkspaces.length; i++) {
            if (allWorkspaces[i].id === id) {
                return allWorkspaces[i];
            }
        }

        return null;
    }

    function workspaceActive(id) {
        return Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === id;
    }

    function workspaceExists(id) {
        return hud.workspaceFor(id) !== null;
    }

    anchors {
        bottom: true
        right: true
    }

    implicitWidth: hud.shown ? hud.hudWidth : 0
    implicitHeight: hud.shown ? hud.hudHeight : 0
    // The HUD overlays content briefly instead of shifting windows like a bar.
    exclusiveZone: 0
    color: "transparent"
    aboveWindows: true

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 160
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.panel
    }

    Row {
        id: workspaces

        anchors {
            left: parent.left
            leftMargin: hud.horizontalMargin
            verticalCenter: parent.verticalCenter
        }

        height: parent.height

        Repeater {
            model: 9

            Rectangle {
                width: hud.itemWidth
                height: hud.hudHeight
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: modelData + 1
                    color: Colors.foreground
                    opacity: hud.workspaceActive(modelData + 1) ? 1.0 : hud.workspaceExists(modelData + 1) ? 0.82 : 0.42
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 20
                    font.bold: hud.workspaceActive(modelData + 1)
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    height: 2
                    color: hud.workspaceActive(modelData + 1) ? Colors.foreground : Colors.faint
                    visible: hud.workspaceActive(modelData + 1) || hud.workspaceExists(modelData + 1)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: hud.workspaceSelected(modelData + 1)
                }
            }
        }
    }
}
