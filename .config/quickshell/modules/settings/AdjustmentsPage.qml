import QtQuick
import qs
import qs.services

FocusScope {
    focus: true

    Column {
        width: parent.width
        spacing: 12

        SettingSlider {
            width: parent.width
            title: "TERMINAL OPACITY"
            unit: "%"
            from: 0
            to: 100
            stepSize: 1
            value: Appearance.opacity * 100
            onCommitted: value => Appearance.save("opacity", (value / 100).toFixed(2))
        }

        SettingSlider {
            width: parent.width
            title: "FONT SIZE"
            unit: "pt"
            from: 6
            to: 48
            stepSize: 0.5
            value: Appearance.fontSize
            onCommitted: value => Appearance.save("font-size", value)
        }

        SettingSlider {
            width: parent.width
            title: "PADDING"
            unit: "px"
            from: 0
            to: 48
            stepSize: 1
            value: Appearance.padding
            onCommitted: value => Appearance.save("padding", Math.round(value))
        }

        SettingsButton {
            text: "RESET TO DEFAULTS"
            onClicked: Appearance.resetTerminal()
        }

        Text {
            width: parent.width
            text: Appearance.error || "Release to save. TAB selects a slider; arrows adjust it.\nTheme changes preserve these values. Alacritty reloads them live."
            wrapMode: Text.WordWrap
            color: Appearance.error ? Colors.danger : Colors.muted
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }
}
