import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import qs
import qs.services

// Notification popups top right, newest at the bottom. Click one to close it.
PanelWindow {
    id: popups

    readonly property int popupWidth: 340
    readonly property int defaultTimeout: Notifications.popupTimeout

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
                readonly property int padding: 12

                width: popups.popupWidth
                height: header.height + content.implicitHeight + popup.padding * 2 + 2
                color: Colors.background
                border.width: 1
                border.color: popup.critical ? Colors.danger : mouse.containsMouse ? Colors.accent : Colors.border

                // An inverted title bar, matching the settings menu's selection.
                Rectangle {
                    id: header

                    x: 1
                    y: 1
                    width: parent.width - 2
                    height: 28
                    color: popup.critical ? Colors.danger : Colors.foreground

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: popup.padding
                        anchors.right: close.left
                        anchors.rightMargin: popup.padding
                        anchors.verticalCenter: parent.verticalCenter
                        text: (popup.critical ? "! " : "> ") + (popup.modelData.appName || "NOTIFICATION").toUpperCase()
                        textFormat: Text.PlainText
                        elide: Text.ElideRight
                        color: Colors.background
                        font.family: Fonts.family
                        font.pixelSize: Fonts.smallSize
                    }

                    Text {
                        id: close

                        anchors.right: parent.right
                        anchors.rightMargin: popup.padding
                        anchors.verticalCenter: parent.verticalCenter
                        text: "×"
                        color: Colors.background
                        font.family: Fonts.family
                        font.pixelSize: Fonts.smallSize
                    }
                }

                Column {
                    id: content

                    x: popup.padding
                    y: header.y + header.height + popup.padding
                    width: parent.width - popup.padding * 2
                    spacing: 8

                    Text {
                        width: parent.width
                        text: popup.modelData.summary
                        textFormat: Text.PlainText
                        color: popup.critical ? Colors.danger : Colors.foreground
                        font.family: Fonts.family
                        font.pixelSize: Fonts.size
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        visible: text !== ""
                        text: popup.modelData.body
                        textFormat: Text.PlainText
                        color: popup.critical ? Colors.danger : Colors.foregroundSoft
                        font.family: Fonts.family
                        font.pixelSize: Fonts.smallSize
                        wrapMode: Text.WordWrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                    }
                }

                // QS 0.3.2 passes the D-Bus timeout through in milliseconds.
                // -1 uses our default in seconds; 0 requests no automatic expiry.
                // Critical messages also stay until dismissed.
                Timer {
                    running: !popup.critical && popup.modelData.expireTimeout !== 0
                    interval: popup.modelData.expireTimeout > 0
                        ? popup.modelData.expireTimeout
                        : popups.defaultTimeout * 1000
                    onTriggered: popup.modelData.expire()
                }

                MouseArea {
                    id: mouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: popup.modelData.dismiss()
                }
            }
        }
    }
}
