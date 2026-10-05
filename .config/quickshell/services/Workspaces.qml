pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs

Singleton {
    id: root

    property string activeSpecialWorkspace: ""
    property var specialWorkspaces: [
        { name: "term", label: "T", accent: Colors.success },
        { name: "files", label: "Y", accent: Colors.accent },
        { name: "music", label: "M", accent: Colors.success },
        { name: "notes", label: "N", accent: Colors.secondary },
        { name: "discord", label: "D", accent: Colors.violet },
        { name: "firefox", label: "F", accent: Colors.orange },
    ]

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
        return root.specialWorkspaceFor(name) !== null;
    }

    function specialWorkspaceVisible(name) {
        return root.activeSpecialWorkspace === "special:" + name;
    }

    function toggleSpecialWorkspace(name) {
        root.activeSpecialWorkspace = root.specialWorkspaceVisible(name) ? "" : "special:" + name;
        Hyprland.dispatch("togglespecialworkspace " + name);
    }

    function setActiveSpecialFromEvent(event) {
        if (event.name !== "activespecial" && event.name !== "activespecialv2") {
            return;
        }

        const parts = event.data.split(",");
        for (let i = 0; i < parts.length; i++) {
            const value = parts[i].trim();
            if (value.startsWith("special:")) {
                root.activeSpecialWorkspace = value;
                return;
            }
        }

        root.activeSpecialWorkspace = "";
    }

    // Seed the initial state from Hyprland's already-loaded monitor info
    // instead of shelling out to hyprctl/jq; live updates then come from
    // the rawEvent connection below.
    function initActiveSpecialWorkspace() {
        const monitors = Hyprland.monitors.values;

        for (let i = 0; i < monitors.length; i++) {
            const info = monitors[i].lastIpcObject;
            const name = info && info.specialWorkspace ? info.specialWorkspace.name : "";
            if (name) {
                root.activeSpecialWorkspace = name;
                return;
            }
        }
    }

    Component.onCompleted: root.initActiveSpecialWorkspace()

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            root.setActiveSpecialFromEvent(event);
        }
    }
}
