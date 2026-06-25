import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    property bool tuxVisible: true

    IpcHandler {
        target: "tux"

        function toggle(): void {
            root.tuxVisible = !root.tuxVisible
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
