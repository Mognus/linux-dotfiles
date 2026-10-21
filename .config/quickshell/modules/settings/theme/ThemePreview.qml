import QtQuick
import qs

Item {
    id: preview
    property var palette: null
    property string emptyText: "Preview unavailable"

    Column {
        width: parent.width
        spacing: 12
        visible: preview.palette !== null

        TerminalPreview {
            width: parent.width
            height: 180
            themeColors: preview.palette
        }

        BrowserPreview {
            width: parent.width
            height: 210
            themeColors: preview.palette
        }
    }

    Text {
        anchors.centerIn: parent
        visible: preview.palette === null
        text: preview.emptyText
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }
}
