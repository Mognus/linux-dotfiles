import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import qs
import qs.services

// Notification popups top right, newest at the bottom. Click one to close it.
PanelWindow {
    id: popups

    readonly property int popupWidth: 300
    readonly property int defaultTimeout: 5

    anchors {
        top: true
        right: true
    }

    margins {
        top: 10
        right: 10
    }

    implicitWidth: popups.popupWidth
    implicitHeight: column.implicitHeight
    // Popups float over windows instead of pushing them aside.
    exclusiveZone: 0
    color: "transparent"
    visible: repeater.count > 0

    Column {
        id: column

        spacing: 6

        Repeater {
            id: repeater

            model: Notifications.list

            Rectangle {
                id: popup

                required property Notification modelData
                readonly property bool critical: popup.modelData.urgency === NotificationUrgency.Critical

                width: popups.popupWidth
                // At most 100px high; long bodies get cut.
                height: Math.min(content.implicitHeight + 20, 100)
                radius: 6
                color: Colors.surface
                border.width: 1
                border.color: {
                    if (popup.critical)
                        return Colors.danger;
                    if (popup.modelData.urgency === NotificationUrgency.Low)
                        return Colors.borderMuted;
                    return Colors.accent;
                }
                clip: true

                Column {
                    id: content

                    x: 12
                    y: 10
                    width: parent.width - 24
                    spacing: 2

                    Text {
                        width: parent.width
                        text: popup.modelData.summary
                        color: popup.critical ? Colors.danger : Colors.foregroundSoft
                        font.family: "Sans"
                        font.pointSize: 11
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        visible: text !== ""
                        text: popup.modelData.body
                        textFormat: Text.PlainText
                        color: popup.critical ? Colors.danger : Colors.foregroundSoft
                        font.family: "Sans"
                        font.pointSize: 11
                        wrapMode: Text.Wrap
                    }
                }

                // Critical ones stay until clicked. The app's timeout wins over the default;
                // it is <= 0 when the app sent none.
                Timer {
                    running: !popup.critical
                    interval: (popup.modelData.expireTimeout > 0 ? popup.modelData.expireTimeout : popups.defaultTimeout) * 1000
                    onTriggered: popup.modelData.expire()
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: popup.modelData.dismiss()
                }
            }
        }
    }
}
