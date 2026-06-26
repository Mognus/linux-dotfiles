import Quickshell
import QtQuick

PanelWindow {
    id: mascot

    property bool angel: false

    anchors {
        left: !mascot.angel
        right: mascot.angel
        bottom: true
    }

    implicitWidth: mascot.angel ? 95 : 104
    implicitHeight: 102
    color: "transparent"
    aboveWindows: true

    AnimatedImage {
        anchors.fill: parent
        source: mascot.angel ? "assets/tuxangel_tiny.gif" : "assets/tuxdevil_tiny.gif"
        fillMode: Image.PreserveAspectFit
        playing: true
    }
}
