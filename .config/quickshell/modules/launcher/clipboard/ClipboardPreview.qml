import QtQuick
import qs
import qs.modules.preview

Item {
    id: preview
    property string text: ""
    property url image: ""

    Text {
        anchors.fill: parent
        visible: !preview.image.toString()
        text: preview.text
        textFormat: Text.PlainText
        wrapMode: Text.WrapAnywhere
        clip: true
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.smallSize
    }

    ImagePreview {
        anchors.fill: parent
        visible: !!preview.image.toString()
        source: preview.image
    }
}
