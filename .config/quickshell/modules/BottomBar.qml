import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import qs
import qs.services
import "../lib/Audio.js" as Audio

PanelWindow {
    id: bar

    readonly property bool shown: ShellState.bottomBarVisible
    readonly property int barHeight: 34
    readonly property int contentGap: 4

    anchors {
        bottom: true
        left: true
        right: true
    }

    // Collapse the surface so a hidden bar does not reserve screen space.
    implicitHeight: bar.shown ? bar.barHeight : 0
    // Keep a small visual separation above the bottom bar while it is visible.
    exclusiveZone: bar.implicitHeight + (bar.shown ? bar.contentGap : 0)
    color: "transparent"
    aboveWindows: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    // Clip the fixed-height content while it moves below the collapsing surface.
    Item {
        id: viewport

        anchors.fill: parent
        clip: true

        Item {
            id: content

            width: parent.width
            height: bar.barHeight
            y: bar.shown ? 0 : height

            Behavior on y {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Rectangle {
        parent: content
        z: -1
        anchors.fill: parent
        color: Colors.bar
    }

    Row {
        parent: content
        anchors {
            right: parent.right
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }

        height: parent.height
        spacing: 2

        Repeater {
            model: 9

            Rectangle {
                width: 36
                height: bar.barHeight
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: modelData + 1
                    color: Colors.foreground
                    opacity: Workspaces.workspaceActive(modelData + 1) ? 1.0 : Workspaces.workspaceExists(modelData + 1) ? 0.82 : 0.42
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 20
                    font.bold: Workspaces.workspaceActive(modelData + 1)
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    height: 2
                    color: Workspaces.workspaceUrgent(modelData + 1) ? Colors.danger : Workspaces.workspaceActive(modelData + 1) ? Colors.foreground : Colors.faint
                    visible: Workspaces.workspaceActive(modelData + 1) || Workspaces.workspaceExists(modelData + 1) || Workspaces.workspaceUrgent(modelData + 1)
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
            color: Recording.recording ? Colors.danger : "transparent"
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 17
            font.bold: true

            MouseArea {
                anchors.fill: parent
                onClicked: Recording.toggle()
            }
        }
    }

    Column {
        parent: content
        anchors.centerIn: parent

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Time.clock
            color: Colors.foreground
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 15
            font.bold: true
        }
    }

    Row {
        parent: content
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }

        height: parent.height
        spacing: 14

        Repeater {
            model: Workspaces.specialWorkspaces

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.label
                color: Workspaces.specialWorkspaceVisible(modelData.name) ? modelData.accent : Workspaces.specialWorkspaceExists(modelData.name) ? Colors.foreground : Colors.muted
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 23
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: Workspaces.toggleSpecialWorkspace(modelData.name)
                }
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 31
            height: bar.barHeight
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "⚙"
                color: ShellState.quickSettingsOpen ? Colors.accent : Colors.foreground
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 19
                font.bold: true
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                height: 2
                color: Colors.accent
                visible: ShellState.quickSettingsOpen
            }

            MouseArea {
                anchors.fill: parent
                onClicked: ShellState.toggleQuickSettings()
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "VOL " + Audio.percent(Pipewire.defaultAudioSink)
            color: Audio.muted(Pipewire.defaultAudioSink) ? Colors.danger : Colors.foreground
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 18
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: Battery.present
            text: "BAT " + Battery.percent
            color: Battery.percent <= 15 && !Battery.charging ? Colors.danger : Colors.foreground
            font.family: "Syne, MesloLGS Nerd Font, monospace"
            font.pixelSize: 18
        }
    }
}
