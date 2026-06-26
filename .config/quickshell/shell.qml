import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

ShellRoot {
    id: root

    property bool tuxVisible: true
    property bool quickSettingsOpen: false
    property string clockText: Qt.formatTime(new Date(), "hh:mm")
    property bool recording: false
    property string activeSpecialWorkspace: ""
    property var specialWorkspaces: [
        { name: "term", label: "T", accent: "#40a02b" },
        { name: "files", label: "Y", accent: "#ffffff" },
        { name: "music", label: "M", accent: "#40a02b" },
        { name: "cmus", label: "C", accent: "#e64553" },
        { name: "notes", label: "N", accent: "#7287fd" },
        { name: "discord", label: "D", accent: "#8839ef" },
        { name: "firefox", label: "F", accent: "#fe640b" },
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

    function toggleSpecialWorkspace(name) {
        root.activeSpecialWorkspace = root.specialWorkspaceVisible(name) ? "" : "special:" + name;
        Hyprland.dispatch("togglespecialworkspace " + name);
    }

    function audioReady(node) {
        return node !== null && node.ready && node.audio !== null;
    }

    function audioLabel(node) {
        if (node === null) {
            return "No device";
        }

        return node.nickname || node.description || node.name;
    }

    function audioVolumeRatio(node) {
        return root.audioReady(node) ? Math.max(0, Math.min(1, node.audio.volume)) : 0;
    }

    function audioPercent(node) {
        return Math.round(root.audioVolumeRatio(node) * 100);
    }

    function audioMuted(node) {
        return root.audioReady(node) && node.audio.muted;
    }

    function setAudioVolume(node, ratio) {
        if (!root.audioReady(node)) {
            return;
        }

        node.audio.volume = Math.max(0, Math.min(1, ratio));
    }

    function toggleAudioMute(node) {
        if (root.audioReady(node)) {
            node.audio.muted = !node.audio.muted;
        }
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
                text: "●"
                color: root.recording ? "#d20f39" : "transparent"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 13
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: recordToggleProcess.running = true
                }
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
                text: "VOL " + root.audioPercent(Pipewire.defaultAudioSink)
                color: root.audioMuted(Pipewire.defaultAudioSink) ? "#e64553" : "#ffffff"
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 14
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 24
                height: topBar.implicitHeight
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "⚙"
                    color: root.quickSettingsOpen ? "#40a02b" : "#ffffff"
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
                    visible: root.quickSettingsOpen
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.quickSettingsOpen = !root.quickSettingsOpen
                }
            }

            Repeater {
                model: root.specialWorkspaces

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.label
                    color: root.specialWorkspaceVisible(modelData.name) ? modelData.accent : root.specialWorkspaceExists(modelData.name) ? "#ffffff" : "#666666"
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 18
                    font.bold: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.toggleSpecialWorkspace(modelData.name)
                    }
                }
            }
        }
    }

    PanelWindow {
        id: quickSettings
        visible: root.quickSettingsOpen

        anchors {
            top: true
            right: true
            bottom: true
        }

        margins {
            top: 0
            right: 0
            bottom: 0
        }

        implicitWidth: 320
        color: "transparent"
        aboveWindows: true
        focusable: true
        exclusiveZone: 0

        Rectangle {
            anchors.fill: parent
            color: "#e6111111"
            radius: 0
            border.width: 1
            border.color: "#24ffffff"
        }

        Column {
            anchors {
                fill: parent
                margins: 18
            }

            spacing: 18

            Row {
                width: parent.width
                height: 28

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 32
                    text: "Quick Settings"
                    color: "#ffffff"
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 18
                    font.bold: true
                }

                Rectangle {
                    width: 28
                    height: 28
                    radius: 0
                    color: closeMouse.containsMouse ? "#28ffffff" : "#14ffffff"

                    Text {
                        anchors.centerIn: parent
                        text: "x"
                        color: "#ffffff"
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 15
                        font.bold: true
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.quickSettingsOpen = false
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 10

                Row {
                    width: parent.width
                    height: 24

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 76
                        text: "Output"
                        color: "#ffffff"
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 15
                        font.bold: true
                    }

                    Rectangle {
                        width: 76
                        height: 24
                        radius: 0
                        color: root.audioMuted(Pipewire.defaultAudioSink) ? "#36e64553" : "#18ffffff"

                        Text {
                            anchors.centerIn: parent
                            text: root.audioMuted(Pipewire.defaultAudioSink) ? "MUTED" : "MUTE"
                            color: root.audioMuted(Pipewire.defaultAudioSink) ? "#e64553" : "#ffffff"
                            font.family: "Syne, MesloLGS Nerd Font, monospace"
                            font.pixelSize: 11
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.toggleAudioMute(Pipewire.defaultAudioSink)
                        }
                    }
                }

                Text {
                    width: parent.width
                    text: root.audioLabel(Pipewire.defaultAudioSink)
                    color: "#b8ffffff"
                    elide: Text.ElideRight
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 12
                }

                Row {
                    width: parent.width
                    height: 30
                    spacing: 10

                    Rectangle {
                        id: outputTrack
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 52
                        height: 10
                        radius: 0
                        color: "#26ffffff"

                        Rectangle {
                            width: outputTrack.width * root.audioVolumeRatio(Pipewire.defaultAudioSink)
                            height: parent.height
                            radius: 0
                            color: root.audioMuted(Pipewire.defaultAudioSink) ? "#e64553" : "#40a02b"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: mouse => root.setAudioVolume(Pipewire.defaultAudioSink, mouse.x / width)
                            onPositionChanged: mouse => {
                                if (pressed) {
                                    root.setAudioVolume(Pipewire.defaultAudioSink, mouse.x / width);
                                }
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 42
                        text: root.audioPercent(Pipewire.defaultAudioSink) + "%"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignRight
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                Row {
                    width: parent.width
                    height: 28
                    spacing: 8

                    Repeater {
                        model: [25, 50, 75, 100]

                        Rectangle {
                            width: (parent.width - 24) / 4
                            height: 28
                            radius: 0
                            color: Math.abs(root.audioPercent(Pipewire.defaultAudioSink) - modelData) < 3 ? "#3040a02b" : "#14ffffff"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: "#ffffff"
                                font.family: "Syne, MesloLGS Nerd Font, monospace"
                                font.pixelSize: 12
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.setAudioVolume(Pipewire.defaultAudioSink, modelData / 100)
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#20ffffff"
            }

            Column {
                width: parent.width
                spacing: 10

                Row {
                    width: parent.width
                    height: 24

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 76
                        text: "Microphone"
                        color: "#ffffff"
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 15
                        font.bold: true
                    }

                    Rectangle {
                        width: 76
                        height: 24
                        radius: 0
                        color: root.audioMuted(Pipewire.defaultAudioSource) ? "#36e64553" : "#18ffffff"

                        Text {
                            anchors.centerIn: parent
                            text: root.audioMuted(Pipewire.defaultAudioSource) ? "MUTED" : "MUTE"
                            color: root.audioMuted(Pipewire.defaultAudioSource) ? "#e64553" : "#ffffff"
                            font.family: "Syne, MesloLGS Nerd Font, monospace"
                            font.pixelSize: 11
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.toggleAudioMute(Pipewire.defaultAudioSource)
                        }
                    }
                }

                Text {
                    width: parent.width
                    text: root.audioLabel(Pipewire.defaultAudioSource)
                    color: "#b8ffffff"
                    elide: Text.ElideRight
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 12
                }

                Row {
                    width: parent.width
                    height: 30
                    spacing: 10

                    Rectangle {
                        id: inputTrack
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 52
                        height: 10
                        radius: 0
                        color: "#26ffffff"

                        Rectangle {
                            width: inputTrack.width * root.audioVolumeRatio(Pipewire.defaultAudioSource)
                            height: parent.height
                            radius: 0
                            color: root.audioMuted(Pipewire.defaultAudioSource) ? "#e64553" : "#7287fd"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: mouse => root.setAudioVolume(Pipewire.defaultAudioSource, mouse.x / width)
                            onPositionChanged: mouse => {
                                if (pressed) {
                                    root.setAudioVolume(Pipewire.defaultAudioSource, mouse.x / width);
                                }
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 42
                        text: root.audioPercent(Pipewire.defaultAudioSource) + "%"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignRight
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }

            Text {
                width: parent.width
                text: Pipewire.ready ? "PIPEWIRE READY" : "PIPEWIRE WAIT"
                color: Pipewire.ready ? "#7dffffff" : "#e64553"
                horizontalAlignment: Text.AlignRight
                font.family: "Syne, MesloLGS Nerd Font, monospace"
                font.pixelSize: 10
                font.bold: true
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
