pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// Owns org.freedesktop.Notifications on D-Bus, so notify-send and apps land here.
// Only one notification daemon can hold that name, so dunst must not run.
Singleton {
    readonly property var list: server.trackedNotifications

    NotificationServer {
        id: server

        bodySupported: true

        // Untracked notifications are dropped right away, tracking keeps them in the list.
        onNotification: notification => notification.tracked = true
    }
}
