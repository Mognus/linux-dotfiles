import QtQuick
import qs

// A color sample, not an embedded terminal process.
Rectangle {
    id: preview

    required property var themeColors
    readonly property color foreground: themeColors ? (themeColors.terminalForeground ?? themeColors.foregroundSoft) : "transparent"

    color: themeColors ? (themeColors.terminalBackground ?? themeColors.background) : "transparent"
    border.width: 1
    border.color: themeColors ? themeColors.borderMuted : "transparent"
    clip: true

    Rectangle {
        id: titlebar

        width: parent.width
        height: 28
        color: preview.themeColors ? preview.themeColors.surface : "transparent"

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "TERMINAL — alacritty"
            color: preview.themeColors ? preview.themeColors.foreground : "transparent"
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }

    Column {
        anchors.top: titlebar.bottom
        anchors.left: parent.left
        anchors.margins: 12
        spacing: 5

        Text {
            text: "magnus@desktop ~"
            color: preview.themeColors ? preview.themeColors.accent : "transparent"
            font.family: Fonts.family
            font.pixelSize: Fonts.size
        }

        Text {
            text: "$ ls"
            color: preview.foreground
            font.family: Fonts.family
            font.pixelSize: Fonts.size
        }

        Text {
            text: "Documents  Pictures  dotfiles"
            color: preview.foreground
            font.family: Fonts.family
            font.pixelSize: Fonts.size
        }

        Rectangle {
            width: 10
            height: 16
            color: preview.themeColors ? preview.themeColors.accent : "transparent"
        }
    }
}
