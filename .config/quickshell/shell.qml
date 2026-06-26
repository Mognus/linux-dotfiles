import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    property bool tuxVisible: true
    property string clockText: Qt.formatTime(new Date(), "hh:mm")

    function workspaceFor(id) {
        const workspaces = Hyprland.workspaces.values;

        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id === id) {
                return workspaces[i];
            }
        }

        return null;
    }

    function workspaceExists(id) {
        return root.workspaceFor(id) !== null;
    }

    function workspaceActive(id) {
        return Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === id;
    }

    function workspaceUrgent(id) {
        const workspace = root.workspaceFor(id);
        return workspace !== null && workspace.urgent;
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: root.clockText = Qt.formatTime(new Date(), "hh:mm")
    }

    IpcHandler {
        target: "tux"

        function toggle(): void {
            root.tuxVisible = !root.tuxVisible
        }
    }

    PanelWindow {
        id: topBar

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 28
        color: "transparent"
        aboveWindows: true

        Rectangle {
            anchors.fill: parent
            color: "#b8000000"
        }

        Row {
            anchors {
                left: parent.left
                leftMargin: 8
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            spacing: 2

            Repeater {
                model: 9

                Rectangle {
                    width: 28
                    height: topBar.implicitHeight
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: modelData + 1
                        color: "#ffffff"
                        opacity: root.workspaceActive(modelData + 1) ? 1.0 : root.workspaceExists(modelData + 1) ? 0.82 : 0.42
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 16
                        font.bold: root.workspaceActive(modelData + 1)
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }

                        height: 2
                        color: root.workspaceUrgent(modelData + 1) ? "#d20f39" : root.workspaceActive(modelData + 1) ? "#ffffff" : "#59ffffff"
                        visible: root.workspaceActive(modelData + 1) || root.workspaceExists(modelData + 1) || root.workspaceUrgent(modelData + 1)
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (modelData + 1))
                    }
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "REC"
                color: "#d20f39"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 12
                font.bold: true
                visible: false
            }
        }

        Column {
            anchors.centerIn: parent

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.clockText
                color: "#ffffff"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 12
                font.bold: true
            }
        }

        Row {
            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            spacing: 14

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "VOL"
                color: "#ffffff"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 14
            }

            Repeater {
                model: ["T", "M", "N", "D", "F"]

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData
                    color: "#666666"
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 18
                    font.bold: true
                }
            }
        }
    }

    PanelWindow {
        visible: root.tuxVisible

        anchors {
            left: true
            bottom: true
        }

        implicitWidth: 104
        implicitHeight: 102
        color: "transparent"
        aboveWindows: true

        AnimatedImage {
            anchors.fill: parent
            source: "assets/tuxdevil_tiny.gif"
            fillMode: Image.PreserveAspectFit
            playing: true
        }
    }

    PanelWindow {
        visible: root.tuxVisible

        anchors {
            right: true
            bottom: true
        }

        implicitWidth: 95
        implicitHeight: 102
        color: "transparent"
        aboveWindows: true

        AnimatedImage {
            anchors.fill: parent
            source: "assets/tuxangel_tiny.gif"
            fillMode: Image.PreserveAspectFit
            playing: true
        }
    }
}
