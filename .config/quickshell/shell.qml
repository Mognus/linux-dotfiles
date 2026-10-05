import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

ShellRoot {
    id: root

    property bool bottomBarVisible: true
    property bool workspaceHudVisible: false
    property bool tuxVisible: true
    property bool quickSettingsOpen: false
    property string activeSpecialWorkspace: ""
    property var specialWorkspaces: [
        { name: "term", label: "T", accent: Colors.success },
        { name: "files", label: "Y", accent: Colors.accent },
        { name: "music", label: "M", accent: Colors.success },
        { name: "notes", label: "N", accent: Colors.secondary },
        { name: "discord", label: "D", accent: Colors.violet },
        { name: "firefox", label: "F", accent: Colors.orange },
    ]

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

    function specialWorkspaceVisible(name) {
        return root.activeSpecialWorkspace === "special:" + name;
    }

    function toggleSpecialWorkspace(name) {
        root.activeSpecialWorkspace = root.specialWorkspaceVisible(name) ? "" : "special:" + name;
        Hyprland.dispatch("togglespecialworkspace " + name);
    }

    function toggleBottomBar() {
        root.bottomBarVisible = !root.bottomBarVisible;
        if (root.bottomBarVisible) {
            root.workspaceHudVisible = false;
        }
    }

    function toggleWorkspaceHud() {
        root.workspaceHudVisible = !root.workspaceHudVisible;
        if (root.workspaceHudVisible) {
            root.bottomBarVisible = false;
        }
    }

    Process {
        id: activeSpecialProcess

        command: [
            "bash",
            "-lc",
            "hyprctl monitors -j | jq -r '.[].specialWorkspace.name | select(. != \"\")' | head -n1"
        ]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.activeSpecialWorkspace = text.trim()
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            root.setActiveSpecialFromEvent(event);
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    IpcHandler {
        target: "bottombar"

        function toggle(): void {
            root.toggleBottomBar()
        }
    }

    IpcHandler {
        target: "workspacehud"

        function toggle(): void {
            root.toggleWorkspaceHud()
        }
    }

    IpcHandler {
        target: "tux"

        function toggle(): void {
            root.tuxVisible = !root.tuxVisible
        }
    }

    IpcHandler {
        target: "quicksettings"

        function toggle(): void {
            root.quickSettingsOpen = !root.quickSettingsOpen
        }

        function close(): void {
            root.quickSettingsOpen = false
        }
    }

    BottomBar {
        shown: root.bottomBarVisible
        quickSettingsOpen: root.quickSettingsOpen
        specialWorkspaces: root.specialWorkspaces
        activeSpecialWorkspace: root.activeSpecialWorkspace

        onQuickSettingsToggleRequested: root.quickSettingsOpen = !root.quickSettingsOpen
        onSpecialWorkspaceToggleRequested: name => root.toggleSpecialWorkspace(name)
    }

    WorkspaceHud {
        shown: root.workspaceHudVisible

        onWorkspaceSelected: id => Hyprland.dispatch("workspace " + id)
    }

    QuickSettingsPanel {
        open: root.quickSettingsOpen

        onCloseRequested: root.quickSettingsOpen = false
    }

    TuxMascot {
        visible: root.tuxVisible
    }

    TuxMascot {
        visible: root.tuxVisible
        angel: true
        bottomInset: root.workspaceHudVisible ? 34 : 0
    }

}
