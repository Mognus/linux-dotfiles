import QtQuick
import qs
import qs.modules.preview

Item {
    id: preview

    property var entry: null
    property string emptyText: "No wallpapers found"

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: caption.top
        anchors.bottomMargin: 12
        color: Colors.surface
        border.width: 1
        border.color: Colors.borderMuted

        ImagePreview {
            anchors.fill: parent
            anchors.margins: 1
            source: preview.entry ? preview.entry.url : ""
            emptyText: preview.emptyText
        }
    }

    Text {
        id: caption
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: preview.entry ? preview.entry.path.split("/").pop() : ""
        textFormat: Text.PlainText
        elide: Text.ElideMiddle
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }
}
