pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// Owns org.freedesktop.Notifications on D-Bus, so notify-send and apps land here.
// Only one notification daemon can hold that name, so dunst must not run.
Singleton {
    id: root

    readonly property var list: server.trackedNotifications
    property bool doNotDisturb: false
    property int popupTimeout: 5

    function dismissAll() {
        // Copy the list because dismissing a notification removes it immediately.
        for (const notification of Array.from(root.list.values)) {
            notification.dismiss();
        }
    }

    onDoNotDisturbChanged: {
        if (root.doNotDisturb) {
            for (const notification of Array.from(root.list.values)) {
                if (notification.urgency !== NotificationUrgency.Critical) {
                    notification.dismiss();
                }
            }
        }
    }

    NotificationServer {
        id: server

        bodySupported: true

        // Untracked notifications are dropped right away, tracking keeps them in the list.
        onNotification: notification => {
            notification.tracked = !root.doNotDisturb || notification.urgency === NotificationUrgency.Critical;
        }
    }
}
