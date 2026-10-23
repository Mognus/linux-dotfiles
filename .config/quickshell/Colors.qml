pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    function withAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    readonly property color background: palette.background
    readonly property color surface: palette.surface
    readonly property color hover: palette.hover
    readonly property color foreground: palette.foreground
    readonly property color foregroundSoft: root.withAlpha(root.foreground, 0.8)
    readonly property color muted: palette.muted
    readonly property color border: palette.border
    readonly property color borderMuted: palette.borderMuted
    // Shared shell accents, independent of the selected application theme.
    readonly property color accent: "#55ff55"
    readonly property color danger: "#ff5555"
    readonly property color panel: palette.panel
    readonly property color bar: palette.bar
    readonly property color faint: palette.faint
    readonly property color subtle: palette.subtle
    readonly property color hoverOverlay: palette.hoverOverlay
    readonly property color lowOverlay: palette.lowOverlay
    readonly property color divider: palette.divider

    FileView {
        path: ThemePaths.stateDir + "/colors.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: palette

            property string background: "#050507"
            property string surface: "#101014"
            property string hover: "#18181d"
            property string foreground: "#ffffff"
            property string muted: "#888888"
            property string border: "#d8d8d8"
            property string borderMuted: "#2a2a30"
            property string panel: "#e6111111"
            property string bar: "#b8323234"
            property string faint: "#59ffffff"
            property string subtle: "#24ffffff"
            property string hoverOverlay: "#28ffffff"
            property string lowOverlay: "#14ffffff"
            property string divider: "#20ffffff"
        }
    }
}
