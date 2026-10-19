pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool bottomBarVisible: true
    property bool workspaceHudVisible: false
    property bool tuxVisible: true

    // Route shown in the shared overlay; empty means closed.
    property string overlay: ""
    property bool overlayFromSettings: false
    readonly property bool settingsOpen: root.overlay === "settings" || root.overlayFromSettings
    readonly property bool launcherOpen: root.overlay === "launcher"
    readonly property bool windowSwitcherOpen: root.overlay === "windowSwitcher"
    readonly property bool clipboardOpen: root.overlay === "clipboard"

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
        root.overlayFromSettings = false;
        root.overlay = root.overlay === name ? "" : name;
    }

    function closeOverlay(name) {
        if (root.overlay === name) {
            root.dismissOverlay();
        }
    }

    function openSettingsPage(name) {
        root.overlayFromSettings = true;
        root.overlay = name;
    }

    function backOverlay() {
        if (root.overlayFromSettings) {
            root.overlayFromSettings = false;
            root.overlay = "settings";
        } else {
            root.dismissOverlay();
        }
    }

    function dismissOverlay() {
        root.overlay = "";
        root.overlayFromSettings = false;
    }

    function toggleSettings() {
        if (root.settingsOpen) {
            root.dismissOverlay();
        } else {
            root.toggleOverlay("settings");
        }
    }

    function closeSettings() {
        if (root.settingsOpen) {
            root.dismissOverlay();
        }
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

    function toggleClipboard() {
        root.toggleOverlay("clipboard");
    }

    function closeClipboard() {
        root.closeOverlay("clipboard");
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

    IpcHandler {
        target: "clipboard"

        function toggle(): void {
            root.toggleClipboard()
        }

        function close(): void {
            root.closeClipboard()
        }
    }
}
