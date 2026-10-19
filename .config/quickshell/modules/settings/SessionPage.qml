import Quickshell
import QtQuick
import qs
import qs.modules
import qs.services

OverlayPage {
    id: page

    title: "General / Session"
    searchEnabled: true
    searching: list.searching
    confirmLabel: "EXECUTE"

    readonly property var actions: [
        { name: "Lock", description: "Lock the screen using the existing Hypridle handler.", command: ["loginctl", "lock-session"] },
        { name: "Log out", description: "End the current Hyprland session.", command: ["hyprctl", "dispatch", "exit"] },
        { name: "Restart", description: "Restart the computer.", command: ["systemctl", "reboot"] },
        { name: "Power off", description: "Shut down the computer.", command: ["systemctl", "poweroff"] }
    ]

    SearchableList {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: description.top
        anchors.bottomMargin: 16
        entries: page.actions
        onActivated: entry => {
            ShellState.dismissOverlay();
            Quickshell.execDetached(entry.command);
        }
    }

    Text {
        id: description

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: list.current ? list.current.description : "No matching actions"
        wrapMode: Text.WordWrap
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.smallSize
    }
}
