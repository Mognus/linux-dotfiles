pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool bottomBarVisible: true
    property bool workspaceHudVisible: false
    property bool tuxVisible: true
    property bool settingsOpen: false
    property bool launcherOpen: false
    property bool windowSwitcherOpen: false

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

    function toggleSettings() {
        root.settingsOpen = !root.settingsOpen;
    }

    function closeSettings() {
        root.settingsOpen = false;
    }

    function toggleLauncher() {
        root.launcherOpen = !root.launcherOpen;
    }

    function closeLauncher() {
        root.launcherOpen = false;
    }

    function toggleWindowSwitcher() {
        root.windowSwitcherOpen = !root.windowSwitcherOpen;
    }

    function closeWindowSwitcher() {
        root.windowSwitcherOpen = false;
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
        target: "settings"

        function toggle(): void {
            root.toggleSettings()
        }

        function close(): void {
            root.closeSettings()
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            root.toggleLauncher()
        }

        function close(): void {
            root.closeLauncher()
        }
    }

    IpcHandler {
        target: "windowswitcher"

        function toggle(): void {
            root.toggleWindowSwitcher()
        }

        function close(): void {
            root.closeWindowSwitcher()
        }
    }
}
