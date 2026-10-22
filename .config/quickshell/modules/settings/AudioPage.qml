import QtQuick
import Quickshell.Services.Pipewire
import qs
import qs.modules
import qs.services
import qs.modules.keyboard
import "../../lib/Audio.js" as Audio

OverlayPage {
    id: page

    title: "General / Audio"
    keyBindings: keys
    Keys.onPressed: event => keys.handle(event)

    property int selectedIndex: 0
    readonly property var controls: [outputSlider, microphoneSlider]
    readonly property var selectedSlider: controls[selectedIndex]

    function activate() {
        if (selectedSlider.enabled) selectedSlider.forceActiveFocus();
        else moveSelection(1);
    }

    function moveSelection(direction) {
        for (let step = 1; step <= controls.length; step++) {
            const index = (selectedIndex + direction * step + controls.length) % controls.length;
            if (controls[index].enabled) {
                selectedIndex = index;
                controls[index].forceActiveFocus();
                return;
            }
        }
        page.forceActiveFocus();
    }

    function adjust(direction) {
        const slider = selectedSlider;
        if (!slider.enabled) return;
        const value = Math.max(slider.from, Math.min(slider.to,
            slider.value + direction * slider.stepSize));
        if (value !== slider.value) setVolume(selectedIndex, value);
    }

    function setVolume(index, value) {
        const node = index === 0 ? Pipewire.defaultAudioSink : Pipewire.defaultAudioSource;
        Audio.setVolume(node, value / 100);
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_J, Qt.Key_Down, Qt.Key_Tab], label: "NEXT", run: () => page.moveSelection(1) },
            { keys: [Qt.Key_K, Qt.Key_Up], label: "PREVIOUS", run: () => page.moveSelection(-1) },
            { keys: [Qt.Key_Backtab], modifiers: Qt.ShiftModifier, run: () => page.moveSelection(-1) },
            { keys: [Qt.Key_H, Qt.Key_Left], label: "DECREASE", enabled: page.selectedSlider.enabled, run: () => page.adjust(-1) },
            { keys: [Qt.Key_L, Qt.Key_Right], label: "INCREASE", enabled: page.selectedSlider.enabled, run: () => page.adjust(1) },
            { keys: [Qt.Key_Escape], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => ShellState.backOverlay() }
        ]
    }

    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 12

        SettingSlider {
            id: outputSlider

            width: parent.width
            title: "OUTPUT"
            unit: "%"
            from: 0
            to: 100
            stepSize: 1
            value: Audio.percent(Pipewire.defaultAudioSink)
            enabled: Audio.ready(Pipewire.defaultAudioSink)
            opacity: enabled ? 1 : 0.45
            keyTarget: page
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 0
            onCommitted: value => page.setVolume(0, value)
        }

        Text {
            width: parent.width
            text: Audio.label(Pipewire.defaultAudioSink)
            textFormat: Text.PlainText
            elide: Text.ElideRight
            color: Colors.muted
            font.family: Fonts.family
            font.pixelSize: Fonts.smallSize
        }

        SettingSlider {
            id: microphoneSlider

            width: parent.width
            title: "MICROPHONE"
            unit: "%"
            from: 0
            to: 100
            stepSize: 1
            value: Audio.percent(Pipewire.defaultAudioSource)
            enabled: Audio.ready(Pipewire.defaultAudioSource)
            opacity: enabled ? 1 : 0.45
            keyTarget: page
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 1
            onCommitted: value => page.setVolume(1, value)
        }

        Text {
            width: parent.width
            text: Audio.label(Pipewire.defaultAudioSource)
            textFormat: Text.PlainText
            elide: Text.ElideRight
            color: Colors.muted
            font.family: Fonts.family
            font.pixelSize: Fonts.smallSize
        }
    }

    Item {
        id: status

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 18

        Rectangle {
            id: indicator

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            height: 6
            color: Pipewire.ready ? Colors.accent : Colors.danger
        }

        Text {
            anchors.left: indicator.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: Pipewire.ready ? "PIPEWIRE READY" : "PIPEWIRE WAIT"
            color: Pipewire.ready ? Colors.muted : Colors.danger
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }
}
