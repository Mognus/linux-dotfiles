pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property string clock: Qt.formatDateTime(systemClock.date, "hh:mm")

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
