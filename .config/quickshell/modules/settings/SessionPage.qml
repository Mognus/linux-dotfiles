import Quickshell
import QtQuick
import qs
import qs.modules
import qs.services

FocusScope {
    id: page

    readonly property var actions: [
        { name: "Lock", description: "Lock the screen using the existing Hypridle handler.", command: ["loginctl", "lock-session"] },
        { name: "Log out", description: "End the current Hyprland session.", command: ["hyprctl", "dispatch", "exit"] },
        { name: "Restart", description: "Restart the computer.", command: ["systemctl", "reboot"] },
        { name: "Power off", description: "Shut down the computer.", command: ["systemctl", "poweroff"] }
    ]

    focus: true

    SearchableList {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: description.top
        anchors.bottomMargin: 16
        entries: page.actions
        onActivated: entry => {
            ShellState.closeSettings();
            Quickshell.execDetached(entry.command);
        }
    }

    Text {
        id: description

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: hint.top
        anchors.bottomMargin: 12
        text: list.current ? list.current.description : "No matching actions"
        wrapMode: Text.WordWrap
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.smallSize
    }

    Text {
        id: hint

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: list.searching ? "Type to filter   ENTER execute   ESC clear search" : "J/K select   / search   ENTER execute   ESC back"
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }
}
