import QtQuick
import qs

// Display only; callers supply a URL and decide how to frame the preview.
Item {
    id: preview

    property alias source: image.source
    property string emptyText: ""
    readonly property alias status: image.status

    Image {
        id: image
        anchors.fill: parent
        sourceSize: Qt.size(width, height)
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: false
    }

    Text {
        anchors.fill: parent
        anchors.margins: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        visible: image.status !== Image.Ready
        text: !image.source.toString() ? preview.emptyText
            : image.status === Image.Error ? "Preview unavailable" : "Loading preview…"
        textFormat: Text.PlainText
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }
}
