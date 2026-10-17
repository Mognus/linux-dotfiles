import QtQuick
import qs

// An illustrative browser layout using the palette's surface and text colors.
Rectangle {
    id: preview

    required property var themeColors

    color: themeColors ? themeColors.surface : "transparent"
    border.width: 1
    border.color: themeColors ? themeColors.borderMuted : "transparent"
    clip: true

    Rectangle {
        id: toolbar

        width: parent.width
        height: 32
        color: preview.themeColors ? preview.themeColors.background : "transparent"

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "←  →  ↻    example.org"
            color: preview.themeColors ? preview.themeColors.foregroundSoft : "transparent"
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }

    Rectangle {
        id: sidebar

        anchors.top: toolbar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 140
        color: preview.themeColors ? preview.themeColors.background : "transparent"

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            height: 30
            color: preview.themeColors ? preview.themeColors.accent : "transparent"

            Text {
                anchors.centerIn: parent
                text: "Example tab"
                color: preview.themeColors ? preview.themeColors.background : "transparent"
                font.family: Fonts.family
                font.pixelSize: Fonts.captionSize
            }
        }

        Text {
            x: 12
            y: 50
            text: "+ New Tab"
            color: preview.themeColors ? preview.themeColors.foregroundSoft : "transparent"
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }

    Column {
        anchors.top: toolbar.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        anchors.margins: 18
        spacing: 10

        Text {
            text: preview.themeColors ? preview.themeColors.name : ""
            color: preview.themeColors ? preview.themeColors.foreground : "transparent"
            font.family: "IBM Plex Sans"
            font.pixelSize: 24
            font.bold: true
        }

        Text {
            width: parent.width
            text: "A quiet place for your tabs, text and ideas."
            wrapMode: Text.WordWrap
            color: preview.themeColors ? preview.themeColors.foregroundSoft : "transparent"
            font.family: "IBM Plex Sans"
            font.pixelSize: 15
        }

        Text {
            text: "Explore this theme →"
            color: preview.themeColors ? preview.themeColors.accent : "transparent"
            font.family: "IBM Plex Sans"
            font.pixelSize: 15
        }
    }
}
