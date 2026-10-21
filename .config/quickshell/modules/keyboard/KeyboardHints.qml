import QtQuick
import qs

// Display only: pages and focused controls supply their actual action definitions.
Text {
    id: hints

    property string extraHint: ""
    property var bindings: null
    property var controlBindings: null

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    topPadding: 12
    bottomPadding: 12
    leftPadding: 12
    rightPadding: 12
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.WordWrap
    textFormat: Text.PlainText
    text: [hints.extraHint, hints.controlBindings ? hints.controlBindings.hints : "",
        hints.bindings ? hints.bindings.hints : ""].filter(text => text.length > 0).join("    ")
    color: Colors.muted
    font.family: Fonts.family
    font.pixelSize: Fonts.captionSize

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Colors.borderMuted
    }
}
