import QtQuick
import Quickshell.Wayland

Item {
    id: preview
    property var toplevel: null
    property bool active: false

    // Only the selected window streams while its page is visible.
    ScreencopyView {
        anchors.centerIn: parent
        captureSource: preview.active && preview.toplevel ? preview.toplevel.wayland : null
        live: true
        constraintSize: Qt.size(preview.width, preview.height)
    }
}
