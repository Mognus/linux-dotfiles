pragma Singleton

import Quickshell

// Shared layout sizing for the app launcher, window switcher and clipboard history.
// Colors come from Colors.qml; the font family and sizes come from Fonts.qml.
Singleton {
    readonly property int padding: 16
    readonly property int contentInset: 12
    readonly property int rowHeight: 48

    readonly property int gridCellSize: 160
    readonly property int gridIconSize: 64
    readonly property int gridIconTopMargin: 28
    readonly property int gridLabelBottomMargin: 24

    readonly property int listIconSize: 24
    readonly property int listIndent: 48
    readonly property int listWidth: 480
    readonly property int listPanelWidth: 1320
    readonly property int listPanelHeight: 720
}
