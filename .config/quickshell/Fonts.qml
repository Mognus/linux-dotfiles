pragma Singleton

import Quickshell

Singleton {
    readonly property string family: "PxPlus IBM VGA 8x16"

    // Pixel sizes shared by the bar, menus, launchers, notifications and lock screen.
    readonly property int captionSize: 12
    readonly property int smallSize: 16
    readonly property int size: 18
    readonly property int largeSize: 20
    readonly property int iconSize: 24
    readonly property int clockSize: 96
}
