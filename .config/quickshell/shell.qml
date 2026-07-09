import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

ShellRoot {
    id: root

    property bool topBarVisible: true
    property bool tuxVisible: true
    property bool quickSettingsOpen: false
    property string clockText: Qt.formatTime(new Date(), "hh:mm")
    property bool recording: false
    property string activeSpecialWorkspace: ""
    property var specialWorkspaces: [
        { name: "term", label: "T", accent: "#40a02b" },
        { name: "files", label: "Y", accent: "#1e66f5" },
        { name: "music", label: "M", accent: "#40a02b" },
        { name: "cmus", label: "C", accent: "#e64553" },
        { name: "notes", label: "N", accent: "#7287fd" },
        { name: "discord", label: "D", accent: "#8839ef" },
        { name: "firefox", label: "F", accent: "#fe640b" },
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

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.clockText = Qt.formatTime(new Date(), "hh:mm");
            recordStatusProcess.exec(["pgrep", "-x", "wf-recorder"]);
        }
    }

    Process {
        id: recordStatusProcess

        command: ["pgrep", "-x", "wf-recorder"]
        running: true

        onExited: exitCode => root.recording = exitCode === 0
    }

    Process {
        id: recordToggleProcess

        command: [Qt.resolvedUrl("../hypr/scripts/record-toggle.sh").toString().replace("file://", "")]

        onExited: recordStatusProcess.exec(["pgrep", "-x", "wf-recorder"])
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
        target: "bar"

        function toggle(): void {
            root.topBarVisible = !root.topBarVisible
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

    TopBar {
        shown: root.topBarVisible
        recording: root.recording
        clockText: root.clockText
        quickSettingsOpen: root.quickSettingsOpen
        specialWorkspaces: root.specialWorkspaces
        activeSpecialWorkspace: root.activeSpecialWorkspace

        onRecordingToggleRequested: recordToggleProcess.running = true
        onQuickSettingsToggleRequested: root.quickSettingsOpen = !root.quickSettingsOpen
        onSpecialWorkspaceToggleRequested: name => root.toggleSpecialWorkspace(name)
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
    }
}
