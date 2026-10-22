import QtQuick
import qs
import qs.modules
import qs.services
import qs.modules.keyboard

OverlayPage {
    id: page

    title: "Appearance / Adjustments"
    keyBindings: keys
    Keys.onPressed: event => keys.handle(event)

    property int selectedIndex: 0
    readonly property var controls: [opacitySlider, fontSlider, paddingSlider, resetButton]
    readonly property var selectedSlider: selectedIndex < 3 ? controls[selectedIndex] : null
    // Start with saved values; edits belong to this page until it is closed.
    property real opacityValue: Appearance.opacity * 100
    property real fontSizeValue: Appearance.fontSize
    property real paddingValue: Appearance.padding

    function activate() {
        controls[selectedIndex].forceActiveFocus();
    }

    function moveSelection(direction) {
        selectedIndex = (selectedIndex + direction + controls.length) % controls.length;
        activate();
    }

    function adjust(direction) {
        const slider = selectedSlider;
        if (!slider) return;
        const value = Math.max(slider.from, Math.min(slider.to,
            Math.round((slider.value + direction * slider.stepSize) * 100) / 100));
        if (value !== slider.value) saveValue(selectedIndex, value);
    }

    function saveValue(index, value) {
        if (index === 0) {
            opacityValue = value;
            Appearance.save("opacity", (value / 100).toFixed(2));
        } else if (index === 1) {
            fontSizeValue = value;
            Appearance.save("font-size", value);
        } else {
            paddingValue = Math.round(value);
            Appearance.save("padding", paddingValue);
        }
    }

    function resetValues() {
        Appearance.resetTerminal();
    }

    Connections {
        target: Appearance
        function onTerminalReset() {
            page.opacityValue = Appearance.opacity * 100;
            page.fontSizeValue = Appearance.fontSize;
            page.paddingValue = Appearance.padding;
        }
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_J, Qt.Key_Down, Qt.Key_Tab], label: "NEXT", run: () => page.moveSelection(1) },
            { keys: [Qt.Key_K, Qt.Key_Up], label: "PREVIOUS", run: () => page.moveSelection(-1) },
            { keys: [Qt.Key_Backtab], modifiers: Qt.ShiftModifier, run: () => page.moveSelection(-1) },
            { keys: [Qt.Key_H, Qt.Key_Left], label: "DECREASE", enabled: page.selectedSlider !== null, run: () => page.adjust(-1) },
            { keys: [Qt.Key_L, Qt.Key_Right], label: "INCREASE", enabled: page.selectedSlider !== null, run: () => page.adjust(1) },
            { keys: [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Space], label: "RESET", enabled: page.selectedIndex === 3, run: () => page.resetValues() },
            { keys: [Qt.Key_Escape], label: "BACK", run: () => ShellState.backOverlay() }
        ]
    }

    Column {
        width: parent.width
        spacing: 12

        SettingSlider {
            id: opacitySlider
            keyTarget: page
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 0
            width: parent.width
            title: "TERMINAL OPACITY"
            unit: "%"
            from: 0
            to: 100
            stepSize: 1
            value: page.opacityValue
            onCommitted: value => page.saveValue(0, value)
        }

        SettingSlider {
            id: fontSlider
            keyTarget: page
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 1
            width: parent.width
            title: "FONT SIZE"
            unit: "pt"
            from: 6
            to: 48
            stepSize: 0.5
            value: page.fontSizeValue
            onCommitted: value => page.saveValue(1, value)
        }

        SettingSlider {
            id: paddingSlider
            keyTarget: page
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 2
            width: parent.width
            title: "PADDING"
            unit: "px"
            from: 0
            to: 48
            stepSize: 1
            value: page.paddingValue
            onCommitted: value => page.saveValue(2, value)
        }

        SettingsButton {
            id: resetButton
            Keys.forwardTo: [page]
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 3
            text: "RESET TO DEFAULTS"
            onClicked: page.resetValues()
        }

        Text {
            width: parent.width
            text: Appearance.error || "Keyboard changes save immediately; dragging saves on release.\nTheme changes preserve these values. Alacritty reloads them live."
            wrapMode: Text.WordWrap
            color: Appearance.error ? Colors.danger : Colors.muted
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }
}
