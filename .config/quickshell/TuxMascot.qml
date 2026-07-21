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

    implicitWidth: sprite.sourceSize.width > 0 ? sprite.sourceSize.width : 100
    implicitHeight: sprite.sourceSize.height > 0 ? sprite.sourceSize.height : 100
    exclusiveZone: 0
    color: "transparent"
    aboveWindows: true

    AnimatedImage {
        id: sprite

        anchors.fill: parent
        source: mascot.angel ? "assets/tuxangel_bottom.gif" : "assets/tuxdevil_bottom.gif"
        fillMode: Image.PreserveAspectFit
        playing: true
    }
}
