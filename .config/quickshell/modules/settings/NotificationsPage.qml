import QtQuick
import qs
import qs.modules
import qs.services

OverlayPage {
    title: "General / Notifications"
    extraHint: "TAB  SELECT"

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

        Rectangle {
            width: parent.width
            height: 92
            color: Colors.surface
            border.width: 1
            border.color: Colors.borderMuted

            Text {
                x: 12
                y: 12
                text: "DEFAULT POPUP TIMEOUT"
                color: Colors.foreground
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }

            Row {
                id: durations

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 12
                spacing: 8

                Repeater {
                    model: [3, 5, 10]

                    SettingsButton {
                        required property int modelData

                        width: (durations.width - 16) / 3
                        text: modelData + " SEC"
                        checked: Notifications.popupTimeout === modelData
                        onClicked: Notifications.popupTimeout = modelData
                    }
                }
            }
        }

        Row {
            spacing: 12

            SettingsButton {
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
