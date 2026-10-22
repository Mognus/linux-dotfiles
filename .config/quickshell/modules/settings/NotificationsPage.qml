import QtQuick
import qs
import qs.modules
import qs.services
import qs.modules.keyboard

OverlayPage {
    id: page

    title: "General / Notifications"
    keyBindings: keys
    Keys.onPressed: event => keys.handle(event)

    property int selectedIndex: 0
    readonly property var controls: [doNotDisturbButton, timeoutSlider, dismissButton]
    readonly property var selectedButton: selectedIndex === 1 ? null : controls[selectedIndex]

    function activate() {
        if (controls[selectedIndex].enabled) controls[selectedIndex].forceActiveFocus();
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
    }

    function adjustTimeout(direction) {
        Notifications.popupTimeout = Math.max(timeoutSlider.from, Math.min(timeoutSlider.to,
            timeoutSlider.value + direction * timeoutSlider.stepSize));
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_J, Qt.Key_Down, Qt.Key_Tab], label: "NEXT", run: () => page.moveSelection(1) },
            { keys: [Qt.Key_K, Qt.Key_Up], label: "PREVIOUS", run: () => page.moveSelection(-1) },
            { keys: [Qt.Key_Backtab], modifiers: Qt.ShiftModifier, run: () => page.moveSelection(-1) },
            { keys: [Qt.Key_H, Qt.Key_Left], label: "DECREASE", enabled: page.selectedIndex === 1, run: () => page.adjustTimeout(-1) },
            { keys: [Qt.Key_L, Qt.Key_Right], label: "INCREASE", enabled: page.selectedIndex === 1, run: () => page.adjustTimeout(1) },
            { keys: [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Space], label: page.selectedIndex === 0 ? "TOGGLE" : "DISMISS ALL", enabled: page.selectedButton !== null && page.selectedButton.enabled, run: () => page.selectedButton.clicked() },
            { keys: [Qt.Key_Escape], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => ShellState.backOverlay() }
        ]
    }

    Column {
        width: parent.width
        spacing: 12

        Rectangle {
            width: parent.width
            height: 96
            color: Colors.surface
            border.width: 1
            border.color: Colors.borderMuted

            Text {
                x: 12
                y: 12
                text: "DO NOT DISTURB"
                color: Colors.foreground
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }

            Text {
                x: 12
                y: 42
                width: parent.width - 148
                text: "Hide normal popups. Critical messages still appear."
                wrapMode: Text.WordWrap
                color: Colors.foregroundSoft
                font.family: Fonts.family
                font.pixelSize: Fonts.smallSize
            }

            SettingsButton {
                id: doNotDisturbButton

                Keys.forwardTo: [page]
                onActiveFocusChanged: if (activeFocus) page.selectedIndex = 0
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                width: 100
                text: Notifications.doNotDisturb ? "ON" : "OFF"
                checked: Notifications.doNotDisturb
                focus: true
                onClicked: Notifications.doNotDisturb = !Notifications.doNotDisturb
            }
        }

        SettingSlider {
            id: timeoutSlider

            width: parent.width
            title: "DEFAULT POPUP TIMEOUT"
            unit: "SEC"
            from: 1
            to: 10
            stepSize: 1
            value: Notifications.popupTimeout
            keyTarget: page
            onActiveFocusChanged: if (activeFocus) page.selectedIndex = 1
            onCommitted: value => Notifications.popupTimeout = Math.round(value)
        }

        Row {
            spacing: 12

            SettingsButton {
                id: dismissButton

                Keys.forwardTo: [page]
                onActiveFocusChanged: if (activeFocus) page.selectedIndex = 2
                text: "DISMISS ALL"
                enabled: Notifications.list.values.length > 0
                onClicked: Notifications.dismissAll()
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Notifications.list.values.length + " ACTIVE"
                color: Colors.muted
                font.family: Fonts.family
                font.pixelSize: Fonts.smallSize
            }
        }

        Text {
            width: parent.width
            text: "Apps may request their own timeout. Critical messages stay until dismissed."
            wrapMode: Text.WordWrap
            color: Colors.muted
            font.family: Fonts.family
            font.pixelSize: Fonts.captionSize
        }
    }
}
