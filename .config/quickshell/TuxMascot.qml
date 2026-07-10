import Quickshell
import QtQuick

PanelWindow {
    id: mascot

    property bool angel: false
    property int bottomInset: 0

    anchors {
        left: !mascot.angel
        right: mascot.angel
        bottom: true
    }

    margins.bottom: mascot.bottomInset

    implicitWidth: mascot.angel ? 61 : 66
    implicitHeight: 66
    exclusiveZone: 0
    color: "transparent"
    aboveWindows: true

    AnimatedImage {
        anchors.fill: parent
        source: mascot.angel ? "assets/tuxangel_bottom.gif" : "assets/tuxdevil_bottom.gif"
        fillMode: Image.PreserveAspectFit
        playing: true
    }
}
