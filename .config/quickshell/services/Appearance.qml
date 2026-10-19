pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs

// The TOML is the saved state. These properties are just its current UI snapshot.
Singleton {
    id: root

    property real opacity: 0.93
    property real fontSize: 20
    property int padding: 12
    property string error: ""
    property var pending: []

    function readState(text) {
        try {
            const state = JSON.parse(text);
            root.opacity = state.opacity;
            root.fontSize = state.font_size;
            root.padding = state.padding;
        } catch (error) {
            root.error = "Could not read terminal settings: " + error;
        }
    }

    function save(setting, value) {
        root.enqueue([ThemePaths.binary, "terminal", setting, String(value)]);
    }

    function resetTerminal() {
        root.enqueue([ThemePaths.binary, "terminal", "reset"]);
    }

    function enqueue(command) {
        root.pending = root.pending.concat([command]);
        root.runNext();
    }

    function runNext() {
        if (!writer.running && root.pending.length > 0) {
            const command = root.pending[0];
            root.pending = root.pending.slice(1);
            writer.exec(command);
        }
    }

    FileView {
        path: ThemePaths.stateDir + "/alacritty.toml"
        watchChanges: true
        printErrors: false
        onLoaded: refresh.restart()
        onFileChanged: {
            reload();
            refresh.restart();
        }
    }

    Timer {
        id: refresh

        interval: 50
        onTriggered: {
            if (reader.running) {
                refresh.restart();
            } else {
                reader.running = true;
            }
        }
    }

    Process {
        command: [ThemePaths.binary, "init"]
        running: true
        stderr: StdioCollector { id: initError }
        stdout: StdioCollector { onStreamFinished: root.readState(text) }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) root.error = initError.text || "Build the writer with make -C tools/appearancectl";
        }
    }

    Process {
        id: reader

        command: [ThemePaths.binary, "get"]
        stdout: StdioCollector { onStreamFinished: root.readState(text) }
        stderr: StdioCollector { id: readError }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) root.error = readError.text;
        }
    }

    Process {
        id: writer

        stdout: StdioCollector { onStreamFinished: root.readState(text) }
        stderr: StdioCollector { id: writeError }
        onExited: (exitCode, exitStatus) => {
            root.error = exitCode === 0 ? "" : writeError.text;
            refresh.restart();
            root.runNext();
        }
    }
}
