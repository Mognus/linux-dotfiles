import QtQuick
import qs

// Display only: the view supplies state and action labels, and handles the keys.
Text {
    id: hints

    property bool searching: false
    property bool searchEnabled: true
    property bool gridNavigation: false
    property string navigationHint: ""
    property string confirmKeys: "ENTER"
    property string confirmLabel: "APPLY"
    property string cancelLabel: searching ? "CLEAR" : "BACK"
    property string extraHint: ""

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
    text: (hints.navigationHint || (hints.searchEnabled ? (hints.gridNavigation ? "↑↓←→ / CTRL+HJKL" : hints.searching ? "↑↓ / CTRL+JK" : "↑↓ / JK") + "  SELECT" : ""))
        + (hints.confirmLabel ? "    " + hints.confirmKeys + "  " + hints.confirmLabel : "")
        + (hints.searchEnabled && !hints.searching ? "    /  FIND" : "")
        + "    ESC  " + hints.cancelLabel
        + (hints.extraHint ? "    " + hints.extraHint : "")
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
