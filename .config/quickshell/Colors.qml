pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    function withAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    readonly property color background: palette.background
    readonly property color surface: palette.surface
    readonly property color hover: palette.hover
    readonly property color foreground: palette.foreground
    readonly property color foregroundSoft: palette.foregroundSoft
    readonly property color muted: palette.muted
    readonly property color border: palette.border
    readonly property color borderMuted: palette.borderMuted
    readonly property color accent: palette.accent
    readonly property color secondary: palette.secondary
    readonly property color success: palette.success
    readonly property color danger: palette.danger
    readonly property color warning: palette.warning
    readonly property color orange: palette.orange
    readonly property color violet: palette.violet
    readonly property color panel: palette.panel
    readonly property color bar: palette.bar
    readonly property color faint: palette.faint
    readonly property color subtle: palette.subtle
    readonly property color hoverOverlay: palette.hoverOverlay
    readonly property color lowOverlay: palette.lowOverlay
    readonly property color divider: palette.divider

    FileView {
        path: Quickshell.env("HOME") + "/.local/state/dotfiles-theme/colors.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: palette

            property string background: "#050507"
            property string surface: "#101014"
            property string hover: "#18181d"
            property string foreground: "#ffffff"
            property string foregroundSoft: "#cdd6f4"
            property string muted: "#888888"
            property string border: "#d8d8d8"
            property string borderMuted: "#2a2a30"
            property string accent: "#00d7d7"
            property string secondary: "#7287fd"
            property string success: "#40a02b"
            property string danger: "#f38ba8"
            property string warning: "#f9e2af"
            property string orange: "#fe640b"
            property string violet: "#8839ef"
            property string panel: "#e6111111"
            property string bar: "#b8000000"
            property string faint: "#59ffffff"
            property string subtle: "#24ffffff"
            property string hoverOverlay: "#28ffffff"
            property string lowOverlay: "#14ffffff"
            property string divider: "#20ffffff"
        }
    }
}
