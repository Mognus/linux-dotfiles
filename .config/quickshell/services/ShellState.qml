pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool bottomBarVisible: true
    property bool workspaceHudVisible: false
    property bool tuxVisible: true

    // Overlays pop up centered and take the keyboard, so only one is open at a
    // time: "settings", "launcher", "windowSwitcher", or "" for none.
    property string overlay: ""
    readonly property bool settingsOpen: root.overlay === "settings"
    readonly property bool launcherOpen: root.overlay === "launcher"
    readonly property bool windowSwitcherOpen: root.overlay === "windowSwitcher"

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

    // Opens the overlay, closing whichever was open; toggling the open one closes it.
    function toggleOverlay(name) {
        root.overlay = root.overlay === name ? "" : name;
    }

    function closeOverlay(name) {
        if (root.overlay === name) {
            root.overlay = "";
        }
    }

    function toggleSettings() {
        root.toggleOverlay("settings");
    }

    function closeSettings() {
        root.closeOverlay("settings");
    }

    function toggleLauncher() {
        root.toggleOverlay("launcher");
    }

    function closeLauncher() {
        root.closeOverlay("launcher");
    }

    function toggleWindowSwitcher() {
        root.toggleOverlay("windowSwitcher");
    }

    function closeWindowSwitcher() {
        root.closeOverlay("windowSwitcher");
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
