import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import "lib/Audio.js" as Audio

PanelWindow {
    id: bar

    property bool recording: false
    property bool quickSettingsOpen: false
    property string clockText: ""
    property string activeSpecialWorkspace: ""
    property var specialWorkspaces: []

    signal recordingToggleRequested()
    signal quickSettingsToggleRequested()
    signal specialWorkspaceToggleRequested(string name)

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
        return bar.workspaceFor(id) !== null;
    }

    function workspaceActive(id) {
        return Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === id;
    }

    function workspaceUrgent(id) {
        const workspace = bar.workspaceFor(id);
        return workspace !== null && workspace.urgent;
    }

    function specialWorkspaceFor(name) {
        const workspaces = Hyprland.workspaces.values;
        const workspaceName = "special:" + name;

        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].name === workspaceName) {
                return workspaces[i];
            }
        }

        return null;
    }

    function specialWorkspaceExists(name) {
        return bar.specialWorkspaceFor(name) !== null;
    }

    function specialWorkspaceVisible(name) {
        return bar.activeSpecialWorkspace === "special:" + name;
    }

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
                height: bar.implicitHeight
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: modelData + 1
                    color: "#ffffff"
                    opacity: bar.workspaceActive(modelData + 1) ? 1.0 : bar.workspaceExists(modelData + 1) ? 0.82 : 0.42
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 16
                    font.bold: bar.workspaceActive(modelData + 1)
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    height: 2
                    color: bar.workspaceUrgent(modelData + 1) ? "#d20f39" : bar.workspaceActive(modelData + 1) ? "#ffffff" : "#59ffffff"
                    visible: bar.workspaceActive(modelData + 1) || bar.workspaceExists(modelData + 1) || bar.workspaceUrgent(modelData + 1)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (modelData + 1))
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "●"
            color: bar.recording ? "#d20f39" : "transparent"
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 13
            font.bold: true

            MouseArea {
                anchors.fill: parent
                onClicked: bar.recordingToggleRequested()
            }
        }
    }

    Column {
        anchors.centerIn: parent

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: bar.clockText
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
            text: "VOL " + Audio.percent(Pipewire.defaultAudioSink)
            color: Audio.muted(Pipewire.defaultAudioSink) ? "#e64553" : "#ffffff"
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 14
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            height: bar.implicitHeight
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "⚙"
                color: bar.quickSettingsOpen ? "#40a02b" : "#ffffff"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 15
                font.bold: true
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                height: 2
                color: "#40a02b"
                visible: bar.quickSettingsOpen
            }

            MouseArea {
                anchors.fill: parent
                onClicked: bar.quickSettingsToggleRequested()
            }
        }

        Repeater {
            model: bar.specialWorkspaces

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.label
                color: bar.specialWorkspaceVisible(modelData.name) ? modelData.accent : bar.specialWorkspaceExists(modelData.name) ? "#ffffff" : "#666666"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 18
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: bar.specialWorkspaceToggleRequested(modelData.name)
                }
            }
        }
    }
}
