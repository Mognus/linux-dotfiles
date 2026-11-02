pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool recording: false

    function toggle() {
        toggleProcess.running = true;
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: statusProcess.exec(["pgrep", "-x", "wf-recorder"])
    }

    Process {
        id: statusProcess

        command: ["pgrep", "-x", "wf-recorder"]
        running: true

        onExited: exitCode => root.recording = exitCode === 0
    }

    Process {
        id: toggleProcess

        command: [Qt.resolvedUrl("../../hypr/scripts/record-toggle.sh").toString().replace("file://", "")]

        onExited: statusProcess.exec(["pgrep", "-x", "wf-recorder"])
    }
}
