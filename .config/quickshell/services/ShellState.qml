pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool bottomBarVisible: true
    property bool workspaceHudVisible: false
    property bool tuxVisible: true
    property bool quickSettingsOpen: false
    property bool settingsOpen: false

    function toggleBottomBar() {
        root.bottomBarVisible = !root.bottomBarVisible;
        if (root.bottomBarVisible) {
            root.workspaceHudVisible = false;
        }
    }

    function toggleWorkspaceHud() {
        root.workspaceHudVisible = !root.workspaceHudVisible;
        if (root.workspaceHudVisible) {
            root.bottomBarVisible = false;
        }
    }

    function toggleTux() {
        root.tuxVisible = !root.tuxVisible;
    }

    function toggleQuickSettings() {
        root.quickSettingsOpen = !root.quickSettingsOpen;
    }

    function closeQuickSettings() {
        root.quickSettingsOpen = false;
    }

    function toggleSettings() {
        root.settingsOpen = !root.settingsOpen;
    }

    function closeSettings() {
        root.settingsOpen = false;
    }

    IpcHandler {
        target: "bottombar"

        function toggle(): void {
            root.toggleBottomBar()
        }
    }

    IpcHandler {
        target: "workspacehud"

        function toggle(): void {
            root.toggleWorkspaceHud()
        }
    }

    IpcHandler {
        target: "tux"

        function toggle(): void {
            root.toggleTux()
        }
    }

    IpcHandler {
        target: "quicksettings"

        function toggle(): void {
            root.toggleQuickSettings()
        }

        function close(): void {
            root.closeQuickSettings()
        }
    }

    IpcHandler {
        target: "settings"

        function toggle(): void {
            root.toggleSettings()
        }

        function close(): void {
            root.closeSettings()
        }
    }
}
